import sys
import os
sys.path.append('../ODM2PythonAPI')

from ODMconnection import dbconnection
from YODAqueries import yodaService as yodaservice
import ODM2.models as models

import yaml
from datetime import datetime, timedelta
from time import strftime
import inspect
import codecs

conn = dbconnection.createConnection('mysql', 'localhost', 'ODM2', 'cinergi', 'cinergi')
yoda_service = yodaservice(conn)

class obj(object):
    def __init__(self, d):
        #for a, b in d.items():
        #for a smaller memory footprint
        for a, b in d.iteritems():
            #if a == 'FeatureGeometry':
            #    b = None
            if isinstance(b, (list, tuple)):
                setattr(self, a, [obj(x) if isinstance(x, dict) else x for x in b])
            else:
                setattr(self, a, obj(b) if isinstance(b, dict) else b)

def getOrganization(model,org):
    if hasattr(org, 'OrganizationObj'):
        print "Parent organization is existed!!! Currently it is not used"
        setattr(org, 'ParentOrganizationID', None)
        delattr(org, 'OrganizationObj')
    else:
        setattr(org, 'ParentOrganizationID', None)
    return yoda_service.get_or_createObject(model,org)

def getExternalIdentifierSystems(model,eis):
    org = getattr(models,'Organizations')
    org = getOrganization(org,eis.IdentifierSystemOrganizationObj)
    setattr(eis, 'IdentifierSystemOrganizationID', org.OrganizationID)
    delattr(eis, 'IdentifierSystemOrganizationObj')
    return yoda_service.get_or_createObject(model,eis)

def getPersonExternalIdentifiers(model,pei):
    p = getattr(models,'People')
    person = yoda_service.get_or_createObject(p,pei.PersonObj)
    e = getattr(models,'ExternalIdentifierSystems')
    eis = getExternalIdentifierSystems(e,pei.ExternalIdentifierSystemObj)
    setattr(pei,'PersonID',person.PersonID)
    setattr(pei,'ExternalIdentifierSystemID',eis.ExternalIdentifierSystemID)
    delattr(pei,'ExternalIdentifierSystemObj')
    delattr(pei,'PersonObj')
    return yoda_service.get_or_createObject(model,pei)

def getAffiliations(model,aff):
    p = getattr(models,'People')
    person = yoda_service.get_or_createObject(p,aff.PersonObj)
    if aff.OrganizationObj != None:
        org = getattr(models,'Organizations')
        org = getOrganization(org,aff.OrganizationObj)
        setattr(aff,'OrganizationID', org.OrganizationID)
    else:
        setattr(aff,'OrganizationID', None)

    if aff.AffiliationStartDate == None:
        setattr(aff, 'AffiliationStartDate', '2015-04-28')
    setattr(aff,'PersonID',person.PersonID)
    delattr(aff,'OrganizationObj')
    delattr(aff,'PersonObj')
    return yoda_service.get_or_createObject(model,aff)

def getAuthorLists(model,al):
    c = getattr(models,'Citations')
    c = yoda_service.get_or_createObject(c,al.CitationObj)
    p = getattr(models,'People')
    person = yoda_service.get_or_createObject(p,al.PersonObj)
    setattr(al,'PersonID',person.PersonID)
    setattr(al,'CitationID',c.CitationID)
    delattr(al,'PersonObj')
    delattr(al,'CitationObj')
    return yoda_service.get_or_createObject(model,al)

def getDatasetCitations(model,dc):
    c = getattr(models,'Citations')
    c = yoda_service.get_or_createObject(c,dc.CitationObj)
    setattr(dc,'CitationID',c.CitationID)
    delattr(dc,'CitationObj')
    ds = getattr(models,'Datasets')
    ds = yoda_service.get_or_createObject(ds,dc.DatasetObj)
    setattr(dc,'DatasetID',ds.DatasetID)
    delattr(dc,'DatasetObj')
    return yoda_service.get_or_createObject(model,dc)

