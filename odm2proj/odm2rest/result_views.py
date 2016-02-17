
from django.http import HttpResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
import csv

from odm2service import Service
from negotiation import IgnoreClientContentNegotiation
from datetime import datetime, timedelta
from ODM2ALLServices import odm2Service as ODM2Read
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
        omit_serializer: true
    
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
              required: false
              type: string
              paramType: query
            - name: page
              description: the default page number is 0. 
              required: false
              type: integer
              paramType: query
            - name: page_size
              description: The default page size is 50 records.
              required: false
              type: integer
              paramType: query

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        #accept = request.accepted_renderer.media_type
        page = request.QUERY_PARAMS.get('page','0')
        page_size = request.QUERY_PARAMS.get('page_size','50')

        page = int(page)
        page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getResultsByPage(page, page_size)
        #items = readConn.getResults()
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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
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
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getResultsByBBoxForSite(west, south, east, north)
        #items = readConn.getResultsByBBoxForSamplingfeature(west, south, east, north)
        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class ResultsActionDateViewSet(APIView):
    """
    All ODM2 Result records Retrieval based on the begin date in "Actions" table.

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
              required: false
              type: string
              paramType: query
            - name: startDate    
              description: ISO date, for example, 1983-01-17.
              required: true
              type: datetime
              paramType: query
            - name: endDate    
              description: ISO date, for example, 1983-01-18.
              required: true
              type: datetime
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

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
        format = request.query_params.get('format', mr.default_format)
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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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

        #accept = request.accepted_renderer.media_type
        #page = request.QUERY_PARAMS.get('page','0')
        #page_size = request.QUERY_PARAMS.get('page_size','10')

        #page = int(page)
        #page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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
              description: ISO date, for example, 2015-04-28 (the begin date time in "actions" table).
              required: true
              type: datetime
              paramType: query
            - name: endDate    
              description: ISO date, for example, 2015-04-29 (the begin date time in "actions" table).
              required: true
              type: datetime
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

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
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getResultsByResultTypeCVByBBoxByDate(rTypeCV, west, south, east, north, beginDate, endDate)

        if items == None or len(items) == 0:
            return Response('There are no available data.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):
        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="results.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=Result.ResultID","Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount"])
        item_csv_header.extend(["SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.SamplingFeatureDescription[type='string']","SamplingFeature.SamplingFeatureGeotypeCV[type='string']","SamplingFeature.Elevation_m[unit='m']","SamplingFeature.ElevationDatumCV[type='string']","SamplingFeature.FeatureGeometry[type='string']"])
        item_csv_header.extend(["Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']"])
        item_csv_header.extend(["Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"])
        item_csv_header.extend(["Site.SiteTypeCV[type='string']","Site.Latitude[unit='degrees']","Site.Longitude[unit='degrees']","Site.SpatialReference.SRSCode[type='string']","Site.SpatialReference.SRSName[type='string']"])
        item_csv_header.extend(["RelatedFeature.RelationshipTypeCV[type='string']","RelatedFeature.SamplingFeatureUUID[type='string']","RelatedFeature.SamplingFeatureTypeCV[type='string']","RelatedFeature.SamplingFeatureCode[type='string']","RelatedFeature.SamplingFeatureName[type='string']","RelatedFeature.SamplingFeatureDescription[type='string']","RelatedFeature.SamplingFeatureGeotypeCV[type='string']","RelatedFeature.Elevation_m[unit='m']","RelatedFeature.ElevationDatumCV[type='string']","RelatedFeature.FeatureGeometry[type='string']","RelatedFeature.Site.SiteTypeCV[type='string']","RelatedFeature.Site.Latitude[unit='degrees']","RelatedFeature.Site.Longitude[unit='degrees']","RelatedFeature.Site.SpatialReference.SRSCode[type='string']","RelatedFeature.Site.SpatialReference.SRSName[type='string']"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
        conn = ODM2Read(self._session)
            
        for value in self.items:
            row = []
            sf_obj = value.FeatureActionObj.SamplingFeatureObj
            a_obj = value.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = value.VariableObj
            u_obj = value.UnitsObj
            p_obj = value.ProcessingLevelObj

            row.append(value.ResultID)
            row.append(value.ResultUUID)
            row.append(value.ResultTypeCV)
            row.append(value.ResultDateTime)
            row.append(value.ResultDateTimeUTCOffset)
            row.append(value.StatusCV)
            row.append(value.SampledMediumCV)
            row.append(value.ValueCount)

            row.append(sf_obj.SamplingFeatureUUID)
            row.append(sf_obj.SamplingFeatureTypeCV)
            row.append(sf_obj.SamplingFeatureCode)
            sf_name = u'%s' % sf_obj.SamplingFeatureName
            row.append(sf_name.encode("utf-8"))
            row.append(sf_obj.SamplingFeatureDescription)
            row.append(sf_obj.SamplingFeatureGeotypeCV)
            row.append(str(sf_obj.Elevation_m))
            row.append(sf_obj.ElevationDatumCV)
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            row.append(fg)

            row.append(a_obj.ActionTypeCV)
            row.append(a_obj.BeginDateTime)
            row.append(a_obj.BeginDateTimeUTCOffset)
            row.append(a_obj.EndDateTime)
            row.append(a_obj.EndDateTimeUTCOffset)

            row.append(m_obj.MethodTypeCV)
            row.append(m_obj.MethodCode)
            row.append(m_obj.MethodName)

            row.append(v_obj.VariableTypeCV)
            row.append(v_obj.VariableCode)
            row.append(v_obj.VariableNameCV)
            row.append(v_obj.NoDataValue)

            row.append(u_obj.UnitsTypeCV)
            row.append(u_obj.UnitsAbbreviation)
            row.append(u_obj.UnitsName)
                    
            row.append(p_obj.ProcessingLevelCode)
            row.append(p_obj.Definition)
            row.append(p_obj.Explanation)

            sfid = sf_obj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                row.append(site.SiteTypeCV)
                row.append(site.Latitude)
                row.append(site.Longitude)
                sr_obj = site.SpatialReferenceObj
                row.append(sr_obj.SRSCode)
                row.append(sr_obj.SRSName)
            else:
                for i in range(5):
                    row.append(None)

            rf_list = []
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                for x in rfeature:
                    row1 = []
                    rf_obj = x.RelatedFeatureObj
                    row1.append(x.RelationshipTypeCV)
                    row1.append(rf_obj.SamplingFeatureUUID)
                    row1.append(rf_obj.SamplingFeatureTypeCV)
                    row1.append(rf_obj.SamplingFeatureCode)
                    sf_name = u'%s' % rf_obj.SamplingFeatureName
                    row1.append(sf_name.encode("utf-8"))
                    row1.append(rf_obj.SamplingFeatureDescription)
                    row1.append(rf_obj.SamplingFeatureGeotypeCV)
                    row1.append(str(rf_obj.Elevation_m))
                    row1.append(rf_obj.ElevationDatumCV)
                    fg = None
                    if rf_obj.FeatureGeometry is not None:
                        fg = rf_obj.shape().wkt
                    row1.append(fg)

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        row1.append(rsite.SiteTypeCV)
                        row1.append(rsite.Latitude)
                        row1.append(rsite.Longitude)
                        sr_obj = rsite.SpatialReferenceObj
                        row1.append(sr_obj.SRSCode)
                        row1.append(sr_obj.SRSName)
                    else:
                        for i in range(5):
                            row1.append(None)
                    rf_list.append(row1)

            else:
                row1 = []
                for i in range(15):
                    row1.append(None)
                rf_list.append(row1)
            
            for i in rf_list:
                row.extend(i)
                writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="results.yaml"'

        response.write("---\n")
        response.write("Results:\n")
        conn = ODM2Read(self._session)

        for value in self.items:

            sf_obj = value.FeatureActionObj.SamplingFeatureObj
            a_obj = value.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = value.VariableObj
            u_obj = value.UnitsObj
            p_obj = value.ProcessingLevelObj

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
            #r += u'           SamplingFeatureID: %d\n' % sf_obj.SamplingFeatureID
            r += u'           SamplingFeatureUUID: %s\n' % sf_obj.SamplingFeatureUUID
            r += u'           SamplingFeatureTypeCV: %s\n' % sf_obj.SamplingFeatureTypeCV
            r += u'           SamplingFeatureCode: %s\n' % sf_obj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % sf_obj.SamplingFeatureName
            r += u'           SamplingFeatureDescription: "%s"\n' % sf_obj.SamplingFeatureDescription
            r += u'           SamplingFeatureGeotypeCV: "%s"\n' % sf_obj.SamplingFeatureGeotypeCV
            r += u'           Elevation_m: %s\n' % str(sf_obj.Elevation_m)
            r += u'           ElevationDatumCV: "%s"\n' % sf_obj.ElevationDatumCV
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            r += u'           FeatureGeometry: "%s"\n' % fg

            r += u'       Action:\n'
            #r += u'          ActionID: %d\n' % a_obj.ActionID
            r += u'           ActionTypeCV: "%s"\n' % a_obj.ActionTypeCV
            r += u'           BeginDateTime: "%s"\n' % str(a_obj.BeginDateTime)
            r += u'           BeginDateTimeUTCOffset: %s\n' % str(a_obj.BeginDateTimeUTCOffset)
            r += u'           EndDateTime: "%s"\n' % str(a_obj.EndDateTime)
            r += u'           EndDateTimeUTCOffset: %s\n' % str(a_obj.EndDateTimeUTCOffset)
            r += u'           Method:\n'
            #r += u'              MethodID: %d\n' % m_obj.MethodID
            r += u'               MethodTypeCV: %s\n' % m_obj.MethodTypeCV
            r += u'               MethodCode: %s\n' % m_obj.MethodCode
            r += u'               MethodName: %s\n' % m_obj.MethodName

            raction = conn.getRelatedActionsByActionID(a_obj.ActionID)
            if raction != None and len(raction) > 0:
                r += u'   RelatedActions:\n'
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj

                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    r += u'       BeginDateTime: "%s"\n' % str(ra_obj.BeginDateTime)
                    r += u'       BeginDateTimeUTCOffset: %s\n' % str(ra_obj.BeginDateTimeUTCOffset)
                    r += u'       EndDateTime: "%s"\n' % str(ra_obj.EndDateTime)
                    r += u'       EndDateTimeUTCOffset: %s\n' % str(ra_obj.EndDateTimeUTCOffset)
                    r += u'       Method:\n'
                    r += u'           MethodTypeCV: %s\n' % m_obj.MethodTypeCV
                    r += u'           MethodCode: %s\n' % ram_obj.MethodCode
                    r += u'           MethodName: %s\n' % ram_obj.MethodName

            sfid = sf_obj.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                r += u'   RelatedFeatures:\n'
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    #r += u'       SamplingFeatureID: %d\n' % rf_obj.SamplingFeatureID
                    r += u'       SamplingFeatureUUID: %s\n' % rf_obj.SamplingFeatureUUID
                    r += u'       SamplingFeatureTypeCV: %s\n' % rf_obj.SamplingFeatureTypeCV
                    r += u'       SamplingFeatureCode: %s\n' % rf_obj.SamplingFeatureCode
                    r += u'       SamplingFeatureName: "%s"\n' % rf_obj.SamplingFeatureName
                    r += u'       SamplingFeatureDescription: "%s"\n' % rf_obj.SamplingFeatureDescription
                    r += u'       SamplingFeatureGeotypeCV: "%s"\n' % rf_obj.SamplingFeatureGeotypeCV
                    r += u'       Elevation_m: %s\n' % str(rf_obj.Elevation_m)
                    r += u'       ElevationDatumCV: "%s"\n' % rf_obj.ElevationDatumCV
                    fg = None
                    if rf_obj.FeatureGeometry is not None:
                        fg = rf_obj.shape().wkt
                    r += u'       FeatureGeometry: "%s"\n' % fg

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        r += u'       Site:\n'
                        r += u'           SiteTypeCV: %s\n' % rsite.SiteTypeCV
                        r += u'           Latitude: %f\n' % rsite.Latitude
                        r += u'           Longitude: %f\n' % rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        r += u'           SpatialReference:\n'
                        #r += u'               SRSID: %d\n' % sr_obj.SpatialReferenceID
                        r += u'               SRSCode: "%s"\n' % sr_obj.SRSCode
                        r += u'               SRSName: %s\n' % sr_obj.SRSName

            site = conn.getSiteBySFId(sfid)
            if site != None:
                r += u'   Site:\n'
                r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                r += u'       Latitude: %f\n' % site.Latitude
                r += u'       Longitude: %f\n' % site.Longitude
                sr_obj = site.SpatialReferenceObj
                r += u'       SpatialReference:\n'
                #r += u'           SRSID: %d\n' % sr_obj.SpatialReferenceID
                r += u'           SRSCode: "%s"\n' % sr_obj.SRSCode
                r += u'           SRSName: %s\n' % sr_obj.SRSName

            r += u'   Variable:\n'
            #r += u'       VariableID: %d\n' % v_obj.VariableID
            r += u'       VariableTypeCV: %s\n' % v_obj.VariableTypeCV
            r += u'       VariableCode: %s\n' % v_obj.VariableCode
            r += u'       VariableNameCV: %s\n' % v_obj.VariableNameCV
            r += u'       NoDataValue: %d\n' % v_obj.NoDataValue
            
            r += u'   Unit:\n'
            #r += u'       UnitID: %d\n' % u_obj.UnitsID
            r += u'       UnitsTypeCV: %s\n' % u_obj.UnitsTypeCV
            r += u'       UnitsAbbreviation: %s\n' % u_obj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % u_obj.UnitsName
            
            r += u'   ProcessingLevel:\n'
            #r += u'       ProcessingLevelID: %d\n' % p_obj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % p_obj.ProcessingLevelCode
            r += u'       Definition: "%s"\n' % p_obj.Definition
            r += u'       Explanation: "%s"\n' % p_obj.Explanation
            response.write(r)
            response.write('\n')

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="results.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        results = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'Result':results}, wrap="Results", indent="  "))
        
        return response


    def sqlalchemy_object_to_dict(self):

        results = []
        conn = ODM2Read(self._session)

        for value in self.items:
            sf_obj = value.FeatureActionObj.SamplingFeatureObj
            a_obj = value.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            o_obj = m_obj.OrganizationObj
            v_obj = value.VariableObj
            u_obj = value.UnitsObj
            p_obj = value.ProcessingLevelObj
            t_obj = value.TaxonomicClassifierObj

            result = {}
            result['ResultUUID'] = value.ResultUUID
            result['ResultTypeCV'] = value.ResultTypeCV
            result['ResultDateTime'] = str(value.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = value.ResultDateTimeUTCOffset
            result['StatusCV'] = value.StatusCV
            result['SampledMediumCV'] = value.SampledMediumCV
            result['ValueCount'] = value.ValueCount

            dsresult = conn.getDataSetResultsByResultID(value.ResultID)
            if dsresult != None and len(dsresult) > 0:
                dsrs = []
                for x in dsresult:
                    ds_obj = x.DataSetObj
                    ds = {}
                    ds["DataSetUUID"] = str(ds_obj.DataSetUUID)
                    ds["DataSetTypeCV"] = ds_obj.DataSetTypeCV
                    ds["DataSetCode"] = ds_obj.DataSetCode
                    ds["DataSetTitle"] = ds_obj.DataSetTitle
                    ds["DataSetAbstract"] = ds_obj.DataSetAbstract
                    dsrs.append(ds)
                result['DataSetsResults'] = dsrs

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = sf_obj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            samplingfeature['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            samplingfeature['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            samplingfeature['Elevation_m'] = sf_obj.Elevation_m
            samplingfeature['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            samplingfeature['FeatureGeometry'] = fg

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

            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            varone = {}
            varone['VariableCode'] = v_obj.VariableCode
            varone['VariableTypeCV'] = v_obj.VariableTypeCV
            varone['VariableNameCV'] = v_obj.VariableNameCV
            varone['VariableDefinition'] = v_obj.VariableDefinition
            varone['NoDataValue'] = v_obj.NoDataValue
            varone['Speciation'] = v_obj.SpeciationCV
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = u_obj.UnitsTypeCV
            unit['UnitsAbbreviation'] = u_obj.UnitsAbbreviation
            unit['UnitsName'] = u_obj.UnitsName
            unit['UnitsLink'] = u_obj.UnitsLink
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = p_obj.ProcessingLevelCode
            pl['Definition'] = p_obj.Definition
            pl['Explanation'] = p_obj.Explanation
            result['ProcessingLevel'] = pl

            if t_obj != None:
                tc = {}
                tc['TaxonomicClassifierTypeCV'] = t_obj.TaxonomicClassifierTypeCV
                tc['TaxonomicClassifierName'] = t_obj.TaxonomicClassifierName
                tc['TaxonomicClassifierCommonName'] = t_obj.TaxonomicClassifierCommonName
                tc['TaxonomicClassifierDescription'] = t_obj.TaxonomicClassifierDescription
                tc['ParentTaxonomicClassifierID'] = t_obj.ParentTaxonomicClassifierID
                result['TaxonomicClassifier'] = tc

            results.append(result)

        self._session.close()
        return results
