
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from collections import OrderedDict
import csv

from odm2service import Service
import pyaml
from negotiation import IgnoreClientContentNegotiation
from dict2xml import dict2xml as xmlify

from shapely import wkb,wkt
import binascii

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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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

        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
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
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "json".
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

        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()
        items = readConn.getSitesBySiteType(siteType)

        if items == None or len(items) == 0:
            return Response('"%s" is not existed.' % siteType,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def getWKTFromWKB(self,value):
        if value:
            binary = binascii.unhexlify(str(value))
            point = wkb.loads(binary)
            point = '{0}'.format(wkt.dumps(point))
            return point
        else:
            return None

    def json_format(self):

        allsites = OrderedDict()
        allsites['type'] = "FeatureCollection"
        features = []
        for site in self.items:
            sf_obj = site.SamplingFeatureObj
            sr_obj = site.SpatialReferenceObj

            feature = OrderedDict()
            feature['type'] = "Feature"

            geometry = OrderedDict()
            geometry['type'] = "Point"
            coord = []
            coord.append(site.Longitude)
            coord.append(site.Latitude)
            geometry['coordinates'] = coord

            feature['geometry'] = geometry

            one_site = OrderedDict()
            one_site['SiteTypeCV'] = site.SiteTypeCV
            queryset = OrderedDict()
            queryset['SamplingFeatureUUID'] = sf_obj.SamplingFeatureUUID
            queryset['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            queryset['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            queryset['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            queryset['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            queryset['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            queryset['Elevation_m'] = sf_obj.Elevation_m
            queryset['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            queryset['FeatureGeometry'] = self.getWKTFromWKB(sf_obj.FeatureGeometry)
            one_site['SamplingFeature'] = queryset

            sr = OrderedDict()
            sr['SRSCode'] = sr_obj.SRSCode
            sr['SRSName'] = sr_obj.SRSName
            sr['SRSDescription'] = sr_obj.SRSDescription
            sr['SRSLink'] = sr_obj.SRSLink
            one_site['SpatialReference'] = sr


            feature['properties'] = one_site
            features.append(feature)

        allsites['features'] = features

        self._session.close()
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
            sf_obj = site.SamplingFeatureObj
            sr_obj = site.SpatialReferenceObj

            row.append(sf_obj.SamplingFeatureTypeCV)
            row.append(sf_obj.SamplingFeatureCode)
            sf_name = u'%s' % sf_obj.SamplingFeatureName
            row.append(sf_name.encode("utf-8"))
            row.append(sf_obj.SamplingFeatureDescription)
            row.append(sf_obj.SamplingFeatureGeotypeCV)
            row.append(self.getWKTFromWKB(sf_obj.FeatureGeometry))
            row.append(sf_obj.Elevation_m)
            row.append(sf_obj.ElevationDatumCV)
            row.append(site.SiteTypeCV)
            row.append(site.Latitude)
            row.append(site.Longitude)
            row.append(sr_obj.SpatialReferenceID)
            row.append(sr_obj.SRSCode)
            row.append(sr_obj.SRSDescription)
            row.append(sr_obj.SRSName)
            
            writer.writerow(row)
            #writer.writerow([s.encode("utf-8") for s in row])
            
        self._session.close()
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

            sf_obj = site.SamplingFeatureObj
            sr_obj = site.SpatialReferenceObj

            st = OrderedDict()
            st['SamplingFeatureID'] = "*SamplingFeatureID%03d" % site.SamplingFeatureID
            st['SiteTypeCV'] = site.SiteTypeCV
            st['Longitude'] = site.Longitude
            st['Latitude'] = site.Latitude
            st['LatLonDatumID'] = "*SRSID%03d" % sr_obj.SpatialReferenceID
            sts.append(st)

            sr = OrderedDict()
            sr['SpatialReference'] = "&SRSID%03d" % sr_obj.SpatialReferenceID
            sr['SpatialReferenceID'] = sr_obj.SpatialReferenceID
            sr['SRSCode'] = sr_obj.SRSCode
            sr['SRSDescription'] = sr_obj.SRSDescription
            sr['SRSName'] = sr_obj.SRSName
            srs.append(sr)
            srs = [i for n, i in enumerate(srs) if i not in srs[n + 1:]]

            sf = OrderedDict()
            sf['SamplingFeature'] = "&SamplingFeatureID%03d" % sf_obj.SamplingFeatureID
            sf['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            sf['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            sf['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            sf['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            sf['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            sf['FeatureGeometry'] = self.getWKTFromWKB(sf_obj.FeatureGeometry)
            sf['Elevation_m'] = sf_obj.Elevation_m
            sf['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            sfs.append(sf)
            sfs = [i for n, i in enumerate(sfs) if i not in sfs[n + 1:]]

        allsites["Sites"] = sts
        allsites["SpatialReferences"] = srs
        allsites["SamplingFeatures"] = sfs

        response.write(pyaml.dump(allsites,vspacing=[1, 0]))

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="sites.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        allsites = {}

        sts = []
        for site in self.items:

            sf_obj = site.SamplingFeatureObj
            sr_obj = site.SpatialReferenceObj

            st = {}
            st['SiteTypeCV'] = site.SiteTypeCV
            st['Longitude'] = site.Longitude
            st['Latitude'] = site.Latitude

            sr = {}
            sr['SRSCode'] = sr_obj.SRSCode
            sr['SRSDescription'] = sr_obj.SRSDescription
            sr['SRSName'] = sr_obj.SRSName
            st['SpatialReference'] = sr

            sf = {}
            sf['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            sf['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            sf['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            sf['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            sf['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            sf['FeatureGeometry'] = self.getWKTFromWKB(sf_obj.FeatureGeometry)
            sf['Elevation_m'] = sf_obj.Elevation_m
            sf['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            st['SamplingFeature'] = sf

            sts.append(st)

        response.write(xmlify({'Site': sts}, wrap="Sites", indent="  "))
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
