import sys
sys.path.append('ODM2PythonAPI')

#from rest_framework import viewsets
from odm2rest.serializers import DummySerializer
from odm2rest.serializers import Odm2JsonSerializer

from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer

# Create your views here.

from django.http import Http404
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from rest_framework import viewsets
import json
from collections import OrderedDict

import csv,cStringIO

from odm2rest.odm2service import Service
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_xml.renderers import XMLRenderer
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework.renderers import BrowsableAPIRenderer
import yaml, pyaml
from negotiation import IgnoreClientContentNegotiation

class SiteViewSet(APIView):
    """
    All ODM2 sites Retrieval
    """

    #queryset = Snippet.objects.all()
    #serializer_class = SnippetModelSerializer

    #queryset = Snippet.objects.all()
    ##serializer_class = DummySerializer
    content_negotiation_class = IgnoreClientContentNegotiation
    ##renderer_classes = (XMLRenderer, JSONRenderer, CSVRenderer, YAMLRenderer, BrowsableAPIRenderer,)
    #renderer_classes = (CSVRenderer, )
    #parser_classes = (YAMLParser, XMLParser,)

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
        items = readConn.getAllSites()

        if items == None or len(items) == 0:
            return Response('All sites are not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class SiteSamplingFeatureCodeViewSet(APIView):
    """
    Site Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

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

        #samplingfeatureCode = request.QUERY_PARAMS.get('SamplingFeatureCode', None)
        if samplingfeatureCode is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getSiteBySFCode(samplingfeatureCode)

        if items == None:
            return Response('"%s" is not existed.' % samplingfeatureCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class SiteTypeViewSet(APIView):
    """
    Site Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, siteType=None):
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

        #samplingfeatureCode = request.QUERY_PARAMS.get('SamplingFeatureCode', None)
        if siteType is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getSitesBySiteType(siteType)

        if items == None or len(items) == 0:
            return Response('"%s" is not existed.' % siteType,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        allsites = OrderedDict()
        allsites['type'] = "FeatureCollection"
        features = []
        for site in self.items:
            feature = OrderedDict()
            feature['type'] = "Feature"

            geometry = OrderedDict()
            geometry['type'] = "Point"
            coord = []
            coord.append(site.Longitude)
            coord.append(site.Latitude)
            geometry['coordinates'] = coord

            feature['geometry'] = geometry

            queryset = OrderedDict()
            queryset['SiteTypeCV'] = site.SiteTypeCV
            queryset['SamplingFeatureID'] = site.SamplingFeatureObj.SamplingFeatureID
            queryset['SamplingFeatureTypeCV'] = site.SamplingFeatureObj.SamplingFeatureTypeCV
            queryset['SamplingFeatureCode'] = site.SamplingFeatureObj.SamplingFeatureCode
            queryset['SamplingFeatureName'] = site.SamplingFeatureObj.SamplingFeatureName
            queryset['SamplingFeatureDescription'] = site.SamplingFeatureObj.SamplingFeatureDescription
            queryset['SamplingFeatureGeotypeCV'] = site.SamplingFeatureObj.SamplingFeatureGeotypeCV
            queryset['Elevation_m'] = site.SamplingFeatureObj.Elevation_m
            queryset['ElevationDatumCV'] = site.SamplingFeatureObj.ElevationDatumCV

            feature['properties'] = queryset
            features.append(feature)

        allsites['features'] = features
        return allsites

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="sites.csv"'

        #fields=SamplingFeatureDescription[type="string"],SamplingFeatureGeotypeCV[type="string"],LatLonDatumID,SamplingFeatureName[type="string"],ElevationDatumCV[type="string"],elevation[unit="m"],SamplingFeatureTypeCV[type="string"],Longitude[unit="degrees"],SamplingFeatureCode[type="string"],Latitude[unit="degrees"],SamplingFeatureID,SiteTypeCV[type="string"]

        site_csv_header = ["#fields=SamplingFeatureTypeCV[type='string']","SamplingFeatureCode[type='string']","SamplingFeatureName[type='string']","SamplingFeatureDescription[type='string']","SamplingFeatureGeoTypeCV[type='string']","FeatureGeometry[type='string']","Elevation[unit='m']","ElevationDatumCV[type='string']","SiteTypeCV[type='string']","Latitude[unit='degrees']","Longitude[unit='degrees']","SpatialReferenceID","SRSCode[type='string']","SRSDescription[type='string']","SRSName[type='string']"]

        writer = csv.writer(response)
        writer.writerow(site_csv_header)
            
        for site in self.items:
            row = []
            row.append(site.SamplingFeatureObj.SamplingFeatureTypeCV)
            row.append(site.SamplingFeatureObj.SamplingFeatureCode)
            row.append(site.SamplingFeatureObj.SamplingFeatureName)
            row.append(site.SamplingFeatureObj.SamplingFeatureDescription)
            row.append(site.SamplingFeatureObj.SamplingFeatureGeotypeCV)
            row.append(site.SamplingFeatureObj.FeatureGeometry)
            row.append(site.SamplingFeatureObj.Elevation_m)
            row.append(site.SamplingFeatureObj.ElevationDatumCV)
            row.append(site.SiteTypeCV)
            row.append(site.Latitude)
            row.append(site.Longitude)
            row.append(site.SpatialReferenceObj.SpatialReferenceID)
            row.append(site.SpatialReferenceObj.SRSCode)
            row.append(site.SpatialReferenceObj.SRSDescription)
            row.append(site.SpatialReferenceObj.SRSName)
            
            writer.writerow(row)
            
        return response
        
    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="sites.yaml"'

        response.write("---\n")
        allsites = {}

        sts = []
        sfs = []
        srs = []

        for site in self.items:

            st = OrderedDict()
            st['SamplingFeatureID'] = "*SamplingFeatureID%03d" % site.SamplingFeatureID
            st['SiteTypeCV'] = site.SiteTypeCV
            st['Longitude'] = site.Longitude
            st['Latitude'] = site.Latitude
            st['LatLonDatumID'] = "*SRSID%03d" % site.SpatialReferenceObj.SpatialReferenceID
            sts.append(st)

            sr = OrderedDict()
            sr['SpatialReference'] = "&SRSID%03d" % site.SpatialReferenceObj.SpatialReferenceID
            sr['SpatialReferenceID'] = site.SpatialReferenceObj.SpatialReferenceID
            sr['SRSCode'] = site.SpatialReferenceObj.SRSCode
            sr['SRSDescription'] = site.SpatialReferenceObj.SRSDescription
            sr['SRSName'] = site.SpatialReferenceObj.SRSName
            srs.append(sr)
            srs = [i for n, i in enumerate(srs) if i not in srs[n + 1:]]

            sf = OrderedDict()
            sf['SamplingFeature'] = "&SamplingFeatureID%03d" % site.SamplingFeatureObj.SamplingFeatureID
            sf['SamplingFeatureTypeCV'] = site.SamplingFeatureObj.SamplingFeatureTypeCV
            sf['SamplingFeatureCode'] = site.SamplingFeatureObj.SamplingFeatureCode
            sf['SamplingFeatureName'] = site.SamplingFeatureObj.SamplingFeatureName
            sf['SamplingFeatureDescription'] = site.SamplingFeatureObj.SamplingFeatureDescription
            sf['SamplingFeatureGeotypeCV'] = site.SamplingFeatureObj.SamplingFeatureGeotypeCV
            sf['FeatureGeometry'] = site.SamplingFeatureObj.FeatureGeometry
            sf['Elevation_m'] = site.SamplingFeatureObj.Elevation_m
            sf['ElevationDatumCV'] = site.SamplingFeatureObj.ElevationDatumCV
            sfs.append(sf)
            sfs = [i for n, i in enumerate(sfs) if i not in sfs[n + 1:]]

        allsites["Sites"] = sts
        allsites["SpatialReferences"] = srs
        allsites["SamplingFeatures"] = sfs

        response.write(pyaml.dump(allsites,vspacing=[1, 0]))

        return response

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)
