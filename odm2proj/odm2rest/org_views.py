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

class OrgCodeViewSet(APIView):
    """
    All ODM2 organizations Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, organizationCode=None):
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

        if organizationCode is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getOrganizationByCode(organizationCode)

        if items == None:
            return Response('"%s" is not existed.' % organizationCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        allitems = []
        for x in self.items:
            queryset = OrderedDict()
            queryset['OrganizationID'] = x.OrganizationID
            queryset['OrganizationTypeCV'] = x.OrganizationTypeCV
            queryset['OrganizationCode'] = x.OrganizationCode
            queryset['OrganizationName'] = x.OrganizationName
            queryset['OrganizationDescription'] = x.OrganizationDescription
            queryset['OrganizationLink'] = x.OrganizationLink
            queryset['ParentOrganizationID'] = x.ParentOrganizationID
            allitems.append(queryset)

        return allitems

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="organizations.csv"'

        item_csv_header = ["#fields=OrganizationID[type='string']","OrganizationTypeCV[type='string']","OrganizationCode[type='string']","OrganizationName[type='string']","OrganizationDescription[type='string']","OrganizationLink[type='string']","ParentOrganizationID"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []
            row.append(item.OrganizationID)
            row.append(item.OrganizationTypeCV)
            row.append(item.OrganizationCode)
            row.append(item.OrganizationName)
            row.append(item.OrganizationDescription)
            row.append(item.OrganizationLink)
            row.append(item.ParentOrganizationID)

            writer.writerow(row)

        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="organizations.yaml"'

        response.write("---\n")
        allitems = {}
        records = []
            
        for item in self.items:

            queryset = OrderedDict()
            queryset["OrganizationID"] = item.OrganizationID
            queryset["OrganizationTypeCV"] = item.OrganizationTypeCV
            queryset["OrganizationCode"] = item.OrganizationCode
            queryset["OrganizationName"] = item.OrganizationName
            queryset["OrganizationDescription"] = item.OrganizationDescription
            queryset["OrganizationLink"] = item.OrganizationLink
            queryset["ParentOrganizationID"] = item.ParentOrganizationID
            records.append(queryset)

        allitems["Organizations"] = records
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