def getSamplingFeatureExternalIdentifiers(model,sfei):    
    sf = getattr(models,'SamplingFeatures')
    sf = yoda_service.get_or_createObject(sf,sfei.SamplingFeatureObj)
    setattr(sfei,'SamplingFeatureID',sf.SamplingFeatureID)
    delattr(sfei,'SamplingFeatureObj')
    eis = getattr(models,'ExternalIdentifierSystems')
    eis = getExternalIdentifierSystems(eis,sfei.ExternalIdentifierSystemObj)
    setattr(sfei,'ExternalIdentifierSystemID',eis.ExternalIdentifierSystemID)
    delattr(sfei,'ExternalIdentifierSystemObj')
    return yoda_service.get_or_createObject(model,sfei)

def getSites(model,site):
    sf = getattr(models,'SamplingFeatures')
    sf = yoda_service.get_or_createObject(sf,site.SamplingFeatureObj)
    setattr(site,'SamplingFeatureID',sf.SamplingFeatureID)
    delattr(site,'SamplingFeatureObj')
    sr = getattr(models,'SpatialReferences')
    sr = yoda_service.get_or_createObject(sr,site.SpatialReferenceObj)
    setattr(site,'SpatialReferenceID',sr.SpatialReferenceID)
    delattr(site,'SpatialReferenceObj')
    return yoda_service.get_or_createObject(model,site)

def getSpecimens(model,sp):
    sf = getattr(models,'SamplingFeatures')
    sf = yoda_service.get_or_createObject(sf,sp.SamplingFeatureObj)
    setattr(sp,'SamplingFeatureID',sf.SamplingFeatureID)
    delattr(sp,'SamplingFeatureObj')
    return yoda_service.get_or_createObject(model,sp)

