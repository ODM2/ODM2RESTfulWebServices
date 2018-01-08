# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from django.conf.urls import url
from django.views.generic import TemplateView

from rest_framework.urlpatterns import format_suffix_patterns

from views import (
    AffiliationsViewSet,
    PeopleViewSet,
    ResultsViewSet,
    SamplingFeaturesViewSet,
    DataSetsViewSet,
    ResultValuesViewSet,
    SamplingFeaturesDataSetViewSet,
    MethodsViewSet,
    ActionsViewSet,
    VariablesViewSet,
    UnitsViewSet,
    OrganizationViewSet,
    DatasetResultsViewSet,
    DataSetsValuesViewSet,
    ProcessingLevelsViewSet
)

urlpatterns = [
    url(r'^docs/$', TemplateView.as_view(template_name='odm2_rest_api/swagger.html')),
    # Affiliations
    url(r'^affiliations$', AffiliationsViewSet.as_view(), name='affiliations-list'),
    # People
    url(r'^people$', PeopleViewSet.as_view(), name='people-list'),
    # Results
    url(r'^results$', ResultsViewSet.as_view(), name='results-list'),
    # Sampling Feature Datasets
    url(r'^samplingfeaturedatasets',
        SamplingFeaturesDataSetViewSet.as_view(), name='samplingfeaturedatasets-list'),
    # Sampling Features
    url(r'^samplingfeatures$', SamplingFeaturesViewSet.as_view(), name='samplingfeatures-list'),
    # DataSets
    url(r'^datasets$', DataSetsViewSet.as_view(), name='datasets-list'),
    # Result Values
    url(r'^resultvalues', ResultValuesViewSet.as_view(),
        name='resultvalues-detail'),
    # Methods
    url(r'^methods$', MethodsViewSet.as_view(), name='methods-list'),
    # Actions
    url(r'^actions$', ActionsViewSet.as_view(), name='actions-list'),
    # Variables
    url(r'^variables$', VariablesViewSet.as_view(), name='variables-list'),
    # Units
    url(r'^units$', UnitsViewSet.as_view(), name='units-list'),
    # Organizations
    url(r'^organizations$', OrganizationViewSet.as_view(), name='organizations-list'),
    # Datasetresults
    url(r'^datasetresults$', DatasetResultsViewSet.as_view(), name='datasetresults-list'),
    # DataSetValues
    url(r'^datasetvalues$', DataSetsValuesViewSet.as_view(), name='datasetvalues-list'),
    # ProcessingLevels
    url(r'^processinglevels', ProcessingLevelsViewSet.as_view(), name='processinglevels-list')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
