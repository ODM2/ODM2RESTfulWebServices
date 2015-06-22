import sys
sys.path.append('ODM2PythonAPI')

from odm2rest.serializers import DummySerializer
from odm2rest.serializers import Odm2JsonSerializer

from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer

from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework import viewsets
from collections import OrderedDict

from django.core.paginator import Paginator, EmptyPage, PageNotAnInteger
import csv,cStringIO

from odm2rest.odm2service import Service
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_xml.renderers import XMLRenderer
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework.renderers import BrowsableAPIRenderer

from rest_framework.views import APIView
import yaml, pyaml
import json

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
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "yaml".
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
        #page = request.QUERY_PARAMS.get('page','1')
        #page_size = request.QUERY_PARAMS.get('page_size','100')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
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
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "yaml".
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

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
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
        for action in self.items:
            m_obj = action.MethodObj
            o_obj = m_obj.OrganizationObj

            queryset = OrderedDict()
            #queryset['ActionID'] = action.ActionID
            queryset['ActionTypeCV'] = action.ActionTypeCV
            queryset['BeginDateTime'] = action.BeginDateTime
            queryset['BeginDateTimeUTCOffset'] = action.BeginDateTimeUTCOffset
            queryset['EndDateTime'] = action.EndDateTime
            queryset['EndDateTimeUTCOffset'] = action.EndDateTimeUTCOffset
            queryset['ActionDescription'] = action.ActionDescription
            queryset['ActionFileLink'] = action.ActionFileLink

            m = OrderedDict()
            m['MethodTypeCV'] = m_obj.MethodTypeCV
            m['MethodCode'] = m_obj.MethodCode
            m['MethodName'] = m_obj.MethodName
            m['MethodDescription'] = m_obj.MethodDescription
            m['MethodLink'] = m_obj.MethodLink

            o = OrderedDict()
            o['OrganizationID'] = o_obj.OrganizationID
            o['OrganizationTypeCV'] = o_obj.OrganizationTypeCV
            o['OrganizationCode'] = o_obj.OrganizationCode
            o['OrganizationName'] = o_obj.OrganizationName
            o['OrganizationDescription'] = o_obj.OrganizationDescription
            o['OrganizationLink'] = o_obj.OrganizationLink
            o['ParentOrganizationID'] = o_obj.ParentOrganizationID
            m['Organization'] = o

            queryset['Method'] = m

            allactions.append(queryset)

        self._session.close()
        return allactions
