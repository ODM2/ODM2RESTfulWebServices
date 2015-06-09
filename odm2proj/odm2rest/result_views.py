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
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read
from dict2xml import dict2xml as xmlify

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
        page = request.QUERY_PARAMS.get('page','0')
        page_size = request.QUERY_PARAMS.get('page_size','10')

        page = int(page)
        page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        #items = readConn.getResultsByPage(page, page_size)
        items = readConn.getResults()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

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

        return mr.content_format(items, format)

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

        return mr.content_format(items, format)

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

        return mr.content_format(items, format)

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
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
              description: maxx, longitude, for example, -110.0.
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
        items = readConn.getResultsByBBoxForSite(west, south, east, north)
        #items = readConn.getResultsByBBoxForSamplingfeature(west, south, east, north)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
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

        return mr.content_format(items, format)

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query
            - name: resultType    
              description: For example, "Time series coverage", "Measurement".
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

        return mr.content_format(items, format)

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query
            - name: resultType    
              description: For example, "Time series coverage", "Measurement".
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
              description: maxx, longitude, for example, -110.0.
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

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        results = []
        for value in self.items:

            result = {}
            result['ResultUUID'] = value.ResultUUID
            result['ResultTypeCV'] = value.ResultTypeCV
            result['ResultDateTime'] = str(value.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.StatusCV
            result['SampledMediumCV'] = value.SampledMediumCV
            result['ValueCount'] = value.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method
            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            conn = ODM2Read(self._session)
            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr = {}
                sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                sr['SRSName'] = site.SpatialReferenceObj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = value.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.VariableObj.VariableCode
            varone['VariableNameCV'] = value.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.ProcessingLevelObj.Definition
            pl['Explanation'] = value.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            results.append(result)

        self._session.close()
        return results

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="results.csv"'

        item_csv_header = ["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount","SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.Elevation_m","Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']","Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
            
        for value in self.items:
            row = []

            row.append(value.ResultID)
            row.append(value.ResultUUID)
            row.append(value.ResultTypeCV)
            row.append(value.ResultDateTime)
            row.append(value.ResultDateTimeUTCOffset)
            row.append(value.StatusCV)
            row.append(value.SampledMediumCV)
            row.append(value.ValueCount)

            row.append(value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID)
            row.append(value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV)
            row.append(value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode)
            row.append(value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName)
            row.append(value.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            row.append(value.FeatureActionObj.ActionObj.ActionTypeCV)
            row.append(value.FeatureActionObj.ActionObj.BeginDateTime)
            row.append(value.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset)
            row.append(value.FeatureActionObj.ActionObj.EndDateTime)
            row.append(value.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)

            row.append(value.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV)
            row.append(value.FeatureActionObj.ActionObj.MethodObj.MethodCode)
            row.append(value.FeatureActionObj.ActionObj.MethodObj.MethodName)

            row.append(value.VariableObj.VariableTypeCV)
            row.append(value.VariableObj.VariableCode)
            row.append(value.VariableObj.VariableNameCV)
            row.append(value.VariableObj.NoDataValue)

            row.append(value.UnitsObj.UnitsTypeCV)
            row.append(value.UnitsObj.UnitsAbbreviation)
            row.append(value.UnitsObj.UnitsName)

            row.append(value.ProcessingLevelObj.ProcessingLevelCode)
            row.append(value.ProcessingLevelObj.Definition)
            row.append(value.ProcessingLevelObj.Explanation)

            writer.writerow(row)

        self._session.close()
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
            conn = ODM2Read(self._session)
            site = conn.getSiteBySFId(sfid)
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

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="results.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        results = []
        for value in self.items:

            result = {}
            result['ResultUUID'] = value.ResultUUID
            result['ResultTypeCV'] = value.ResultTypeCV
            result['ResultDateTime'] = str(value.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(value.ResultDateTimeUTCOffset)
            result['StatusCV'] = value.StatusCV
            result['SampledMediumCV'] = value.SampledMediumCV
            result['ValueCount'] = value.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureName
            samplingfeature['Elevation_m'] = str(value.FeatureActionObj.SamplingFeatureObj.Elevation_m)

            action = {}
            action['ActionTypeCV'] = value.FeatureActionObj.ActionObj.ActionTypeCV
            action['BeginDateTime'] = str(value.FeatureActionObj.ActionObj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = value.FeatureActionObj.ActionObj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(value.FeatureActionObj.ActionObj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(value.FeatureActionObj.ActionObj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = value.FeatureActionObj.ActionObj.MethodObj.MethodTypeCV
            method['MethodCode'] = value.FeatureActionObj.ActionObj.MethodObj.MethodCode
            method['MethodName'] = value.FeatureActionObj.ActionObj.MethodObj.MethodName
            action['Method'] = method
            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            sfid = value.FeatureActionObj.SamplingFeatureObj.SamplingFeatureID
            conn = ODM2Read(self._session)
            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr = {}
                sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
                sr['SRSName'] = site.SpatialReferenceObj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = value.VariableObj.VariableTypeCV
            varone['VariableCode'] = value.VariableObj.VariableCode
            varone['VariableNameCV'] = value.VariableObj.VariableNameCV
            varone['NoDataValue'] = value.VariableObj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = value.UnitsObj.UnitsTypeCV
            unit['UnitsAbbreviation'] = value.UnitsObj.UnitsAbbreviation
            unit['UnitsName'] = value.UnitsObj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = value.ProcessingLevelObj.ProcessingLevelCode
            pl['Definition'] = value.ProcessingLevelObj.Definition
            pl['Explanation'] = value.ProcessingLevelObj.Explanation
            result['ProcessingLevel'] = pl

            results.append(result)

        response.write(xmlify({'Result':results}, wrap="Results", indent="  "))
        
        self._session.close()
        return response
