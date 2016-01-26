
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.response import Response
from rest_framework import status
from collections import OrderedDict
import csv
from rest_framework.views import APIView
import pyaml

from odm2service import Service
from ODM2ALLServices import odm2Service as ODM2Read
from dict2xml import dict2xml as xmlify
from negotiation import IgnoreClientContentNegotiation

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
            - name: accept
              description: The supported accept header styles are "application/json", "text/csv", and "application/yaml".
              required: false
              type: string
              paramType: query

    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

class ActionsViewSet(APIView):
    """
    All ODM2 Action Retrieval

    """

    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

    def get(self, request, format=None):

        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "json".
              required: false
              type: string
              paramType: query
        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','1')
        #page_size = request.QUERY_PARAMS.get('page_size','100')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        #items = readConn.getActionsByPAge(page,page_size)
        items = readConn.getActions()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class ActionTypeViewSet(APIView):
    """
    All ODM2 Action Retrieval
    """

    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, actionType=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "json".
              required: false
              type: string
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        if actionType is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getActionByActionType(actionType)

        if items == None:
            return Response('"%s" is not existed.' % actionType,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="actions.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=ActionTypeCV[type='string']","BeginDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","BeginDateTimeUTCOffset","EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","EndDateTimeUTCOffset","ActionDescription[type='string']","ActionFileLink[type='string']"])
        item_csv_header.extend(["MethodTypeCV[type='string']","MethodCode[type='string']","MethodName[type='string']","MethodDescription[type='string']","MethodLink[type='string']"])
        item_csv_header.extend(["OrganizationTypeCV[type='string']","OrganizationCode[type='string']","OrganizationName[type='string']","OrganizationDescription[type='string']","OrganizationLink[type='string']","ParentOrganizationID"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for item in self.items:
            m_obj = item.MethodObj
            o_obj = m_obj.OrganizationObj            

            row = []
            row.append(item.ActionTypeCV)
            row.append(item.BeginDateTime)
            row.append(item.BeginDateTimeUTCOffset)
            row.append(item.EndDateTime)
            row.append(item.EndDateTimeUTCOffset)
            row.append(item.ActionDescription)
            row.append(item.ActionFileLink)

            row.append(m_obj.MethodTypeCV)
            row.append(m_obj.MethodCode)
            row.append(m_obj.MethodName)
            row.append(m_obj.MethodDescription)
            row.append(m_obj.MethodLink)

            row.append(o_obj.OrganizationTypeCV)
            row.append(o_obj.OrganizationCode)
            row.append(o_obj.OrganizationName)
            row.append(o_obj.OrganizationDescription)
            row.append(o_obj.OrganizationLink)
            row.append(o_obj.ParentOrganizationID)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="actions.yaml"'

        response.write("---\n")
        allactions = {}

        ats = []
        mts = []
        orgs = []

        for action in self.items:
            m_obj = action.MethodObj
            o_obj = m_obj.OrganizationObj            

            at = OrderedDict()
            at['ActionTypeCV'] = action.ActionTypeCV
            at['MethodID'] = "*MethodID%03d" % action.MethodID 
            at['ActionDescription'] = action.ActionDescription
            at['ActionFileLink'] = action.ActionFileLink
            at['BeginDateTime'] = action.BeginDateTime
            at['BeginDateTimeUTCOffset'] = action.BeginDateTimeUTCOffset
            at['EndDateTime'] = action.EndDateTime
            at['EndDateTimeUTCOffset'] = action.EndDateTimeUTCOffset
            ats.append(at)

            m = OrderedDict()
            m['Method'] = "&MethodID%03d" % m_obj.MethodID
            m['MethodTypeCV'] = m_obj.MethodTypeCV
            m['MethodCode'] = m_obj.MethodCode
            m['MethodName'] = m_obj.MethodName
            m['MethodDescription'] = m_obj.MethodDescription
            m['MethodLink'] = m_obj.MethodLink
            m['OrganizationID'] = "*OrganizationID%03d" % m_obj.OrganizationID 
            mts.append(m)
            mts = [i for n, i in enumerate(mts) if i not in mts[n + 1:]]


            o = OrderedDict()
            o['OrganizationID'] = "&OrganizationID%03d" % o_obj.OrganizationID
            o['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            o['OrganizationCode'] = o_obj.OrganizationCode
            o['OrganizationName'] = o_obj.OrganizationName
            o['OrganizationDescription'] = o_obj.OrganizationDescription
            o['OrganizationLink'] = o_obj.OrganizationLink
            o['ParentOrganizationID'] = o_obj.ParentOrganizationID
            orgs.append(o)
            orgs = [i for n, i in enumerate(orgs) if i not in orgs[n + 1:]]
            
        allactions["Actions"] = ats
        allactions["Methods"] = mts
        allactions["Organizations"] = orgs
        response.write(pyaml.dump(allactions, vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="actions.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allactions = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'Action': allactions}, wrap="Actions", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        allactions = []
        conn = ODM2Read(self._session)

        for a_obj in self.items:
            m_obj = a_obj.MethodObj
            o_obj = m_obj.OrganizationObj

            action = {}
            action['ActionTypeCV'] = a_obj.ActionTypeCV
            action['BeginDateTime'] = str(a_obj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = a_obj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(a_obj.EndDateTime)
            action['EndDateTimeUTCOffset'] = a_obj.EndDateTimeUTCOffset
            action['ActionDescription'] = a_obj.ActionDescription
            action['ActionFileLink'] = a_obj.ActionFileLink
            method = {}
            method['MethodTypeCV'] = m_obj.MethodTypeCV
            method['MethodCode'] = m_obj.MethodCode
            method['MethodName'] = m_obj.MethodName
            method['MethodDescription'] = m_obj.MethodDescription
            method['MethodLink'] = m_obj.MethodLink
            org = {}
            org['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            org['OrganizationCode'] = o_obj.OrganizationCode
            org['OrganizationName'] = o_obj.OrganizationName
            org['OrganizationDescription'] = o_obj.OrganizationDescription
            org['OrganizationLink'] = o_obj.OrganizationLink
            org['ParentOrganizationID'] = o_obj.ParentOrganizationID
            method['Organization'] = org
            action['Method'] = method

            raction = conn.getRelatedActionsByActionID(a_obj.ActionID)
            if raction != None and len(raction) > 0:
                ractions = []
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj
                    rao_obj = ram_obj.OrganizationObj
                    ra = {}
                    ra['RelationshipTypeCV'] = x.RelationshipTypeCV
                    raid = {}
                    raid['ActionTypeCV'] = ra_obj.ActionTypeCV
                    raid['BeginDateTime'] = str(ra_obj.BeginDateTime)
                    raid['BeginDateTimeUTCOffset'] = ra_obj.BeginDateTimeUTCOffset
                    raid['EndDateTime'] = str(ra_obj.EndDateTime)
                    raid['EndDateTimeUTCOffset'] = ra_obj.EndDateTimeUTCOffset
                    raid['ActionDescription'] = ra_obj.ActionDescription
                    raid['ActionFileLink'] = ra_obj.ActionFileLink
                    ram = {}
                    ram['MethodTypeCV'] = ram_obj.MethodTypeCV
                    ram['MethodCode'] = ram_obj.MethodCode
                    ram['MethodName'] = ram_obj.MethodName
                    ram['MethodDescription'] = ram_obj.MethodDescription
                    ram['MethodLink'] = ram_obj.MethodLink
                    raorg = {}
                    raorg['OrganizationTypeCV'] = rao_obj.OrganizationTypeCV
                    raorg['OrganizationCode'] = rao_obj.OrganizationCode
                    raorg['OrganizationName'] = rao_obj.OrganizationName
                    raorg['OrganizationDescription'] = rao_obj.OrganizationDescription
                    raorg['OrganizationLink'] = rao_obj.OrganizationLink
                    raorg['ParentOrganizationID'] = rao_obj.ParentOrganizationID
                    ram['Organization'] = raorg
                    raid['Method'] = ram
                    ra['RelatedAction'] = raid
                    
                    ractions.append(ra)
                action['RelatedActions'] = ractions

            actionby = conn.getActionByByActionID(a_obj.ActionID)
            if actionby != None and len(actionby) > 0:
                actionbys = []
                for x in actionby:
                    aff_obj = x.AffiliationObj
                    aff_o_obj = aff_obj.OrganizationObj
                    aff_p_obj = aff_obj.PersonObj

                    ab = {}
                    ab['IsActionLead'] = x.IsActionLead
                    ab['RoleDescription'] = x.RoleDescription

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
                    aff_o = {}
                    aff_o['OrganizationTypeCV'] = aff_o_obj.OrganizationTypeCV
                    aff_o['OrganizationCode'] = aff_o_obj.OrganizationCode
                    aff_o['OrganizationName'] = aff_o_obj.OrganizationName
                    aff_o['OrganizationDescription'] = aff_o_obj.OrganizationDescription
                    aff_o['OrganizationLink'] = aff_o_obj.OrganizationLink
                    aff_o['ParentOrganizationID'] = aff_o_obj.ParentOrganizationID
                    aff['Organization'] = aff_o
                    aff['Person'] = aff_p
                    ab['Affiliation'] = aff
                    
                    actionbys.append(ab)
                action['ActionBys'] = actionbys

            allactions.append(action)

        self._session.close()
        return allactions
