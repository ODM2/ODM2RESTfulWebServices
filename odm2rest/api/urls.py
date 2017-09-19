# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from django.conf.urls import url

from views import AffiliationsViewSet

urlpatterns = [
    url(r'^affiliations$', AffiliationsViewSet.as_view(), name='affiliations-list'),
]