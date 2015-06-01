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

class ActionIDViewSet(APIView):
    """
    All ODM2 Action Retrieval
    """

    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, actionID=None):
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

        if actionID is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getActionByActionID(actionID)

        if items == None:
            return Response('"%s" is not existed.' % actionID,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        allactions = []
        for action in self.items:
            queryset = OrderedDict()
            queryset['ActionID'] = action.ActionID
            queryset['ActionTypeCV'] = action.ActionTypeCV
            queryset['ActionDescription'] = action.ActionDescription
            queryset['ActionFileLink'] = action.ActionFileLink

            m = OrderedDict()
            m['MethodTypeCV'] = action.MethodObj.MethodTypeCV
            m['MethodCode'] = action.MethodObj.MethodCode
            m['MethodName'] = action.MethodObj.MethodName
            m['MethodDescription'] = action.MethodObj.MethodDescription
            m['MethodLink'] = action.MethodObj.MethodLink
            m['OrganizationID'] = action.MethodObj.OrganizationID
            queryset['MethodID'] = m

            queryset['BeginDateTime'] = action.BeginDateTime
            queryset['BeginDateTimeUTCOffset'] = action.BeginDateTimeUTCOffset
            queryset['EndDateTime'] = action.EndDateTime
            queryset['EndDateTimeUTCOffset'] = action.EndDateTimeUTCOffset

            allactions.append(queryset)

        self._session.close()
        return allactions

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="actions.csv"'

        action_csv_header = ["#fields=ActionID[type='string']","ActionTypeCV[type='string']","ActionDescription[type='string']","ActionFileLink[type='string']","MethodTypeCV[type='string']","MethodCode[type='string']","MethodName[type='string']\
","MethodDescription[type='string']","MethodLink[type='string']","OrganizationID","BeginDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","BeginDateTimeUTCOffset","EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","EndDateTimeUTCOffset"]
        
        writer = csv.writer(response)
        writer.writerow(action_csv_header)
            
        for item in self.items:
            row = []
            row.append(item.ActionID)
            row.append(item.ActionTypeCV)
            row.append(item.ActionDescription)
            row.append(item.ActionFileLink)
            row.append(item.MethodObj.MethodTypeCV)
            row.append(item.MethodObj.MethodCode)
            row.append(item.MethodObj.MethodName)
            row.append(item.MethodObj.MethodDescription)
            row.append(item.MethodObj.MethodLink)
            row.append(item.MethodObj.OrganizationID)
            row.append(item.BeginDateTime)
            row.append(item.BeginDateTimeUTCOffset)
            row.append(item.EndDateTime)
            row.append(item.EndDateTimeUTCOffset)

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

        for action in self.items:
            at = OrderedDict()
            at['ActionID'] = action.ActionID
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
            m['Method'] = "&MethodID%03d" % action.MethodObj.MethodID
            m['MethodTypeCV'] = action.MethodObj.MethodTypeCV
            m['MethodCode'] = action.MethodObj.MethodCode
            m['MethodName'] = action.MethodObj.MethodName
            m['MethodDescription'] = action.MethodObj.MethodDescription
            m['MethodLink'] = action.MethodObj.MethodLink
            m['OrganizationID'] = action.MethodObj.OrganizationID
            mts.append(m)
            mts = [i for n, i in enumerate(mts) if i not in mts[n + 1:]]

        allactions["Actions"] = ats
        allactions["Methods"] = mts
        response.write(pyaml.dump(allactions, vspacing=[1, 0]))

        self._session.close()
        return response

