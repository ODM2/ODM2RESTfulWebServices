import sys
sys.path.append('ODM2PythonAPI')

from odm2rest.serializers import DummySerializer
from odm2rest.serializers import Odm2JsonSerializer

from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework import viewsets
from collections import OrderedDict

from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
import csv,cStringIO

from odm2rest.odm2service import Service
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_xml.renderers import XMLRenderer
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework.renderers import BrowsableAPIRenderer

import yaml, pyaml
from sets import Set
from negotiation import IgnoreClientContentNegotiation

class ValuesViewSet(APIView):
    """
    All ODM2 Data Value Retrieval

    """

    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

    def get(self, request, format=None, resultUUID=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query
            - name: page
              description: the default page number is 0. 
              required: false
              type: integer
              paramType: query
            - name: page_size
              description: The default page size is 100 records.
              required: false
              type: integer
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        if resultUUID is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        page = request.QUERY_PARAMS.get('page','0')
        page_size = request.QUERY_PARAMS.get('page_size','100')

        page = int(page)
        page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        ts = readConn.getResultByUUID(resultUUID)
        if ts == None or len(ts) == 0:
            return Response('time series data is not available.',
                            status=status.HTTP_400_BAD_REQUEST)

        mr.setResultTypeCV(ts.ResultTypeCV)
        items = None

        if ts.ResultTypeCV == 'Time series coverage':
            items = readConn.getTimeSeriesResultValuesByResultID(ts.ResultID, page, page_size)
        elif ts.ResultTypeCV == 'Measurement':
            items = readConn.getMeasurementResultValuesByResultID(ts.ResultID, page, page_size)            

        if items == None or len(items) == 0:
            return Response('time series data is not available.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)


class MultipleRepresentations(Service):

    def json_format(self):

        allvalues = []
        for value in self.items:
            queryset = OrderedDict()
            queryset['ResultTypeCV'] = value.TimeSeriesResultObj.ResultTypeCV
            s = OrderedDict()
            s['SamplingFeatureCode'] = value.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            s['SamplingFeatureName'] = value.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            s['FeatureGeometry'] = value.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.FeatureGeometry
            s['Elevation_m'] = value.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m
            queryset['SamplingFeature'] = s

            v = OrderedDict()
            v['VariableCode'] = value.TimeSeriesResultObj.VariableObj.VariableCode
            v['VariableNameCV'] = value.TimeSeriesResultObj.VariableObj.VariableNameCV
            queryset['Variable'] = v
            queryset['ValueDateTime'] = value.ValueDateTime
            queryset['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            queryset['DataValue'] = value.DataValue

            allvalues.append(queryset)

        return allvalues

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="values.csv"'

        value_csv_header = ["#fields=ResultTypeCV[type='string']","SamplingFeatureCode[type='string']","SamplingFeatureName[type='string']","FeatureGeometry[type='string']","Elevation","VariableCode[type='string']","VariableNameCV[type='string']","ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","ValueDateTimeUTCOffset","DataValue"]
            
        writer = csv.writer(response)
        writer.writerow(value_csv_header)
        
        for item in self.items:
            row = []
            #row.append(item.ResultID)
            row.append(item.TimeSeriesResultObj.ResultTypeCV)
            #row.append(item.TimeSeriesResultObj.ProcessingLevelObj.Definition)
            #row.append(item.TimeSeriesResultObj.SampledMediumCV)
            row.append(item.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(item.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(item.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.FeatureGeometry)
            row.append(item.TimeSeriesResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)
            row.append(item.TimeSeriesResultObj.VariableObj.VariableCode)
            row.append(item.TimeSeriesResultObj.VariableObj.VariableNameCV)
            #row.append(item.TimeSeriesResultObj.AggregationStatisticCV)
            row.append(item.ValueDateTime)
            row.append(item.ValueDateTimeUTCOffset)
            row.append(item.DataValue)

            writer.writerow(row)

        return response

    def yaml_format(self):

        if self.resulttypecv == 'Time series coverage':
            return self.yaml_timeseriesdata(self.items, self.conn)
        elif self.resulttypecv == 'Measurement':
            return self.yaml_measurementdata(self.items, self.conn)

    def yaml_timeseriesdata(self, items, conn):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'

        response.write("---\n")
        #response.write("YODA:\n")
        #response.write('- {Version: 1.0.0, Profile: TimeSeries, CreationTool: NULL, DateCreated: "2015-03-19", DateUpdated: "2015-03-19"}\n\n')

        tsrv_data = '' 
        flag = True

        for value in items:

            if flag:

                r = u'Result: &ResultID%03d\n' % value.TimeSeriesResultObj.ResultID
                r += u'   ResultUUID: "%s"\n' % value.TimeSeriesResultObj.ResultObj.ResultUUID
                r += u'   ResultTypeCV: \'%s\'\n' % value.TimeSeriesResultObj.ResultObj.ResultTypeCV
                r += u'   ResultDateTime: "%s"\n' % str(value.TimeSeriesResultObj.ResultObj.ResultDateTime)
                r += u'   ResultDateTimeUTCOffset: %s\n' % str(value.TimeSeriesResultObj.ResultObj.ResultDateTimeUTCOffset)
                r += u'   StatusCV: %s\n' % value.TimeSeriesResultObj.ResultObj.StatusCV
                r += u'   SampledMediumCV: %s\n' % value.TimeSeriesResultObj.ResultObj.SampledMediumCV
                r += u'   ValueCount: %d\n' % value.TimeSeriesResultObj.ResultObj.ValueCount

                r += u'   FeatureAction: \n'
                r += u'       FeatureActionID: %d\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.FeatureActionID
                r += u'       SamplingFeature:\n'
                r += u'           SamplingFeatureID: %d\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                r += u'           SamplingFeatureCode: %s\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
                r += u'           SamplingFeatureName: "%s"\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
                r += u'           Elevation_m: %f\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m

                r += u'           Action:\n'
                r += u'               ActionID: %d\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID
                r += u'               BeginDateTime: "%s"\n' % str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
                r += u'               BeginDateTimeUTCOffset: %s\n' % str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
                r += u'               EndDateTime: "%s"\n' % str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
                r += u'               EndDateTimeUTCOffset: %s\n' % str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
                r += u'               Method:\n'
                r += u'                   MethodID: %d\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodID
                r += u'                   MethodCode: %s\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
                r += u'                   MethodName: %s\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
                raction = conn.getRelatedActionsByActionID(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID)
                if raction != None:
                    r += u'   RelatedActions:\n'
                    for x in raction:
                        r += u'       RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                        r += u'       RelatedActionID:\n'
                        r += u'           BeginDateTime: "%s"\n' % str(x.RelatedActionObj.BeginDateTime)
                        r += u'           BeginDateTimeUTCOffset: %s\n' % str(x.RelatedActionObj.BeginDateTimeUTCOffset)
                        r += u'           EndDateTime: "%s"\n' % str(x.RelatedActionObj.EndDateTime)
                        r += u'           EndDateTimeUTCOffset: %s\n' % str(x.RelatedActionObj.EndDateTimeUTCOffset)
                        r += u'           Method:\n'
                        r += u'               MethodID: %d\n' % x.RelatedActionObj.MethodObj.MethodID
                        r += u'               MethodCode: %s\n' % x.RelatedActionObj.MethodObj.MethodCode
                        r += u'               MethodName: %s\n' % x.RelatedActionObj.MethodObj.MethodName

                sfid = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                site = conn.getSiteBySFId(sfid)
                if site != None:
                    r += u'   Site:\n'
                    r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                    r += u'       Latitude: %f\n' % site.Latitude
                    r += u'       Longitude: %f\n' % site.Longitude
                    r += u'       SpatialReference:\n'
                    r += u'           SRSID: %d\n' % site.SpatialReferenceObj.SpatialReferenceID
                    r += u'           SRSCode: "%s"\n' % site.SpatialReferenceObj.SRSCode
                    r += u'           SRSName: %s\n' % site.SpatialReferenceObj.SRSName

                r += u'   Variable:\n'
                r += u'       VariableID: %d\n' % value.TimeSeriesResultObj.ResultObj.VariableObj.VariableID
                r += u'       VariableCode: %s\n' % value.TimeSeriesResultObj.ResultObj.VariableObj.VariableCode
                r += u'       VariableNameCV: %s\n' % value.TimeSeriesResultObj.ResultObj.VariableObj.VariableNameCV
                r += u'       NoDataValue: %s\n' % str(value.TimeSeriesResultObj.ResultObj.VariableObj.NoDataValue)

                r += u'   Unit:\n'
                r += u'       UnitID: %d\n' % value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsID
                r += u'       UnitsAbbreviation: %s\n' % value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsAbbreviation
                r += u'       UnitsName: %s\n' % value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsName

                r += u'   ProcessingLevel:\n'
                r += u'       ProcessingLevelID: %d\n' % value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelID
                r += u'       ProcessingLevelCode: "%s"\n' % value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode

                tsr = u'TimeSeriesResult:\n'
                tsr += u'   &TimeSeriesResultID%03d ' % value.TimeSeriesResultObj.ResultID
                tsr += u'{ResultID: *ResultID%03d, ' % value.TimeSeriesResultObj.ResultID
                if value.TimeSeriesResultObj.XLocation != None:
                    tsr += u'XLocation: %f, ' % value.TimeSeriesResultObj.XLocation
                else:
                    tsr += u'XLocation: NULL, '
                if value.TimeSeriesResultObj.XLocationUnitsID != None:
                    tsr += u'XLocationUnitsID: *UnitID%03d, ' % value.TimeSeriesResultObj.XLocationUnitsID
                else:
                    tsr += u'XLocationUnitsID: NULL, '
                if value.TimeSeriesResultObj.YLocation != None:
                    tsr += u'YLocation: %f, ' % value.TimeSeriesResultObj.YLocation
                else:
                    tsr += u'YLocation: NULL, '
                if value.TimeSeriesResultObj.YLocationUnitsID != None:
                    tsr += u'YLocationUnitsID: *UnitID%03d, ' % value.TimeSeriesResultObj.YLocationUnitsID
                else:
                    tsr += u'YLocationUnitsID: NULL, '
                if value.TimeSeriesResultObj.ZLocation != None:
                    tsr += u'ZLocation: %f, ' % value.TimeSeriesResultObj.ZLocation
                else:
                    tsr += u'ZLocation: NULL, '
                if value.TimeSeriesResultObj.ZLocationUnitsID != None:
                    tsr += u'ZLocationUnitsID: *UnitID%03d, ' % value.TimeSeriesResultObj.ZLocationUnitsID
                else:
                    tsr += u'ZLocationUnitsID: NULL, '
                if value.TimeSeriesResultObj.SpatialReferenceID != None:
                    tsr += u'SpatialReferenceID: *SRSID%03d, ' % value.TimeSeriesResultObj.SpatialReferenceID
                else:
                    tsr += u'SpatialReferenceID: NULL, '
                if value.TimeSeriesResultObj.IntendedTimeSpacing != None:
                    tsr += u'IntendedTimeSpacing: %f, ' % value.TimeSeriesResultObj.IntendedTimeSpacing
                else:
                    tsr += u'IntendedTimeSpacing: NULL, '
                if value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID != None:
                    tsr += u'IntendedTimeSpacingUnitsID: *UnitID%03d, ' % value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID
                else:
                    tsr += u'IntendedTimeSpacingUnitsID: NULL, '
                tsr += u'AggregationStatisticCV: %s}\n' % value.TimeSeriesResultObj.AggregationStatisticCV

                tsrv = u'TimeSeriesResultValues:\n'
                tsrv += u'  ColumnDefinitions:\n'
                tsrv += u'    - {ColumnNumber: 1, Label: ValueDateTime, ODM2Field: ValueDateTime}\n'
                tsrv += u'    - {ColumnNumber: 2, Label: ValueDateTimeUTCOffset, ODM2Field: ValueDateTimeUTCOffset}\n'
                tsrv += u'    - {ColumnNumber: 3, Label: AirTemp_Avg, Result: *TimeSeriesResultID%03d, ' % value.ResultID 
                tsrv += u'ODM2Field: DataValue, CensorCodeCV: %s, ' % value.CensorCodeCV
                tsrv += u'TimeAggregationInterval: %s, ' % str(value.TimeAggregationInterval)
                tsrv += u'TimeAggregationIntervalUnitsID: {'

                tsrv += u'UnitID: %d, ' % value.TimeUnitObj.UnitsID
                tsrv += u'UnitsAbbreviation: %s, ' % value.TimeUnitObj.UnitsAbbreviation
                tsrv += u'UnitsName: %s}}\n' % value.TimeUnitObj.UnitsName

                tsrv += u'Data:\n'
                tsrv += u'- [ValueDateTime,ValueDateTimeUTCOffset,AirTemp_Avg]\n'

                flag = False

            tsrv_data += u'- ["%s",%s,%f]\n' % (str(value.ValueDateTime),str(value.ValueDateTimeUTCOffset),value.DataValue) 

        tsrv += tsrv_data

        response.write(r)
        response.write('\n')
        response.write(tsr)
        response.write('\n')
        response.write(tsrv)
        #response.write(pyaml.dump(allvalues,vspacing=[1, 0]))

        return response

    def yaml_measurementdata(self, items, conn, conn2):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'

        response.write("---\n")
        resulttype = u'ResultTypeCV: "%s"\n' % self.resulttypecv
        response.write(resulttype)
        #response.write("YODA:\n")
        #response.write('- {Version: 1.0.0, Profile: TimeSeries, CreationTool: NULL, DateCreated: "2015-03-19", DateUpdated: "2015-03-19"}\n\n')

        tsrv_data = '' 
        flag = True

        for value in items:

            if flag:

                r = u'Result: &ResultID%03d\n' % value.MeasurementResultObj.ResultID
                r += u'   ResultUUID: "%s"\n' % value.MeasurementResultObj.ResultUUID
                r += u'   ResultTypeCV: \'%s\'\n' % value.MeasurementResultObj.ResultTypeCV
                r += u'   ResultDateTime: "%s"\n' % str(value.MeasurementResultObj.ResultDateTime)
                r += u'   ResultDateTimeUTCOffset: %d\n' % value.MeasurementResultObj.ResultDateTimeUTCOffset
                r += u'   StatusCV: %s\n' % value.MeasurementResultObj.StatusCV
                r += u'   SampledMediumCV: %s\n' % value.MeasurementResultObj.SampledMediumCV
                r += u'   ValueCount: %d\n' % value.MeasurementResultObj.ValueCount

                r += u'   FeatureAction: \n'
                r += u'       SamplingFeature:\n'
                r += u'           SamplingFeatureID: %d\n' % value.MeasurementResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                r += u'           SamplingFeatureCode: %s\n' % value.MeasurementResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
                r += u'           SamplingFeatureName: "%s"\n' % value.MeasurementResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
                r += u'           Elevation_m: %s\n' % str(value.MeasurementResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

                r += u'           Action:\n'
                r += u'               ActionID: %d\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.ActionID
                r += u'               BeginDateTime: "%s"\n' % str(value.MeasurementResultObj.FeatureActionObj.ActionObj.BeginDateTime)
                r += u'               BeginDateTimeUTCOffset: %d\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
                r += u'               EndDateTime: "%s"\n' % str(value.MeasurementResultObj.FeatureActionObj.ActionObj.EndDateTime)
                r += u'               EndDateTimeUTCOffset: %d\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset
                r += u'               Method:\n'
                r += u'                   MethodID: %d\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.MethodObj.MethodID
                r += u'                   MethodCode: %s\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
                r += u'                   MethodName: %s\n' % value.MeasurementResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
                raction = conn.getRelatedActionsByActionID(value.MeasurementResultObj.FeatureActionObj.ActionObj.ActionID)
                if raction != None:
                    r += u'   RelatedActions:\n'
                    for x in raction:
                        r += u'       RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                        r += u'       RelatedActionID:\n'
                        r += u'           BeginDateTime: "%s"\n' % str(x.RelatedActionObj.BeginDateTime)
                        r += u'           BeginDateTimeUTCOffset: %d\n' % x.RelatedActionObj.BeginDateTimeUTCOffset
                        r += u'           EndDateTime: "%s"\n' % str(x.RelatedActionObj.EndDateTime)
                        r += u'           EndDateTimeUTCOffset: %d\n' % x.RelatedActionObj.EndDateTimeUTCOffset
                        r += u'           Method:\n'
                        r += u'               MethodID: %d\n' % x.RelatedActionObj.MethodObj.MethodID
                        r += u'               MethodCode: %s\n' % x.RelatedActionObj.MethodObj.MethodCode
                        r += u'               MethodName: %s\n' % x.RelatedActionObj.MethodObj.MethodName

                sfid = value.MeasurementResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                site = conn.getSiteBySFId(sfid)
                if site != None:
                    r += u'   Site:\n'
                    r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                    r += u'       Latitude: %f\n' % site.Latitude
                    r += u'       Longitude: %f\n' % site.Longitude
                    r += u'       SpatialReference:\n'
                    r += u'           SRSID: %d\n' % site.SpatialReferenceObj.SpatialReferenceID
                    r += u'           SRSCode: "%s"\n' % site.SpatialReferenceObj.SRSCode
                    r += u'           SRSName: %s\n' % site.SpatialReferenceObj.SRSName

                r += u'   Variable:\n'
                r += u'       VariableID: %d\n' % value.MeasurementResultObj.VariableObj.VariableID
                r += u'       VariableCode: %s\n' % value.MeasurementResultObj.VariableObj.VariableCode
                r += u'       VariableNameCV: %s\n' % value.MeasurementResultObj.VariableObj.VariableNameCV
                r += u'       NoDataValue: %d\n' % value.MeasurementResultObj.VariableObj.NoDataValue

                r += u'   Unit:\n'
                r += u'       UnitID: %d\n' % value.MeasurementResultObj.UnitObj.UnitsID
                r += u'       UnitsAbbreviation: %s\n' % value.MeasurementResultObj.UnitObj.UnitsAbbreviation
                r += u'       UnitsName: %s\n' % value.MeasurementResultObj.UnitObj.UnitsName

                r += u'   ProcessingLevel:\n'
                r += u'       ProcessingLevelID: %d\n' % value.MeasurementResultObj.ProcessingLevelObj.ProcessingLevelID
                r += u'       ProcessingLevelCode: "%s"\n' % value.MeasurementResultObj.ProcessingLevelObj.ProcessingLevelCode

                tsr = u'MeasurementResult:\n'
                tsr += u'   &MeasurementResultID%03d ' % value.MeasurementResultObj.ResultID
                tsr += u'{ResultID: *ResultID%03d, ' % value.MeasurementResultObj.ResultID
                if value.MeasurementResultObj.XLocation != None:
                    tsr += u'XLocation: %f, ' % value.MeasurementResultObj.XLocation
                else:
                    tsr += u'XLocation: NULL, '
                if value.MeasurementResultObj.XLocationUnitsID != None:
                    tsr += u'XLocationUnitsID: *UnitID%03d, ' % value.MeasurementResultObj.XLocationUnitsID
                else:
                    tsr += u'XLocationUnitsID: NULL, '
                if value.MeasurementResultObj.YLocation != None:
                    tsr += u'YLocation: %f, ' % value.MeasurementResultObj.YLocation
                else:
                    tsr += u'YLocation: NULL, '
                if value.MeasurementResultObj.YLocationUnitsID != None:
                    tsr += u'YLocationUnitsID: *UnitID%03d, ' % value.MeasurementResultObj.YLocationUnitsID
                else:
                    tsr += u'YLocationUnitsID: NULL, '
                if value.MeasurementResultObj.ZLocation != None:
                    tsr += u'ZLocation: %f, ' % value.MeasurementResultObj.ZLocation
                else:
                    tsr += u'ZLocation: NULL, '
                if value.MeasurementResultObj.ZLocationUnitsID != None:
                    tsr += u'ZLocationUnitsID: *UnitID%03d, ' % value.MeasurementResultObj.ZLocationUnitsID
                else:
                    tsr += u'ZLocationUnitsID: NULL, '
                if value.MeasurementResultObj.SpatialReferenceID != None:
                    tsr += u'SpatialReferenceID: *SRSID%03d, ' % value.MeasurementResultObj.SpatialReferenceID
                else:
                    tsr += u'SpatialReferenceID: NULL, '
                tsr += u'CensorCodeCV: %s, ' % value.MeasurementResultObj.CensorCodeCV
                tsr += u'QualityCodeCV: %s, ' % value.MeasurementResultObj.QualityCodeCV
                tsr += u'AggregationStatisticCV: %s, ' % value.MeasurementResultObj.AggregationStatisticCV
                tsr += u'TimeAggregationInterval: %d, ' % value.MeasurementResultObj.TimeAggregationInterval
                tsr += u'TimeAggregationIntervalUnitsID: {'

                tsr += u'UnitID: %d, ' % value.MeasurementResultObj.TimeUnitObj.UnitsID
                tsr += u'UnitsAbbreviation: %s, ' % value.MeasurementResultObj.TimeUnitObj.UnitsAbbreviation
                tsr += u'UnitsName: %s}}\n' % value.MeasurementResultObj.TimeUnitObj.UnitsName

                tsrv = u'MeasurementResultValues:\n'
                tsrv += u'  ColumnDefinitions:\n'
                tsrv += u'    - {ColumnNumber: 1, Label: ValueDateTime, ODM2Field: ValueDateTime}\n'
                tsrv += u'    - {ColumnNumber: 2, Label: ValueDateTimeUTCOffset, ODM2Field: ValueDateTimeUTCOffset}\n'
                tsrv += u'    - {ColumnNumber: 3, Label: AirTemp_Avg, Result: *MeasurementResultID%03d}\n' % value.ResultID 

                tsrv += u'Data:\n'
                tsrv += u'- [ValueDateTime,ValueDateTimeUTCOffset,AirTemp_Avg]\n'

                flag = False

            tsrv_data += u'- ["%s",%d,%f]\n' % (str(value.ValueDateTime),value.ValueDateTimeUTCOffset,value.DataValue) 

        tsrv += tsrv_data

        response.write(r)
        response.write('\n')
        response.write(tsr)
        response.write('\n')
        response.write(tsrv)
        #response.write(pyaml.dump(allvalues,vspacing=[1, 0]))

        return response

