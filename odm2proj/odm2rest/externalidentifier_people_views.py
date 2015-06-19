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

class ExternalIdentifierPeopleViewSet(APIView):
    """
    All ODM2 ExternalIdentifiers For People Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (JSONRenderer, YAMLRenderer)
    #serializer_class = VariableSerializer

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
        items = readConn.getExternalIdentifiersForPeople()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="personexternalidentifiersystem.csv"'

        item_csv_header = ["#fields=PersonExternalIdentifier[type='string']","PersonExternalIdentifierURI[type='string']","ExternalIdentifierSystemID","ExternalIdentifierSystemName[type='string']","ExternalIdentifierSystemDescription[type='string']","ExternalIdentifierSystemURL[type='string']","IdentifierSystemOrganization.OrganizationID","IdentifierSystemOrganization.OrganizationTypeCV[type='string']","IdentifierSystemOrganization.OrganizationCode[type='string']","IdentifierSystemOrganization.OrganizationName[type='string']","IdentifierSystemOrganization.OrganizationDescription[type='string']","IdentifierSystemOrganization.OrganizationLink[type='string']","IdentifierSystemOrganization.ParentOrganizationID","PersonID","PersonFirstName[type='string']","PersonMiddleName[type='string']","PersonLastName[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []

            row.append(item.PersonExternalIdentifier)
            row.append(item.PersonExternalIdentifierURI)
            eis_obj = item.ExternalIdentifierSystemObj
            row.append(eis_obj.ExternalIdentifierSystemID)
            row.append(eis_obj.ExternalIdentifierSystemName)
            row.append(eis_obj.ExternalIdentifierSystemDescription)
            row.append(eis_obj.ExternalIdentifierSystemURL)
            o_obj = eis_obj.IdentifierSystemOrganizationObj
            row.append(o_obj.OrganizationID)
            row.append(o_obj.OrganizationTypeCV)
            row.append(o_obj.OrganizationCode)
            row.append(o_obj.OrganizationName)
            row.append(o_obj.OrganizationDescription)
            row.append(o_obj.OrganizationLink)
            row.append(o_obj.ParentOrganizationID)
            c_obj = item.PersonObj
            row.append(c_obj.PersonID)
            row.append(c_obj.PersonFirstName)
            row.append(c_obj.PersonMiddleName)
            row.append(c_obj.PersonLastName)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="personexternalidentifiersystem.yaml"'

        response.write("---\n")

        alleis = {}

        ceis = []
        eis = []
        orgs = []
        cs = []

        for item in self.items:

            cei = OrderedDict()
            cei['Person'] = "*PersonID%03d" % item.PersonID
            cei['ExternalIdentifierSystem'] = "*ExternalIdentifierSystemID%03d" % item.ExternalIdentifierSystemID
            cei['PersonExternalIdentifier'] = u'%s' % item.PersonExternalIdentifier
            cei['PersonExternalIdentifierURI'] = u'%s' % item.PersonExternalIdentifierURI
            ceis.append(cei)

            eis_obj = item.ExternalIdentifierSystemObj
            queryset = OrderedDict()
            queryset['ExternalIdentifierSystem'] = "&ExternalIdentifierSystemID%03d" % eis_obj.ExternalIdentifierSystemID
            queryset['ExternalIdentifierSystemName'] = eis_obj.ExternalIdentifierSystemName
            queryset['ExternalIdentifierSystemDescription'] = eis_obj.ExternalIdentifierSystemDescription
            queryset['ExternalIdentifierSystemURL'] = eis_obj.ExternalIdentifierSystemURL
            queryset['IdentifierSystemOrganization'] = "*IdentifierSystemOrganizationID%03d" % eis_obj.IdentifierSystemOrganizationID 
            eis.append(queryset)
            eis = [i for n, i in enumerate(eis) if i not in eis[n + 1:]]

            o_obj = eis_obj.IdentifierSystemOrganizationObj
            o = OrderedDict()
            o['Organization'] = "&IdentifierSystemOrganizationID%03d" % o_obj.OrganizationID
            o['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            o['OrganizationCode'] = o_obj.OrganizationCode
            o['OrganizationName'] = o_obj.OrganizationName
            o['OrganizationDescription'] = o_obj.OrganizationDescription
            o['OrganizationLink'] = o_obj.OrganizationLink
            o['ParentOrganizationID'] = o_obj.ParentOrganizationID
            orgs.append(o)
            orgs = [i for n, i in enumerate(orgs) if i not in orgs[n + 1:]]

            c_obj = item.PersonObj
            c = OrderedDict()
            c['Person'] = "&PersonID%03d" % c_obj.PersonID
            c['PersonFirstName'] = c_obj.PersonFirstName
            c['PersonMiddleName'] = c_obj.PersonMiddleName
            c['PersonLastName'] = c_obj.PersonLastName
            cs.append(c)
            cs = [i for n, i in enumerate(cs) if i not in cs[n + 1:]]

        alleis["PersonExternalIdentifiers"] = ceis
        alleis["ExternalIdentifierSystems"] = eis
        alleis["Organizations"] = orgs
        alleis["People"] = cs

        response.write(pyaml.dump(alleis, vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):
        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="personexternalidentifiersystem.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allitems = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'PeopleExternalIdentifier': allitems}, wrap="PeopleExternalIdentifiers", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allitems = []
        for item in self.items:

            cei = OrderedDict()
            cei['PersonExternalIdentifier'] = item.PersonExternalIdentifier
            cei['PersonExternalIdentifierURI'] = item.PersonExternalIdentifierURI

            eis_obj = item.ExternalIdentifierSystemObj
            queryset = OrderedDict()
            queryset['ExternalIdentifierSystemID'] = eis_obj.ExternalIdentifierSystemID
            queryset['ExternalIdentifierSystemName'] = eis_obj.ExternalIdentifierSystemName
            queryset['ExternalIdentifierSystemDescription'] = eis_obj.ExternalIdentifierSystemDescription
            queryset['ExternalIdentifierSystemURL'] = eis_obj.ExternalIdentifierSystemURL

            o_obj = eis_obj.IdentifierSystemOrganizationObj
            o = OrderedDict()
            o['OrganizationID'] = o_obj.OrganizationID
            o['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            o['OrganizationCode'] = o_obj.OrganizationCode
            o['OrganizationName'] = o_obj.OrganizationName
            o['OrganizationDescription'] = o_obj.OrganizationDescription
            o['OrganizationLink'] = o_obj.OrganizationLink
            o['ParentOrganizationID'] = o_obj.ParentOrganizationID
            queryset['IdentifierSystemOrganization'] = o

            c_obj = item.PersonObj
            c = OrderedDict()
            c['PersonID'] = c_obj.PersonID
            c['PersonFirstName'] = c_obj.PersonFirstName
            c['PersonMiddleName'] = c_obj.PersonMiddleName
            c['PersonLastName'] = c_obj.PersonLastName

            cei['ExternalIdentifierSystem'] = queryset
            cei['People'] = c

            allitems.append(cei)

        self._session.close()
        return allitems

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

