__author__ = 'Choonhan Youn'

import sys
import os
import uuid

from ODM2.base import serviceBase
from ODM2.models import *
import datetime as dt

from ODM2.apiCustomType import Geometry

class yodaService(serviceBase):

    def get_or_createObject(self,model,data):
        keywords = ['UUID','Elevation_m','Latitude','Longitude','Offset1Value','Offset2Value','Offset3Value','NoDataValue','XLocation','YLocation','ZLocation','IntendedTimeSpacing','TimeAggregationInterval','DataValue']

        filters = {}
        q = self._session.query(model)
        for attr, value in data.__dict__.iteritems():
            if attr.endswith(tuple(keywords)):
                continue
            else:
                filters[attr] = value
        #print "filters", filters
        q = q.filter_by(**filters)

        try:
            item = q.one()
            return item
        except:
            item = None

        if item == None:
            item = model()
            for attr, value in data.__dict__.iteritems():
                #print attr, value
                if attr.endswith('UUID'):
                    setattr(item, attr, uuid.uuid4().hex)
                else:
                    setattr(item,attr,value)

            self._session.add(item)
            self._session.commit()
            
            return item

    def get_or_createTimeSeriesResultValues(self,trv,valueDateTime,valueDateTimeUTCOffset,dataValue):
        """
        ValueID = Column(BigInteger, primary_key=True)
        ResultID = Column(ForeignKey('ODM2.TimeSeriesResults.ResultID'), nullable=False)
        DataValue = Column(Float(53), nullable=False)
        ValueDateTime = Column(DateTime, nullable=False)
        ValueDateTimeUTCOffset = Column(Integer, nullable=False)
        CensorCodeCV = Column(String(255), nullable=False)
        QualityCodeCV = Column(String(255), nullable=False)
        TimeAggregationInterval = Column(Float(53), nullable=False)
        TimeAggregationIntervalUnitsID = Column(ForeignKey('ODM2.Units.UnitsID'), nullable=False)
        """
        try:
            for i in range(len(dataValue)):
                if i == 0:
                    #check data value
                    if valueDateTime[i] != 'ValueDateTime':
                        print "There is no \"ValueDateTime\" data."
                        break
                    if valueDateTimeUTCOffset[i] != 'ValueDateTimeUTCOffset':
                        print "There is no \"ValueDateTimeUTCOffset\" data."
                        break
                    if dataValue[i] != trv.Label:
                        print "There is no \"DataValue\" data."
                        break
                    delattr(trv,'Label')
                    continue

                filters = {}
                q = self._session.query(TimeSeriesResultValues)
                for attr, value in trv.__dict__.iteritems():
                    if attr == 'TimeAggregationInterval' or attr == 'DataValue':
                        continue
                    elif attr == 'ValueDateTime':
                        filters[attr]=valueDateTime[i]
                    elif attr == 'ValueDateTimeUTCOffset':
                        filters[attr]=valueDateTimeUTCOffset[i]
                    else:
                        filters[attr] = value
                #print "filters",filters
                q = q.filter_by(**filters)
                try:
                    values = q.one()
                except:
                    values = None 

                if values != None:
                    continue

                values = TimeSeriesResultValues()
                for attr, value in trv.__dict__.iteritems():
                    #print attr,value
                    if attr == 'DataValue':
                        #print "datavalue",dataValue[i]
                        setattr(values,attr,dataValue[i])
                        #print getattr(values,attr)
                    elif attr == 'ValueDateTime':
                        setattr(values,attr,valueDateTime[i])
                    elif attr == 'ValueDateTimeUTCOffset':
                        setattr(values,attr,valueDateTimeUTCOffset[i])
                    else:
                        setattr(values,attr,value)

                self._session.add(values)
                self._session.commit()

            return values
        except Exception, e:
            print e
            return None
