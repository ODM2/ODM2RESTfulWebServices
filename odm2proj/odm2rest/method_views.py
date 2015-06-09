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
from dict2xml import dict2xml as xmlify

class MethodsViewSet(APIView):
    """
    All ODM2 methods Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
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
        items = readConn.getMethods()

        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MethodCodeViewSet(APIView):
    """
    All ODM2 methods Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, methodCode=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        if methodCode is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getMethodByCode(methodCode)

        if items == None:
            return Response('"%s" is not existed.' % methodCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        allitems = []
        for x in self.items:
            queryset = OrderedDict()
            queryset['MethodID'] = x.MethodID
            queryset['MethodTypeCV'] = x.MethodTypeCV
            queryset['MethodCode'] = x.MethodCode
            queryset['MethodName'] = x.MethodName
            queryset['MethodDescription'] = x.MethodDescription
            queryset['MethodLink'] = x.MethodLink
            queryset['OrganizationID'] = x.OrganizationID
            allitems.append(queryset)

        self._session.close()
        return allitems

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="methods.csv"'

        item_csv_header = ["#fields=MethodID[type='string']","MethodTypeCV[type='string']","MethodCode[type='string']","MethodName[type='string']","MethodDescription[type='string']","MethodLink[type='string']","OrganizationID"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []
            row.append(item.MethodID)
            row.append(item.MethodTypeCV)
            row.append(item.MethodCode)
            row.append(item.MethodName)
            row.append(item.MethodDescription)
            row.append(item.MethodLink)
            row.append(item.OrganizationID)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="methods.yaml"'

        response.write("---\n")
        allitems = {}
        records = []
            
        for item in self.items:

            queryset = OrderedDict()
            queryset["MethodID"] = item.MethodID
            queryset["MethodTypeCV"] = item.MethodTypeCV
            queryset["MethodCode"] = item.MethodCode
            queryset["MethodName"] = item.MethodName
            queryset["MethodDescription"] = item.MethodDescription
            queryset["MethodLink"] = item.MethodLink
            queryset["OrganizationID"] = item.OrganizationID
            records.append(queryset)

        allitems["Methods"] = records
        response.write(pyaml.dump(allitems,vspacing=[0, 0]))

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="methods.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        allitems = []
        for x in self.items:
            queryset = OrderedDict()
            queryset['MethodID'] = x.MethodID
            queryset['MethodTypeCV'] = x.MethodTypeCV
            queryset['MethodCode'] = x.MethodCode
            queryset['MethodName'] = x.MethodName
            queryset['MethodDescription'] = x.MethodDescription
            queryset['MethodLink'] = x.MethodLink
            queryset['OrganizationID'] = x.OrganizationID
            allitems.append(queryset)

        response.write(xmlify({'Method': allitems}, wrap="Methods", indent="  "))
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

