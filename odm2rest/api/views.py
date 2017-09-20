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

from core import get_affiliations, get_people

from serializers import (AffiliationsSerializer, PeopleSerializer)


class SwaggerSchemaView(APIView):
    permission_classes = [AllowAny]
    renderer_classes = [
        CoreJSONRenderer,
        renderers.OpenAPIRenderer,
        renderers.SwaggerUIRenderer
    ]

    def get(self, request):
        return Response(SCHEMA)


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
        serialized_affs = AffiliationsSerializer(affiliations, many=True)

        if len(affiliations) == 1:
            serialized_affs = AffiliationsSerializer(affiliations[0])

        return Response(serialized_affs.data)


class PeopleViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'peopleID': request.query_params.get('peopleID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName')
        }
        people = get_people(**get_kwargs)
        serialized_affs = PeopleSerializer(people, many=True)

        if len(people) == 1:
            serialized_affs = PeopleSerializer(people[0])

        return Response(serialized_affs.data)


