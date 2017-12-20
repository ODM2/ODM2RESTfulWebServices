# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from django.core.management import settings

import pandas as pd

from sqlalchemy.engine.url import URL

from odm2api.ODMconnection import dbconnection
from odm2api.ODM2.services.readService import ReadODM2
import odm2api.ODM2.models as odm2_models

from utils import get_vals

from serializers import (
    AffiliationSerializer,
    PeopleSerializer,
    ResultSerializer,
    SamplingFeatureSerializer,
    DataSetSerializer,
    CategoricalResultValuesSerializer,
    MeasurementResultValuesSerializer,
    PointCoverageResultValuesSerializer,
    ProfileResultValuesSerializer,
    ProcessingLevelSerializer,
    SectionResultsSerializer,
    SpectraResultValuesSerializer,
    TimeSeriesResultValuesSerializer,
    TrajectoryResultValuesSerializer,
    TransectResultValuesSerializer,
    DataSetsResultsSerializer,
    SitesSerializer,
    SpecimensSerializer,
    MethodSerializer,
    ActionSerializer,
    VariableSerializer,
    UnitSerializer,
    OrganizationSerializer,
    SamplingFeatureDatasetSerializer,
    SpecimensDatasetSerializer,
    SitesDatasetSerializer,
    RelatedFeatureSerializer

)

db_settings = {
    'drivername': settings.ODM2DATABASE['engine'],
    'username': settings.ODM2DATABASE['user'],
    'password': settings.ODM2DATABASE['password'],
    'host': settings.ODM2DATABASE['address'],
    'port': settings.ODM2DATABASE['port'],
    'database': settings.ODM2DATABASE['db']
}

SESSION_FACTORY = dbconnection.createConnectionFromString(str(URL(**db_settings)))
READ = ReadODM2(SESSION_FACTORY)


def db_check():
    db_session = SESSION_FACTORY.getSession()
    try:
        db_session.query(odm2_models.SamplingFeatures).first()
    except:
        print('Rolling Back...')
        db_session.rollback()
    finally:
        pass


# Model creators ---
def result_creator(res):
    res_dct = get_vals(res)

    act_obj = res.FeatureActionObj.ActionObj

    # Get methods
    m_dct = get_vals(act_obj.MethodObj)

    # Get Organization
    orgs_dct = None
    if act_obj.MethodObj.OrganizationObj:
        orgs_dct = get_vals(act_obj.MethodObj.OrganizationObj)
    m_dct.update({
        'Organization': orgs_dct
    })

    a_dct = get_vals(res.FeatureActionObj.ActionObj)

    a_dct.update({
        'Method': m_dct
    })

    # Get Feature Action ----
    feat_act_dct = get_vals(res.FeatureActionObj)
    feat_act_dct.update({
        'SamplingFeature': get_vals(res.FeatureActionObj.SamplingFeatureObj),
        'Action': a_dct
    })
    # ------------------------

    # Get taxonomic classifier
    taxo_dct = None
    if res.TaxonomicClassifierObj:
        taxo_dct = get_vals(res.TaxonomicClassifierObj)

    res_dct.update({
        'FeatureAction': feat_act_dct,
        'ProcessingLevel': get_vals(res.ProcessingLevelObj),
        'TaxonomicClassifier': taxo_dct,
        'Unit': get_vals(res.UnitsObj),
        'Variable': get_vals(res.VariableObj)
    })

    return res_dct


def samplingfeaturedatasets_creator(sfd):
    ds = sfd.datasets.keys()
    related = sfd.related_features
    all_ds = []
    # all_related = []
    for d in ds:
        ds_dct = get_vals(d)
        ds_dct.update({
            u'Results': [result_creator(r) for r in sfd.datasets[d]]
        })
        all_ds.append(ds_dct)
    # related_dct = get_vals(r)
    # all_related.append(related_dct)
    sf = READ.getSamplingFeatures([sfd.SamplingFeatureID])[0]
    sf_dct = get_vals(sf)

    related_vals = None
    if related:
        related_vals = get_vals(related)

    sf_dct.update({
        u'Datasets': all_ds,
        u'related_features': related_vals
    })

    return sf_dct
