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
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read
from dict2xml import dict2xml as xmlify

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
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
            count = readConn.getCountForTimeSeriesResultValuesByResultID(ts.ResultID)
            if count > 1000:
                items = readConn.getTimeSeriesResultValuesByResultIDByPage(ts.ResultID, page, page_size)
            else:
                items = readConn.getTimeSeriesResultValuesByResultID(ts.ResultID)
        elif ts.ResultTypeCV == 'Measurement':
            #count = readConn.getCountForMeasurementResultValuesByResultID(ts.ResultID)            
            #if count > 10:
            #    items = readConn.getMeasurementResultValuesByResultIDByPage(ts.ResultID, page, page_size)            
            #else:
            items = readConn.getMeasurementResultValuesByResultID(ts.ResultID)            

        if items == None or len(items) == 0:
            return Response('time series data is not available.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        if self.resulttypecv == 'Time series coverage':
            return self.json_timeseriesdata(self.items)
        elif self.resulttypecv == 'Measurement':
            return self.json_measurementdata(self.items)

    def csv_format(self):

        if self.resulttypecv == 'Time series coverage':
            return self.csv_timeseriesdata(self.items)
        elif self.resulttypecv == 'Measurement':
            return self.csv_measurementdata(self.items)

    def yaml_format(self):

        if self.resulttypecv == 'Time series coverage':
            return self.yaml_timeseriesdata(self.items)
        elif self.resulttypecv == 'Measurement':
            return self.yaml_measurementdata(self.items)

    def xml_format(self):

        if self.resulttypecv == 'Time series coverage':
            return self.xml_timeseriesdata(self.items)
        elif self.resulttypecv == 'Measurement':
            return self.xml_measurementdata(self.items)

    def json_timeseriesdata(self, items):

        flag = True
        result = {}
        results = []
        for value in items:

            if flag:
                result['ResultUUID'] = value.TimeSeriesResultObj.ResultObj.ResultUUID
                result['ResultTypeCV'] = value.TimeSeriesResultObj.ResultObj.ResultTypeCV
                result['ResultDateTime'] = str(value.TimeSeriesResultObj.ResultObj.ResultDateTime)
                result['ResultDateTimeUTCOffset'] = str(value.TimeSeriesResultObj.ResultObj.ResultDateTimeUTCOffset)
                result['StatusCV'] = value.TimeSeriesResultObj.ResultObj.StatusCV
                result['SampledMediumCV'] = value.TimeSeriesResultObj.ResultObj.SampledMediumCV
                result['ValueCount'] = value.TimeSeriesResultObj.ResultObj.ValueCount

                samplingfeature = {}
                samplingfeature['SamplingFeatureUUID'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
                samplingfeature['SamplingFeatureTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
                samplingfeature['SamplingFeatureCode'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
                samplingfeature['SamplingFeatureName'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
                samplingfeature['Elevation_m'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

                action = {}
                action['ActionTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
                action['BeginDateTime'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
                action['BeginDateTimeUTCOffset'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
                action['EndDateTime'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
                action['EndDateTimeUTCOffset'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
                method = {}
                method['MethodTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
                method['MethodCode'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
                method['MethodName'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
                action['Method'] = method

                aid = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID 
                conn = ODM2Read(self._session)
                raction = conn.getRelatedActionsByActionID(aid)
                if raction != None:
                    arrayrelaction = []
                    for x in raction:
                        relaction = {}
                        relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                        relaction['ActionTypeCV'] = x.RelatedActionObj.ActionTypeCV
                        relaction['BeginDateTime'] = str(x.RelatedActionObj.BeginDateTime)
                        relaction['BeginDateTimeUTCOffset'] = x.RelatedActionObj.BeginDateTimeUTCOffset
                        relaction['EndDateTime'] = str(x.RelatedActionObj.EndDateTime)
                        relaction['EndDateTimeUTCOffset'] = str(x.RelatedActionObj.EndDateTimeUTCOffset)
                        relmethod = {}
                        relmethod['MethodTypeCV'] = x.RelatedActionObj.MethodObj.MethodTypeCV
                        relmethod['MethodCode'] = x.RelatedActionObj.MethodObj.MethodCode
                        relmethod['MethodName'] = x.RelatedActionObj.MethodObj.MethodName
                        relaction['Method'] = relmethod
                        arrayrelaction.append(relaction)

                        #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                        result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
                else:
                    result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

                sfid = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                site = conn.getSiteBySFId(sfid)
                if site != None:
                    s = {}
                    s['SiteTypeCV'] = site.SiteTypeCV
                    s['Latitude'] = site.Latitude
                    s['Longitude'] = site.Longitude
                    sr = {}
                    sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                    sr['SRSName'] = site.SpatialReferenceObj.SRSName
                    s['SpatialReference'] = sr
                    result['Site'] = s

                varone = {}
                varone['VariableTypeCV'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableTypeCV
                varone['VariableCode'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableCode
                varone['VariableNameCV'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableNameCV
                varone['NoDataValue'] = value.TimeSeriesResultObj.ResultObj.VariableObj.NoDataValue
                result['Variable'] = varone
            
                unit = {}
                unit['UnitsTypeCV'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsTypeCV
                unit['UnitsAbbreviation'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsAbbreviation
                unit['UnitsName'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsName
                result['Unit'] = unit
            
                pl = {}
                pl['ProcessingLevelCode'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode
                pl['Definition'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Definition
                pl['Explanation'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Explanation
                result['ProcessingLevel'] = pl

                mresult = {}
                if value.TimeSeriesResultObj.XLocation != None:
                    mresult['XLocation'] = value.TimeSeriesResultObj.XLocation
                else:
                    mresult['XLocation'] = ''
                if value.TimeSeriesResultObj.XLocationUnitsID != None:
                    mresult['XLocationUnitsID'] = value.TimeSeriesResultObj.XLocationUnitsID
                else:
                    mresult['XLocationUnitsID'] = ''
                if value.TimeSeriesResultObj.YLocation != None:
                    mresult['YLocation'] = value.TimeSeriesResultObj.YLocation
                else:
                    mresult['YLocation'] = ''
                if value.TimeSeriesResultObj.YLocationUnitsID != None:
                    mresult['YLocationUnitsID'] = value.TimeSeriesResultObj.YLocationUnitsID
                else:
                    mresult['YLocationUnitsID'] = ''
                if value.TimeSeriesResultObj.ZLocation != None:
                    mresult['ZLocation'] = value.TimeSeriesResultObj.ZLocation
                else:
                    mresult['ZLocation'] = ''
                if value.TimeSeriesResultObj.ZLocationUnitsID != None:
                    mresult['ZLocationUnitsID'] = value.TimeSeriesResultObj.ZLocationUnitsID
                else:
                    mresult['ZLocationUnitsID'] = ''

                if value.TimeSeriesResultObj.SpatialReferenceID != None:
                    msr = {}
                    msr['SRSCode'] = value.TimeSeriesResultObj.SpatialReferenceObj.SRSCode
                    msr['SRSName'] = value.TimeSeriesResultObj.SpatialReferenceObj.SRSName
                    mresult['SpatialReference'] = msr
                else:
                    mresult['SpatialReference'] = ''
            
                if value.TimeSeriesResultObj.IntendedTimeSpacing != None:
                    mresult['IntendedTimeSpacing'] = value.TimeSeriesResultObj.IntendedTimeSpacing
                else:
                    mresult['IntendedTimeSpacing'] = ''
                if value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID != None:
                    mresult['IntendedTimeSpacingUnitsID'] = value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID
                else:
                    mresult['IntendedTimeSpacingUnitsID'] = ''

                mresult['CensorCodeCV'] = value.CensorCodeCV
                mresult['QualityCodeCV'] = value.QualityCodeCV
                mresult['AggregationStatisticCV'] = value.TimeSeriesResultObj.AggregationStatisticCV
                mresult['TimeAggregationInterval'] = value.TimeAggregationInterval

                tunit = {}
                tunit['UnitsTypeCV'] = value.TimeUnitObj.UnitsTypeCV
                tunit['UnitsAbbreviation'] = value.TimeUnitObj.UnitsAbbreviation
                tunit['UnitsName'] = value.TimeUnitObj.UnitsName
                mresult['TimeAggregationIntervalUnit'] = tunit
                result['TimeSeriesResult'] = mresult
                flag = False

            mvalue = {}
            mvalue['ValueDateTime'] = str(value.ValueDateTime)
            mvalue['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            mvalue['DataValue'] = value.DataValue
            results.append(mvalue)

        final_result = {'Result':result,'DataRecords':results}

        self._session.close()
        return final_result

    def json_measurementdata(self, items):

        results = []
        for value in items:

            result = {}
            result['ResultUUID'] = value.MeasurementResultObj.ResultObj.ResultUUID
            result['ResultTypeCV'] = value.MeasurementResultObj.ResultObj.ResultTypeCV
            result['ResultDateTime'] = str(value.MeasurementResultObj.ResultObj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.MeasurementResultObj.ResultObj.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.MeasurementResultObj.ResultObj.StatusCV
            result['SampledMediumCV'] = value.MeasurementResultObj.ResultObj.SampledMediumCV
            result['ValueCount'] = value.MeasurementResultObj.ResultObj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method

            aid = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID 
            conn = ODM2Read(self._session)
            raction = conn.getRelatedActionsByActionID(aid)
            if raction != None:
                arrayrelaction = []
                for x in raction:
                    relaction = {}
                    relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                    relaction['ActionTypeCV'] = x.RelatedActionObj.ActionTypeCV
                    relaction['BeginDateTime'] = str(x.RelatedActionObj.BeginDateTime)
                    relaction['BeginDateTimeUTCOffset'] = x.RelatedActionObj.BeginDateTimeUTCOffset
                    relaction['EndDateTime'] = str(x.RelatedActionObj.EndDateTime)
                    relaction['EndDateTimeUTCOffset'] = str(x.RelatedActionObj.EndDateTimeUTCOffset)
                    relmethod = {}
                    relmethod['MethodTypeCV'] = x.RelatedActionObj.MethodObj.MethodTypeCV
                    relmethod['MethodCode'] = x.RelatedActionObj.MethodObj.MethodCode
                    relmethod['MethodName'] = x.RelatedActionObj.MethodObj.MethodName
                    relaction['Method'] = relmethod
                    arrayrelaction.append(relaction)

                #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
            else:
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr = {}
                sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                sr['SRSName'] = site.SpatialReferenceObj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableCode
            varone['VariableNameCV'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.MeasurementResultObj.ResultObj.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Definition
            pl['Explanation'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            mresult = {}
            if value.MeasurementResultObj.XLocation != None:
                mresult['XLocation'] = value.MeasurementResultObj.XLocation
            else:
                mresult['XLocation'] = ''
            if value.MeasurementResultObj.XLocationUnitsID != None:
                mresult['XLocationUnitsID'] = value.MeasurementResultObj.XLocationUnitsID
            else:
                mresult['XLocationUnitsID'] = ''
            if value.MeasurementResultObj.YLocation != None:
                mresult['YLocation'] = value.MeasurementResultObj.YLocation
            else:
                mresult['YLocation'] = ''
            if value.MeasurementResultObj.YLocationUnitsID != None:
                mresult['YLocationUnitsID'] = value.MeasurementResultObj.YLocationUnitsID
            else:
                mresult['YLocationUnitsID'] = ''
            if value.MeasurementResultObj.ZLocation != None:
                mresult['ZLocation'] = value.MeasurementResultObj.ZLocation
            else:
                mresult['ZLocation'] = ''
            if value.MeasurementResultObj.ZLocationUnitsID != None:
                mresult['ZLocationUnitsID'] = value.MeasurementResultObj.ZLocationUnitsID
            else:
                mresult['ZLocationUnitsID'] = ''

            if value.MeasurementResultObj.SpatialReferenceID != None:
                msr = {}
                msr['SRSCode'] = value.MeasurementResultObj.SpatialReferenceObj.SRSCode
                msr['SRSName'] = value.MeasurementResultObj.SpatialReferenceObj.SRSName
                mresult['SpatialReference'] = msr
            else:
                mresult['SpatialReference'] = ''
            
            mresult['CensorCodeCV'] = value.MeasurementResultObj.CensorCodeCV
            mresult['QualityCodeCV'] = value.MeasurementResultObj.QualityCodeCV
            mresult['AggregationStatisticCV'] = value.MeasurementResultObj.AggregationStatisticCV
            mresult['TimeAggregationInterval'] = value.MeasurementResultObj.TimeAggregationInterval

            tunit = {}
            tunit['UnitsTypeCV'] = value.MeasurementResultObj.TimeUnitObj.UnitsTypeCV
            tunit['UnitsAbbreviation'] = value.MeasurementResultObj.TimeUnitObj.UnitsAbbreviation
            tunit['UnitsName'] = value.MeasurementResultObj.TimeUnitObj.UnitsName
            mresult['TimeAggregationIntervalUnit'] = tunit

            mvalue = {}
            mvalue['ValueDateTime'] = str(value.ValueDateTime)
            mvalue['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            mvalue['DataValue'] = value.DataValue
            mresult['MeasurementResultValues'] = mvalue
            result['MeasurementResult'] = mresult

            results.append(result)

        self._session.close()
        return results

    def csv_timeseriesdata(self, items):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="values.csv"'

        item_csv_header = ["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount","SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.Elevation_m","Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']","Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']","TimeSeriesResult.XLocation","TimeSeriesResult.XLocationUnitsID","TimeSeriesResult.YLocation","TimeSeriesResult.YLocationUnitsID","TimeSeriesResult.ZLocation","TimeSeriesResult.ZLocationUnitsID","TimeSeriesResult.CensorCodeCV[type='string']","TimeSeriesResult.QualityCodeCV[type='string']","TimeSeriesResult.AggregationStatisticCV[type='string']","TimeSeriesResult.TimeAggregationInterval","TimeSeriesResult.TimeUnit.UnitsTypeCV[type='string']","TimeSeriesResult.TimeUnit.UnitsAbbreviation[type='string']","TimeSeriesResult.TimeUnit.UnitsName[type='string']","TimeSeriesResultValues.ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","TimeSeriesResultValues.ValueDateTimeUTCOffset","TimeSeriesResultValues.DataValue"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for value in items:
            row = []

            row.append(value.ResultID)
            row.append(value.TimeSeriesResultObj.ResultObj.ResultUUID)
            row.append(value.TimeSeriesResultObj.ResultObj.ResultTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.ResultDateTime)
            row.append(value.TimeSeriesResultObj.ResultObj.ResultDateTimeUTCOffset)
            row.append(value.TimeSeriesResultObj.ResultObj.StatusCV)
            row.append(value.TimeSeriesResultObj.ResultObj.SampledMediumCV)
            row.append(value.TimeSeriesResultObj.ResultObj.ValueCount)

            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)

            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode)
            row.append(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName)

            row.append(value.TimeSeriesResultObj.ResultObj.VariableObj.VariableTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.VariableObj.VariableCode)
            row.append(value.TimeSeriesResultObj.ResultObj.VariableObj.VariableNameCV)
            row.append(value.TimeSeriesResultObj.ResultObj.VariableObj.NoDataValue)

            row.append(value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsTypeCV)
            row.append(value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsAbbreviation)
            row.append(value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsName)

            row.append(value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode)
            row.append(value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Definition)
            row.append(value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Explanation)

            if value.TimeSeriesResultObj.XLocation != None:
                row.append(value.TimeSeriesResultObj.XLocation)
            else:
                row.append('')
            if value.TimeSeriesResultObj.XLocationUnitsID != None:
                row.append(value.TimeSeriesResultObj.XLocationUnitsID)
            else:
                row.append('')
            if value.TimeSeriesResultObj.YLocation != None:
                row.append(value.TimeSeriesResultObj.YLocation)
            else:
                row.append('')
            if value.TimeSeriesResultObj.YLocationUnitsID != None:
                row.append(value.TimeSeriesResultObj.YLocationUnitsID)
            else:
                row.append('')
            if value.TimeSeriesResultObj.ZLocation != None:
                row.append(value.TimeSeriesResultObj.ZLocation)
            else:
                row.append('')
            if value.TimeSeriesResultObj.ZLocationUnitsID != None:
                row.append(value.TimeSeriesResultObj.ZLocationUnitsID)
            else:
                row.append('')

            row.append(value.CensorCodeCV)
            row.append(value.QualityCodeCV)
            row.append(value.TimeSeriesResultObj.AggregationStatisticCV)
            row.append(value.TimeAggregationInterval)

            row.append(value.TimeUnitObj.UnitsTypeCV)
            row.append(value.TimeUnitObj.UnitsAbbreviation)
            row.append(value.TimeUnitObj.UnitsName)

            row.append(value.ValueDateTime)
            row.append(value.ValueDateTimeUTCOffset)
            row.append(value.DataValue)

            writer.writerow(row)

        self._session.close()
        return response        

    def csv_measurementdata(self, items):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="values.csv"'

        item_csv_header = ["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount","SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.Elevation_m","Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']","Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']","MeasurementResult.XLocation","MeasurementResult.XLocationUnitsID","MeasurementResult.YLocation","MeasurementResult.YLocationUnitsID","MeasurementResult.ZLocation","MeasurementResult.ZLocationUnitsID","MeasurementResult.CensorCodeCV[type='string']","MeasurementResult.QualityCodeCV[type='string']","MeasurementResult.AggregationStatisticCV[type='string']","MeasurementResult.TimeAggregationInterval","MeasurementResult.TimeUnit.UnitsTypeCV[type='string']","MeasurementResult.TimeUnit.UnitsAbbreviation[type='string']","MeasurementResult.TimeUnit.UnitsName[type='string']","MeasurementResultValues.ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","MeasurementResultValues.ValueDateTimeUTCOffset","MeasurementResultValues.DataValue"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for value in items:
            row = []

            row.append(value.ResultID)
            row.append(value.MeasurementResultObj.ResultObj.ResultUUID)
            row.append(value.MeasurementResultObj.ResultObj.ResultTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.ResultDateTime)
            row.append(value.MeasurementResultObj.ResultObj.ResultDateTimeUTCOffset)
            row.append(value.MeasurementResultObj.ResultObj.StatusCV)
            row.append(value.MeasurementResultObj.ResultObj.SampledMediumCV)
            row.append(value.MeasurementResultObj.ResultObj.ValueCount)

            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)

            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode)
            row.append(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName)

            row.append(value.MeasurementResultObj.ResultObj.VariableObj.VariableTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.VariableObj.VariableCode)
            row.append(value.MeasurementResultObj.ResultObj.VariableObj.VariableNameCV)
            row.append(value.MeasurementResultObj.ResultObj.VariableObj.NoDataValue)

            row.append(value.MeasurementResultObj.ResultObj.UnitsObj.UnitsTypeCV)
            row.append(value.MeasurementResultObj.ResultObj.UnitsObj.UnitsAbbreviation)
            row.append(value.MeasurementResultObj.ResultObj.UnitsObj.UnitsName)

            row.append(value.MeasurementResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode)
            row.append(value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Definition)
            row.append(value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Explanation)

            if value.MeasurementResultObj.XLocation != None:
                row.append(value.MeasurementResultObj.XLocation)
            else:
                row.append('')
            if value.MeasurementResultObj.XLocationUnitsID != None:
                row.append(value.MeasurementResultObj.XLocationUnitsID)
            else:
                row.append('')
            if value.MeasurementResultObj.YLocation != None:
                row.append(value.MeasurementResultObj.YLocation)
            else:
                row.append('')
            if value.MeasurementResultObj.YLocationUnitsID != None:
                row.append(value.MeasurementResultObj.YLocationUnitsID)
            else:
                row.append('')
            if value.MeasurementResultObj.ZLocation != None:
                row.append(value.MeasurementResultObj.ZLocation)
            else:
                row.append('')
            if value.MeasurementResultObj.ZLocationUnitsID != None:
                row.append(value.MeasurementResultObj.ZLocationUnitsID)
            else:
                row.append('')

            row.append(value.MeasurementResultObj.CensorCodeCV)
            row.append(value.MeasurementResultObj.QualityCodeCV)
            row.append(value.MeasurementResultObj.AggregationStatisticCV)
            row.append(value.MeasurementResultObj.TimeAggregationInterval)

            row.append(value.MeasurementResultObj.TimeUnitObj.UnitsTypeCV)
            row.append(value.MeasurementResultObj.TimeUnitObj.UnitsAbbreviation)
            row.append(value.MeasurementResultObj.TimeUnitObj.UnitsName)

            row.append(value.ValueDateTime)
            row.append(value.ValueDateTimeUTCOffset)
            row.append(value.DataValue)

            writer.writerow(row)

        self._session.close()
        return response
        

    def yaml_timeseriesdata(self, items):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'

        response.write("---\n")

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
                conn = ODM2Read(self._session)
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

        self._session.close()
        return response

    def yaml_measurementdata(self, items):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'
        response.write("---\n")

        for value in items:
            r = u'Result: &ResultID%03d\n' % value.ResultID
            r += u'   ResultUUID: "%s"\n' % value.MeasurementResultObj.ResultObj.ResultUUID
            r += u'   ResultTypeCV: \'%s\'\n' % value.MeasurementResultObj.ResultObj.ResultTypeCV
            r += u'   ResultDateTime: "%s"\n' % str(value.MeasurementResultObj.ResultObj.ResultDateTime)
            r += u'   ResultDateTimeUTCOffset: %d\n' % value.MeasurementResultObj.ResultObj.ResultDateTimeUTCOffset
            r += u'   StatusCV: %s\n' % value.MeasurementResultObj.ResultObj.StatusCV
            r += u'   SampledMediumCV: %s\n' % value.MeasurementResultObj.ResultObj.SampledMediumCV
            r += u'   ValueCount: %d\n' % value.MeasurementResultObj.ResultObj.ValueCount
            r += u'   FeatureAction: \n'
            r += u'       SamplingFeature:\n'
            r += u'           SamplingFeatureID: %d\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            r += u'           SamplingFeatureCode: %s\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            r += u'           Elevation_m: %s\n' % str(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            r += u'           Action:\n'
            r += u'               ActionID: %d\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID
            r += u'               BeginDateTime: "%s"\n' % str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            r += u'               BeginDateTimeUTCOffset: %d\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            r += u'               EndDateTime: "%s"\n' % str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            r += u'               EndDateTimeUTCOffset: %s\n' % str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            r += u'               Method:\n'
            r += u'                   MethodID: %d\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodID
            r += u'                   MethodCode: %s\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            r += u'                   MethodName: %s\n' % value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            aid = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID 
            conn = ODM2Read(self._session)
            raction = conn.getRelatedActionsByActionID(aid)
            if raction != None:
                r += u'   RelatedActions:\n'
                for x in raction:
                    r += u'       RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    r += u'       RelatedActionID:\n'
                    r += u'           BeginDateTime: "%s"\n' % str(x.RelatedActionObj.BeginDateTime)
                    r += u'           BeginDateTimeUTCOffset: %d\n' % x.RelatedActionObj.BeginDateTimeUTCOffset
                    r += u'           EndDateTime: "%s"\n' % str(x.RelatedActionObj.EndDateTime)
                    r += u'           EndDateTimeUTCOffset: %s\n' % str(x.RelatedActionObj.EndDateTimeUTCOffset)
                    r += u'           Method:\n'
                    r += u'               MethodID: %d\n' % x.RelatedActionObj.MethodObj.MethodID
                    r += u'               MethodCode: %s\n' % x.RelatedActionObj.MethodObj.MethodCode
                    r += u'               MethodName: %s\n' % x.RelatedActionObj.MethodObj.MethodName

            sfid = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
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
            r += u'       VariableID: %d\n' % value.MeasurementResultObj.ResultObj.VariableObj.VariableID
            r += u'       VariableCode: %s\n' % value.MeasurementResultObj.ResultObj.VariableObj.VariableCode
            r += u'       VariableNameCV: %s\n' % value.MeasurementResultObj.ResultObj.VariableObj.VariableNameCV
            r += u'       NoDataValue: %s\n' % str(value.MeasurementResultObj.ResultObj.VariableObj.NoDataValue)
            r += u'   Unit:\n'
            r += u'       UnitID: %d\n' % value.MeasurementResultObj.ResultObj.UnitsObj.UnitsID
            r += u'       UnitsAbbreviation: %s\n' % value.MeasurementResultObj.ResultObj.UnitsObj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % value.MeasurementResultObj.ResultObj.UnitsObj.UnitsName

            r += u'   ProcessingLevel:\n'
            r += u'       ProcessingLevelID: %d\n' % value.MeasurementResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % value.MeasurementResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode

            tsr  = u'MeasurementResult: &MeasurementResultID%03d\n' % value.MeasurementResultObj.ResultID
            tsr += u'    ResultID: *ResultID%03d\n' % value.MeasurementResultObj.ResultID
            if value.MeasurementResultObj.XLocation != None:
                tsr += u'    XLocation: %f\n' % value.MeasurementResultObj.XLocation
            else:
                tsr += u'    XLocation: NULL\n'
            if value.MeasurementResultObj.XLocationUnitsID != None:
                tsr += u'    XLocationUnitsID: *UnitID%03d\n' % value.MeasurementResultObj.XLocationUnitsID
            else:
                tsr += u'    XLocationUnitsID: NULL\n'
            if value.MeasurementResultObj.YLocation != None:
                tsr += u'    YLocation: %f\n' % value.MeasurementResultObj.YLocation
            else:
                tsr += u'    YLocation: NULL\n'
            if value.MeasurementResultObj.YLocationUnitsID != None:
                tsr += u'    YLocationUnitsID: *UnitID%03d\n' % value.MeasurementResultObj.YLocationUnitsID
            else:
                tsr += u'    YLocationUnitsID: NULL\n'
            if value.MeasurementResultObj.ZLocation != None:
                tsr += u'    ZLocation: %f\n' % value.MeasurementResultObj.ZLocation
            else:
                tsr += u'    ZLocation: NULL\n'
            if value.MeasurementResultObj.ZLocationUnitsID != None:
                tsr += u'    ZLocationUnitsID: *UnitID%03d\n' % value.MeasurementResultObj.ZLocationUnitsID
            else:
                tsr += u'    ZLocationUnitsID: NULL\n'
            if value.MeasurementResultObj.SpatialReferenceID != None:
                tsr += u'    SpatialReferenceID: *SRSID%03d\n' % value.MeasurementResultObj.SpatialReferenceID
            else:
                tsr += u'    SpatialReferenceID: NULL\n'
            
            tsr += u'    CensorCodeCV: %s\n' % value.MeasurementResultObj.CensorCodeCV
            tsr += u'    QualityCodeCV: %s\n' % value.MeasurementResultObj.QualityCodeCV
            tsr += u'    AggregationStatisticCV: %s\n' % value.MeasurementResultObj.AggregationStatisticCV
            tsr += u'    TimeAggregationInterval: %d\n' % value.MeasurementResultObj.TimeAggregationInterval
            tsr += u'    TimeAggregationIntervalUnitsID:\n'

            tsr += u'        UnitID: %d\n' % value.MeasurementResultObj.TimeUnitObj.UnitsID
            tsr += u'        UnitsAbbreviation: %s\n' % value.MeasurementResultObj.TimeUnitObj.UnitsAbbreviation
            tsr += u'        UnitsName: %s\n\n' % value.MeasurementResultObj.TimeUnitObj.UnitsName

            tsr += u'MeasurementResultValues:\n'
            tsr += u'    ResultID: *MeasurementResultID%03d\n' % value.ResultID
            tsr += u'    ValueDateTime: %s\n' % str(value.ValueDateTime)
            tsr += u'    ValueDateTimeUTCOffset: %d\n' % value.ValueDateTimeUTCOffset
            tsr += u'    DataValue: %f\n' % value.DataValue

        response.write(r)
        response.write('\n')
        response.write(tsr)
        #response.write(pyaml.dump(allvalues,vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_timeseriesdata(self, items):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="values.xml"'
        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        flag = True
        result = {}
        results = []
        for value in items:

            if flag:
                result['ResultUUID'] = value.TimeSeriesResultObj.ResultObj.ResultUUID
                result['ResultTypeCV'] = value.TimeSeriesResultObj.ResultObj.ResultTypeCV
                result['ResultDateTime'] = str(value.TimeSeriesResultObj.ResultObj.ResultDateTime)
                result['ResultDateTimeUTCOffset'] = str(value.TimeSeriesResultObj.ResultObj.ResultDateTimeUTCOffset)
                result['StatusCV'] = value.TimeSeriesResultObj.ResultObj.StatusCV
                result['SampledMediumCV'] = value.TimeSeriesResultObj.ResultObj.SampledMediumCV
                result['ValueCount'] = value.TimeSeriesResultObj.ResultObj.ValueCount

                samplingfeature = {}
                samplingfeature['SamplingFeatureUUID'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
                samplingfeature['SamplingFeatureTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
                samplingfeature['SamplingFeatureCode'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
                samplingfeature['SamplingFeatureName'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
                samplingfeature['Elevation_m'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

                action = {}
                action['ActionTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
                action['BeginDateTime'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
                action['BeginDateTimeUTCOffset'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
                action['EndDateTime'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
                action['EndDateTimeUTCOffset'] = str(value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
                method = {}
                method['MethodTypeCV'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
                method['MethodCode'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
                method['MethodName'] = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
                action['Method'] = method

                aid = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID 
                conn = ODM2Read(self._session)
                raction = conn.getRelatedActionsByActionID(aid)
                if raction != None:
                    arrayrelaction = []
                    for x in raction:
                        relaction = {}
                        relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                        relaction['ActionTypeCV'] = x.RelatedActionObj.ActionTypeCV
                        relaction['BeginDateTime'] = str(x.RelatedActionObj.BeginDateTime)
                        relaction['BeginDateTimeUTCOffset'] = x.RelatedActionObj.BeginDateTimeUTCOffset
                        relaction['EndDateTime'] = str(x.RelatedActionObj.EndDateTime)
                        relaction['EndDateTimeUTCOffset'] = str(x.RelatedActionObj.EndDateTimeUTCOffset)
                        relmethod = {}
                        relmethod['MethodTypeCV'] = x.RelatedActionObj.MethodObj.MethodTypeCV
                        relmethod['MethodCode'] = x.RelatedActionObj.MethodObj.MethodCode
                        relmethod['MethodName'] = x.RelatedActionObj.MethodObj.MethodName
                        relaction['Method'] = relmethod
                        arrayrelaction.append(relaction)

                        #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                        result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
                else:
                    result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

                sfid = value.TimeSeriesResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
                site = conn.getSiteBySFId(sfid)
                if site != None:
                    s = {}
                    s['SiteTypeCV'] = site.SiteTypeCV
                    s['Latitude'] = site.Latitude
                    s['Longitude'] = site.Longitude
                    sr = {}
                    sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                    sr['SRSName'] = site.SpatialReferenceObj.SRSName
                    s['SpatialReference'] = sr
                    result['Site'] = s

                varone = {}
                varone['VariableTypeCV'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableTypeCV
                varone['VariableCode'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableCode
                varone['VariableNameCV'] = value.TimeSeriesResultObj.ResultObj.VariableObj.VariableNameCV
                varone['NoDataValue'] = value.TimeSeriesResultObj.ResultObj.VariableObj.NoDataValue
                result['Variable'] = varone
            
                unit = {}
                unit['UnitsTypeCV'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsTypeCV
                unit['UnitsAbbreviation'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsAbbreviation
                unit['UnitsName'] = value.TimeSeriesResultObj.ResultObj.UnitsObj.UnitsName
                result['Unit'] = unit
            
                pl = {}
                pl['ProcessingLevelCode'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode
                pl['Definition'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Definition
                pl['Explanation'] = value.TimeSeriesResultObj.ResultObj.ProcessingLevelObj.Explanation
                result['ProcessingLevel'] = pl

                mresult = {}
                if value.TimeSeriesResultObj.XLocation != None:
                    mresult['XLocation'] = value.TimeSeriesResultObj.XLocation
                else:
                    mresult['XLocation'] = ''
                if value.TimeSeriesResultObj.XLocationUnitsID != None:
                    mresult['XLocationUnitsID'] = value.TimeSeriesResultObj.XLocationUnitsID
                else:
                    mresult['XLocationUnitsID'] = ''
                if value.TimeSeriesResultObj.YLocation != None:
                    mresult['YLocation'] = value.TimeSeriesResultObj.YLocation
                else:
                    mresult['YLocation'] = ''
                if value.TimeSeriesResultObj.YLocationUnitsID != None:
                    mresult['YLocationUnitsID'] = value.TimeSeriesResultObj.YLocationUnitsID
                else:
                    mresult['YLocationUnitsID'] = ''
                if value.TimeSeriesResultObj.ZLocation != None:
                    mresult['ZLocation'] = value.TimeSeriesResultObj.ZLocation
                else:
                    mresult['ZLocation'] = ''
                if value.TimeSeriesResultObj.ZLocationUnitsID != None:
                    mresult['ZLocationUnitsID'] = value.TimeSeriesResultObj.ZLocationUnitsID
                else:
                    mresult['ZLocationUnitsID'] = ''

                if value.TimeSeriesResultObj.SpatialReferenceID != None:
                    msr = {}
                    msr['SRSCode'] = value.TimeSeriesResultObj.SpatialReferenceObj.SRSCode
                    msr['SRSName'] = value.TimeSeriesResultObj.SpatialReferenceObj.SRSName
                    mresult['SpatialReference'] = msr
                else:
                    mresult['SpatialReference'] = ''
            
                if value.TimeSeriesResultObj.IntendedTimeSpacing != None:
                    mresult['IntendedTimeSpacing'] = value.TimeSeriesResultObj.IntendedTimeSpacing
                else:
                    mresult['IntendedTimeSpacing'] = ''
                if value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID != None:
                    mresult['IntendedTimeSpacingUnitsID'] = value.TimeSeriesResultObj.IntendedTimeSpacingUnitsID
                else:
                    mresult['IntendedTimeSpacingUnitsID'] = ''

                mresult['CensorCodeCV'] = value.CensorCodeCV
                mresult['QualityCodeCV'] = value.QualityCodeCV
                mresult['AggregationStatisticCV'] = value.TimeSeriesResultObj.AggregationStatisticCV
                mresult['TimeAggregationInterval'] = value.TimeAggregationInterval

                tunit = {}
                tunit['UnitsTypeCV'] = value.TimeUnitObj.UnitsTypeCV
                tunit['UnitsAbbreviation'] = value.TimeUnitObj.UnitsAbbreviation
                tunit['UnitsName'] = value.TimeUnitObj.UnitsName
                mresult['TimeAggregationIntervalUnit'] = tunit
                result['TimeSeriesResult'] = mresult
                flag = False

            mvalue = {}
            mvalue['ValueDateTime'] = str(value.ValueDateTime)
            mvalue['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            mvalue['DataValue'] = value.DataValue
            results.append(mvalue)

        response.write(xmlify({'Result':result,'DataRecords':{'Data':results}}, wrap="Results", indent="  "))

        self._session.close()
        return response

    def xml_measurementdata(self, items):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="values.xml"'
        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        results = []
        for value in items:

            result = {}
            result['ResultUUID'] = value.MeasurementResultObj.ResultObj.ResultUUID
            result['ResultTypeCV'] = value.MeasurementResultObj.ResultObj.ResultTypeCV
            result['ResultDateTime'] = str(value.MeasurementResultObj.ResultObj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.MeasurementResultObj.ResultObj.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.MeasurementResultObj.ResultObj.StatusCV
            result['SampledMediumCV'] = value.MeasurementResultObj.ResultObj.SampledMediumCV
            result['ValueCount'] = value.MeasurementResultObj.ResultObj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method

            aid = value.MeasurementResultObj.ResultObj.FeatureActionObj.ActionObj.ActionID 
            conn = ODM2Read(self._session)
            raction = conn.getRelatedActionsByActionID(aid)
            if raction != None:
                arrayrelaction = []
                for x in raction:
                    relaction = {}
                    relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                    relaction['ActionTypeCV'] = x.RelatedActionObj.ActionTypeCV
                    relaction['BeginDateTime'] = str(x.RelatedActionObj.BeginDateTime)
                    relaction['BeginDateTimeUTCOffset'] = x.RelatedActionObj.BeginDateTimeUTCOffset
                    relaction['EndDateTime'] = str(x.RelatedActionObj.EndDateTime)
                    relaction['EndDateTimeUTCOffset'] = str(x.RelatedActionObj.EndDateTimeUTCOffset)
                    relmethod = {}
                    relmethod['MethodTypeCV'] = x.RelatedActionObj.MethodObj.MethodTypeCV
                    relmethod['MethodCode'] = x.RelatedActionObj.MethodObj.MethodCode
                    relmethod['MethodName'] = x.RelatedActionObj.MethodObj.MethodName
                    relaction['Method'] = relmethod
                    arrayrelaction.append(relaction)

                #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
            else:
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.MeasurementResultObj.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr = {}
                sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                sr['SRSName'] = site.SpatialReferenceObj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableCode
            varone['VariableNameCV'] = value.MeasurementResultObj.ResultObj.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.MeasurementResultObj.ResultObj.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.MeasurementResultObj.ResultObj.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Definition
            pl['Explanation'] = value.MeasurementResultObj.ResultObj.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            mresult = {}
            if value.MeasurementResultObj.XLocation != None:
                mresult['XLocation'] = value.MeasurementResultObj.XLocation
            else:
                mresult['XLocation'] = ''
            if value.MeasurementResultObj.XLocationUnitsID != None:
                mresult['XLocationUnitsID'] = value.MeasurementResultObj.XLocationUnitsID
            else:
                mresult['XLocationUnitsID'] = ''
            if value.MeasurementResultObj.YLocation != None:
                mresult['YLocation'] = value.MeasurementResultObj.YLocation
            else:
                mresult['YLocation'] = ''
            if value.MeasurementResultObj.YLocationUnitsID != None:
                mresult['YLocationUnitsID'] = value.MeasurementResultObj.YLocationUnitsID
            else:
                mresult['YLocationUnitsID'] = ''
            if value.MeasurementResultObj.ZLocation != None:
                mresult['ZLocation'] = value.MeasurementResultObj.ZLocation
            else:
                mresult['ZLocation'] = ''
            if value.MeasurementResultObj.ZLocationUnitsID != None:
                mresult['ZLocationUnitsID'] = value.MeasurementResultObj.ZLocationUnitsID
            else:
                mresult['ZLocationUnitsID'] = ''

            if value.MeasurementResultObj.SpatialReferenceID != None:
                msr = {}
                msr['SRSCode'] = value.MeasurementResultObj.SpatialReferenceObj.SRSCode
                msr['SRSName'] = value.MeasurementResultObj.SpatialReferenceObj.SRSName
                mresult['SpatialReference'] = msr
            else:
                mresult['SpatialReference'] = ''
            
            mresult['CensorCodeCV'] = value.MeasurementResultObj.CensorCodeCV
            mresult['QualityCodeCV'] = value.MeasurementResultObj.QualityCodeCV
            mresult['AggregationStatisticCV'] = value.MeasurementResultObj.AggregationStatisticCV
            mresult['TimeAggregationInterval'] = value.MeasurementResultObj.TimeAggregationInterval

            tunit = {}
            tunit['UnitsTypeCV'] = value.MeasurementResultObj.TimeUnitObj.UnitsTypeCV
            tunit['UnitsAbbreviation'] = value.MeasurementResultObj.TimeUnitObj.UnitsAbbreviation
            tunit['UnitsName'] = value.MeasurementResultObj.TimeUnitObj.UnitsName
            mresult['TimeAggregationIntervalUnit'] = tunit

            mvalue = {}
            mvalue['ValueDateTime'] = str(value.ValueDateTime)
            mvalue['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            mvalue['DataValue'] = value.DataValue
            mresult['MeasurementResultValues'] = mvalue
            result['MeasurementResult'] = mresult

            results.append(result)

        response.write(xmlify({'Result':results}, wrap="Results", indent="  "))

        self._session.close()
        return response
