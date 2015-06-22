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
from dict2xml import dict2xml as xmlify
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read

class SamplingfeatureViewSet(APIView):
    """
    All ODM2 samplingfeatures Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query
            - name: page
              description: the default page number is 0. 
              required: false
              type: integer
              paramType: query
            - name: page_size
              description: The default page size is 100 records.
              required: false
              type: integer
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        page = request.QUERY_PARAMS.get('page','0')
        page_size = request.QUERY_PARAMS.get('page_size','100')

        page = int(page)
        page_size = int(page_size)

        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getSamplingFeaturesByPage(page,page_size)

        if items == None or len(items) == 0:
            return Response('samplingfeatures are not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class SFCodeViewSet(APIView):
    """
    Samplingfeature Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

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

        #samplingfeatureCode = request.QUERY_PARAMS.get('SamplingFeatureCode', None)
        if samplingfeatureCode is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getSamplingFeatureBySFCode(samplingfeatureCode)

        if items == None:
            return Response('"%s" is not existed.' % samplingfeatureCode,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class SFTypeViewSet(APIView):
    """
    Samplingfeature Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, samplingfeatureType=None):
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

        #samplingfeatureCode = request.QUERY_PARAMS.get('SamplingFeatureCode', None)
        if samplingfeatureType is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        format = request.query_params.get('format', 'yaml')
        #accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getSamplingFeatureBySFType(samplingfeatureType)

        if items == None or len(items) == 0:
            return Response('"%s" is not existed.' % samplingfeatureType,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):

    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="samplingfeatures.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=SamplingFeatureUUID[type='string']","SamplingFeatureTypeCV[type='string']","SamplingFeatureCode[type='string']","SamplingFeatureName[type='string']","SamplingFeatureDescription[type='string']","SamplingFeatureGeotypeCV[type='string']","Elevation_m[unit='m']","ElevationDatumCV[type='string']","FeatureGeometry[type='string']"])
        item_csv_header.extend(["Site.SiteTypeCV[type='string']","Site.Latitude[unit='degrees']","Site.Longitude[unit='degrees']","Site.SpatialReference.SRSCode[type='string']","Site.SpatialReference.SRSName[type='string']","Site.SpatialReference.SRSDescription[type='string']","Site.SpatialReference.SRSLink[type='string']"])
        item_csv_header.extend(["Specimen.SpecimenTypeCV[type='string']","Specimen.SpecimenMediumCV[type='string']","Specimen.IsFieldSpecimen[type='boolean']"])
        item_csv_header.extend(["RelatedFeature.RelationshipTypeCV[type='string']","RelatedFeature.SamplingFeatureUUID[type='string']","RelatedFeature.SamplingFeatureTypeCV[type='string']","RelatedFeature.SamplingFeatureCode[type='string']","RelatedFeature.SamplingFeatureName[type='string']","RelatedFeature.SamplingFeatureDescription[type='string']","RelatedFeature.SamplingFeatureGeotypeCV[type='string']","RelatedFeature.Elevation_m[unit='m']","RelatedFeature.ElevationDatumCV[type='string']","RelatedFeature.FeatureGeometry[type='string']","RelatedFeature.Site.SiteTypeCV[type='string']","RelatedFeature.Site.Latitude[unit='degrees']","RelatedFeature.Site.Longitude[unit='degrees']","RelatedFeature.Site.SpatialReference.SRSCode[type='string']","RelatedFeature.Site.SpatialReference.SRSName[type='string']","RelatedFeature.Site.SpatialReference.SRSDescription[type='string']","RelatedFeature.Site.SpatialReference.SRSLink[type='string']"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
        conn = ODM2Read(self._session)
            
        for value in self.items:
            row = []

            row.append(value.SamplingFeatureUUID)
            row.append(value.SamplingFeatureTypeCV)
            row.append(value.SamplingFeatureCode)
            sf_name = u'%s' % value.SamplingFeatureName
            row.append(sf_name.encode("utf-8"))
            row.append(value.SamplingFeatureDescription)
            row.append(value.SamplingFeatureGeotypeCV)
            row.append(str(value.Elevation_m))
            row.append(value.ElevationDatumCV)
            row.append(value.FeatureGeometry)

            sfid = value.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                row.append(site.SiteTypeCV)
                row.append(site.Latitude)
                row.append(site.Longitude)
                sr_obj = site.SpatialReferenceObj
                row.append(sr_obj.SRSCode)
                row.append(sr_obj.SRSName)
                row.append(sr_obj.SRSDescription)
                row.append(sr_obj.SRSLink)
            else:
                for i in range(7):
                    row.append(None)

            specimen = conn.getSpecimenBySFID(sfid)
            if specimen != None:
                row.append(specimen.SpecimenTypeCV)
                row.append(specimen.SpecimenMediumCV)
                row.append(specimen.IsFieldSpecimen)
            else:
                for i in range(3):
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
                    #row1.append(rf_obj.SamplingFeatureName)
                    sf_name = u'%s' % rf_obj.SamplingFeatureName
                    row1.append(sf_name.encode("utf-8"))
                    row1.append(rf_obj.SamplingFeatureDescription)
                    row1.append(rf_obj.SamplingFeatureGeotypeCV)
                    row1.append(str(rf_obj.Elevation_m))
                    row1.append(rf_obj.ElevationDatumCV)
                    row1.append(rf_obj.FeatureGeometry)

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        row1.append(rsite.SiteTypeCV)
                        row1.append(rsite.Latitude)
                        row1.append(rsite.Longitude)
                        sr_obj = rsite.SpatialReferenceObj
                        row1.append(sr_obj.SRSCode)
                        row1.append(sr_obj.SRSName)
                        row1.append(sr_obj.SRSDescription)
                        row1.append(sr_obj.SRSLink)
                    else:
                        for i in range(7):
                            row1.append(None)
                    rf_list.append(row1)

            else:
                row1 = []
                for i in range(17):
                    row1.append(None)
                rf_list.append(row1)
            
            for i in rf_list:
                row.extend(i)
                writer.writerow(row)

        self._session.close()
        return response
        
    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="samplingfeatures.yaml"'

        response.write("---\n")
        response.write("SamplingFeatures:\n")
        conn = ODM2Read(self._session)

        for value in self.items:

            r = u' - SamplingFeatureUUID: %s\n' % value.SamplingFeatureUUID
            r += u'   SamplingFeatureTypeCV: %s\n' % value.SamplingFeatureTypeCV
            r += u'   SamplingFeatureCode: %s\n' % value.SamplingFeatureCode
            r += u'   SamplingFeatureName: "%s"\n' % value.SamplingFeatureName
            r += u'   SamplingFeatureDescription: "%s"\n' % value.SamplingFeatureDescription
            r += u'   SamplingFeatureGeotypeCV: "%s"\n' % value.SamplingFeatureGeotypeCV
            r += u'   Elevation_m: %s\n' % str(value.Elevation_m)
            r += u'   ElevationDatumCV: "%s"\n' % value.ElevationDatumCV
            r += u'   FeatureGeometry: "%s"\n' % value.FeatureGeometry

            sfid = value.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                r += u'   RelatedFeatures:\n'
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    r += u'       SamplingFeatureUUID: %s\n' % rf_obj.SamplingFeatureUUID
                    r += u'       SamplingFeatureTypeCV: %s\n' % rf_obj.SamplingFeatureTypeCV
                    r += u'       SamplingFeatureCode: %s\n' % rf_obj.SamplingFeatureCode
                    r += u'       SamplingFeatureName: "%s"\n' % rf_obj.SamplingFeatureName
                    r += u'       SamplingFeatureDescription: "%s"\n' % rf_obj.SamplingFeatureDescription
                    r += u'       SamplingFeatureGeotypeCV: "%s"\n' % rf_obj.SamplingFeatureGeotypeCV
                    r += u'       Elevation_m: %s\n' % str(rf_obj.Elevation_m)
                    r += u'       ElevationDatumCV: "%s"\n' % rf_obj.ElevationDatumCV
                    r += u'       FeatureGeometry: "%s"\n' % rf_obj.FeatureGeometry

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        r += u'       Site:\n'
                        r += u'           SiteTypeCV: %s\n' % rsite.SiteTypeCV
                        r += u'           Latitude: %f\n' % rsite.Latitude
                        r += u'           Longitude: %f\n' % rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        r += u'           SpatialReference:\n'
                        #r += u'                   SRSID: %d\n' % sr_obj.SpatialReferenceID
                        r += u'               SRSCode: "%s"\n' % sr_obj.SRSCode
                        r += u'               SRSName: %s\n' % sr_obj.SRSName
                        r += u'               SRSDescription: %s\n' % sr_obj.SRSDescription
                        r += u'               SRSLink: %s\n' % sr_obj.SRSLink

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
                r += u'           SRSDescription: %s\n' % sr_obj.SRSDescription
                r += u'           SRSLink: %s\n' % sr_obj.SRSLink

            specimen = conn.getSpecimenBySFID(sfid)
            if specimen != None:
                r += u'   Specimen:\n'
                r += u'       SpecimenTypeCV: %s\n' % specimen.SpecimenTypeCV
                r += u'       SpecimenMediumCV: %s\n' % specimen.SpecimenMediumCV
                r += u'       IsFieldSpecimen: %s\n' % str(specimen.IsFieldSpecimen)

            response.write(r)
            response.write('\n')

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="sites.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        sfs = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'SamplingFeature': sfs}, wrap="SamplingFeatures", indent="  "))
        self._session.close()
        return response

    def sqlalchemy_object_to_dict(self):

        sfs = []
        conn = ODM2Read(self._session)

        for value in self.items:

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = value.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = value.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = value.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = value.SamplingFeatureName
            samplingfeature['SamplingFeatureDescription'] = value.SamplingFeatureDescription
            samplingfeature['SamplingFeatureGeotypeCV'] = value.SamplingFeatureGeotypeCV
            samplingfeature['Elevation_m'] = str(value.Elevation_m)
            samplingfeature['ElevationDatumCV'] = value.ElevationDatumCV
            samplingfeature['FeatureGeometry'] = value.FeatureGeometry

            sfid = value.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                rfeatures = []
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    rf = {}
                    rf['RelationshipTypeCV'] = x.RelationshipTypeCV
                    rf['SamplingFeatureUUID'] = rf_obj.SamplingFeatureUUID
                    rf['SamplingFeatureTypeCV'] = rf_obj.SamplingFeatureTypeCV
                    rf['SamplingFeatureCode'] = rf_obj.SamplingFeatureCode
                    rf['SamplingFeatureName'] = rf_obj.SamplingFeatureName
                    rf['SamplingFeatureDescription'] = rf_obj.SamplingFeatureDescription
                    rf['SamplingFeatureGeotypeCV'] = rf_obj.SamplingFeatureGeotypeCV
                    rf['Elevation_m'] = str(rf_obj.Elevation_m)
                    rf['ElevationDatumCV'] = rf_obj.ElevationDatumCV
                    rf['FeatureGeometry'] = rf_obj.FeatureGeometry

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        rs = {}
                        rs['SiteTypeCV'] = rsite.SiteTypeCV
                        rs['Latitude'] = rsite.Latitude
                        rs['Longitude'] = rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        rsr = {}
                        rsr['SRSCode'] = sr_obj.SRSCode
                        rsr['SRSName'] = sr_obj.SRSName
                        rsr['SRSDescription'] = sr_obj.SRSDescription
                        rsr['SRSLink'] = sr_obj.SRSLink
                        rs['SpatialReference'] = rsr
                        rf['Site'] = rs
                    rfeatures.append(rf)

                samplingfeature['RelatedFeatures'] = rfeatures

            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr_obj = site.SpatialReferenceObj
                sr = {}
                sr['SRSCode'] = sr_obj.SRSCode
                sr['SRSName'] = sr_obj.SRSName
                sr['SRSDescription'] = sr_obj.SRSDescription
                sr['SRSLink'] = sr_obj.SRSLink
                s['SpatialReference'] = sr
                samplingfeature['Site'] = s

            specimen = conn.getSpecimenBySFID(sfid)
            if specimen != None:
                s = {}
                s['SpecimenTypeCV'] = specimen.SpecimenTypeCV
                s['SpecimenMediumCV'] = specimen.SpecimenMediumCV
                s['IsFieldSpecimen'] = specimen.IsFieldSpecimen
                samplingfeature['Specimen'] = s

            sfs.append(samplingfeature)

        self._session.close()
        return sfs

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)
