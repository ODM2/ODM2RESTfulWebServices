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


from core import (
    get_affiliations,
    get_people,
    get_results,
    get_samplingfeatures,
    get_datasets,
    get_resultvalues,
    get_samplingfeaturedatasets,
    get_methods
)

from serializers import (
    AffiliationSerializer,
    PeopleSerializer,
    ResultSerializer,
    SamplingFeatureSerializer,
    DataSetSerializer,
    CategoricalResultValuesSerializer,
    MeasurementResultValuesSerializer,
    PointCoverageResultValuesSerializer,
    ProfileResultValuesSerializer,
    SectionResultsSerializer,
    SpectraResultValuesSerializer,
    TimeSeriesResultValuesSerializer,
    TrajectoryResultValuesSerializer,
    TransectResultValuesSerializer,
    DataSetsResultsSerializer,
    SitesSerializer,
    SpecimensSerializer,
    MethodSerializer

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

        # Query parameter for lastName available when querying with
        # first name and organization code.
        if firstName or organizationCode:
            last_name = request.query_params.get('lastName')
            if last_name:
                get_kwargs.update({
                    'lastName': last_name
                })

        affiliations = get_affiliations(**get_kwargs)
        serialized = AffiliationSerializer(affiliations, many=True)

        if len(affiliations) == 1:
            serialized = AffiliationSerializer(affiliations[0])

        return Response(serialized.data)


class PeopleViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, peopleID=None, firstName=None, lastName=None, format=None):

        get_kwargs = {
            'peopleID': peopleID,
            'firstName': firstName,
            'lastName': lastName
        }

        if firstName:
            get_kwargs.update({
                'lastName': request.query_params.get('lastName')
            })
        people = get_people(**get_kwargs)
        serialized = PeopleSerializer(people, many=True)

        if len(people) == 1:
            serialized = PeopleSerializer(people[0])

        return Response(serialized.data)


class ResultsViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, resultID=None,
            resultUUID=None, resultType=None,
            actionID=None, samplingFeatureID=None,
            variableID=None, simulationID=None, format=None):

        get_kwargs = {
            'resultID': resultID,
            'resultUUID': resultUUID,
            'resultType': resultType,
            'actionID': actionID,
            'samplingFeatureID': samplingFeatureID,
            'variableID': variableID,
            'simulationID': simulationID
        }
        if resultType:
            get_kwargs.update({
                'actionID': request.query_params.get('actionID'),
                'samplingFeatureID': request.query_params.get('samplingFeatureID'),
                'variableID': request.query_params.get('variableID'),
                'simulationID': request.query_params.get('simulationID')
            })

        print(get_kwargs)
        results = get_results(**get_kwargs)
        serialized = ResultSerializer(results, many=True)

        if len(results) == 1:
            serialized = ResultSerializer(results[0])
        return Response(serialized.data)


class SamplingFeaturesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, samplingFeatureID=None,
            samplingFeatureCode=None, samplingFeatureUUID=None,
            samplingFeatureType=None, format=None):

        get_kwargs = {
            'samplingFeatureID': samplingFeatureID,
            'samplingFeatureCode': samplingFeatureCode,
            'samplingFeatureUUID': samplingFeatureUUID,
            'samplingFeatureType': samplingFeatureType,
            'results': False
        }

        results = request.query_params.get('results')
        if results:
            get_kwargs.update({
                'results': results
            })

        sf_serialized, sp_serialized, si_serialized = [], [], []
        sf_list, sp_list, si_list = get_samplingfeatures(**get_kwargs)

        if sf_list:
            sf_serialized = SamplingFeatureSerializer(sf_list, many=True).data
        if sp_list:
            sp_serialized = SpecimensSerializer(sp_list, many=True).data
        if si_list:
            si_serialized = SitesSerializer(si_list, many=True).data

        sf_all = sf_serialized + sp_serialized + si_serialized


        if len(sf_all) == 1:
            sf_all = sf_all[0]

        return Response(sf_all)


class SamplingFeaturesDataSetViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, samplingFeatureID=None,
            samplingFeatureCode=None, samplingFeatureUUID=None,
            dataSetType=None,):

        get_kwargs = {
            'samplingFeatureID': request.query_params.get('samplingFeatureID'),
            'samplingFeatureCode': request.query_params.get('samplingFeatureCode'),
            'samplingFeatureUUID': request.query_params.get('samplingFeatureUUID'),
            'dataSetType': dataSetType,
            'results': False
        }

        results = request.query_params.get('results')
        if results:
            get_kwargs.update({
                'results': results
            })

        sfs = get_samplingfeaturedatasets(**get_kwargs)
        serialized = DataSetsResultsSerializer(sfs, many=True)

        if len(sfs) == 1:
            serialized = DataSetsResultsSerializer(sfs[0])

        return Response(serialized.data)


class DataSetsViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, datasetUUID=None, datasetCode=None, format=None):

        get_kwargs = {
            'datasetCode': datasetCode,
            'datasetUUID': datasetUUID,
        }

        ds = get_datasets(**get_kwargs)
        serialized = DataSetSerializer(ds, many=True)

        if len(ds) == 1:
            serialized = DataSetSerializer(ds[0])

        return Response(serialized.data)


class ResultValuesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, resultID=None, beginDate=None, endDate=None, format=None):

        get_kwargs = {
            'resultID': resultID,
            'beginDate': beginDate,
            'endDate': endDate
        }

        if resultID:
            get_kwargs.update({
                'beginDate': request.query_params.get('beginDate'),
                'endDate': request.query_params.get('endDate')
            })

        res_val, res_type = get_resultvalues(**get_kwargs)
        RVSerializer = None
        if 'categorical' in res_type.lower():
            RVSerializer = CategoricalResultValuesSerializer
        elif 'measurement' in res_type.lower():
            RVSerializer = MeasurementResultValuesSerializer
        elif 'point' in res_type.lower():
            RVSerializer = PointCoverageResultValuesSerializer
        elif 'profile' in res_type.lower():
            RVSerializer = ProfileResultValuesSerializer
        elif 'section' in res_type.lower():
            RVSerializer = SectionResultsSerializer
        elif 'spectra' in res_type.lower():
            RVSerializer = SpectraResultValuesSerializer
        elif 'time' in res_type.lower():
            RVSerializer = TimeSeriesResultValuesSerializer
        elif 'trajectory' in res_type.lower():
            RVSerializer = TrajectoryResultValuesSerializer
        elif 'transect' in res_type.lower():
            RVSerializer = TransectResultValuesSerializer
        serialized = RVSerializer(res_val, many=True)

        if len(res_val) == 1:
            serialized = RVSerializer(res_val[0])

        return Response(serialized.data)


class MethodsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, methodID=None, methodCode=None, methodType=None, format=None):

        get_kwargs = {
            'methodID': methodID,
            'methodCode': methodCode,
            'methodType': methodType
        }

        methods = get_methods(**get_kwargs)
        serialized = MethodSerializer(methods, many=True)

        if len(methods) == 1:
            serialized = MethodSerializer(methods[0])

        return Response(serialized.data)

