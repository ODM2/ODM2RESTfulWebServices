# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework_swagger.views import get_swagger_view

from views import (
    AffiliationsViewSet,
    PeopleViewSet
)

schema_view = get_swagger_view(title='ODM2 REST API')

urlpatterns = [
    url(r'^docs/$', schema_view),
    url(r'^affiliations$', AffiliationsViewSet.as_view(), name='affiliations-list'),
    url(r'^people$', PeopleViewSet.as_view(), name='people-list')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
