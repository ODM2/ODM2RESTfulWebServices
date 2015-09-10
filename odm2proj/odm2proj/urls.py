from django.conf.urls import url, include

urlpatterns = [
    url(r'^', include('odm2rest.urls')),
    url(r'^docs/', include('rest_framework_swagger.urls')),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]

# urlpatterns = patterns('',
#                       url(r'^', include('odm2rest.urls')),
#                       url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework')),
#                       url(r'^docs/', include('rest_framework_swagger.urls')),
#                       url(r'^rest-api/', include('rest_framework_docs.urls')),
# )
