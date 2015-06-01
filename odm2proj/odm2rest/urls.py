from django.conf.urls import patterns, url, include
from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework import routers

from odm2rest.variable_views import VariableViewSet, VariableCodeViewSet
from odm2rest import views
from odm2rest.site_views import SiteViewSet, SiteSamplingFeatureCodeViewSet, SiteTypeViewSet
#from odm2rest.cv_views import ODMVocabulariesViewSet, TermsViewSet, TermsDetailViewSet, CVtermViewSet
from odm2rest.action_views import ActionsViewSet, ActionIDViewSet
from odm2rest.value_views import ValuesViewSet
from odm2rest.result_views import ResultsViewSet, ResultsVarCodeViewSet, ResultsSFCodeViewSet, ResultsSFUUIDViewSet, ResultsBBoxViewSet, ResultsActionDateViewSet, ResultsRTypeCVViewSet, ResultsComplexViewSet
from odm2rest.method_views import MethodsViewSet, MethodCodeViewSet
from odm2rest.org_views import OrgsViewSet, OrgCodeViewSet
from odm2rest.dataset_views import DatasetViewSet
from odm2rest.datasetdetail_views import DatasetDetailViewSet

urlpatterns = [
    url(r'^$', views.api_root),
    url(r'^methods/$', MethodsViewSet.as_view(), name='method-list'),
    url(r'^methods/(?P<methodCode>.+)/$', MethodCodeViewSet.as_view(), name='method-detail'),
    url(r'^organizations/$', OrgsViewSet.as_view(), name='org-list'),
    url(r'^organizations/(?P<organizationCode>.+)/$', OrgCodeViewSet.as_view(), name='org-detail'),
    url(r'^actions/$', ActionsViewSet.as_view(), name='action-list'),
    url(r'^actions/(?P<actionID>.+)/$', ActionIDViewSet.as_view(), name='action-list'),
    url(r'^Observations/$', ResultsViewSet.as_view(), name='observ-list'),
    url(r'^Observations/variableCode/(?P<variableCode>.+)/$', ResultsVarCodeViewSet.as_view(), name='resultvarcode-list'),
    url(r'^Observations/samplingfeatureCode/(?P<samplingfeatureCode>.+)/$', ResultsSFCodeViewSet.as_view(), name='resultsfcode-list'),
    url(r'^Observations/samplingfeatureUUID/(?P<samplingfeatureUUID>.+)/$', ResultsSFUUIDViewSet.as_view(), name='resultsfuuid-list'),
    url(r'^Observations/boundingbox', ResultsBBoxViewSet.as_view(), name='resultbbox-list'),
    url(r'^Observations/actionDate', ResultsActionDateViewSet.as_view(), name='resultactiondate-list'),
    url(r'^Observations/resultType/(?P<resultType>.+)/$', ResultsRTypeCVViewSet.as_view(), name='resultrtypecv-list'),
    url(r'^Observations/fineGrainSearch', ResultsComplexViewSet.as_view(), name='resultcomplex-list'),
    #url(r'^value/$', ValuesViewSet.as_view(), name='value-list'),
    url(r'^Observations/value/(?P<resultUUID>.+)/$', ValuesViewSet.as_view(), name='value-list'),
    url(r'^variables/$', VariableViewSet.as_view(), name='variable-list'),
    url(r'^variables/(?P<variableCode>.+)/$', VariableCodeViewSet.as_view(), name='variable-detail'),
    url(r'^sites/$',  SiteViewSet.as_view(), name='site-list'),
    url(r'^sites/samplingfeatureCode/(?P<samplingfeatureCode>.+)/$', SiteSamplingFeatureCodeViewSet.as_view(), name='site-detail-sfc'),
    url(r'^sites/siteType/(?P<siteType>.+)/$',  SiteTypeViewSet.as_view(), name='site-detail-st'),
    url(r'^datasets/$', DatasetViewSet.as_view(), name='dataset-list'),
    url(r'^datasets/(?P<datasetUUID>.+)/$', DatasetDetailViewSet.as_view(), name='datasetdetail-list'),
]

urlpatterns = format_suffix_patterns(urlpatterns)