# ---


def get_affiliations(**kwargs):
    db_check()
    ids = None
    if kwargs.get('affiliationID'):
        ids = [int(i) for i in kwargs.get('affiliationID').split(',')]
    person_first = kwargs.get('firstName')
    person_last = kwargs.get('lastName')
    org_code = kwargs.get('organizationCode')

    Affs = READ.getAffiliations(ids=ids,
                         personfirst=person_first,
                         personlast=person_last,
                         orgcode=org_code)

    Aff_list = []

    for aff in Affs:
        aff_dct = get_vals(aff)

        orgs_dct = None
        if aff.OrganizationObj:
            orgs_dct = get_vals(aff.OrganizationObj)

        aff_dct.update({
            'Person':get_vals(aff.PersonObj),
            'Organization': orgs_dct
        })

        Aff_list.append(
            AffiliationSerializer(aff_dct).data
        )

    return Aff_list


def get_people(**kwargs):
    db_check()
    ids = None
    if kwargs.get('peopleID'):
        ids = [int(i) for i in kwargs.get('peopleID').split(',')]
    person_first = kwargs.get('firstName')
    person_last = kwargs.get('lastName')

    Ppl = READ.getPeople(ids=ids,
                         firstname=person_first,
                         lastname=person_last)

    Ppl_list = []
    for person in Ppl:
        ppl_dct = get_vals(person)
        Ppl_list.append(
            PeopleSerializer(ppl_dct).data
        )

    return Ppl_list


def get_results(**kwargs):
    db_check()
    ids = None
    uuids = None
    if kwargs.get('resultID'):
        ids = [int(i) for i in kwargs.get('resultID').split(',')]
    if kwargs.get('resultUUID'):
        uuids = kwargs.get('resultUUID').split(',')
    result_type = kwargs.get('resultType')
    act_id = kwargs.get('actionID')
    sf_id = kwargs.get('samplingFeatureID')
    site_id = kwargs.get('siteID')
    var_id = kwargs.get('variableID')
    sim_id = kwargs.get('simulationID')

    Results = READ.getResults(ids=ids,
                              type=result_type,
                              uuids=uuids,
                              actionid=act_id,
                              simulationid=sim_id,
                              sfid=sf_id,
                              variableid=var_id,
                              siteid=site_id)

    Results_list = []
    for res in Results:
        Serializer = ResultSerializer(result_creator(res))
        if res.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV == 'Specimen':
            Serializer.fields['FeatureAction'].fields['SamplingFeature'] = SpecimensSerializer()
        if res.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV == 'Site':
            Serializer.fields['FeatureAction'].fields['SamplingFeature'] = SitesSerializer()
        Results_list.append(
            Serializer.data
        )

    return Results_list


def get_samplingfeatures(**kwargs):
    db_check()
    ids = None
    codes = None
    uuids = None
    if kwargs.get('samplingFeatureID'):
        ids = [int(i) for i in kwargs.get('samplingFeatureID').split(',')]
    if kwargs.get('samplingFeatureUUID'):
        uuids = kwargs.get('samplingFeatureUUID').split(',')
    if kwargs.get('samplingFeatureCode'):
        codes = kwargs.get('samplingFeatureCode').split(',')

    sf_type = kwargs.get('samplingFeatureType')
    res = kwargs.get('results')

    if type(res) in [str, unicode]:
        if res.upper() == 'TRUE':
            res = True
        else:
            res = False

    sampling_features = READ.getSamplingFeatures(ids=ids,
                                                 codes=codes,
                                                 uuids=uuids,
                                                 type=sf_type,
                                                 wkt=None,
                                                 results=res)

    sf_list = []
    for sf in sampling_features:
        sf_dct = get_vals(sf)
        serialized = SamplingFeatureSerializer(sf_dct).data
        if sf.SamplingFeatureTypeCV == 'Site':
            serialized = SitesSerializer(sf_dct).data
        if sf.SamplingFeatureTypeCV == 'Specimen':
            serialized = SpecimensSerializer(sf_dct).data

        sf_list.append(
            serialized
        )

    return sf_list


