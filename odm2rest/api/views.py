# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response

from core import get_affiliations
from serializers import AffiliationsSerializer

class AffiliationsViewSet(APIView):

    def get(self, request, format=None):

        get_kwargs = {
            'affiliationID': request.query_params.get('affiliationID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName')
        }
        affiliations = get_affiliations(**get_kwargs)
        serialized_affs = AffiliationsSerializer(affiliations, many=True)

        return Response(serialized_affs.data)