def getSpatialOffsets(model,so):
    uobj = getattr(models,'Units')
    if isinstance(so.Offset1UnitObj,basestring):
        print "Unit type is string. Need fix"
        setattr(so,'Offset1UnitID',1)
    else:
        u = yoda_service.get_or_createObject(uobj,so.Offset1UnitObj)
        setattr(so,'Offset1UnitID',u.UnitsID)
    if so.Offset2UnitObj == None:
        setattr(so,'Offset2UnitID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,so.Offset2UnitObj)
        setattr(so,'Offset2UnitID',u.UnitsID)
    if so.Offset3UnitObj == None:
        setattr(so,'Offset3UnitID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,so.Offset3UnitObj)
        setattr(so,'Offset3UnitID',u.UnitsID)
    delattr(so,'Offset1UnitObj')
    delattr(so,'Offset2UnitObj')
    delattr(so,'Offset3UnitObj')
    return yoda_service.get_or_createObject(model,so)

def getRelatedFeatures(model,rf):
    sfobj = getattr(models,'SamplingFeatures')
    sf = yoda_service.get_or_createObject(sfobj,rf.SamplingFeatureObj)
    setattr(rf,'SamplingFeatureID',sf.SamplingFeatureID)
    sf = yoda_service.get_or_createObject(sfobj,rf.RelatedFeatureObj)
    setattr(rf,'RelatedFeatureID',sf.SamplingFeatureID)
    if rf.SpatialOffsetObj != None:
        so = getattr(models,'SpatialOffsets')
        so = getSpatialOffsets(so,rf.SpatialOffsetObj)
        setattr(rf,'SpatialOffsetID',so.SpatialOffsetID)
    else:
        setattr(rf,'SpatialOffsetID',None)
    delattr(rf,'SamplingFeatureObj')
    delattr(rf,'RelatedFeatureObj')
    delattr(rf,'SpatialOffsetObj')
    return yoda_service.get_or_createObject(model,rf)

def getMethod(model,method):
    if hasattr(method, 'OrganizationObj'):
        if method.OrganizationObj != None:
            org = getattr(models,'Organizations')
            org = getOrganization(org,method.OrganizationObj)
            setattr(method, 'OrganizationID', org.OrganizationID)
        else:
            setattr(method, 'OrganizationID', None)
        delattr(method, 'OrganizationObj')                
    else:
        setattr(method, 'OrganizationID', None)
    return yoda_service.get_or_createObject(model,method)

def getAction(model,action):
    m = getattr(models,'Methods')
    m = getMethod(m,action.MethodObj)
    if action.BeginDateTime == None:
        print "BeginDateTime should be not NULL."
        delattr(action, 'BeginDateTime')
        #setattr(action, 'BeginDateTime', strftime("%Y-%m-%d %H:%M:%S"))
        setattr(action, 'BeginDateTime', '2015-04-28')
    if action.BeginDateTimeUTCOffset == None:        
        print "BeginDateTimeUTCOffset should be not NULL."
        delattr(action, 'BeginDateTimeUTCOffset')
        setattr(action, 'BeginDateTimeUTCOffset', -7)
    setattr(action, 'MethodID', m.MethodID)
    delattr(action, 'MethodObj')
    at = yoda_service.get_or_createObject(model,action)
    return at

def getFeatureAction(model,fa):
    sf = getattr(models,'SamplingFeatures')
    sf = yoda_service.get_or_createObject(sf,fa.SamplingFeatureObj)
    setattr(fa,'SamplingFeatureID',sf.SamplingFeatureID)
    delattr(fa,'SamplingFeatureObj')
    a = getattr(models,'Actions')
    a = getAction(a,fa.ActionObj)
    setattr(fa,'ActionID',a.ActionID)
    delattr(fa,'ActionObj')

    return yoda_service.get_or_createObject(model,fa)

def getActionBy(model,aby):
    a = getattr(models,'Actions')
    a = getAction(a,aby.ActionObj)
    setattr(aby,'ActionID',a.ActionID)
    delattr(aby,'ActionObj')
    af = getattr(models,'Affiliations')
    af = getAffiliations(af,aby.AffiliationObj)
    setattr(aby,'AffiliationID',af.AffiliationID)
    delattr(aby,'AffiliationObj')

    #if aby.IsActionLead:
    #    setattr(aby,"IsActionLead",1)
    #else:
    #    setattr(aby,"IsActionLead",0)

    return yoda_service.get_or_createObject(model,aby)

def getResults(model,r):
    fa = getattr(models,'FeatureActions')
    fa = getFeatureAction(fa,r.FeatureActionObj)
    setattr(r,'FeatureActionID',fa.FeatureActionID)
    delattr(r,'FeatureActionObj')
    v = getattr(models,'Variables')
    v = yoda_service.get_or_createObject(v,r.VariableObj)
    setattr(r,'VariableID',v.VariableID)
    delattr(r,'VariableObj')
    if isinstance(r.UnitsObj,basestring):
        print "Unit type is string. Need fix"
        setattr(r,'UnitsID',1)
    else:
        u = getattr(models,'Units')
        u = yoda_service.get_or_createObject(u,r.UnitsObj)
        setattr(r,'UnitsID',u.UnitsID)
    delattr(r,'UnitsObj')

    #implement later
    #if r.TaxonomicClassifierObj == None:
    #    setattr(r,'TaxonomicClassifierID',None)
    #    delattr(r,'TaxonomicClassifierObj')
    #else:
        #t = yoda_service.get_or_createTaxonomicclassifier(r.TaxonomicClassifierObj)
    setattr(r,'TaxonomicClassifierID',None)
    delattr(r,'TaxonomicClassifierObj')
    p = getattr(models,'ProcessingLevels')
    p = yoda_service.get_or_createObject(p,r.ProcessingLevelObj)
    setattr(r,'ProcessingLevelID',p.ProcessingLevelID)
    delattr(r,'ProcessingLevelObj')
    return yoda_service.get_or_createObject(model,r)

def getDatasetsResults(model,ds):
    d = getattr(models,'Datasets')
    d = yoda_service.get_or_createObject(d,ds.DatasetObj)
    setattr(ds,'DatasetID',d.DatasetID)
    delattr(ds,'DatasetObj')
    r = getattr(models,'Results')
    r = getResults(r,ds.ResultObj)
    setattr(ds,'ResultID',r.ResultID)
    delattr(ds,'ResultObj')
    return yoda_service.get_or_createObject(model,ds)

def getTimeSeriesResults(model,tr):
    r = getattr(models,'Results')
    r = getResults(r,tr.ResultObj)
    setattr(tr,'ResultID',r.ResultID)
    delattr(tr,'ResultObj')

    uobj = getattr(models,'Units')
    if tr.XLocationUnitsObj == None:
        setattr(tr,'XLocationUnitsID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,tr.XLocationUnitsObj)
        setattr(tr,'XLocationUnitsID',u.UnitsID)
    if tr.YLocationUnitsObj == None:
        setattr(tr,'YLocationUnitsID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,tr.YLocationUnitsObj)
        setattr(tr,'YLocationUnitsID',u.UnitsID)
    if tr.ZLocationUnitsObj == None:
        setattr(tr,'ZLocationUnitsID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,tr.ZLocationUnitsObj)
        setattr(tr,'ZLocationUnitsID',u.UnitsID)

    delattr(tr,'XLocationUnitsObj')
    delattr(tr,'YLocationUnitsObj')
    delattr(tr,'ZLocationUnitsObj')

    if tr.SpatialReferenceObj == None:
        setattr(tr,'SpatialReferenceID',None)
    else:
        sr = getattr(models,'SpatialReferences')
        sr = yoda_service.get_or_createObject(sr,tr.SpatialReferenceObj)
        setattr(tr,'SpatialReferenceID',sr.SpatialReferenceID)
    delattr(tr,'SpatialReferenceObj')
    
    if tr.IntendedTimeSpacingUnitsObj == None:
        setattr(tr,'IntendedTimeSpacingUnitsID',None)
    else:
        u = yoda_service.get_or_createObject(uobj,tr.IntendedTimeSpacingUnitsObj)
        setattr(tr,'IntendedTimeSpacingUnitsID',u.UnitsID)
    delattr(tr,'IntendedTimeSpacingUnitsObj')

    return yoda_service.get_or_createObject(model,tr)


def getTimeSeriesResultValues(trv,valueDateTime,valueDateTimeUTCOffset,dataValue):
    ts = getattr(models,'TimeSeriesResults')
    ts = getTimeSeriesResults(ts,trv.Result)
    setattr(trv,'ResultID',ts.ResultID)
    delattr(trv,'Result')
    delattr(trv,'ColumnNumber')
    delattr(trv,'ODM2Field')
    u = getattr(models,'Units')
    u = yoda_service.get_or_createObject(u,trv.TimeAggregationIntervalUnitsObj)
    setattr(trv,'TimeAggregationIntervalUnitsID',u.UnitsID)
    delattr(trv,'TimeAggregationIntervalUnitsObj')
    setattr(trv,'ValueDateTime',None)
    setattr(trv,'ValueDateTimeUTCOffset',None)
    setattr(trv,'DataValue',None)
    return yoda_service.get_or_createTimeSeriesResultValues(trv,valueDateTime,valueDateTimeUTCOffset,dataValue)

def main():

    #f = codecs.open('Specimen_Template_Working.yaml','r','utf-8',errors='ignore')
    f = codecs.open('Timeseries_Template_Working_my_version.yaml','r','utf-8',errors='ignore')
    dataMap = yaml.load(f)
    #dataMap = yaml.safe_load(f)
    f.close()

    #print dataMap
    s = obj(dataMap)

    for attr, value in s.__dict__.iteritems():
        #print attr,value
        if attr == 'Organizations':
            print "Organization:=============="
            for x in value:
                org = getattr(models,attr)
                org = getOrganization(org,x)
                print "OrganizationID:", org.OrganizationID

        elif attr == 'ExternalIdentifierSystems':
            print "ExternalIdentifierSystems:============"
            for x in value:
                eis = getattr(models,attr)
                eis = getExternalIdentifierSystems(eis,x)
                print "ExternalIdentifierSystemID:", eis.ExternalIdentifierSystemID

        elif attr == 'PersonExternalIdentifiers':
            print "PersonExternalIdentifiers:=========="
            for x in value:
                pei = getattr(models,attr)
                pei = getPersonExternalIdentifiers(pei,x)
                print "BridgeID:",pei.BridgeID

        elif attr == 'Affiliations':
            print "Affiliations:==========="
            for x in value:
                a = getattr(models,attr)            
                a = getAffiliations(a,x)
                print "AffiliationID:",a.AffiliationID

        elif attr == 'AuthorLists':
            print "AuthorLists:=============="
            for x in value:
                a = getattr(models,attr)            
                a = getAuthorLists(a,x)
                print "BridgeID:",a.BridgeID
    
        elif attr == 'DatasetCitations':
            print "DatasetCitations:================="
            for x in value:
                dc = getattr(models,attr)            
                dc = getDatasetCitations(dc,x)
                print "BridgeID:",dc.BridgeID

        elif attr == 'SamplingFeatureExternalIdentifiers':
            print "SamplingFeatureExternalIdentifiers:=========="
            for x in value:
                sfei = getattr(models,attr)            
                sfei = getSamplingFeatureExternalIdentifiers(sfei,x)
                print "BridgeID:",sfei.BridgeID

        elif attr == 'Sites':
            print "Sites:=============="
            for x in value:
                site = getattr(models,attr)            
                site = getSites(site,x)
                print "SamplingFeatureID:",site.SamplingFeatureID

        elif attr == 'Specimens':
            print "Specimens:================="
            for x in value:
                sp = getattr(models,attr)            
                sp = getSpecimens(sp,x)
                print "SamplingFeatureID:",sp.SamplingFeatureID

        elif attr == 'SpatialOffsets':
            print "SpatialOffsets:============="
            for x in value:
                so = getattr(models,attr)            
                so = getSpatialOffsets(so,x)
                print "SpatialOffsetID:",so.SpatialOffsetID

        elif attr == 'RelatedFeatures':
            print "RelatedFeatures:==========="
            for x in value:
                rf = getattr(models,attr)            
                rf = getRelatedFeatures(rf,x)
                print "RelationID:",rf.RelationID

        elif attr == 'Methods':
            print "Methods:=============="
            for x in value:
                m = getattr(models,attr)            
                m = getMethod(m,x)
                print "MethodID:",m.MethodID

        elif attr == 'Actions':
            print "Actions:==============="
            for x in value:
                a = getattr(models,attr)            
                a = getAction(a,x)
                print "ActionID:",a.ActionID

        elif attr == 'FeatureActions':
            print "FeatureActions:=============="
            for x in value:
                fa = getattr(models,attr)            
                fa = getFeatureAction(fa,x)
                print "FeatureActionID:",fa.FeatureActionID

        elif attr == 'ActionBy':
            print "ActionBy:================="
            for x in value:
                aby = getattr(models,attr)            
                aby = getActionBy(aby,x)
                print "BridgeID:",aby.ActionID

        elif attr == 'Results':
            print "Results:============"
            for x in value:
                rt = getattr(models,attr)            
                rt = getResults(rt,x)
                print "ResultID:", rt.ResultID

        elif attr == 'DatasetsResults':
            print "DatasetsResults:============="
            for x in value:
                ds = getattr(models,attr)            
                ds = getDatasetsResults(ds,x)
                print "BridgeID:",ds.BridgeID

        elif attr == 'TimeSeriesResults':
            print "TimeSeriesResults:=========="
            for x in value:
                tr = getattr(models,attr)            
                tr = getTimeSeriesResults(tr,x)
                print "ResultID:",tr.ResultID

        elif attr == 'TimeSeriesResultValues':
            print "TimeSeriesResultValues:=========="
            valuelist = [[] for i in xrange(len(value.ColumnDefinitions))]
            print "valuelist", len(valuelist)
            for x in value.Data:
                for i in range(len(x)):
                    for j in range(len(x[i])):
                        valuelist[j].append(x[i][j])
           
            for x in value.ColumnDefinitions:
                if hasattr(x, 'Result'):
                    trv = getTimeSeriesResultValues(x,valuelist[0],valuelist[1],valuelist[x.ColumnNumber-1])
                    print "ValueID:",trv.ValueID

        else:
            #if attr == 'Datasets' or attr == 'People' or attr == 'Citations' or attr == 'SpatialReferences' or attr == 'SamplingFeatures' or attr == 'Variables' or attr == 'ProcessingLevels':
            print "%s:==============" % attr
            if attr == 'YODA':
                continue
            for x in value:
                ds = getattr(models,attr)
                ds = yoda_service.get_or_createObject(ds,x)
                if attr == 'Datasets':
                    print "DatasetID:",ds.DatasetID
                if attr == 'People':
                    print "PersonID:", ds.PersonID
                if attr == 'Citations':
                    print "CitationID:",ds.CitationID
                if attr == 'SpatialReferences':
                    print "SpatialReferenceID:",ds.SpatialReferenceID
                if attr == 'SamplingFeatures':
                    print "SamplingFeatureID:", ds.SamplingFeatureID
                if attr == 'Variables':
                    print "VariableID:",ds.VariableID
                if attr == 'ProcessingLevels':
                    print "ProcessingLevelID:", ds.ProcessingLevelID

if __name__ == "__main__":
    main()

