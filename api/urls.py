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
    SamplingFeaturesViewSet
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
    url(r'^results/simulationID/(?P<simulationID>.+)/$', ResultsViewSet.as_view(), name='results-detail'),
    # url(r'^samplingfeatures$', SamplingFeaturesViewSet.as_view(), name='samplingfeatures-list')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
