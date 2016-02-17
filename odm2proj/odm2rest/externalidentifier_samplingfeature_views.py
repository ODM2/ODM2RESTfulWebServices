
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

class ExternalIdentifierSamplingFeatureViewSet(APIView):
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
        items = readConn.getExternalIdentifiersForSamplingFeature()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="samplingfeatureexternalidentifiersystem.csv"'

        item_csv_header = ["#fields=SamplingFeatureExternalIdentifier[type='string']","SamplingFeatureExternalIdentifierURI[type='string']","ExternalIdentifierSystemID","ExternalIdentifierSystemName[type='string']","ExternalIdentifierSystemDescription[type='string']","ExternalIdentifierSystemURL[type='string']","IdentifierSystemOrganization.OrganizationID","IdentifierSystemOrganization.OrganizationTypeCV[type='string']","IdentifierSystemOrganization.OrganizationCode[type='string']","IdentifierSystemOrganization.OrganizationName[type='string']","IdentifierSystemOrganization.OrganizationDescription[type='string']","IdentifierSystemOrganization.OrganizationLink[type='string']","IdentifierSystemOrganization.ParentOrganizationID","SamplingFeatureID","SamplingFeatureUUID[type='string']","SamplingFeatureTypeCV[type='string']","SamplingFeatureCode[type='string']","SamplingFeatureName[type='string']","SamplingFeatureDescription[type='string']","SamplingFeatureGeotypeCV[type='string']","Elevation_m","ElevationDatumCV[type='string']","FeatureGeometry[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            row = []

            row.append(item.SamplingFeatureExternalIdentifier)
            row.append(item.SamplingFeatureExternalIdentifierURI)
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
            c_obj = item.SamplingFeatureObj
            row.append(c_obj.SamplingFeatureID)
            row.append(c_obj.SamplingFeatureUUID)
            row.append(c_obj.SamplingFeatureTypeCV)
            row.append(c_obj.SamplingFeatureCode)
            row.append(c_obj.SamplingFeatureName)
            row.append(c_obj.SamplingFeatureDescription)
            row.append(c_obj.SamplingFeatureGeotypeCV)
            row.append(c_obj.Elevation_m)
            row.append(c_obj.ElevationDatumCV)
            fg = None
            if c_obj.FeatureGeometry is not None:
                fg = c_obj.shape().wkt
            row.append(fg)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="samplingfeatureexternalidentifiersystem.yaml"'

        response.write("---\n")

        alleis = {}

        ceis = []
        eis = []
        orgs = []
        cs = []

        for item in self.items:

            cei = OrderedDict()
            cei['SamplingFeature'] = "*SamplingFeatureID%03d" % item.SamplingFeatureID
            cei['ExternalIdentifierSystem'] = "*ExternalIdentifierSystemID%03d" % item.ExternalIdentifierSystemID
            cei['SamplingFeatureExternalIdentifier'] = u'%s' % item.SamplingFeatureExternalIdentifier
            cei['SamplingFeatureExternalIdentifierURI'] = u'%s' % item.SamplingFeatureExternalIdentifierURI
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

            c_obj = item.SamplingFeatureObj
            c = OrderedDict()
            c['SamplingFeature'] = "&SamplingFeatureID%03d" % c_obj.SamplingFeatureID
            c['SamplingFeatureID'] = c_obj.SamplingFeatureID
            c['SamplingFeatureUUID'] = str(c_obj.SamplingFeatureUUID)
            c['SamplingFeatureTypeCV'] = c_obj.SamplingFeatureTypeCV
            c['SamplingFeatureCode'] = c_obj.SamplingFeatureCode
            c['SamplingFeatureName'] = c_obj.SamplingFeatureName
            c['SamplingFeatureDescription'] = c_obj.SamplingFeatureDescription
            c['SamplingFeatureGeotypeCV'] = c_obj.SamplingFeatureGeotypeCV
            c['Elevation_m'] = c_obj.Elevation_m
            c['ElevationDatumCV'] = c_obj.ElevationDatumCV
            fg = None
            if c_obj.FeatureGeometry is not None:
                fg = c_obj.shape().wkt
            c['FeatureGeometry'] = fg
            cs.append(c)
            cs = [i for n, i in enumerate(cs) if i not in cs[n + 1:]]

        alleis["SamplingFeatureExternalIdentifiers"] = ceis
        alleis["ExternalIdentifierSystems"] = eis
        alleis["Organizations"] = orgs
        alleis["SamplingFeatures"] = cs

        response.write(pyaml.dump(alleis, vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):
        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="samplingfeatureexternalidentifiersystem.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allitems = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'SamplingFeatureExternalIdentifier': allitems}, wrap="SamplingFeatureExternalIdentifiers", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allitems = []
        for item in self.items:

            cei = OrderedDict()
            cei['SamplingFeatureExternalIdentifier'] = item.SamplingFeatureExternalIdentifier
            cei['SamplingFeatureExternalIdentifierURI'] = item.SamplingFeatureExternalIdentifierURI

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

            c_obj = item.SamplingFeatureObj
            c = OrderedDict()
            c['SamplingFeatureID'] = c_obj.SamplingFeatureID
            c['SamplingFeatureUUID'] = c_obj.SamplingFeatureUUID
            c['SamplingFeatureTypeCV'] = c_obj.SamplingFeatureTypeCV
            c['SamplingFeatureCode'] = c_obj.SamplingFeatureCode
            c['SamplingFeatureName'] = c_obj.SamplingFeatureName
            c['SamplingFeatureDescription'] = c_obj.SamplingFeatureDescription
            c['SamplingFeatureGeotypeCV'] = c_obj.SamplingFeatureGeotypeCV
            c['Elevation_m'] = c_obj.Elevation_m
            c['ElevationDatumCV'] = c_obj.ElevationDatumCV
            fg = None
            if c_obj.FeatureGeometry is not None:
                fg = c_obj.shape().wkt
            c['FeatureGeometry'] = fg
            cei['ExternalIdentifierSystem'] = queryset
            cei['SamplingFeature'] = c

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

