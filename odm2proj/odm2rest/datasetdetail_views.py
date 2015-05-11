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
              description: The format type is "yaml", "json" or "csv". The default type is "yaml".
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

        return mr.content_format_with_conn(items, format, readConn)

class MultipleRepresentations(Service):

    def json_format(self):

        allitems = []
        for x in self.items:
            queryset = OrderedDict()
            queryset['DatasetID'] = x.DatasetID
            queryset['DatasetUUID'] = x.DatasetUUID
            queryset['DatasetTypeCV'] = x.DatasetTypeCV
            queryset['DatasetCode'] = x.DatasetCode
            queryset['DatasetTitle'] = x.DatasetTitlw
            queryset['DatasetAbstract'] = x.DatasetAbstract
            allitems.append(queryset)

        return allitems

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="datasets.csv"'

        item_csv_header = ["#fields=DataSetID","DataSetUUID[type='string']","DataSetTypeCV[type='string']","DataSetCode[type='string']","DataSetTitle[type='string']","DataSetAbstract[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []
            row.append(item.DatasetID)
            row.append(item.DatasetUUID)
            row.append(item.DatasetTypeCV)
            row.append(item.DatasetCode)
            row.append(item.DatasetTitle)
            row.append(item.DatasetAbstract)

            writer.writerow(row)

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
            site = self.conn.getSiteBySFId(sfid)
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

        return response


class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

