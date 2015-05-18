__author__ = 'Choonhan Youn'

import sys
import os
import uuid

from ODM2.base import serviceBase
from ODM2.models import *
import datetime as dt
from ODM2.apiCustomType import Geometry

class odm2Service(serviceBase):

    """
    Actions
    """

    def getActions(self):
        try:
            return self._session.query(Actions).order_by(Actions.ActionID).all()
        except:
            return None

    def getActionsByPage(self, page=0, page_size=None):
        try:
            return self._session.query(Actions).order_by(Actions.ActionID).offset(page*page_size).limit(page_size).all()
        except:
            return None

    def getActionByActionID(self, actionID):
        try:
            return self._session.query(Actions).filter_by(ActionID=actionID).one()
        except:
            return None

    """
    Datasets
    """
    def getDataSets(self):

        try:
            return self._session.query(Datasets).all()
        except:
            return None

    def getDataSetResultsByUUID(self,dsuuid):

        try:
            return self._session.query(DatasetsResults).join(Datasets).filter(Datasets.DatasetUUID==dsuuid).all()
        except:
            return None

    """
    Site
    """

    def getSiteBySFId(self, siteId):
        try:
            return self._session.query(Sites).filter_by(SamplingFeatureID=siteId).one()
        except:
            return None

    def getAllSites(self):
        try:
            return self._session.query(Sites).all()
        except:
            return None

    def getSiteBySFCode(self, siteCode):
        try:
            sf= self._session.query(SamplingFeatures).filter_by(SamplingFeatureCode = siteCode).one()
            return self._session.query(Sites).filter_by(SamplingFeatureID = sf.SamplingFeatureID).one()
        except:
            return None

    def getSitesBySiteType(self, siteType):
        try:
            return self._session.query(Sites).filter_by(SiteTypeCV=siteType).all()
        except:
            return None

    """
    Method
    """
    def getMethodByCode(self, methodCode):
        try:
            return self._session.query(Methods).filter_by(MethodCode=methodCode).one()
        except:
            return None

    """
    Organization
    """
    def getOrganizationByCode(self, orgCode):
        try:
            return self._session.query(Organizations).filter_by(OrganizationCode=orgCode).one()
        except:
            return None

    """
    Variables
    """
    def getVariables(self):
        try:
            return self._session.query(Variables).all()
        except:
            return None

    def getVariableByCode(self, variableCode):
        try:
            return self._session.query(Variables).filter_by(VariableCode=variableCode).one()
        except:
            return None

    """
    Results
    """

    def getResults(self):

        try:
            return self._session.query(Results).all()
        except:
            return None

    def getResultsByPage(self,page,page_size):

        try:
            q=self._session.query(Results).order_by(Results.ResultID).offset(page*page_size).limit(page_size).all()
            return q
        except:
            return None

    def getResultsByVariableCode(self,variableCode):

        try:
            return self._session.query(Results).join(Variables).filter_by(VariableCode=variableCode).all()
        except:
            return None

    def getResultsBySamplingfeatureCode(self,samplingfeatureCode):

        try:
            return self._session.query(Results).\
                join(FeatureActions).\
                join(SamplingFeatures).\
                filter(SamplingFeatures.SamplingFeatureCode==samplingfeatureCode).all()
        except:
            return None

    def getResultsBySamplingfeatureUUID(self,samplingfeatureUUID):

        try:
            return self._session.query(Results).\
                join(FeatureActions).\
                join(SamplingFeatures).\
                filter(SamplingFeatures.SamplingFeatureUUID==samplingfeatureUUID).all()
        except:
            return None

    def getResultsByBBox(self, xmin, ymin, xmax, ymax):
        """
        north - ymax - latitude
        south - ymin - latitude
        west - xmin - longitude
        east - xmax - longitude
        """

        try:
            return self._session.query(Results).\
                join(FeatureActions).\
                join(SamplingFeatures).\
                join(Sites).\
                filter(Sites.Latitude >= ymin, Sites.Latitude <= ymax, Sites.Longitude >= xmin, Sites.Longitude <= xmax).all()
        except:
            return None

    def getResultsByActionByDate(self, beginDate, endDate):

        try:
            return self._session.query(Results).\
                join(FeatureActions).\
                join(Actions).\
                filter(Actions.BeginDateTime >= beginDate, Actions.BeginDateTime <= endDate).\
                order_by(Actions.BeginDateTime).all()
        except:
            return None

    def getResultsByResultTypeCV(self,rTypeCV):
        try:
            return self._session.query(Results).filter_by(ResultTypeCV=rTypeCV).all()
        except:
            return None

    def getResultsByResultTypeCVByBBoxByDate(self, rTypeCV, xmin, ymin, xmax, ymax, beginDate, endDate):
        """
        north - ymax - latitude
        south - ymin - latitude
        west - xmin - longitude
        east - xmax - longitude
        """

        try:
            return self._session.query(Results).\
                join(FeatureActions).\
                join(SamplingFeatures).\
                join(Sites).\
                filter(Results.ResultTypeCV==rTypeCV, Sites.Latitude >= ymin, Sites.Latitude <= ymax, Sites.Longitude >= xmin, Sites.Longitude <= xmax, Results.ResultDateTime >= beginDate, Results.ResultDateTime <= endDate).all()
        except:
            return None

    def getResultByUUID(self,resultUUID):
        try:
            return self._session.query(Results.ResultID,Results.ResultTypeCV).filter_by(ResultUUID=resultUUID).one()
        except:
            return None
            

    """
    Time Series Values
    """
    def getTimeSeriesResultValuesByResultID(self, resultID, page, page_size):
        try:
            q=self._session.query(TimeSeriesResultValues).\
                filter_by(ResultID=resultID).order_by(TimeSeriesResultValues.ValueDateTime).offset(page*page_size).limit(page_size).all()
            return q
        except:
            return None


    def getMeasurementResultValuesByResultID(self, resultID, page, page_size):
        try:
            q=self._session.query(MeasurementResultValues).filter_by(ResultID=resultID).order_by(MeasurementResultValues.ValueDateTime).offset(page*page_size).limit(page_size).all()
            return q
        except:
            return None

    """
    RelatedActions
    """

    def getRelatedActionsByActionID(self,actionID):

        try:
            return self._session.query(RelatedActions).filter_by(ActionID=actionID).all()
        except:
            return None
