# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns

from views import (
    SwaggerSchemaView,
    AffiliationsViewSet,
    PeopleViewSet,
    ResultsViewSet,
    SamplingFeaturesViewSet
)

urlpatterns = [
    url(r'^docs/$', SwaggerSchemaView.as_view()),
    # Affiliations
    url(r'^affiliations/$', AffiliationsViewSet.as_view(), name='affiliations-list'),
    url(r'^affiliations/affiliationID/(?P<affiliationID>.+)/$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    url(r'^affiliations/(firstName/(?P<firstName>[^/]+)/)?(lastName/(?P<lastName>[^/]+)/)?$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    url(r'^affiliations/organizationCode/(?P<organizationCode>.+)/$',
        AffiliationsViewSet.as_view(), name='affiliations-detail'),
    # People
    url(r'^people$', PeopleViewSet.as_view(), name='people-list'),
    # Results
    url(r'^results$', ResultsViewSet.as_view(), name='results-list'),
    # url(r'^samplingfeatures$', SamplingFeaturesViewSet.as_view(), name='samplingfeatures-list')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