def get_samplingfeaturedatasets(**kwargs):
    db_check()
    ids = None
    codes = None
    uuids = None
    if kwargs.get('samplingFeatureID'):
        ids = [int(i) for i in kwargs.get('samplingFeatureID').split(',')]
    if kwargs.get('samplingFeatureUUID'):
        uuids = kwargs.get('samplingFeatureUUID').split(',')
    if kwargs.get('samplingFeatureCode'):
        codes = kwargs.get('samplingFeatureCode').split(',')

    sf_type = kwargs.get('samplingFeatureType')

    ds_type = kwargs.get('dataSetType')

    dataSetResults = READ.getSamplingFeatureDatasets(ids=ids,
                                                     codes=codes,
                                                     uuids=uuids,
                                                     dstype=ds_type,
                                                     sftype=sf_type)

    dsr_list = []
    for dsr in dataSetResults:
        SFDSerializer = SamplingFeatureDatasetSerializer(samplingfeaturedatasets_creator(dsr))
        if dsr.SamplingFeatureTypeCV == 'Specimen':
            SFDSerializer = SpecimensDatasetSerializer(samplingfeaturedatasets_creator(dsr))
            SFDSerializer.fields['Datasets'].child.fields['Results'].child.fields['FeatureAction'].fields['SamplingFeature'] = SpecimensSerializer()  # noqa
            if dsr.related_features.SamplingFeatureTypeCV == 'Site':
                SFDSerializer.fields['related_features'] = SitesSerializer()
        if dsr.SamplingFeatureTypeCV == 'Site':
            SFDSerializer = SitesDatasetSerializer(samplingfeaturedatasets_creator(dsr))
            SFDSerializer.fields['Datasets'].child.fields['Results'].child.fields['FeatureAction'].fields['SamplingFeature'] = SitesSerializer()  # noqa
        dsr_list.append(
            SFDSerializer.data
        )

    return dsr_list


def get_datasets(**kwargs):
    codes = kwargs.get('datasetCode')
    uuids = kwargs.get('datasetUUID')

    if codes:
        codes = codes.split(',')
    if uuids:
        uuids = uuids.split(',')

    datasets = READ.getDataSets(codes=codes, uuids=uuids)
    ds_list = []
    for ds in datasets:
        ds_dct = get_vals(ds)
        ds_list.append(
            DataSetSerializer(ds_dct).data
        )

    return ds_list


def get_datasetsvalues(**kwargs):
    db_check()
    ids = kwargs.get('datasetID')
    codes = kwargs.get('datasetCode')
    uuids = kwargs.get('datasetUUID')
    ds_type = kwargs.get('datasetType')
    starttime = kwargs.get('beginDate')
    endtime = kwargs.get('endDate')

    if ids:
        ids = [int(i) for i in kwargs.get('datasetID').split(',')]
    if uuids:
        uuids = kwargs.get('datasetUUID').split(',')
    if codes:
        codes = kwargs.get('datasetCode').split(',')

    dataSetsValues = READ.getDataSetsValues(ids=ids,
                                            codes=codes,
                                            uuids=uuids,
                                            dstype=ds_type)

    dsr_val = []
  
    if isinstance(dataSetsValues, pd.DataFrame):
        res = READ.getResults(ids=list(dataSetsValues.resultid.values))[0]
        res_type = res.ResultTypeCV.lower()

        RVSerializer = None
        if 'category' in res_type.lower():
            RVSerializer = CategoricalResultValuesSerializer
        elif 'measurement' in res_type.lower():
            RVSerializer = MeasurementResultValuesSerializer
        elif 'point' in res_type.lower():
            RVSerializer = PointCoverageResultValuesSerializer
        elif 'profile' in res_type.lower():
            RVSerializer = ProfileResultValuesSerializer
        elif 'section' in res_type.lower():
            RVSerializer = SectionResultsSerializer
        elif 'spectra' in res_type.lower():
            RVSerializer = SpectraResultValuesSerializer
        elif 'time' in res_type.lower():
            RVSerializer = TimeSeriesResultValuesSerializer
        elif 'trajectory' in res_type.lower():
            RVSerializer = TrajectoryResultValuesSerializer
        elif 'transect' in res_type.lower():
            RVSerializer = TransectResultValuesSerializer

        dsr_val = [RVSerializer(r.to_dict()).data for idx, r in dataSetsValues.iterrows()]

    return dsr_val


