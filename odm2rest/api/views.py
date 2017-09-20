# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from rest_framework.renderers import JSONRenderer, CoreJSONRenderer
from rest_framework_yaml.renderers import YAMLRenderer
from rest_framework_csv.renderers import CSVRenderer
from rest_framework.views import APIView
from rest_framework.response import Response

from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework.schemas import SchemaGenerator
from rest_framework.views import APIView
from rest_framework_swagger import renderers
from schema import SCHEMA

from core import (
    get_affiliations,
    get_people,
    get_results
)

from serializers import (
    AffiliationSerializer,
    PeopleSerializer,
    ResultSerializer
)


# Swagger schema view --------------
class SwaggerSchemaView(APIView):
    permission_classes = [AllowAny]
    renderer_classes = [
        CoreJSONRenderer,
        renderers.OpenAPIRenderer,
        renderers.SwaggerUIRenderer
    ]

    def get(self, request):
        return Response(SCHEMA)
# end Swagger schema view -----------


class AffiliationsViewSet(APIView):
    """
    All ODM2 affiliations retrieval
    """

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'affiliationID': request.query_params.get('affiliationID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName'),
            'organizationCode': request.query_params.get('organizationCode')
        }
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


