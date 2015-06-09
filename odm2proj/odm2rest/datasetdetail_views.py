import sys
sys.path.append('ODM2PythonAPI')

#from rest_framework import viewsets
from odm2rest.serializers import DummySerializer
from odm2rest.serializers import Odm2JsonSerializer

from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

# Create your views here.

from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework import viewsets
import json
from collections import OrderedDict

import csv,cStringIO
import yaml, pyaml

from odm2rest.odm2service import Service
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_xml.renderers import XMLRenderer
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework.renderers import BrowsableAPIRenderer
from negotiation import IgnoreClientContentNegotiation
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read
from dict2xml import dict2xml as xmlify

class DatasetDetailViewSet(APIView):
    """
    All ODM2 dataset Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, datasetUUID=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "yaml".
              required: false
              type: string
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """
        if datasetUUID is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getDataSetResultsByUUID(datasetUUID)
        #conn = mr.readService()

        if items == None or len(items) == 0:
            return Response('"%s" is not existed.' % datasetUUID,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        flag = True
        
        dataset = {}
        results = []
        for value in self.items:
            if flag:
                dataset['DatasetID'] = value.DatasetObj.DatasetID
                dataset['DatasetUUID'] = value.DatasetObj.DatasetUUID
                dataset['DatasetTypeCV'] = value.DatasetObj.DatasetTypeCV
                dataset['DatasetCode'] = value.DatasetObj.DatasetCode
                dataset['DatasetTitle'] = value.DatasetObj.DatasetTitle
                dataset['DatasetAbstract'] = value.DatasetObj.DatasetAbstract
                flag = False

            result = {}
            result['ResultUUID'] = value.ResultObj.ResultUUID
            result['ResultTypeCV'] = value.ResultObj.ResultTypeCV
            result['ResultDateTime'] = str(value.ResultObj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.ResultObj.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.ResultObj.StatusCV
            result['SampledMediumCV'] = value.ResultObj.SampledMediumCV
            result['ValueCount'] = value.ResultObj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method
            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            conn = ODM2Read(self._session)
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
            varone['VariableTypeCV'] = value.ResultObj.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.ResultObj.VariableObj.VariableCode
            varone['VariableNameCV'] = value.ResultObj.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.ResultObj.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.ResultObj.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.ResultObj.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.ResultObj.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.ResultObj.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.ResultObj.ProcessingLevelObj.Definition
            pl['Explanation'] = value.ResultObj.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            results.append(result)

        dataset['Results'] = results

        self._session.close()
        return dataset

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="datasets.csv"'

        item_csv_header = ["#fields=DataSet.DataSetID","DataSet.DataSetUUID[type='string']","DataSet.DataSetTypeCV[type='string']","DataSet.DataSetCode[type='string']","DataSet.DataSetTitle[type='string']","DataSet.DataSetAbstract[type='string']","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount","SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.Elevation_m","Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']","Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for value in self.items:
            row = []
            row.append(value.DatasetObj.DatasetID)
            row.append(value.DatasetObj.DatasetUUID)
            row.append(value.DatasetObj.DatasetTypeCV)
            row.append(value.DatasetObj.DatasetCode)
            row.append(value.DatasetObj.DatasetTitle)
            row.append(value.DatasetObj.DatasetAbstract)

            row.append(value.ResultObj.ResultUUID)
            row.append(value.ResultObj.ResultTypeCV)
            row.append(value.ResultObj.ResultDateTime)
            row.append(value.ResultObj.ResultDateTimeUTCOffset)
            row.append(value.ResultObj.StatusCV)
            row.append(value.ResultObj.SampledMediumCV)
            row.append(value.ResultObj.ValueCount)

            row.append(value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID)
            row.append(value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV)
            row.append(value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(value.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            row.append(value.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)

            row.append(value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode)
            row.append(value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName)

            row.append(value.ResultObj.VariableObj.VariableTypeCV)
            row.append(value.ResultObj.VariableObj.VariableCode)
            row.append(value.ResultObj.VariableObj.VariableNameCV)
            row.append(value.ResultObj.VariableObj.NoDataValue)

            row.append(value.ResultObj.UnitsObj.UnitsTypeCV)
            row.append(value.ResultObj.UnitsObj.UnitsAbbreviation)
            row.append(value.ResultObj.UnitsObj.UnitsName)

            row.append(value.ResultObj.ProcessingLevelObj.ProcessingLevelCode)
            row.append(value.ResultObj.ProcessingLevelObj.Definition)
            row.append(value.ResultObj.ProcessingLevelObj.Explanation)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="dataset.yaml"'

        response.write("---\n")
        response.write("Dataset:\n")

        flag = True

        for value in self.items:
            if flag:
                q  = u'    DatasetID: %d\n' % value.DatasetObj.DatasetID
                q += u'    DatasetUUID: %s\n' % value.DatasetObj.DatasetUUID
                q += u'    DatasetTypeCV: %s\n' % value.DatasetObj.DatasetTypeCV
                q += u'    DatasetCode: %s\n' % value.DatasetObj.DatasetCode
                q += u'    DatasetTitle: %s\n' % value.DatasetObj.DatasetTitle
                q += u'    DatasetAbstract: %s\n' % value.DatasetObj.DatasetAbstract
                response.write(q)
                response.write("\n")
                response.write("Results:\n")
                flag = False

            #r  = u' - ResultID: %d\n' % value.ResultID
            r  = u' - ResultUUID: "%s"\n' % value.ResultObj.ResultUUID
            r += u'   ResultTypeCV: \'%s\'\n' % value.ResultObj.ResultTypeCV
            r += u'   ResultDateTime: "%s"\n' % str(value.ResultObj.ResultDateTime)
            r += u'   ResultDateTimeUTCOffset: %s\n' % str(value.ResultObj.ResultDateTimeUTCOffset)
            r += u'   StatusCV: %s\n' % value.ResultObj.StatusCV
            r += u'   SampledMediumCV: %s\n' % value.ResultObj.SampledMediumCV
            r += u'   ValueCount: %d\n' % value.ResultObj.ValueCount

            r += u'   FeatureAction: \n'
            #r += u'       FeatureActionID: %d\n' % value.FeatureActionObj.FeatureActionID
            r += u'       SamplingFeature:\n'
            #r += u'           SamplingFeatureID: %d\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            r += u'           SamplingFeatureUUID: %s\n' % value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            r += u'           SamplingFeatureTypeCV: %s\n' % value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            r += u'           SamplingFeatureCode: %s\n' % value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            r += u'           Elevation_m: %s\n' % str(value.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            r += u'           Action:\n'
            #r += u'               ActionID: %d\n' % value.FeatureActionObj.ActionObj.ActionID
            r += u'               ActionTypeCV: "%s"\n' % value.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
            r += u'               BeginDateTime: "%s"\n' % str(value.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            r += u'               BeginDateTimeUTCOffset: %d\n' % value.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            r += u'               EndDateTime: "%s"\n' % str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            r += u'               EndDateTimeUTCOffset: %s\n' % str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            r += u'               Method:\n'
            #r += u'                   MethodID: %d\n' % value.FeatureActionObj.ActionObj.MethodObj.MethodID
            r += u'                   MethodTypeCV: %s\n' % value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            r += u'                   MethodCode: %s\n' % value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            r += u'                   MethodName: %s\n' % value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            sfid = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            conn = ODM2Read(self._session)
            site = conn.getSiteBySFId(sfid)
            if site != None:
                r += u'   Site:\n'
                r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                r += u'       Latitude: %f\n' % site.Latitude
                r += u'       Longitude: %f\n' % site.Longitude
                r += u'       SpatialReference:\n'
                #r += u'           SRSID: %d\n' % site.SpatialReferenceObj.SpatialReferenceID
                r += u'           SRSCode: "%s"\n' % site.SpatialReferenceObj.SRSCode
                r += u'           SRSName: %s\n' % site.SpatialReferenceObj.SRSName

            r += u'   Variable:\n'
            #r += u'       VariableID: %d\n' % value.VariableObj.VariableID
            r += u'       VariableTypeCV: %s\n' % value.ResultObj.VariableObj.VariableTypeCV
            r += u'       VariableCode: %s\n' % value.ResultObj.VariableObj.VariableCode
            r += u'       VariableNameCV: %s\n' % value.ResultObj.VariableObj.VariableNameCV
            r += u'       NoDataValue: %d\n' % value.ResultObj.VariableObj.NoDataValue
            
            r += u'   Unit:\n'
            #r += u'       UnitID: %d\n' % value.UnitObj.UnitsID
            r += u'       UnitsTypeCV: %s\n' % value.ResultObj.UnitsObj.UnitsTypeCV
            r += u'       UnitsAbbreviation: %s\n' % value.ResultObj.UnitsObj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % value.ResultObj.UnitsObj.UnitsName
            
            r += u'   ProcessingLevel:\n'
            #r += u'       ProcessingLevelID: %d\n' % value.ProcessingLevelObj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % value.ResultObj.ProcessingLevelObj.ProcessingLevelCode
            r += u'       Definition: "%s"\n' % value.ResultObj.ProcessingLevelObj.Definition
            r += u'       Explanation: "%s"\n' % value.ResultObj.ProcessingLevelObj.Explanation
            response.write(r)
            response.write('\n')

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="dataset.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        flag = True
        
        dataset = {}
        results = []
        for value in self.items:
            if flag:
                dataset['DatasetID'] = value.DatasetObj.DatasetID
                dataset['DatasetUUID'] = value.DatasetObj.DatasetUUID
                dataset['DatasetTypeCV'] = value.DatasetObj.DatasetTypeCV
                dataset['DatasetCode'] = value.DatasetObj.DatasetCode
                dataset['DatasetTitle'] = value.DatasetObj.DatasetTitle
                dataset['DatasetAbstract'] = value.DatasetObj.DatasetAbstract
                flag = False

            result = {}
            result['ResultUUID'] = value.ResultObj.ResultUUID
            result['ResultTypeCV'] = value.ResultObj.ResultTypeCV
            result['ResultDateTime'] = str(value.ResultObj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.ResultObj.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.ResultObj.StatusCV
            result['SampledMediumCV'] = value.ResultObj.SampledMediumCV
            result['ValueCount'] = value.ResultObj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.ResultObj.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.ResultObj.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.ResultObj.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.ResultObj.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.ResultObj.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.ResultObj.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method
            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            conn = ODM2Read(self._session)
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
            varone['VariableTypeCV'] = value.ResultObj.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.ResultObj.VariableObj.VariableCode
            varone['VariableNameCV'] = value.ResultObj.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.ResultObj.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.ResultObj.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.ResultObj.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.ResultObj.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.ResultObj.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.ResultObj.ProcessingLevelObj.Definition
            pl['Explanation'] = value.ResultObj.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            results.append(result)

        dataset['Results'] = {'Result': results }
        response.write(xmlify(dataset, wrap="Dataset", indent="  "))
        
        self._session.close()
        return response

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

