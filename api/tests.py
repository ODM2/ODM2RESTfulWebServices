# -*- coding: utf-8 -*-
from __future__ import unicode_literals

import json
import os

from django.conf import settings

from jsonschema import (validate, FormatChecker)

from rest_framework import status
from rest_framework.test import (APIRequestFactory,
                                 APITestCase)

from api.views import (PeopleViewSet,
                       ActionsViewSet,
                       AffiliationsViewSet,
                       ResultsViewSet,
                       ResultValuesViewSet,
                       SamplingFeaturesDataSetViewSet,
                       SamplingFeaturesViewSet,
                       DataSetsViewSet,
                       DatasetResultsViewSet,
                       DataSetsValuesViewSet,
                       MethodsViewSet,
                       OrganizationViewSet,
                       ProcessingLevelsViewSet,
                       UnitsViewSet,
                       VariablesViewSet)
from api import API_VERSION

FACTORY = APIRequestFactory()


# TODO: Need a database to spin up before being able to run tests
# TODO: Once structure of each response is established, need json schema testing
class PeopleViewTests(APITestCase):
    def test_get_people(self):
        view = PeopleViewSet.as_view()
        request = FACTORY.get('/{}/people'.format(API_VERSION))
        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class AffiliationsViewTests(APITestCase):
    def test_get_affiliations(self):
        view = AffiliationsViewSet.as_view()
        request = FACTORY.get('/{}/affiliations'.format(API_VERSION))
        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class ResultsViewTests(APITestCase):
    def test_get_results(self):
        view = ResultsViewSet.as_view()
        requests = FACTORY.get('/{}/results'.format(API_VERSION),
                               data={'resultID': 1064})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class SamplingFeatureDatasetsViewTests(APITestCase):
    def test_get_samplingfeaturedatasets(self):
        view = SamplingFeaturesDataSetViewSet.as_view()
        requests = FACTORY.get('/{}/samplingfeaturedatasets'.format(API_VERSION),
                               data={'samplingFeatureID': 1064})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class SamplingFeaturesViewTests(APITestCase):
    def test_get_samplingfeatures(self):
        view = SamplingFeaturesViewSet.as_view()
        requests = FACTORY.get('/{}/samplingfeatures'.format(API_VERSION),
                               data={'samplingFeatureID': 1064})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class DatasetsViewTests(APITestCase):
    def test_get_datasets(self):
        view = DataSetsViewSet.as_view()
        requests = FACTORY.get('/{}/datasets'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class DatasetResultsViewTests(APITestCase):
    def test_get_datasetresults(self):
        view = DatasetResultsViewSet.as_view()
        requests = FACTORY.get('/{}/datasetresults',
                               data={'datasetID': 1})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class DatasetValuesViewTests(APITestCase):
    def test_get_datasetvalues(self):
        view = DataSetsValuesViewSet.as_view()
        requests = FACTORY.get('/{}/datasetvalues',
                               data={'datasetID': 1})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class ResultValuesViewTests(APITestCase):
    def test_get_resultvalues(self):
        view = ResultValuesViewSet.as_view()
        requests = FACTORY.get('/{}/resultvalues',
                               data={'resultID': 1064})
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class ActionsViewTests(APITestCase):
    def test_get_actions(self):
        view = ActionsViewSet.as_view()
        requests = FACTORY.get('/{}/actions'.format(API_VERSION),
                               data={'actionID': 1})
        response = view(requests)

        schema = json.load(open(os.path.join(settings.JSON_SCHEMA, 'actions.json')))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)
        validate(response.data[0], schema, format_checker=FormatChecker())



class MethodViewTests(APITestCase):
    def test_get_methods(self):
        view = MethodsViewSet.as_view()
        requests = FACTORY.get('/{}/methods'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class OrganizationsViewTests(APITestCase):
    def test_get_organizations(self):
        view = OrganizationViewSet.as_view()
        requests = FACTORY.get('/{}/organizations'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class ProcessingLevelsViewTests(APITestCase):
    def test_get_processinglevels(self):
        view = ProcessingLevelsViewSet.as_view()
        requests = FACTORY.get('/{}/processinglevels'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class UnitsViewTests(APITestCase):
    def test_get_units(self):
        view = UnitsViewSet.as_view()
        requests = FACTORY.get('/{}/units'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)


class VariablesViewTests(APITestCase):
    def test_get_variables(self):
        view = VariablesViewSet.as_view()
        requests = FACTORY.get('/{}/variables'.format(API_VERSION))
        response = view(requests)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreater(len(response.data), 0)
