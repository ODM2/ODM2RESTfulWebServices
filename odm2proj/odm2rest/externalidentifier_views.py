
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from collections import OrderedDict

import csv
import pyaml

from odm2service import Service
from negotiation import IgnoreClientContentNegotiation
from dict2xml import dict2xml as xmlify

class ExternalIdentifierViewSet(APIView):
    """
    All ODM2 ExternalIdentifiers Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (JSONRenderer, YAMLRenderer)
    #serializer_class = VariableSerializer

    def get(self, request, format=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
              required: false
              type: string
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getExternalIdentifiers()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="externalidentifiersystem.csv"'

        item_csv_header = ["#fields=ExternalIdentifierSystemID","ExternalIdentifierSystemName[type='string']","ExternalIdentifierSystemDescription[type='string']","ExternalIdentifierSystemURL[type='string']","IdentifierSystemOrganization.OrganizationID","IdentifierSystemOrganization.OrganizationTypeCV[type='string']","IdentifierSystemOrganization.OrganizationCode[type='string']","IdentifierSystemOrganization.OrganizationName[type='string']","IdentifierSystemOrganization.OrganizationDescription[type='string']","IdentifierSystemOrganization.OrganizationLink[type='string']","IdentifierSystemOrganization.ParentOrganizationID"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []
            row.append(item.ExternalIdentifierSystemID)
            row.append(item.ExternalIdentifierSystemName)
            row.append(item.ExternalIdentifierSystemDescription)
            row.append(item.ExternalIdentifierSystemURL)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationID)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationTypeCV)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationCode)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationName)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationDescription)
            row.append(item.IdentifierSystemOrganizationObj.OrganizationLink)
            row.append(item.IdentifierSystemOrganizationObj.ParentOrganizationID)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="externalidentifiersystem.yaml"'

        response.write("---\n")

        alleis = {}

        eis = []
        orgs = []

        for item in self.items:
            queryset = OrderedDict()
            queryset['ExternalIdentifierSystemID'] = item.ExternalIdentifierSystemID
            queryset['ExternalIdentifierSystemName'] = item.ExternalIdentifierSystemName
            queryset['ExternalIdentifierSystemDescription'] = item.ExternalIdentifierSystemDescription
            queryset['ExternalIdentifierSystemURL'] = item.ExternalIdentifierSystemURL
            queryset['IdentifierSystemOrganization'] = "*IdentifierSystemOrganizationID%03d" % item.IdentifierSystemOrganizationID 
            eis.append(queryset)

            o = OrderedDict()
            o['Organization'] = "&IdentifierSystemOrganizationID%03d" % item.IdentifierSystemOrganizationObj.OrganizationID
            o['OrganizationTypeCV'] = item.IdentifierSystemOrganizationObj.OrganizationTypeCV
            o['OrganizationCode'] = item.IdentifierSystemOrganizationObj.OrganizationCode
            o['OrganizationName'] = item.IdentifierSystemOrganizationObj.OrganizationName
            o['OrganizationDescription'] = item.IdentifierSystemOrganizationObj.OrganizationDescription
            o['OrganizationLink'] = item.IdentifierSystemOrganizationObj.OrganizationLink
            o['ParentOrganizationID'] = item.IdentifierSystemOrganizationObj.ParentOrganizationID
            orgs.append(o)
            orgs = [i for n, i in enumerate(orgs) if i not in orgs[n + 1:]]

        alleis["ExternalIdentifierSystems"] = eis
        alleis["Organizations"] = orgs
        response.write(pyaml.dump(alleis, vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):
        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="externalidentifiersystem.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allitems = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'ExternalIdentifierSystem': allitems}, wrap="ExternalIdentifierSystems", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allitems = []
        for item in self.items:
            queryset = OrderedDict()
            queryset['ExternalIdentifierSystemID'] = item.ExternalIdentifierSystemID
            queryset['ExternalIdentifierSystemName'] = item.ExternalIdentifierSystemName
            queryset['ExternalIdentifierSystemDescription'] = item.ExternalIdentifierSystemDescription
            queryset['ExternalIdentifierSystemURL'] = item.ExternalIdentifierSystemURL

            o = OrderedDict()
            o['OrganizationID'] = item.IdentifierSystemOrganizationObj.OrganizationID
            o['OrganizationTypeCV'] = item.IdentifierSystemOrganizationObj.OrganizationTypeCV
            o['OrganizationCode'] = item.IdentifierSystemOrganizationObj.OrganizationCode
            o['OrganizationName'] = item.IdentifierSystemOrganizationObj.OrganizationName
            o['OrganizationDescription'] = item.IdentifierSystemOrganizationObj.OrganizationDescription
            o['OrganizationLink'] = item.IdentifierSystemOrganizationObj.OrganizationLink
            o['ParentOrganizationID'] = item.IdentifierSystemOrganizationObj.ParentOrganizationID
            queryset['IdentifierSystemOrganization'] = o

            allitems.append(queryset)

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

