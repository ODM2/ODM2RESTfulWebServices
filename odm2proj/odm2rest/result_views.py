import sys
sys.path.append('ODM2PythonAPI')

from odm2rest.serializers import DummySerializer
from odm2rest.serializers import Odm2JsonSerializer

from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

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
import yaml, pyaml

from sets import Set
from negotiation import IgnoreClientContentNegotiation
from datetime import datetime, timedelta

class ResultsViewSet(APIView):
    """
    All ODM2 Result records Retrieval

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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        #items = readConn.getResultsByPage(page, page_size)
        items = readConn.getResults()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsVarCodeViewSet(APIView):
    """
    All ODM2 Result records Retrieval

    """
    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

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

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsByVariableCode(variableCode)

        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsSFCodeViewSet(APIView):
    """
    All ODM2 Result records Retrieval

    """
    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

    def get(self, request, format=None, samplingfeatureCode=None):
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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsBySamplingfeatureCode(samplingfeatureCode)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsSFUUIDViewSet(APIView):
    """
    All ODM2 Result records Retrieval

    """
    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

    def get(self, request, format=None, samplingfeatureUUID=None):
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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsBySamplingfeatureUUID(samplingfeatureUUID)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsBBoxViewSet(APIView):
    """
    All ODM2 Result records Retrieval

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
            - name: west    
              description: minx, longitude, for example, -112.0.
              required: true
              type: float
              paramType: query
            - name: south    
              description: miny, latitude, for example, 40.0.
              required: true
              type: float
              paramType: query
            - name: east    
              description: maxx, longitude, for example, -111.0.
              required: true
              type: float
              paramType: query
            - name: north    
              description: maxy, latitude, for example, 42.0.
              required: true
              type: float
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        west = request.query_params.get('west')
        south = request.query_params.get('south')
        east = request.query_params.get('east')
        north = request.query_params.get('north')
        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsByBBox(west, south, east, north)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsActionDateViewSet(APIView):
    """
    All ODM2 Result records Retrieval

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
            - name: startDate    
              description: ISO date, for example, 2008-03-20.
              required: true
              type: datetime
              paramType: query
            - name: endDate    
              description: ISO date, for example, 2008-05-20.
              required: true
              type: datetime
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        sDate = request.query_params.get('startDate')
        eDate = request.query_params.get('endDate')
        fromDate = datetime.strptime(sDate, '%Y-%m-%d')
        toDate = datetime.strptime(eDate, '%Y-%m-%d')

        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsByActionByDate(fromDate, toDate)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsRTypeCVViewSet(APIView):
    """
    All ODM2 Result records Retrieval

    """
    #serializer_class = DummySerializer
    paginate_by = 10
    paginate_by_param = 'page_size'
    max_paginate_by = 100
    content_negotiation_class = IgnoreClientContentNegotiation
    #renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)

    def get(self, request, format=None, resultType=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query
            - name: resultType    
              description: For example, "Time Series Coverage", "Measurement".
              required: true
              type: string
              paramType: path

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsByResultTypeCV(resultType)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class ResultsComplexViewSet(APIView):
    """
    All ODM2 Result records Retrieval

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
            - name: resultType    
              description: For example, "Time Series Coverage", "Measurement".
              required: true
              type: string
              paramType: query
            - name: west    
              description: minx, longitude, for example, -112.0.
              required: true
              type: float
              paramType: query
            - name: south    
              description: miny, latitude, for example, 40.0.
              required: true
              type: float
              paramType: query
            - name: east    
              description: maxx, longitude, for example, -111.0.
              required: true
              type: float
              paramType: query
            - name: north    
              description: maxy, latitude, for example, 42.0.
              required: true
              type: float
              paramType: query
            - name: startDate    
              description: ISO date, for example, 2014-10-20.
              required: true
              type: datetime
              paramType: query
            - name: endDate    
              description: ISO date, for example, 2014-10-21.
              required: true
              type: datetime
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        rTypeCV = request.query_params.get('resultType')
        west = request.query_params.get('west')
        south = request.query_params.get('south')
        east = request.query_params.get('east')
        north = request.query_params.get('north')
        sDate = request.query_params.get('startDate')
        eDate = request.query_params.get('endDate')
        beginDate = datetime.strptime(sDate, '%Y-%m-%d')
        endDate = datetime.strptime(eDate, '%Y-%m-%d')
        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getResultsByResultTypeCVByBBoxByDate(rTypeCV, west, south, east, north, beginDate, endDate)

        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format_with_conn(items, format, readConn)

