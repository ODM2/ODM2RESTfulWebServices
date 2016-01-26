
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

import csv
import pyaml

from odm2service import Service
from negotiation import IgnoreClientContentNegotiation
from dict2xml import dict2xml as xmlify
from ODM2ALLServices import odm2Service as ODM2Read

class OrgsViewSet(APIView):
    """
    All ODM2 organizations Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

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
        items = readConn.getOrganizations()

        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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

        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getOrganizationByCode(organizationCode)

        if items == None:
            return Response('"%s" is not existed.' % organizationCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

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

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="organizations.yaml"'

        response.write("---\n")
        allitems = {}
        records = self.sqlalchemy_object_to_dict()
        allitems["Organizations"] = records
        response.write(pyaml.dump(allitems,vspacing=[0, 0]))
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="organizations.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allitems = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'Organization': allitems}, wrap="Organizations", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allitems = []
        conn = ODM2Read(self._session)

        for o_obj in self.items:

            org = {}
            org['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            org['OrganizationCode'] = o_obj.OrganizationCode
            org['OrganizationName'] = o_obj.OrganizationName
            org['OrganizationDescription'] = o_obj.OrganizationDescription
            org['OrganizationLink'] = o_obj.OrganizationLink
            org['ParentOrganizationID'] = o_obj.ParentOrganizationID

            org_aff = conn.getAffiliationsByOrgID(o_obj.OrganizationID)
            if org_aff != None and len(org_aff) > 0:
                affs = []
                for aff_obj in org_aff:
                    aff_p_obj = aff_obj.PersonObj

                    aff = {}
                    aff['IsPrimaryOrganizationContact'] = aff_obj.IsPrimaryOrganizationContact
                    aff['AffiliationStartDate'] = str(aff_obj.AffiliationStartDate)
                    aff['AffiliationEndDate'] = str(aff_obj.AffiliationEndDate)
                    aff['PrimaryPhone'] = aff_obj.PrimaryPhone
                    aff['PrimaryEmail'] = aff_obj.PrimaryEmail
                    aff['PrimaryAddress'] = aff_obj.PrimaryAddress
                    aff['PersonLink'] = aff_obj.PersonLink

                    aff_p = {}
                    aff_p['PersonFirstName'] = aff_p_obj.PersonFirstName
                    aff_p['PersonMiddleName'] = aff_p_obj.PersonMiddleName
                    aff_p['PersonLastName'] = aff_p_obj.PersonLastName

                    aff['Person'] = aff_p
                    affs.append(aff)
                org['Affiliations'] = affs
            allitems.append(org)

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

