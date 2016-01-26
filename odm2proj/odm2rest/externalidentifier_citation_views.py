
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from collections import OrderedDict

import csv
from odm2service import Service
from negotiation import IgnoreClientContentNegotiation
from dict2xml import dict2xml as xmlify

class ExternalIdentifierCitationViewSet(APIView):
    """
    All ODM2 ExternalIdentifiers For Citation Retrieval
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
        items = readConn.getExternalIdentifiersForCitation()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="citationexternalidentifiersystem.csv"'

        item_csv_header = ["#fields=CitationExternalIdentifier[type='string']","CitationExternalIdentifierURI[type='string']","ExternalIdentifierSystemID","ExternalIdentifierSystemName[type='string']","ExternalIdentifierSystemDescription[type='string']","ExternalIdentifierSystemURL[type='string']","IdentifierSystemOrganization.OrganizationID","IdentifierSystemOrganization.OrganizationTypeCV[type='string']","IdentifierSystemOrganization.OrganizationCode[type='string']","IdentifierSystemOrganization.OrganizationName[type='string']","IdentifierSystemOrganization.OrganizationDescription[type='string']","IdentifierSystemOrganization.OrganizationLink[type='string']","IdentifierSystemOrganization.ParentOrganizationID","CitationID","Title[type='string']","Publisher[type='string']","PublicationYear","CitationLink[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []

            row.append(item.CitationExternalIdentifier)
            row.append(item.CitationExternalIdentifierURI)
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
            c_obj = item.CitationObj
            row.append(c_obj.CitationID)
            row.append(c_obj.Title)
            row.append(c_obj.Publisher)
            row.append(c_obj.PublicationYear)
            row.append(c_obj.CitationLink)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="citationexternalidentifiersystem.yaml"'

        response.write("---\n")

        alleis = {}

        ceis = []
        eis = []
        orgs = []
        cs = []

        for item in self.items:

            cei = OrderedDict()
            cei['Citation'] = "*CitationID%03d" % item.CitationID
            cei['ExternalIdentifierSystem'] = "*ExternalIdentifierSystemID%03d" % item.ExternalIdentifierSystemID
            cei['CitationExternalIdentifier'] = u'%s' % item.CitationExternalIdentifier
            cei['CitationExternalIdentifierURI'] = u'%s' % item.CitationExternalIdentifierURI
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

            c_obj = item.CitationObj
            c = OrderedDict()
            c['Citation'] = "&CitationID%03d" % c_obj.CitationID
            c['Title'] = c_obj.Title
            c['Publisher'] = c_obj.Publisher
            c['PublicationYear'] = c_obj.PublicationYear
            c['CitationLink'] = c_obj.CitationLink
            cs.append(c)
            cs = [i for n, i in enumerate(cs) if i not in cs[n + 1:]]

        alleis["CitationExternalIdentifiers"] = ceis
        alleis["ExternalIdentifierSystems"] = eis
        alleis["Organizations"] = orgs
        alleis["Citations"] = cs

        response.write(pyaml.dump(alleis, vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):
        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="citationexternalidentifiersystem.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allitems = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'CitationExternalIdentifier': allitems}, wrap="CitationExternalIdentifiers", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allitems = []
        for item in self.items:

            cei = OrderedDict()
            cei['CitationExternalIdentifier'] = item.CitationExternalIdentifier
            cei['CitationExternalIdentifierURI'] = item.CitationExternalIdentifierURI

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

            c_obj = item.CitationObj
            c = OrderedDict()
            c['CitationID'] = c_obj.CitationID
            c['Title'] = c_obj.Title
            c['Publisher'] = c_obj.Publisher
            c['PublicationYear'] = c_obj.PublicationYear
            c['CitationLink'] = c_obj.CitationLink

            cei['ExternalIdentifierSystem'] = queryset
            cei['Citation'] = c

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