def get_datasetresults(**kwargs):
    db_check()
    ids = kwargs.get('datasetID')
    codes = kwargs.get('datasetCode')
    uuids = kwargs.get('datasetUUID')
    if ids:
        ids = [int(i) for i in kwargs.get('datasetID').split(',')]
    if uuids:
        uuids = kwargs.get('datasetUUID').split(',')
    if codes:
        codes = kwargs.get('datasetCode').split(',')

    ds_type = kwargs.get('datasetType')

    dataSetResults = READ.getDataSetsResults(ids=ids,
                                             codes=codes,
                                             uuids=uuids,
                                             dstype=ds_type)

    dsr_list = []
    for dsr in dataSetResults:
        dsr_dct = get_vals(dsr)

        ds_dct = get_vals(dsr.DataSetObj)

        res_dct = result_creator(dsr.ResultObj)

        dsr_dct.update({
            'Result': res_dct,
            'DataSet': ds_dct
        })

        Serializer = DataSetsResultsSerializer(dsr_dct)
        if dsr.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV == 'Specimen':
            Serializer.fields['Result'].fields['FeatureAction'].fields['SamplingFeature'] = SpecimensSerializer()
        if dsr.ResultObj.FeatureActionObj.SamplingFeatureObj.SamplingFeatureTypeCV == 'Site':
            Serializer.fields['Result'].fields['FeatureAction'].fields['SamplingFeature'] = SitesSerializer()

        dsr_list.append(
            Serializer.data
        )

    return dsr_list


def get_resultvalues(**kwargs):
    # Result Values doesn't use model,
    # it outputs dataframe,
    # therefore can be serialized directly

    ids = kwargs.get('resultID')
    starttime = kwargs.get('beginDate')
    endtime = kwargs.get('endDate')

    if ids:
        ids = [int(i) for i in ids.split(',')]

    result_values = READ.getResultValues(resultids=ids,
                                         starttime=starttime,
                                         endtime=endtime)

    res_val = []
    if isinstance(result_values, pd.DataFrame):
        res = READ.getResults(ids=[ids[0]])[0]
        res_type = res.ResultTypeCV

        RVSerializer = None
        if 'category' in res_type.lower():
            RVSerializer = CategoricalResultValuesSerializer
        elif 'measurement' in res_type.lower():
            RVSerializer = MeasurementResultValuesSerializer
        elif 'point' in res_type.lower():
            RVSerializer = PointCoverageResultValuesSerializer
        elif 'profile' in res_type.lower():
            RVSerializer = ProfileResultValuesSerializer
        elif 'section' in res_type.lower():
            RVSerializer = SectionResultsSerializer
        elif 'spectra' in res_type.lower():
            RVSerializer = SpectraResultValuesSerializer
        elif 'time' in res_type.lower():
            RVSerializer = TimeSeriesResultValuesSerializer
        elif 'trajectory' in res_type.lower():
            RVSerializer = TrajectoryResultValuesSerializer
        elif 'transect' in res_type.lower():
            RVSerializer = TransectResultValuesSerializer

        res_val = [RVSerializer(r.to_dict()).data for idx, r in result_values.iterrows()]

    return res_val


