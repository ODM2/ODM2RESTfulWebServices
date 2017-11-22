# -*- coding: utf-8 -*-
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

from rest_framework.parsers import JSONParser
from rest_framework.renderers import (JSONRenderer)
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_csv.renderers import CSVRenderer
from rest_framework_yaml.parsers import YAMLParser
from rest_framework_yaml.renderers import YAMLRenderer

from core import (
    get_affiliations,
    get_people,
    get_results,
    get_samplingfeatures,
    get_datasets,
    get_resultvalues,
    get_samplingfeaturedatasets,
    get_methods,
    get_actions,
    get_variables,
    get_units,
    get_organizations,
    get_datasetresults,
    get_datasetsvalues,
    get_processinglevels
)
from serializers import (
    CategoricalResultValuesSerializer,
    MeasurementResultValuesSerializer,
    PointCoverageResultValuesSerializer,
    ProfileResultValuesSerializer,
    SectionResultsSerializer,
    SpectraResultValuesSerializer,
    TimeSeriesResultValuesSerializer,
    TrajectoryResultValuesSerializer,
    TransectResultValuesSerializer,
    DataSetsResultsSerializer

)


class AffiliationsViewSet(APIView):
    """
    All ODM2 affiliations retrieval
    """

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)
    parser_classes =  (JSONParser, YAMLParser,)

    def get(self, request, format=None):
        get_kwargs = {
            'affiliationID': request.query_params.get('affiliationID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName'),
            'organizationCode': request.query_params.get('organizationCode')
        }

        affiliations = get_affiliations(**get_kwargs)

        return Response(affiliations)


class PeopleViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'peopleID': request.query_params.get('peopleID'),
            'firstName': request.query_params.get('firstName'),
            'lastName': request.query_params.get('lastName')
        }

        people = get_people(**get_kwargs)

        return Response(people)


class ResultsViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'resultID': request.query_params.get('resultID'),
            'resultUUID': request.query_params.get('resultUUID'),
            'resultType': request.query_params.get('resultType'),
            'actionID': request.query_params.get('actionID'),
            'samplingFeatureID': request.query_params.get('samplingFeatureID'),
            'variableID': request.query_params.get('variableID'),
            'simulationID': request.query_params.get('simulationID'),
            'siteID': request.query_params.get('siteID')
        }

        results = get_results(**get_kwargs)
        # serialized = ResultSerializer(results, many=True)

        # if len(results) == 1:
        #     serialized = ResultSerializer(results[0])
        return Response(results)


class SamplingFeaturesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'samplingFeatureID': request.query_params.get('samplingFeatureID'),
            'samplingFeatureCode': request.query_params.get('samplingFeatureCode'),
            'samplingFeatureUUID': request.query_params.get('samplingFeatureUUID'),
            'samplingFeatureType': request.query_params.get('samplingFeatureType'),
            'results': False
        }

        results = request.query_params.get('results')
        if results:
            get_kwargs.update({
                'results': results
            })

        sf_list = get_samplingfeatures(**get_kwargs)

        return Response(sf_list)


class SamplingFeaturesDataSetViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'samplingFeatureID': request.query_params.get('samplingFeatureID'),
            'samplingFeatureCode': request.query_params.get('samplingFeatureCode'),
            'samplingFeatureUUID': request.query_params.get('samplingFeatureUUID'),
            'datasetType': request.query_params.get('datasetType'),
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


class DataSetsValuesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'datasetID': request.query_params.get('datasetID'),
            'datasetUUID': request.query_params.get('datasetUUID'),
            'datasetCode': request.query_params.get('datasetCode'),
            'datasetType': request.query_params.get('datasetType'),
            'beginDate': request.query_params.get('beginDate'),
            'endDate': request.query_params.get('endDate')
        }

        if get_kwargs['datasetID'] or get_kwargs['datasetCode'] or get_kwargs['datasetUUID']:
            dsr_val = get_datasetsvalues(**get_kwargs)
        else:
            raise Exception('Must enter datasetID, datasetCode, or datasetUUID')

        return Response(dsr_val)


class DataSetsViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'datasetCode': request.query_params.get('datasetCode'),
            'datasetUUID': request.query_params.get('datasetUUID')
        }

        datasets = get_datasets(**get_kwargs)

        return Response(datasets)


class DatasetResultsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'datasetID': request.query_params.get('datasetID'),
            'datasetCode': request.query_params.get('datasetCode'),
            'datasetUUID': request.query_params.get('datasetUUID'),
            'datasetType': request.query_params.get('datasetType'),
            'results': False
        }

        dsr = get_datasetresults(**get_kwargs)

        return Response(dsr)


class ResultValuesViewSet(APIView):

    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'resultID': request.query_params.get('resultID'),
            'beginDate': request.query_params.get('beginDate'),
            'endDate': request.query_params.get('endDate')
        }

        if get_kwargs['resultID']:
            res_val = get_resultvalues(**get_kwargs)
        else:
            raise Exception('Must enter resultID')


        return Response(res_val)


class MethodsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):

        get_kwargs = {
            'methodID': request.query_params.get('methodID'),
            'methodCode': request.query_params.get('methodCode'),
            'methodType': request.query_params.get('methodType')
        }

        methods = get_methods(**get_kwargs)

        return Response(methods)


class ActionsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'actionID': request.query_params.get('actionID'),
            'actionType': request.query_params.get('actionType'),
            'samplingFeatureID': request.query_params.get('samplingFeatureID')
        }

        actions = get_actions(**get_kwargs)

        return Response(actions)


class VariablesViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'variableID': request.query_params.get('variableID'),
            'variableCode': request.query_params.get('variableCode'),
            'siteCode': request.query_params.get('siteCode'),
            'results': False
        }

        results = request.query_params.get('results')
        if results:
            get_kwargs.update({
                'results': results
            })

        variables = get_variables(**get_kwargs)

        return Response(variables)


class UnitsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'unitsID': request.query_params.get('unitsID'),
            'unitsType': request.query_params.get('unitsType'),
            'unitsName': request.query_params.get('unitsName')
        }

        units = get_units(**get_kwargs)

        return Response(units)


class OrganizationViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'organizationID': request.query_params.get('organizationID'),
            'organizationCode': request.query_params.get('organizationCode')
        }

        organizations = get_organizations(**get_kwargs)

        return Response(organizations)


class ProcessingLevelsViewSet(APIView):
    renderer_classes = (JSONRenderer, YAMLRenderer, CSVRenderer)

    def get(self, request, format=None):
        get_kwargs = {
            'processingLevelID': request.query_params.get('processingLevelID'),
            'processingLevelCode': request.query_params.get('processingLevelCode')
        }

        processinglevels = get_processinglevels(**get_kwargs)

        return Response(processinglevels)