class MultipleRepresentations(Service):

    def json_format(self):

        allvalues = []
        for value in self.items:
            queryset = OrderedDict()
            queryset['ResultID'] = value.ResultID
            queryset['ResultUUID'] = value.ResultUUID
            queryset['ResultTypeCV'] = value.ResultTypeCV
            s = OrderedDict()
            s['SamplingFeatureCode'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            s['SamplingFeatureName'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            s['FeatureGeometry'] = value.FeatureActionObj.SamplingFeatureObj.FeatureGeometry
            s['Elevation_m'] = value.FeatureActionObj.SamplingFeatureObj.Elevation_m
            queryset['SamplingFeature'] = s

            v = OrderedDict()
            v['VariableCode'] = value.VariableObj.VariableCode
            v['VariableNameCV'] = value.VariableObj.VariableNameCV
            queryset['Variable'] = v

            allvalues.append(queryset)

        return allvalues

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="results.csv"'

        value_csv_header = ["#fields=ResultID[type='string']","ResultUUID[type='string']","ResultTypeCV[type='string']","SamplingFeatureCode[type='string']","SamplingFeatureName[type='string']","FeatureGeometry[type='string']","Elevation","VariableCode[type='string']","VariableNameCV[type='string']","ValueDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","ValueDateTimeUTCOffset","DataValue"]
            
        writer = csv.writer(response)
        writer.writerow(value_csv_header)
        
        for item in self.items:
            row = []
            row.append(item.ResultID)
            row.append(item.ResultUUID)
            row.append(item.ResultTypeCV)
            #row.append(item.ProcessingLevelObj.Definition)
            #row.append(item.SampledMediumCV)
            row.append(item.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(item.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(item.FeatureActionObj.SamplingFeatureObj.FeatureGeometry)
            row.append(item.FeatureActionObj.SamplingFeatureObj.Elevation_m)
            row.append(item.VariableObj.VariableCode)
            row.append(item.VariableObj.VariableNameCV)

            writer.writerow(row)

        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="results.yaml"'

        response.write("---\n")
        response.write("Results:\n")

        for value in self.items:

            #r  = u' - ResultID: %d\n' % value.ResultID
            r  = u' - ResultUUID: "%s"\n' % value.ResultUUID
            r += u'   ResultTypeCV: \'%s\'\n' % value.ResultTypeCV
            r += u'   ResultDateTime: "%s"\n' % str(value.ResultDateTime)
            r += u'   ResultDateTimeUTCOffset: %s\n' % str(value.ResultDateTimeUTCOffset)
            r += u'   StatusCV: %s\n' % value.StatusCV
            r += u'   SampledMediumCV: %s\n' % value.SampledMediumCV
            r += u'   ValueCount: %d\n' % value.ValueCount

            r += u'   FeatureAction: \n'
            #r += u'       FeatureActionID: %d\n' % value.FeatureActionObj.FeatureActionID
            r += u'       SamplingFeature:\n'
            #r += u'           SamplingFeatureID: %d\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            r += u'           SamplingFeatureUUID: %s\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            r += u'           SamplingFeatureTypeCV: %s\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            r += u'           SamplingFeatureCode: %s\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            r += u'           Elevation_m: %s\n' % str(value.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            r += u'           Action:\n'
            #r += u'               ActionID: %d\n' % value.FeatureActionObj.ActionObj.ActionID
            r += u'               ActionTypeCV: "%s"\n' % value.FeatureActionObj.ActionObj.ActionTypeCV
            r += u'               BeginDateTime: "%s"\n' % str(value.FeatureActionObj.ActionObj.BeginDateTime)
            r += u'               BeginDateTimeUTCOffset: %s\n' % str(value.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
            r += u'               EndDateTime: "%s"\n' % str(value.FeatureActionObj.ActionObj.EndDateTime)
            r += u'               EndDateTimeUTCOffset: %s\n' % str(value.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            r += u'               Method:\n'
            #r += u'                   MethodID: %d\n' % value.FeatureActionObj.ActionObj.MethodObj.MethodID
            r += u'                   MethodTypeCV: %s\n' % value.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            r += u'                   MethodCode: %s\n' % value.FeatureActionObj.ActionObj.MethodObj.MethodCode
            r += u'                   MethodName: %s\n' % value.FeatureActionObj.ActionObj.MethodObj.MethodName
            sfid = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            site = self.conn.getSiteBySFId(sfid)
            if site != None:
                r += u'   Site:\n'
                r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                r += u'       Latitude: %f\n' % site.Latitude
                r += u'       Longitude: %f\n' % site.Longitude
                r += u'       SpatialReference:\n'
                #r += u'           SRSID: %d\n' % site.SpatialReferenceObj.SpatialReferenceID
                r += u'           SRSCode: "%s"\n' % site.SpatialReferenceObj.SRSCode
                r += u'           SRSName: %s\n' % site.SpatialReferenceObj.SRSName

            r += u'   Variable:\n'
            #r += u'       VariableID: %d\n' % value.VariableObj.VariableID
            r += u'       VariableTypeCV: %s\n' % value.VariableObj.VariableTypeCV
            r += u'       VariableCode: %s\n' % value.VariableObj.VariableCode
            r += u'       VariableNameCV: %s\n' % value.VariableObj.VariableNameCV
            r += u'       NoDataValue: %d\n' % value.VariableObj.NoDataValue
            
            r += u'   Unit:\n'
            #r += u'       UnitID: %d\n' % value.UnitsObj.UnitsID
            r += u'       UnitsTypeCV: %s\n' % value.UnitsObj.UnitsTypeCV
            r += u'       UnitsAbbreviation: %s\n' % value.UnitsObj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % value.UnitsObj.UnitsName
            
            r += u'   ProcessingLevel:\n'
            #r += u'       ProcessingLevelID: %d\n' % value.ProcessingLevelObj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % value.ProcessingLevelObj.ProcessingLevelCode
            r += u'       Definition: "%s"\n' % value.ProcessingLevelObj.Definition
            r += u'       Explanation: "%s"\n' % value.ProcessingLevelObj.Explanation
            response.write(r)
            response.write('\n')

        return response