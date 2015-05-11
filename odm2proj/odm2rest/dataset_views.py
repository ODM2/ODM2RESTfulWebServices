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

class DatasetViewSet(APIView):
    """
    All ODM2 dataset Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None):
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

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getDataSets()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):
    def json_format(self):

        allitems = []
        for x in self.items:
            queryset = OrderedDict()
            queryset['DatasetID'] = x.DatasetID
            queryset['DatasetUUID'] = x.DatasetUUID
            queryset['DatasetTypeCV'] = x.DatasetTypeCV
            queryset['DatasetCode'] = x.DatasetCode
            queryset['DatasetTitle'] = x.DatasetTitle
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
        response['Content-Disposition'] = 'attachment; filename="datasets.yaml"'

        response.write("---\n")
        allitems = {}
        records = []
            
        for item in self.items:

            queryset = OrderedDict()
            queryset["DatasetID"] = item.DatasetID
            queryset["DatasetUUID"] = item.DatasetUUID
            queryset["DatasetTypeCV"] = item.DatasetTypeCV
            queryset["DatasetCode"] = item.DatasetCode
            queryset["DatasetTitle"] = item.DatasetTitle
            queryset["DatasetAbstract"] = item.DatasetAbstract
            records.append(queryset)

        allitems["DataSets"] = records
        response.write(pyaml.dump(allitems,vspacing=[0, 0]))

        return response

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

