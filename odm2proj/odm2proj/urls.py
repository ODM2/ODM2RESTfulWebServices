from django.conf.urls import patterns, url, include
from rest_framework.urlpatterns import format_suffix_patterns

urlpatterns = [
    url(r'^', include('odm2rest.urls')),
    url(r'^docs/', include('rest_framework_swagger.urls')),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]

#urlpatterns = patterns('',
#                       url(r'^', include('odm2rest.urls')),
#                       url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
#                       url(r'^docs/', include('rest_framework_swagger.urls')),
#                       url(r'^rest-api/', include('rest_framework_docs.urls')),
#)
