# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from django.core.management import settings

from odm2api.ODMconnection import dbconnection
from odm2api.ODM2.services.readService import ReadODM2

from models import (
    Affiliation,
    Organization,
    People,
    Result,
    Variable,
    Unit,
    FeatureAction,
    ProcessingLevel,
    TaxonomicClassifier
)

SESSION_FACTORY = dbconnection.createConnection(**settings.ODM2DATABASE)
READ = ReadODM2(SESSION_FACTORY)


def get_affiliations(**kwargs):
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
        organization = None
        if aff.OrganizationObj:
            organization = Organization(
                    org_type=aff.OrganizationObj.OrganizationTypeCV,
                    code=aff.OrganizationObj.OrganizationCode,
                    name=aff.OrganizationObj.OrganizationName,
                    description=aff.OrganizationObj.OrganizationDescription,
                    web_link=aff.OrganizationObj.OrganizationLink,
                    parent_id=aff.OrganizationObj.ParentOrganizationID
                )
        Aff_list.append(
            Affiliation(
                person=People(
                    firstname=aff.PersonObj.PersonFirstName,
                    middlename=aff.PersonObj.PersonMiddleName,
                    lastname=aff.PersonObj.PersonLastName
                ),
                organization=organization,
                poc=aff.IsPrimaryOrganizationContact,
                startdate=aff.AffiliationStartDate,
                enddate=aff.AffiliationEndDate,
                phone=aff.PrimaryPhone,
                email=aff.PrimaryEmail,
                address=aff.PrimaryAddress,
                web_link=aff.PersonLink
            )
        )

    return Aff_list


def get_people(**kwargs):
    ids = None
    if kwargs.get('peopleID'):
        ids = [int(i) for i in kwargs.get('peopleID').split(',')]
    person_first = kwargs.get('firstName')
    person_last = kwargs.get('lastName')

    print(person_first, person_last)

    Ppl = READ.getPeople(ids=ids,
                         firstname=person_first,
                         lastname=person_last)

    Ppl_list = []

    for person in Ppl:
        Ppl_list.append(
            People(
                firstname=person.PersonFirstName,
                middlename=person.PersonMiddleName,
                lastname=person.PersonLastName
            )
        )

    return Ppl_list


def get_results(**kwargs):
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
        tax_class = None
        feat_act = FeatureAction(
            sf=res.FeatureActionObj.SamplingFeatureObj.SamplingFeatureCode,
            act=res.FeatureActionObj.ActionObj.ActionTypeCV
        )

        var = Variable(
            name=res.VariableObj.VariableNameCV,
            var_type=res.VariableObj.VariableTypeCV,
            nd=res.VariableObj.NoDataValue,
            spec=res.VariableObj.SpeciationCV,
            var_def=res.VariableObj.VariableDefinition,
            code=res.VariableObj.VariableCode
        )

        unit = Unit(
            unit_type=res.UnitsObj.UnitsTypeCV,
            abbv=res.UnitsObj.UnitsAbbreviation,
            name=res.UnitsObj.UnitsName,
            link=res.UnitsObj.UnitsLink
        )

        if res.TaxonomicClassifierObj:
            tax_class = TaxonomicClassifier(
                tc_type=res.TaxonomicClassifierObj.TaxonomicClassifierTypeCV,
                name=res.TaxonomicClassifierObj.TaxonomicClassifierName,
                com_name=res.TaxonomicClassifierObj.TaxonomicClassifierCommonName,
                desc=res.TaxonomicClassifierObj.TaxonomicClassifierDescription,
                pt_id=res.TaxonomicClassifierObj.ParentTaxonomicClassifierID
            )

        proc_lvl = ProcessingLevel(
            code=res.ProcessingLevelObj.ProcessingLevelCode,
            pl_def=res.ProcessingLevelObj.Definition,
            exp=res.ProcessingLevelObj.Explanation
        )
        Results_list.append(
            Result(
                uuid=str(res.ResultUUID),
                feat_act=feat_act,
                res_type=res.ResultTypeCV,
                var=var,
                unit=unit,
                tax_class=tax_class,
                dt=res.ResultDateTime,
                dt_utc_off=res.ResultDateTimeUTCOffset,
                v_dt=res.ValidDateTime,
                v_dt_utc_off=res.ValidDateTimeUTCOffset,
                status=res.StatusCV,
                sm=res.SampledMediumCV,
                val_cnt=res.ValueCount,
                proc_lvl=proc_lvl
            )
        )

    return Results_list