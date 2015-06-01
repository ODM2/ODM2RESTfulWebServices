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

class VariableViewSet(APIView):
    """
    All ODM2 variables Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (JSONRenderer, YAMLRenderer)
    #serializer_class = VariableSerializer

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
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getVariables()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class VariableCodeViewSet(APIView):
    """
    All ODM2 variables Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, variableCode=None):
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

        if variableCode is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getVariableByCode(variableCode)

        if items == None:
            return Response('"%s" is not existed.' % variableCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        allvars = []
        for variable in self.items:
            queryset = OrderedDict()
            queryset['VariableID'] = variable.VariableID
            queryset['VariableCode'] = variable.VariableCode
            queryset['VariableType'] = variable.VariableTypeCV
            queryset['VariableName'] = variable.VariableNameCV
            queryset['VariableDefinition'] = variable.VariableDefinition
            queryset['NoDataValue'] = variable.NoDataValue
            queryset['Speciation'] = variable.SpeciationCV
            allvars.append(queryset)

        self._session.close()
        return allvars

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="variables.csv"'

        variable_csv_header = ["#fields=VariableTypeCV[type='string']","VariableCode[type='string']","VariableNameCV[type='string']","VariableDefinition[type='string']","SpeciationCV[type='string']","NoDataValue"]

        writer = csv.writer(response)
        writer.writerow(variable_csv_header)
            
        for variable in self.items:
            row = []
            row.append(variable.VariableTypeCV)
            row.append(variable.VariableCode)
            row.append(variable.VariableNameCV)
            row.append(variable.VariableDefinition)
            row.append(variable.SpeciationCV)
            row.append(variable.NoDataValue)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="variables.yaml"'

        response.write("---\n")
        allvars = {}
        vararray = []
            
        for variable in self.items:

            queryset = OrderedDict()
            queryset["VariableID"] = variable.VariableID
            queryset["VariableCode"] = variable.VariableCode
            queryset["VariableType"] = variable.VariableTypeCV
            queryset["VariableName"] = variable.VariableNameCV
            queryset["VariableDefinition"] = variable.VariableDefinition
            queryset["NoDataValue"] = str(variable.NoDataValue)
            queryset["Speciation"] = variable.SpeciationCV
            vararray.append(queryset)
                
            #queryset = "- {"
            #queryset += "VariableCode: " + variable.VariableCode + ", "
            #queryset += "VariableType: " + variable.VariableTypeCV + ", "
            #queryset += "VariableName: \"" + variable.VariableNameCV + "\", "
            #if variable.VariableDefinition == None:
            #    queryset += "VariableDefinition: \"\", "
            #else:
            #    queryset += "VariableDefinition: " + variable.VariableDefinition +", "
            #queryset += "NoDataValue: " + str(variable.NoDataValue) + ", "
            #queryset += "Speciation: " + variable.SpeciationCV
            #queryset += "}"
            #response.write(queryset+"\n")
            #Variables.append(queryset)

        #response.write(yaml.dump(Variables, indent=4 ,default_flow_style=False).replace('-   ', '  - ')+"\n")
        #response.write(pyaml.dump(Variables,vspacing=[2, 1]))
        allvars["Variables"] = vararray
        response.write(pyaml.dump(allvars,vspacing=[0, 0]))

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

