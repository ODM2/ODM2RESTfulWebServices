# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from rest_framework.renderers import (JSONRenderer, CoreJSONRenderer)
from rest_framework.parsers import JSONParser
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_yaml.parsers import YAMLParser
from rest_framework.views import APIView
from rest_framework.response import Response

from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.schemas import SchemaGenerator
from rest_framework.views import APIView
from rest_framework_swagger import renderers

from core import (
    get_affiliations,
    get_people,
    get_results,
    get_samplingfeatures
)

from serializers import (
    AffiliationSerializer,
    PeopleSerializer,
    ResultSerializer,
    SamplingFeatureSerializer
)


class AffiliationsViewSet(APIView):
    """
    All ODM2 affiliations retrieval
    """

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)
    parser_classes =  (JSONParser, YAMLParser,)

    def get(self, request, affiliationID=None, firstName=None, lastName=None, organizationCode=None, format=None):
        get_kwargs = {
            'affiliationID': affiliationID,
            'firstName': firstName,
            'lastName': lastName,
            'organizationCode': organizationCode
        }
        print(self.kwargs)
        affiliations = get_affiliations(**get_kwargs)
        serialized = AffiliationSerializer(affiliations, many=True)

        if len(affiliations) == 1:
            serialized = AffiliationSerializer(affiliations[0])

        return Response(serialized.data)


class PeopleViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'peopleID': request.query_params.get('peopleID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName')
        }
        people = get_people(**get_kwargs)
        serialized = PeopleSerializer(people, many=True)

        if len(people) == 1:
            serialized = PeopleSerializer(people[0])

        return Response(serialized.data)


class ResultsViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'resultID': request.query_params.get('resultID'),
            'resultUUID': request.query_params.get('resultUUID'),
            'resultType': request.query_params.get('resultType'),
            'actionID': request.query_params.get('actionID'),
            'samplingFeatureID': request.query_params.get('samplingFeatureID'),
            'siteID': request.query_params.get('siteID'),
            'variableID': request.query_params.get('variableID'),
            'simulationID': request.query_params.get('simulationID')
        }

        results = get_results(**get_kwargs)
        serialized = ResultSerializer(results, many=True)

        if len(results) == 1:
            serialized = ResultSerializer(results[0])
        return Response(serialized.data)


class SamplingFeaturesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        results = get_samplingfeatures()
        serialized = SamplingFeatureSerializer(results, many=True)

        if len(results) == 1:
            serialized = SamplingFeatureSerializer(results[0])

        return Response(serialized.data)