def get_methods(**kwargs):
    ids = kwargs.get('methodID')
    codes = kwargs.get('methodCode')
    mtype = kwargs.get('methodType')

    if ids:
        ids = [int(i) for i in ids.split(',')]
    if codes:
        codes = codes.split(',')

    methods = READ.getMethods(ids=ids,
                              codes=codes,
                              type=mtype)
    m_list = []
    for m in methods:
        m_dct = get_vals(m)

        orgs_dct = None
        if m.OrganizationObj:
            orgs_dct = get_vals(m.OrganizationObj)

        m_dct.update({
            'Organization': orgs_dct
        })
        m_list.append(
            MethodSerializer(m_dct).data
        )

    return m_list


def get_actions(**kwargs):
    # TODO: Get relationship to affiliations via ActionBy, currently not in API
    ids = kwargs.get('actionID')
    acttype = kwargs.get('actionType')
    sfid = kwargs.get('samplingFeatureID')

    if ids:
        ids = [int(i) for i in ids.split(',')]

    actions = READ.getActions(ids=ids,
                              type=acttype,
                              sfid=sfid)

    act_list = []
    for a in actions:
        a_dct = get_vals(a)

        # Get methods
        m_dct = get_vals(a.MethodObj)

        orgs_dct = None
        if a.MethodObj.OrganizationObj:
            orgs_dct = get_vals(a.MethodObj.OrganizationObj)

        m_dct.update({
            'Organization': orgs_dct
        })

        a_dct.update({
            'Method': m_dct
        })

        act_list.append(
            ActionSerializer(a_dct).data
        )

    return act_list

def get_variables(**kwargs):
    db_check()
    ids = kwargs.get('variableID')
    codes = kwargs.get('variableCode')
    sitecode = kwargs.get('siteCode')

    if ids:
        ids = [int(i) for i in ids.split(',')]
    if codes:
        codes = codes.split(',')

    res = kwargs.get('results')

    if type(res) in [str, unicode]:
        if res.upper() == 'TRUE':
            res = True
        else:
            res = False

    varibles = READ.getVariables(ids=ids,
                                 codes=codes,
                                 sitecode=sitecode,
                                 results=res)

    vars_list = []
    for var in varibles:
        var_dct = get_vals(var)
        vars_list.append(
            VariableSerializer(var_dct).data
        )

    return vars_list

def get_units(**kwargs):
    db_check()
    ids = kwargs.get('unitsID')
    name = kwargs.get('unitsName')
    unitstype = kwargs.get('unitsType')

    if ids:
        ids = [int(i) for i in ids.split(',')]

    units = READ.getUnits(ids=ids,
                          name=name,
                          type=unitstype)

    units_list = []
    for u in units:
        units_dct = get_vals(u)
        units_list.append(
            UnitSerializer(units_dct).data
        )

    return units_list


def get_organizations(**kwargs):
    ids = kwargs.get('organizationID')
    codes = kwargs.get('organizationCode')

    if ids:
        ids = [int(i) for i in ids.split(',')]
    if codes:
        codes = codes.split(',')

    organizations = READ.getOrganizations(ids=ids,
                                          codes=codes)

    orgs_list = []
    for org in organizations:
        org_dct = get_vals(org)
        orgs_list.append(
            OrganizationSerializer(org_dct).data
        )

    return orgs_list


def get_processinglevels(**kwargs):
    ids = kwargs.get('processingLevelID')
    codes = kwargs.get('processingLevelCode')

    if ids:
        ids = [int(i) for i in ids.split(',')]
    if codes:
        codes = codes.split(',')

    proclevels = READ.getProcessingLevels(ids=ids,
                                          codes=codes)

    pl_list = []
    for pl in proclevels:
        pl_dct = get_vals(pl)
        pl_list.append(
            ProcessingLevelSerializer(pl_dct).data
        )

    return pl_list
