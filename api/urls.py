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
    SamplingFeaturesDataSetViewSet
    MethodsViewSet
)

urlpatterns = [
    url(r'^docs/$', TemplateView.as_view(template_name='swagger.html')),
    # Affiliations
    url(r'^affiliations/$', AffiliationsViewSet.as_view(), name='affiliations-list'),
    url(r'^affiliations/affiliationID/(?P<affiliationID>.+)/$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    url(r'^affiliations/(firstName/(?P<firstName>[^/]+)/)?(lastName/(?P<lastName>[^/]+)/)?$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    url(r'^affiliations/organizationCode/(?P<organizationCode>.+)/$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    # People
    url(r'^people/$', PeopleViewSet.as_view(), name='people-list'),
    url(r'^people/peopleID/(?P<peopleID>.+)/$', PeopleViewSet.as_view(), name='people-detail'),
    url(r'^people/firstName/(?P<firstName>.+)/$', PeopleViewSet.as_view(), name='people-detail'),
    url(r'^people/lastName/(?P<lastName>.+)/$', PeopleViewSet.as_view(), name='people-detail'),
    # Results
    url(r'^results/$', ResultsViewSet.as_view(), name='results-list'),
    url(r'^results/resultID/(?P<resultID>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/resultUUID/(?P<resultUUID>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/resultType/(?P<resultType>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/actionID/(?P<actionID>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/samplingFeatureID/(?P<samplingFeatureID>.+)/$',
        ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/variableID/(?P<variableID>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    url(r'^results/simulationID/(?P<simulationID>.+)/$',
        ResultsViewSet.as_view(), name='results-detail'),
    # Sampling Features
    url(r'^samplingfeatures/$', SamplingFeaturesViewSet.as_view(), name='samplingfeatures-list'),
    url(r'^samplingfeatures/samplingFeatureID/(?P<samplingFeatureID>.+)/$',
        SamplingFeaturesViewSet.as_view(), name='samplingfeatures-detail'),
    url(r'^samplingfeatures/samplingFeatureUUID/(?P<samplingFeatureUUID>.+)/$',
        SamplingFeaturesViewSet.as_view(), name='samplingfeatures-detail'),
    url(r'^samplingfeatures/samplingFeatureCode/(?P<samplingFeatureCode>.+)/$',
        SamplingFeaturesViewSet.as_view(), name='samplingfeatures-detail'),
    url(r'^samplingfeatures/samplingFeatureType/(?P<samplingFeatureType>.+)/$',
        SamplingFeaturesViewSet.as_view(), name='samplingfeatures-detail'),
    # Sampling Feature Datasets
    url(r'^samplingfeaturedatasets/samplingFeatureID/(?P<samplingFeatureID>.+)/$',
        SamplingFeaturesDataSetViewSet.as_view(), name='samplingfeaturedatasets-detail'),
    url(r'^samplingfeaturedatasets/samplingFeatureUUID/(?P<samplingFeatureUUID>.+)/$',
        SamplingFeaturesDataSetViewSet.as_view(), name='samplingfeaturedatasets-detail'),
    url(r'^samplingfeaturedatasets/samplingFeatureCode/(?P<samplingFeatureCode>.+)/$',
        SamplingFeaturesDataSetViewSet.as_view(), name='samplingfeaturedatasets-detail'),
    # DataSets
    url(r'^datasets/$', DataSetsViewSet.as_view(), name='datasets-list'),
    url(r'^datasets/datasetUUID/(?P<datasetUUID>.+)/$', DataSetsViewSet.as_view(),
        name='datasets-detail'),
    url(r'^datasets/datasetCode/(?P<datasetCode>.+)/$', DataSetsViewSet.as_view(),
        name='datasets-detail'),
    # Result Values
    url(r'^resultvalues/resultID/(?P<resultID>.+)/', ResultValuesViewSet.as_view(),
        name='resultvalues-detail'),
    # Methods
    url(r'^methods/$', MethodsViewSet.as_view(), name='methods-list'),
    url(r'^methods/methodID/(?P<methodID>.+)/$', MethodsViewSet.as_view(), name='method-detail'),
    url(r'^methods/methodCode/(?P<methodCode>.+)/$', MethodsViewSet.as_view(), name='method-detail'),
    url(r'^methods/methodType/(?P<methodType>.+)/$', MethodsViewSet.as_view(), name='method-detail')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
