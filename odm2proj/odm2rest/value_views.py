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

        if mr.resulttypecv_to_id[ts.ResultTypeCV] == 'TSC':
            count = readConn.getCountForTimeSeriesResultValuesByResultID(ts.ResultID)
            if count > 1000:
                items = readConn.getTimeSeriesResultValuesByResultIDByPage(ts.ResultID, page, page_size)
            else:
                items = readConn.getTimeSeriesResultValuesByResultID(ts.ResultID)
        elif mr.resulttypecv_to_id[ts.ResultTypeCV] == 'M':
            #count = readConn.getCountForMeasurementResultValuesByResultID(ts.ResultID)            
            #if count > 10:
            #    items = readConn.getMeasurementResultValuesByResultIDByPage(ts.ResultID, page, page_size)            
            #else:
            items = readConn.getMeasurementResultValuesByResultID(ts.ResultID)            
            #items = getattr(readConn,id_to_method['m'])(ts.ResultID)            

        if items == None or len(items) == 0:
            return Response('time series data is not available.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        if self.resulttypecv_to_id[self.resulttypecv] == 'TSC':
            return self.json_timeseriesdata()
        elif self.resulttypecv_to_id[self.resulttypecv] == 'M':
            return self.json_measurementdata()

    def csv_format(self):

        if self.resulttypecv_to_id[self.resulttypecv] == 'TSC':
            return self.csv_timeseriesdata()
        elif self.resulttypecv_to_id[self.resulttypecv] == 'M':
            return self.csv_measurementdata()

    def yaml_format(self):

        if self.resulttypecv_to_id[self.resulttypecv] == 'TSC':
            return self.yaml_timeseriesdata()
        elif self.resulttypecv_to_id[self.resulttypecv] == 'M':
            return self.yaml_measurementdata()

    def xml_format(self):

        if self.resulttypecv_to_id[self.resulttypecv] == 'TSC':
            return self.xml_timeseriesdata()
        elif self.resulttypecv_to_id[self.resulttypecv] == 'M':
            return self.xml_measurementdata()

    def json_timeseriesdata(self):

        result, results = self.sqlalchemy_timeseries_object_to_dict()
        final_result = {'Result':result,'DataRecords':results}
        return final_result

    def json_measurementdata(self):

        return self.sqlalchemy_measurement_object_to_dict()

    def csv_timeseriesdata(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="values.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount"])
        item_csv_header.extend(["SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.SamplingFeatureDescription[type='string']","SamplingFeature.SamplingFeatureGeotypeCV[type='string']","SamplingFeature.Elevation_m[unit='m']","SamplingFeature.ElevationDatumCV[type='string']","SamplingFeature.FeatureGeometry[type='string']"])
        item_csv_header.extend(["Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']"])
        item_csv_header.extend(["Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue"])
        item_csv_header.extend(["Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"])
        item_csv_header.extend(["TimeSeriesResult.XLocation","TimeSeriesResult.XLocationUnitsID","TimeSeriesResult.YLocation","TimeSeriesResult.YLocationUnitsID","TimeSeriesResult.ZLocation","TimeSeriesResult.ZLocationUnitsID","TimeSeriesResult.CensorCodeCV[type='string']","TimeSeriesResult.QualityCodeCV[type='string']","TimeSeriesResult.AggregationStatisticCV[type='string']","TimeSeriesResult.TimeAggregationInterval","TimeSeriesResult.TimeUnit.UnitsTypeCV[type='string']"])
        item_csv_header.extend(["TimeSeriesResult.TimeUnit.UnitsAbbreviation[type='string']","TimeSeriesResult.TimeUnit.UnitsName[type='string']","TimeSeriesResultValues.ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","TimeSeriesResultValues.ValueDateTimeUTCOffset","TimeSeriesResultValues.DataValue"])

        item_csv_header.extend(["Site.SiteTypeCV[type='string']","Site.Latitude[unit='degrees']","Site.Longitude[unit='degrees']","Site.SpatialReference.SRSCode[type='string']","Site.SpatialReference.SRSName[type='string']"])
        item_csv_header.extend(["RelatedFeature.RelationshipTypeCV[type='string']","RelatedFeature.SamplingFeatureUUID[type='string']","RelatedFeature.SamplingFeatureTypeCV[type='string']","RelatedFeature.SamplingFeatureCode[type='string']","RelatedFeature.SamplingFeatureName[type='string']","RelatedFeature.SamplingFeatureDescription[type='string']","RelatedFeature.SamplingFeatureGeotypeCV[type='string']","RelatedFeature.Elevation_m[unit='m']","RelatedFeature.ElevationDatumCV[type='string']","RelatedFeature.FeatureGeometry[type='string']","RelatedFeature.Site.SiteTypeCV[type='string']","RelatedFeature.Site.Latitude[unit='degrees']","RelatedFeature.Site.Longitude[unit='degrees']","RelatedFeature.Site.SpatialReference.SRSCode[type='string']","RelatedFeature.Site.SpatialReference.SRSName[type='string']"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
        conn = ODM2Read(self._session)
            
        for value in self.items:
            row = []

            t_obj = value.TimeSeriesResultObj
            r_obj = t_obj.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj
            tu_obj = value.TimeUnitObj

            row.append(value.ResultID)
            row.append(r_obj.ResultUUID)
            row.append(r_obj.ResultTypeCV)
            row.append(r_obj.ResultDateTime)
            row.append(r_obj.ResultDateTimeUTCOffset)
            row.append(r_obj.StatusCV)
            row.append(r_obj.SampledMediumCV)
            row.append(r_obj.ValueCount)

            row.append(sf_obj.SamplingFeatureUUID)
            row.append(sf_obj.SamplingFeatureTypeCV)
            row.append(sf_obj.SamplingFeatureCode)
            sf_name = u'%s' % sf_obj.SamplingFeatureName
            row.append(sf_name.encode("utf-8"))
            row.append(sf_obj.SamplingFeatureDescription)
            row.append(sf_obj.SamplingFeatureGeotypeCV)
            row.append(str(sf_obj.Elevation_m))
            row.append(sf_obj.ElevationDatumCV)
            row.append(sf_obj.FeatureGeometry)

            row.append(a_obj.ActionTypeCV)
            row.append(a_obj.BeginDateTime)
            row.append(a_obj.BeginDateTimeUTCOffset)
            row.append(a_obj.EndDateTime)
            row.append(a_obj.EndDateTimeUTCOffset)

            row.append(m_obj.MethodTypeCV)
            row.append(m_obj.MethodCode)
            row.append(m_obj.MethodName)

            row.append(v_obj.VariableTypeCV)
            row.append(v_obj.VariableCode)
            row.append(v_obj.VariableNameCV)
            row.append(v_obj.NoDataValue)

            row.append(u_obj.UnitsTypeCV)
            row.append(u_obj.UnitsAbbreviation)
            row.append(u_obj.UnitsName)

            row.append(p_obj.ProcessingLevelCode)
            row.append(p_obj.Definition)
            row.append(p_obj.Explanation)

            if t_obj.XLocation != None:
                row.append(t_obj.XLocation)
            else:
                row.append('')
            if t_obj.XLocationUnitsID != None:
                row.append(t_obj.XLocationUnitsID)
            else:
                row.append('')
            if t_obj.YLocation != None:
                row.append(t_obj.YLocation)
            else:
                row.append('')
            if t_obj.YLocationUnitsID != None:
                row.append(t_obj.YLocationUnitsID)
            else:
                row.append('')
            if t_obj.ZLocation != None:
                row.append(t_obj.ZLocation)
            else:
                row.append('')
            if t_obj.ZLocationUnitsID != None:
                row.append(t_obj.ZLocationUnitsID)
            else:
                row.append('')

            row.append(value.CensorCodeCV)
            row.append(value.QualityCodeCV)
            row.append(t_obj.AggregationStatisticCV)
            row.append(value.TimeAggregationInterval)

            row.append(tu_obj.UnitsTypeCV)
            row.append(tu_obj.UnitsAbbreviation)
            row.append(tu_obj.UnitsName)

            row.append(value.ValueDateTime)
            row.append(value.ValueDateTimeUTCOffset)
            row.append(value.DataValue)

            sfid = sf_obj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                row.append(site.SiteTypeCV)
                row.append(site.Latitude)
                row.append(site.Longitude)
                sr_obj = site.SpatialReferenceObj
                row.append(sr_obj.SRSCode)
                row.append(sr_obj.SRSName)
            else:
                for i in range(5):
                    row.append(None)

            rf_list = []
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                for x in rfeature:
                    row1 = []
                    rf_obj = x.RelatedFeatureObj
                    row1.append(x.RelationshipTypeCV)
                    row1.append(rf_obj.SamplingFeatureUUID)
                    row1.append(rf_obj.SamplingFeatureTypeCV)
                    row1.append(rf_obj.SamplingFeatureCode)
                    sf_name = u'%s' % rf_obj.SamplingFeatureName
                    row1.append(sf_name.encode("utf-8"))
                    row1.append(rf_obj.SamplingFeatureDescription)
                    row1.append(rf_obj.SamplingFeatureGeotypeCV)
                    row1.append(str(rf_obj.Elevation_m))
                    row1.append(rf_obj.ElevationDatumCV)
                    row1.append(rf_obj.FeatureGeometry)

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        row1.append(rsite.SiteTypeCV)
                        row1.append(rsite.Latitude)
                        row1.append(rsite.Longitude)
                        sr_obj = rsite.SpatialReferenceObj
                        row1.append(sr_obj.SRSCode)
                        row1.append(sr_obj.SRSName)
                    else:
                        for i in range(5):
                            row1.append(None)
                    rf_list.append(row1)

            else:
                row1 = []
                for i in range(15):
                    row1.append(None)
                rf_list.append(row1)
            
            for i in rf_list:
                row.extend(i)
                writer.writerow(row)

        self._session.close()
        return response        

    def csv_measurementdata(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="values.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount"])
        item_csv_header.extend(["SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.SamplingFeatureDescription[type='string']","SamplingFeature.SamplingFeatureGeotypeCV[type='string']","SamplingFeature.Elevation_m[unit='m']","SamplingFeature.ElevationDatumCV[type='string']","SamplingFeature.FeatureGeometry[type='string']"])
        item_csv_header.extend(["Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']"])
        item_csv_header.extend(["Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue"])
        item_csv_header.extend(["Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"])
        item_csv_header.extend(["MeasurementResult.XLocation","MeasurementResult.XLocationUnitsID","MeasurementResult.YLocation","MeasurementResult.YLocationUnitsID","MeasurementResult.ZLocation","MeasurementResult.ZLocationUnitsID","MeasurementResult.CensorCodeCV[type='string']","MeasurementResult.QualityCodeCV[type='string']","MeasurementResult.AggregationStatisticCV[type='string']","MeasurementResult.TimeAggregationInterval","MeasurementResult.TimeUnit.UnitsTypeCV[type='string']","MeasurementResult.TimeUnit.UnitsAbbreviation[type='string']","MeasurementResult.TimeUnit.UnitsName[type='string']","MeasurementResultValues.ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","MeasurementResultValues.ValueDateTimeUTCOffset","MeasurementResultValues.DataValue"])
        item_csv_header.extend(["Site.SiteTypeCV[type='string']","Site.Latitude[unit='degrees']","Site.Longitude[unit='degrees']","Site.SpatialReference.SRSCode[type='string']","Site.SpatialReference.SRSName[type='string']"])
        item_csv_header.extend(["RelatedFeature.RelationshipTypeCV[type='string']","RelatedFeature.SamplingFeatureUUID[type='string']","RelatedFeature.SamplingFeatureTypeCV[type='string']","RelatedFeature.SamplingFeatureCode[type='string']","RelatedFeature.SamplingFeatureName[type='string']","RelatedFeature.SamplingFeatureDescription[type='string']","RelatedFeature.SamplingFeatureGeotypeCV[type='string']","RelatedFeature.Elevation_m[unit='m']","RelatedFeature.ElevationDatumCV[type='string']","RelatedFeature.FeatureGeometry[type='string']","RelatedFeature.Site.SiteTypeCV[type='string']","RelatedFeature.Site.Latitude[unit='degrees']","RelatedFeature.Site.Longitude[unit='degrees']","RelatedFeature.Site.SpatialReference.SRSCode[type='string']","RelatedFeature.Site.SpatialReference.SRSName[type='string']"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
        conn = ODM2Read(self._session)
            
        for value in self.items:
            row = []

            ms_obj = value.MeasurementResultObj
            r_obj = ms_obj.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj
            mst_obj = ms_obj.TimeUnitObj

            row.append(value.ResultID)
            row.append(r_obj.ResultUUID)
            row.append(r_obj.ResultTypeCV)
            row.append(r_obj.ResultDateTime)
            row.append(r_obj.ResultDateTimeUTCOffset)
            row.append(r_obj.StatusCV)
            row.append(r_obj.SampledMediumCV)
            row.append(r_obj.ValueCount)

            row.append(sf_obj.SamplingFeatureUUID)
            row.append(sf_obj.SamplingFeatureTypeCV)
            row.append(sf_obj.SamplingFeatureCode)
            sf_name = u'%s' % sf_obj.SamplingFeatureName
            row.append(sf_name.encode("utf-8"))
            row.append(sf_obj.SamplingFeatureDescription)
            row.append(sf_obj.SamplingFeatureGeotypeCV)
            row.append(str(sf_obj.Elevation_m))
            row.append(sf_obj.ElevationDatumCV)
            row.append(sf_obj.FeatureGeometry)

            row.append(a_obj.ActionTypeCV)
            row.append(a_obj.BeginDateTime)
            row.append(a_obj.BeginDateTimeUTCOffset)
            row.append(a_obj.EndDateTime)
            row.append(a_obj.EndDateTimeUTCOffset)

            row.append(m_obj.MethodTypeCV)
            row.append(m_obj.MethodCode)
            row.append(m_obj.MethodName)

            row.append(v_obj.VariableTypeCV)
            row.append(v_obj.VariableCode)
            row.append(v_obj.VariableNameCV)
            row.append(v_obj.NoDataValue)

            row.append(u_obj.UnitsTypeCV)
            row.append(u_obj.UnitsAbbreviation)
            row.append(u_obj.UnitsName)

            row.append(p_obj.ProcessingLevelCode)
            row.append(p_obj.Definition)
            row.append(p_obj.Explanation)

            if ms_obj.XLocation != None:
                row.append(ms_obj.XLocation)
            else:
                row.append('')
            if ms_obj.XLocationUnitsID != None:
                row.append(ms_obj.XLocationUnitsID)
            else:
                row.append('')
            if ms_obj.YLocation != None:
                row.append(ms_obj.YLocation)
            else:
                row.append('')
            if ms_obj.YLocationUnitsID != None:
                row.append(ms_obj.YLocationUnitsID)
            else:
                row.append('')
            if ms_obj.ZLocation != None:
                row.append(ms_obj.ZLocation)
            else:
                row.append('')
            if ms_obj.ZLocationUnitsID != None:
                row.append(ms_obj.ZLocationUnitsID)
            else:
                row.append('')

            row.append(ms_obj.CensorCodeCV)
            row.append(ms_obj.QualityCodeCV)
            row.append(ms_obj.AggregationStatisticCV)
            row.append(ms_obj.TimeAggregationInterval)

            row.append(mst_obj.UnitsTypeCV)
            row.append(mst_obj.UnitsAbbreviation)
            row.append(mst_obj.UnitsName)

            row.append(value.ValueDateTime)
            row.append(value.ValueDateTimeUTCOffset)
            row.append(value.DataValue)

            sfid = sf_obj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                row.append(site.SiteTypeCV)
                row.append(site.Latitude)
                row.append(site.Longitude)
                sr_obj = site.SpatialReferenceObj
                row.append(sr_obj.SRSCode)
                row.append(sr_obj.SRSName)
            else:
                for i in range(5):
                    row.append(None)

            rf_list = []
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                for x in rfeature:
                    row1 = []
                    rf_obj = x.RelatedFeatureObj
                    row1.append(x.RelationshipTypeCV)
                    row1.append(rf_obj.SamplingFeatureUUID)
                    row1.append(rf_obj.SamplingFeatureTypeCV)
                    row1.append(rf_obj.SamplingFeatureCode)
                    sf_name = u'%s' % rf_obj.SamplingFeatureName
                    row1.append(sf_name.encode("utf-8"))
                    row1.append(rf_obj.SamplingFeatureDescription)
                    row1.append(rf_obj.SamplingFeatureGeotypeCV)
                    row1.append(str(rf_obj.Elevation_m))
                    row1.append(rf_obj.ElevationDatumCV)
                    row1.append(rf_obj.FeatureGeometry)

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        row1.append(rsite.SiteTypeCV)
                        row1.append(rsite.Latitude)
                        row1.append(rsite.Longitude)
                        sr_obj = rsite.SpatialReferenceObj
                        row1.append(sr_obj.SRSCode)
                        row1.append(sr_obj.SRSName)
                    else:
                        for i in range(5):
                            row1.append(None)
                    rf_list.append(row1)

            else:
                row1 = []
                for i in range(15):
                    row1.append(None)
                rf_list.append(row1)
            
            for i in rf_list:
                row.extend(i)
                writer.writerow(row)

        self._session.close()
        return response
        

    def yaml_timeseriesdata(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'

        response.write("---\n")

        tsrv_data = '' 
        flag = True

        for value in self.items:

            if flag:
                conn = ODM2Read(self._session)

                t_obj = value.TimeSeriesResultObj
                r_obj = t_obj.ResultObj
                sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
                a_obj = r_obj.FeatureActionObj.ActionObj
                m_obj = a_obj.MethodObj
                v_obj = r_obj.VariableObj
                u_obj = r_obj.UnitsObj
                p_obj = r_obj.ProcessingLevelObj
                tu_obj = value.TimeUnitObj

                r = u'Result: &ResultID%03d\n' % t_obj.ResultID
                r += u'   ResultUUID: "%s"\n' % r_obj.ResultUUID
                r += u'   ResultTypeCV: \'%s\'\n' % r_obj.ResultTypeCV
                r += u'   ResultDateTime: "%s"\n' % str(r_obj.ResultDateTime)
                r += u'   ResultDateTimeUTCOffset: %s\n' % str(r_obj.ResultDateTimeUTCOffset)
                r += u'   StatusCV: %s\n' % r_obj.StatusCV
                r += u'   SampledMediumCV: %s\n' % r_obj.SampledMediumCV
                r += u'   ValueCount: %d\n' % r_obj.ValueCount

                r += u'   FeatureAction: \n'
                #r += u'       FeatureActionID: %d\n' % value.TimeSeriesResultObj.ResultObj.FeatureActionObj.FeatureActionID
                r += u'       SamplingFeature:\n'
                r += u'           SamplingFeatureID: %d\n' % sf_obj.SamplingFeatureID
                r += u'           SamplingFeatureCode: %s\n' % sf_obj.SamplingFeatureCode
                r += u'           SamplingFeatureName: "%s"\n' % sf_obj.SamplingFeatureName
                r += u'           SamplingFeatureDescription: "%s"\n' % sf_obj.SamplingFeatureDescription
                r += u'           SamplingFeatureGeotypeCV: "%s"\n' % sf_obj.SamplingFeatureGeotypeCV
                r += u'           Elevation_m: %s\n' % str(sf_obj.Elevation_m)
                r += u'           ElevationDatumCV: "%s"\n' % sf_obj.ElevationDatumCV
                r += u'           FeatureGeometry: "%s"\n' % sf_obj.FeatureGeometry

                r += u'       Action:\n'
                r += u'           ActionID: %d\n' % a_obj.ActionID
                r += u'           BeginDateTime: "%s"\n' % str(a_obj.BeginDateTime)
                r += u'           BeginDateTimeUTCOffset: %s\n' % str(a_obj.BeginDateTimeUTCOffset)
                r += u'           EndDateTime: "%s"\n' % str(a_obj.EndDateTime)
                r += u'           EndDateTimeUTCOffset: %s\n' % str(a_obj.EndDateTimeUTCOffset)
                r += u'           Method:\n'
                r += u'               MethodID: %d\n' % m_obj.MethodID
                r += u'               MethodCode: %s\n' % m_obj.MethodCode
                r += u'               MethodName: %s\n' % m_obj.MethodName
                raction = conn.getRelatedActionsByActionID(a_obj.ActionID)
                if raction != None and len(raction) > 0:
                    r += u'   RelatedActions:\n'
                    for x in raction:
                        ra_obj = x.RelatedActionObj
                        ram_obj = ra_obj.MethodObj

                        r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                        r += u'       BeginDateTime: "%s"\n' % str(ra_obj.BeginDateTime)
                        r += u'       BeginDateTimeUTCOffset: %s\n' % str(ra_obj.BeginDateTimeUTCOffset)
                        r += u'       EndDateTime: "%s"\n' % str(ra_obj.EndDateTime)
                        r += u'       EndDateTimeUTCOffset: %s\n' % str(ra_obj.EndDateTimeUTCOffset)
                        r += u'       Method:\n'
                        r += u'           MethodID: %d\n' % ram_obj.MethodID
                        r += u'           MethodCode: %s\n' % ram_obj.MethodCode
                        r += u'           MethodName: %s\n' % ram_obj.MethodName

                sfid = sf_obj.SamplingFeatureID
                rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
                if rfeature != None and len(rfeature) > 0:
                    r += u'   RelatedFeatures:\n'
                    for x in rfeature:
                        rf_obj = x.RelatedFeatureObj
                        r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                        #r += u'       SamplingFeatureID: %d\n' % rf_obj.SamplingFeatureID
                        r += u'       SamplingFeatureUUID: %s\n' % rf_obj.SamplingFeatureUUID
                        r += u'       SamplingFeatureTypeCV: %s\n' % rf_obj.SamplingFeatureTypeCV
                        r += u'       SamplingFeatureCode: %s\n' % rf_obj.SamplingFeatureCode
                        r += u'       SamplingFeatureName: "%s"\n' % rf_obj.SamplingFeatureName
                        r += u'       SamplingFeatureDescription: "%s"\n' % rf_obj.SamplingFeatureDescription
                        r += u'       SamplingFeatureGeotypeCV: "%s"\n' % rf_obj.SamplingFeatureGeotypeCV
                        r += u'       Elevation_m: %s\n' % str(rf_obj.Elevation_m)
                        r += u'       ElevationDatumCV: "%s"\n' % rf_obj.ElevationDatumCV
                        r += u'       FeatureGeometry: "%s"\n' % rf_obj.FeatureGeometry

                        rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                        if rsite != None:
                            r += u'       Site:\n'
                            r += u'           SiteTypeCV: %s\n' % rsite.SiteTypeCV
                            r += u'           Latitude: %f\n' % rsite.Latitude
                            r += u'           Longitude: %f\n' % rsite.Longitude
                            sr_obj = rsite.SpatialReferenceObj
                            r += u'           SpatialReference:\n'
                            #r += u'               SRSID: %d\n' % sr_obj.SpatialReferenceID
                            r += u'               SRSCode: "%s"\n' % sr_obj.SRSCode
                            r += u'               SRSName: %s\n' % sr_obj.SRSName

                site = conn.getSiteBySFId(sfid)
                if site != None:
                    r += u'   Site:\n'
                    r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                    r += u'       Latitude: %f\n' % site.Latitude
                    r += u'       Longitude: %f\n' % site.Longitude
                    sr_obj = site.SpatialReferenceObj
                    r += u'       SpatialReference:\n'
                    r += u'           SRSID: %d\n' % sr_obj.SpatialReferenceID
                    r += u'           SRSCode: "%s"\n' % sr_obj.SRSCode
                    r += u'           SRSName: %s\n' % sr_obj.SRSName

                r += u'   Variable:\n'
                r += u'       VariableID: %d\n' % v_obj.VariableID
                r += u'       VariableCode: %s\n' % v_obj.VariableCode
                r += u'       VariableNameCV: %s\n' % v_obj.VariableNameCV
                r += u'       NoDataValue: %s\n' % str(v_obj.NoDataValue)

                r += u'   Unit:\n'
                r += u'       UnitID: %d\n' % u_obj.UnitsID
                r += u'       UnitsAbbreviation: %s\n' % u_obj.UnitsAbbreviation
                r += u'       UnitsName: %s\n' % u_obj.UnitsName

                r += u'   ProcessingLevel:\n'
                r += u'       ProcessingLevelID: %d\n' % p_obj.ProcessingLevelID
                r += u'       ProcessingLevelCode: "%s"\n' % p_obj.ProcessingLevelCode

                tsr = u'TimeSeriesResult:\n'
                tsr += u'   &TimeSeriesResultID%03d ' % t_obj.ResultID
                tsr += u'{ResultID: *ResultID%03d, ' % t_obj.ResultID
                if t_obj.XLocation != None:
                    tsr += u'XLocation: %f, ' % t_obj.XLocation
                else:
                    tsr += u'XLocation: NULL, '
                if t_obj.XLocationUnitsID != None:
                    tsr += u'XLocationUnitsID: *UnitID%03d, ' % t_obj.XLocationUnitsID
                else:
                    tsr += u'XLocationUnitsID: NULL, '
                if t_obj.YLocation != None:
                    tsr += u'YLocation: %f, ' % t_obj.YLocation
                else:
                    tsr += u'YLocation: NULL, '
                if t_obj.YLocationUnitsID != None:
                    tsr += u'YLocationUnitsID: *UnitID%03d, ' % t_obj.YLocationUnitsID
                else:
                    tsr += u'YLocationUnitsID: NULL, '
                if t_obj.ZLocation != None:
                    tsr += u'ZLocation: %f, ' % t_obj.ZLocation
                else:
                    tsr += u'ZLocation: NULL, '
                if t_obj.ZLocationUnitsID != None:
                    tsr += u'ZLocationUnitsID: *UnitID%03d, ' % t_obj.ZLocationUnitsID
                else:
                    tsr += u'ZLocationUnitsID: NULL, '
                if t_obj.SpatialReferenceID != None:
                    tsr += u'SpatialReferenceID: *SRSID%03d, ' % t_obj.SpatialReferenceID
                else:
                    tsr += u'SpatialReferenceID: NULL, '
                if t_obj.IntendedTimeSpacing != None:
                    tsr += u'IntendedTimeSpacing: %f, ' % t_obj.IntendedTimeSpacing
                else:
                    tsr += u'IntendedTimeSpacing: NULL, '
                if t_obj.IntendedTimeSpacingUnitsID != None:
                    tsr += u'IntendedTimeSpacingUnitsID: *UnitID%03d, ' % t_obj.IntendedTimeSpacingUnitsID
                else:
                    tsr += u'IntendedTimeSpacingUnitsID: NULL, '
                tsr += u'AggregationStatisticCV: %s}\n' % t_obj.AggregationStatisticCV

                tsrv = u'TimeSeriesResultValues:\n'
                tsrv += u'  ColumnDefinitions:\n'
                tsrv += u'    - {ColumnNumber: 1, Label: ValueDateTime, ODM2Field: ValueDateTime}\n'
                tsrv += u'    - {ColumnNumber: 2, Label: ValueDateTimeUTCOffset, ODM2Field: ValueDateTimeUTCOffset}\n'
                tsrv += u'    - {ColumnNumber: 3, Label: AirTemp_Avg, Result: *TimeSeriesResultID%03d, ' % value.ResultID 
                tsrv += u'ODM2Field: DataValue, CensorCodeCV: %s, ' % value.CensorCodeCV
                tsrv += u'TimeAggregationInterval: %s, ' % str(value.TimeAggregationInterval)
                tsrv += u'TimeAggregationIntervalUnitsID: {'

                tsrv += u'UnitID: %d, ' % tu_obj.UnitsID
                tsrv += u'UnitsAbbreviation: %s, ' % tu_obj.UnitsAbbreviation
                tsrv += u'UnitsName: %s}}\n' % tu_obj.UnitsName

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

    def yaml_measurementdata(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="values.yaml"'
        response.write("---\n")

        conn = ODM2Read(self._session)

        for value in self.items:
            ms_obj = value.MeasurementResultObj
            r_obj = ms_obj.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj
            mst_obj = ms_obj.TimeUnitObj

            r = u'Result: &ResultID%03d\n' % value.ResultID
            r += u'   ResultUUID: "%s"\n' % r_obj.ResultUUID
            r += u'   ResultTypeCV: \'%s\'\n' % r_obj.ResultTypeCV
            r += u'   ResultDateTime: "%s"\n' % str(r_obj.ResultDateTime)
            r += u'   ResultDateTimeUTCOffset: %d\n' % r_obj.ResultDateTimeUTCOffset
            r += u'   StatusCV: %s\n' % r_obj.StatusCV
            r += u'   SampledMediumCV: %s\n' % r_obj.SampledMediumCV
            r += u'   ValueCount: %d\n' % r_obj.ValueCount
            r += u'   FeatureAction: \n'
            r += u'       SamplingFeature:\n'
            r += u'           SamplingFeatureID: %d\n' % sf_obj.SamplingFeatureID
            r += u'           SamplingFeatureCode: %s\n' % sf_obj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % sf_obj.SamplingFeatureName
            r += u'           SamplingFeatureDescription: "%s"\n' % sf_obj.SamplingFeatureDescription
            r += u'           SamplingFeatureGeotypeCV: "%s"\n' % sf_obj.SamplingFeatureGeotypeCV
            r += u'           Elevation_m: %s\n' % str(sf_obj.Elevation_m)
            r += u'           ElevationDatumCV: "%s"\n' % sf_obj.ElevationDatumCV
            r += u'           FeatureGeometry: "%s"\n' % sf_obj.FeatureGeometry

            r += u'       Action:\n'
            r += u'           ActionID: %d\n' % a_obj.ActionID
            r += u'           BeginDateTime: "%s"\n' % str(a_obj.BeginDateTime)
            r += u'           BeginDateTimeUTCOffset: %d\n' % a_obj.BeginDateTimeUTCOffset
            r += u'           EndDateTime: "%s"\n' % str(a_obj.EndDateTime)
            r += u'           EndDateTimeUTCOffset: %s\n' % str(a_obj.EndDateTimeUTCOffset)
            r += u'           Method:\n'
            r += u'               MethodID: %d\n' % m_obj.MethodID
            r += u'               MethodCode: %s\n' % m_obj.MethodCode
            r += u'               MethodName: %s\n' % m_obj.MethodName
            aid = a_obj.ActionID 
            raction = conn.getRelatedActionsByActionID(aid)
            if raction != None and len(raction) > 0:
                r += u'   RelatedActions:\n'
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj

                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    r += u'       BeginDateTime: "%s"\n' % str(ra_obj.BeginDateTime)
                    r += u'       BeginDateTimeUTCOffset: %d\n' % ra_obj.BeginDateTimeUTCOffset
                    r += u'       EndDateTime: "%s"\n' % str(ra_obj.EndDateTime)
                    r += u'       EndDateTimeUTCOffset: %s\n' % str(ra_obj.EndDateTimeUTCOffset)
                    r += u'       Method:\n'
                    r += u'           MethodID: %d\n' % ram_obj.MethodID
                    r += u'           MethodCode: %s\n' % ram_obj.MethodCode
                    r += u'           MethodName: %s\n' % ram_obj.MethodName

            sfid = sf_obj.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                r += u'   RelatedFeatures:\n'
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    #r += u'       SamplingFeatureID: %d\n' % rf_obj.SamplingFeatureID
                    r += u'       SamplingFeatureUUID: %s\n' % rf_obj.SamplingFeatureUUID
                    r += u'       SamplingFeatureTypeCV: %s\n' % rf_obj.SamplingFeatureTypeCV
                    r += u'       SamplingFeatureCode: %s\n' % rf_obj.SamplingFeatureCode
                    r += u'       SamplingFeatureName: "%s"\n' % rf_obj.SamplingFeatureName
                    r += u'       SamplingFeatureDescription: "%s"\n' % rf_obj.SamplingFeatureDescription
                    r += u'       SamplingFeatureGeotypeCV: "%s"\n' % rf_obj.SamplingFeatureGeotypeCV
                    r += u'       Elevation_m: %s\n' % str(rf_obj.Elevation_m)
                    r += u'       ElevationDatumCV: "%s"\n' % rf_obj.ElevationDatumCV
                    r += u'       FeatureGeometry: "%s"\n' % rf_obj.FeatureGeometry

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        r += u'       Site:\n'
                        r += u'           SiteTypeCV: %s\n' % rsite.SiteTypeCV
                        r += u'           Latitude: %f\n' % rsite.Latitude
                        r += u'           Longitude: %f\n' % rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        r += u'           SpatialReference:\n'
                        #r += u'               SRSID: %d\n' % sr_obj.SpatialReferenceID
                        r += u'               SRSCode: "%s"\n' % sr_obj.SRSCode
                        r += u'               SRSName: %s\n' % sr_obj.SRSName

            site = conn.getSiteBySFId(sfid)
            if site != None:
                r += u'   Site:\n'
                r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                r += u'       Latitude: %f\n' % site.Latitude
                r += u'       Longitude: %f\n' % site.Longitude
                sr_obj = site.SpatialReferenceObj
                r += u'       SpatialReference:\n'
                r += u'           SRSID: %d\n' % sr_obj.SpatialReferenceID
                r += u'           SRSCode: "%s"\n' % sr_obj.SRSCode
                r += u'           SRSName: %s\n' % sr_obj.SRSName

            r += u'   Variable:\n'
            r += u'       VariableID: %d\n' % v_obj.VariableID
            r += u'       VariableCode: %s\n' % v_obj.VariableCode
            r += u'       VariableNameCV: %s\n' % v_obj.VariableNameCV
            r += u'       NoDataValue: %s\n' % str(v_obj.NoDataValue)
            r += u'   Unit:\n'
            r += u'       UnitID: %d\n' % u_obj.UnitsID
            r += u'       UnitsAbbreviation: %s\n' % u_obj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % u_obj.UnitsName

            r += u'   ProcessingLevel:\n'
            r += u'       ProcessingLevelID: %d\n' % p_obj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % p_obj.ProcessingLevelCode

            tsr  = u'MeasurementResult: &MeasurementResultID%03d\n' % ms_obj.ResultID
            tsr += u'    ResultID: *ResultID%03d\n' % ms_obj.ResultID
            if ms_obj.XLocation != None:
                tsr += u'    XLocation: %f\n' % ms_obj.XLocation
            else:
                tsr += u'    XLocation: NULL\n'
            if ms_obj.XLocationUnitsID != None:
                tsr += u'    XLocationUnitsID: *UnitID%03d\n' % ms_obj.XLocationUnitsID
            else:
                tsr += u'    XLocationUnitsID: NULL\n'
            if ms_obj.YLocation != None:
                tsr += u'    YLocation: %f\n' % ms_obj.YLocation
            else:
                tsr += u'    YLocation: NULL\n'
            if ms_obj.YLocationUnitsID != None:
                tsr += u'    YLocationUnitsID: *UnitID%03d\n' % ms_obj.YLocationUnitsID
            else:
                tsr += u'    YLocationUnitsID: NULL\n'
            if ms_obj.ZLocation != None:
                tsr += u'    ZLocation: %f\n' % ms_obj.ZLocation
            else:
                tsr += u'    ZLocation: NULL\n'
            if ms_obj.ZLocationUnitsID != None:
                tsr += u'    ZLocationUnitsID: *UnitID%03d\n' % ms_obj.ZLocationUnitsID
            else:
                tsr += u'    ZLocationUnitsID: NULL\n'
            if ms_obj.SpatialReferenceID != None:
                tsr += u'    SpatialReferenceID: *SRSID%03d\n' % ms_obj.SpatialReferenceID
            else:
                tsr += u'    SpatialReferenceID: NULL\n'
            
            tsr += u'    CensorCodeCV: %s\n' % ms_obj.CensorCodeCV
            tsr += u'    QualityCodeCV: %s\n' % ms_obj.QualityCodeCV
            tsr += u'    AggregationStatisticCV: %s\n' % ms_obj.AggregationStatisticCV
            tsr += u'    TimeAggregationInterval: %d\n' % ms_obj.TimeAggregationInterval
            tsr += u'    TimeAggregationIntervalUnitsID:\n'

            tsr += u'        UnitID: %d\n' % mst_obj.UnitsID
            tsr += u'        UnitsAbbreviation: %s\n' % mst_obj.UnitsAbbreviation
            tsr += u'        UnitsName: %s\n\n' % mst_obj.UnitsName

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

    def xml_timeseriesdata(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="values.xml"'
        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        result, results = self.sqlalchemy_timeseries_object_to_dict()
        response.write(xmlify({'Result':result,'DataRecords':{'Data':results}}, wrap="Results", indent="  "))

        return response

    def xml_measurementdata(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="values.xml"'
        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        results = self.sqlalchemy_measurement_object_to_dict()
        response.write(xmlify({'Result':results}, wrap="Results", indent="  "))

        return response


    def sqlalchemy_timeseries_object_to_dict(self):

        flag = True
        result = {}
        results = []

        for value in self.items:

            if flag:
                conn = ODM2Read(self._session)
                t_obj = value.TimeSeriesResultObj
                r_obj = t_obj.ResultObj
                sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
                a_obj = r_obj.FeatureActionObj.ActionObj
                m_obj = a_obj.MethodObj
                v_obj = r_obj.VariableObj
                u_obj = r_obj.UnitsObj
                p_obj = r_obj.ProcessingLevelObj
                tu_obj = value.TimeUnitObj

                result['ResultUUID'] = r_obj.ResultUUID
                result['ResultTypeCV'] = r_obj.ResultTypeCV
                result['ResultDateTime'] = str(r_obj.ResultDateTime)
                result['ResultDateTimeUTCOffset'] = str(r_obj.ResultDateTimeUTCOffset)
                result['StatusCV'] = r_obj.StatusCV
                result['SampledMediumCV'] = r_obj.SampledMediumCV
                result['ValueCount'] = r_obj.ValueCount

                samplingfeature = {}
                samplingfeature['SamplingFeatureUUID'] = sf_obj.SamplingFeatureUUID
                samplingfeature['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
                samplingfeature['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
                samplingfeature['SamplingFeatureName'] = sf_obj.SamplingFeatureName
                samplingfeature['Elevation_m'] = str(sf_obj.Elevation_m)

                action = {}
                action['ActionTypeCV'] = a_obj.ActionTypeCV
                action['BeginDateTime'] = str(a_obj.BeginDateTime)
                action['BeginDateTimeUTCOffset'] = a_obj.BeginDateTimeUTCOffset
                action['EndDateTime'] = str(a_obj.EndDateTime)
                action['EndDateTimeUTCOffset'] = str(a_obj.EndDateTimeUTCOffset)

                method = {}
                method['MethodTypeCV'] = m_obj.MethodTypeCV
                method['MethodCode'] = m_obj.MethodCode
                method['MethodName'] = m_obj.MethodName
                action['Method'] = method

                aid = a_obj.ActionID 
                raction = conn.getRelatedActionsByActionID(aid)
                if raction != None and len(raction) > 0:
                    arrayrelaction = []
                    for x in raction:
                        relaction = {}
                        relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                        ra_obj = x.RelatedActionObj
                        ram_obj = ra_obj.MethodObj
                        relaction['ActionTypeCV'] = ra_obj.ActionTypeCV
                        relaction['BeginDateTime'] = str(ra_obj.BeginDateTime)
                        relaction['BeginDateTimeUTCOffset'] = ra_obj.BeginDateTimeUTCOffset
                        relaction['EndDateTime'] = str(ra_obj.EndDateTime)
                        relaction['EndDateTimeUTCOffset'] = str(ra_obj.EndDateTimeUTCOffset)
                        relmethod = {}
                        relmethod['MethodTypeCV'] = ram_obj.MethodTypeCV
                        relmethod['MethodCode'] = ram_obj.MethodCode
                        relmethod['MethodName'] = ram_obj.MethodName
                        relaction['Method'] = relmethod
                        arrayrelaction.append(relaction)

                        #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                        result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
                else:
                    result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

                sfid = sf_obj.SamplingFeatureID
                site = conn.getSiteBySFId(sfid)
                if site != None:
                    s = {}
                    s['SiteTypeCV'] = site.SiteTypeCV
                    s['Latitude'] = site.Latitude
                    s['Longitude'] = site.Longitude
                    sr_obj = site.SpatialReferenceObj
                    sr = {}
                    sr['SRSCode'] = sr_obj.SRSCode
                    sr['SRSName'] = sr_obj.SRSName
                    s['SpatialReference'] = sr
                    result['Site'] = s

                varone = {}
                varone['VariableTypeCV'] = v_obj.VariableTypeCV
                varone['VariableCode'] = v_obj.VariableCode
                varone['VariableNameCV'] = v_obj.VariableNameCV
                varone['NoDataValue'] = v_obj.NoDataValue
                result['Variable'] = varone
            
                unit = {}
                unit['UnitsTypeCV'] = u_obj.UnitsTypeCV
                unit['UnitsAbbreviation'] = u_obj.UnitsAbbreviation
                unit['UnitsName'] = u_obj.UnitsName
                result['Unit'] = unit
           
                pl = {}
                pl['ProcessingLevelCode'] = p_obj.ProcessingLevelCode
                pl['Definition'] = p_obj.Definition
                pl['Explanation'] = p_obj.Explanation
                result['ProcessingLevel'] = pl

                mresult = {}
                if t_obj.XLocation != None:
                    mresult['XLocation'] = t_obj.XLocation
                else:
                    mresult['XLocation'] = ''
                if t_obj.XLocationUnitsID != None:
                    mresult['XLocationUnitsID'] = t_obj.XLocationUnitsID
                else:
                    mresult['XLocationUnitsID'] = ''
                if t_obj.YLocation != None:
                    mresult['YLocation'] = t_obj.YLocation
                else:
                    mresult['YLocation'] = ''
                if t_obj.YLocationUnitsID != None:
                    mresult['YLocationUnitsID'] = t_obj.YLocationUnitsID
                else:
                    mresult['YLocationUnitsID'] = ''
                if t_obj.ZLocation != None:
                    mresult['ZLocation'] = t_obj.ZLocation
                else:
                    mresult['ZLocation'] = ''
                if t_obj.ZLocationUnitsID != None:
                    mresult['ZLocationUnitsID'] = t_obj.ZLocationUnitsID
                else:
                    mresult['ZLocationUnitsID'] = ''

                if t_obj.SpatialReferenceID != None:
                    ts_obj = t_obj.SpatialReferenceObj
                    msr = {}
                    msr['SRSCode'] = ts_obj.SRSCode
                    msr['SRSName'] = ts_obj.SRSName
                    mresult['SpatialReference'] = msr
                else:
                    mresult['SpatialReference'] = ''
            
                if t_obj.IntendedTimeSpacing != None:
                    mresult['IntendedTimeSpacing'] = t_obj.IntendedTimeSpacing
                else:
                    mresult['IntendedTimeSpacing'] = ''
                if t_obj.IntendedTimeSpacingUnitsID != None:
                    mresult['IntendedTimeSpacingUnitsID'] = t_obj.IntendedTimeSpacingUnitsID
                else:
                    mresult['IntendedTimeSpacingUnitsID'] = ''

                mresult['CensorCodeCV'] = value.CensorCodeCV
                mresult['QualityCodeCV'] = value.QualityCodeCV
                mresult['AggregationStatisticCV'] = t_obj.AggregationStatisticCV
                mresult['TimeAggregationInterval'] = value.TimeAggregationInterval

                tunit = {}
                tunit['UnitsTypeCV'] = tu_obj.UnitsTypeCV
                tunit['UnitsAbbreviation'] = tu_obj.UnitsAbbreviation
                tunit['UnitsName'] = tu_obj.UnitsName
                mresult['TimeAggregationIntervalUnit'] = tunit
                result['TimeSeriesResult'] = mresult
                flag = False

            mvalue = {}
            mvalue['ValueDateTime'] = str(value.ValueDateTime)
            mvalue['ValueDateTimeUTCOffset'] = value.ValueDateTimeUTCOffset
            mvalue['DataValue'] = value.DataValue
            results.append(mvalue)

        self._session.close()
        return result,results

    def sqlalchemy_measurement_object_to_dict(self):

        results = []
        conn = ODM2Read(self._session)

        for value in self.items:

            ms_obj = value.MeasurementResultObj
            r_obj = ms_obj.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj
            mst_obj = ms_obj.TimeUnitObj

            result = {}
            result['ResultUUID'] = r_obj.ResultUUID
            result['ResultTypeCV'] = r_obj.ResultTypeCV
            result['ResultDateTime'] = str(r_obj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(r_obj.ResultDateTimeUTCOffset)
            result['StatusCV'] = r_obj.StatusCV
            result['SampledMediumCV'] = r_obj.SampledMediumCV
            result['ValueCount'] = r_obj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = sf_obj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            samplingfeature['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            samplingfeature['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            samplingfeature['Elevation_m'] = str(sf_obj.Elevation_m)
            samplingfeature['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            samplingfeature['FeatureGeometry'] = sf_obj.FeatureGeometry

            action = {}
            action['ActionTypeCV'] = a_obj.ActionTypeCV
            action['BeginDateTime'] = str(a_obj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = a_obj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(a_obj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(a_obj.EndDateTimeUTCOffset)

            method = {}
            method['MethodTypeCV'] = m_obj.MethodTypeCV
            method['MethodCode'] = m_obj.MethodCode
            method['MethodName'] = m_obj.MethodName
            action['Method'] = method

            aid = a_obj.ActionID 
            raction = conn.getRelatedActionsByActionID(aid)
            if raction != None and len(raction) > 0:
                arrayrelaction = []
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj
                    relaction = {}
                    relaction['RelationshipTypeCV'] = x.RelationshipTypeCV
                    relaction['ActionTypeCV'] = ra_obj.ActionTypeCV
                    relaction['BeginDateTime'] = str(ra_obj.BeginDateTime)
                    relaction['BeginDateTimeUTCOffset'] = ra_obj.BeginDateTimeUTCOffset
                    relaction['EndDateTime'] = str(ra_obj.EndDateTime)
                    relaction['EndDateTimeUTCOffset'] = str(ra_obj.EndDateTimeUTCOffset)
                    relmethod = {}
                    relmethod['MethodTypeCV'] = ram_obj.MethodTypeCV
                    relmethod['MethodCode'] = ram_obj.MethodCode
                    relmethod['MethodName'] = ram_obj.MethodName
                    relaction['Method'] = relmethod
                    arrayrelaction.append(relaction)

                #result['RelatedActions'] = {'RelatedAction':arrayrelaction}
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action, 'RelatedActions': {'RelatedAction':arrayrelaction}}
            else:
                result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = sf_obj.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                rfeatures = []
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    rf = {}
                    rf['RelationshipTypeCV'] = x.RelationshipTypeCV
                    rf['SamplingFeatureUUID'] = rf_obj.SamplingFeatureUUID
                    rf['SamplingFeatureTypeCV'] = rf_obj.SamplingFeatureTypeCV
                    rf['SamplingFeatureCode'] = rf_obj.SamplingFeatureCode
                    rf['SamplingFeatureName'] = rf_obj.SamplingFeatureName
                    rf['SamplingFeatureDescription'] = rf_obj.SamplingFeatureDescription
                    rf['SamplingFeatureGeotypeCV'] = rf_obj.SamplingFeatureGeotypeCV
                    rf['Elevation_m'] = str(rf_obj.Elevation_m)
                    rf['ElevationDatumCV'] = rf_obj.ElevationDatumCV
                    rf['FeatureGeometry'] = rf_obj.FeatureGeometry

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        rs = {}
                        rs['SiteTypeCV'] = rsite.SiteTypeCV
                        rs['Latitude'] = rsite.Latitude
                        rs['Longitude'] = rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        rsr = {}
                        rsr['SRSCode'] = sr_obj.SRSCode
                        rsr['SRSName'] = sr_obj.SRSName
                        rs['SpatialReference'] = rsr
                        rf['Site'] = rs
                    rfeatures.append(rf)

                result['RelatedFeatures'] = rfeatures

            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr_obj = site.SpatialReferenceObj
                sr = {}
                sr['SRSCode'] = sr_obj.SRSCode
                sr['SRSName'] = sr_obj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = v_obj.VariableTypeCV
            varone['VariableCode'] = v_obj.VariableCode
            varone['VariableNameCV'] = v_obj.VariableNameCV
            varone['NoDataValue'] = v_obj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = u_obj.UnitsTypeCV
            unit['UnitsAbbreviation'] = u_obj.UnitsAbbreviation
            unit['UnitsName'] = u_obj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = p_obj.ProcessingLevelCode
            pl['Definition'] = p_obj.Definition
            pl['Explanation'] = p_obj.Explanation
            result['ProcessingLevel'] = pl

            mresult = {}
            if ms_obj.XLocation != None:
                mresult['XLocation'] = ms_obj.XLocation
            else:
                mresult['XLocation'] = ''
            if ms_obj.XLocationUnitsID != None:
                mresult['XLocationUnitsID'] = ms_obj.XLocationUnitsID
            else:
                mresult['XLocationUnitsID'] = ''
            if ms_obj.YLocation != None:
                mresult['YLocation'] = ms_obj.YLocation
            else:
                mresult['YLocation'] = ''
            if ms_obj.YLocationUnitsID != None:
                mresult['YLocationUnitsID'] = ms_obj.YLocationUnitsID
            else:
                mresult['YLocationUnitsID'] = ''
            if ms_obj.ZLocation != None:
                mresult['ZLocation'] = ms_obj.ZLocation
            else:
                mresult['ZLocation'] = ''
            if ms_obj.ZLocationUnitsID != None:
                mresult['ZLocationUnitsID'] = ms_obj.ZLocationUnitsID
            else:
                mresult['ZLocationUnitsID'] = ''

            if ms_obj.SpatialReferenceID != None:
                mss_obj = ms_obj.SpatialReferenceObj
                msr = {}
                msr['SRSCode'] = mss_obj.SRSCode
                msr['SRSName'] = mss_obj.SRSName
                mresult['SpatialReference'] = msr
            else:
                mresult['SpatialReference'] = ''
            
            mresult['CensorCodeCV'] = ms_obj.CensorCodeCV
            mresult['QualityCodeCV'] = ms_obj.QualityCodeCV
            mresult['AggregationStatisticCV'] = ms_obj.AggregationStatisticCV
            mresult['TimeAggregationInterval'] = ms_obj.TimeAggregationInterval

            tunit = {}
            tunit['UnitsTypeCV'] = mst_obj.UnitsTypeCV
            tunit['UnitsAbbreviation'] = mst_obj.UnitsAbbreviation
            tunit['UnitsName'] = mst_obj.UnitsName
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
