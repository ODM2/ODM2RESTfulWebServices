# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from django.conf.urls import url
from rest_framework.urlpatterns import format_suffix_patterns
from views import AffiliationsViewSet, PeopleViewSet

urlpatterns = [
    url(r'^affiliations$', AffiliationsViewSet.as_view(), name='affiliations-list'),
    url(r'^people', PeopleViewSet.as_view(), name='people-list')
]

urlpatterns = format_suffix_patterns(urlpatterns, allowed=['json', 'html', 'yaml', 'csv'])
