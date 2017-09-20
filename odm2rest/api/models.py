# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


class Affiliation(object):

    def __init__(self, person, organization, poc, startdate, enddate, phone, email, address, web_link):
        self.Person = person
        self.Organization = organization
        self.IsPrimaryOrganizationContact = poc
        self.AffiliationStartDate = startdate
        self.AffiliationEndDate = enddate
        self.PrimaryPhone = phone
        self.PrimaryEmail = email
        self.PrimaryAddress = address
        self.PersonLink = web_link


class People(object):

    def __init__(self, firstname, middlename, lastname):
        self.PersonFirstName = firstname
        self.PersonMiddleName = middlename
        self.PersonLastName = lastname


class Organization(object):

    def __init__(self, org_type, code, name, description, web_link, parent_id):
        self.OrganizationTypeCV = org_type
        self.OrganizationCode = code
        self.OrganizationName = name
        self.OrganizationDescription = description
        self.OrganizationLink = web_link

        self.ParentOrganizationID = parent_id


class Result(object):

    def __init__(self, uuid, feat_act, res_type,
                 var, unit, tax_class, dt, dt_utc_off,
                 v_dt, v_dt_utc_off, status, sm, val_cnt, proc_lvl):

        self.ResultUUID = uuid
        self.FeatureAction = feat_act
        self.ResultTypeCV = res_type
        self.Variable = var
        self.Unit = unit
        self.TaxonomicClassifier = tax_class
        self.ResultDateTime = dt
        self.ResultDateTimeUTCOffset = dt_utc_off
        self.ValidDateTime = v_dt
        self.ValidDateTimeUTCOffset = v_dt_utc_off
        self.StatusCV = status
        self.SampledMediumCV = sm
        self.ValueCount = val_cnt
        self.ProcessingLevel = proc_lvl


class Variable(object):

    def __init__(self, name, var_type, nd, spec, var_def, code):
        self.VariableNameCV = name
        self.VariableTypeCV = var_type
        self.NoDataValue = nd
        self.Speciation = spec
        self.VariableDefinition = var_def
        self.VariableCode = code


class Unit(object):

    def __init__(self, unit_type, abbv, name, link):
        self.UnitsTypeCV = unit_type
        self.UnitsAbbreviation = abbv
        self.UnitsName = name
        self.UnitsLink = link


class FeatureAction(object):

    def __init__(self, sf, act):
        self.SamplingFeature = sf
        self.Action = act


class ProcessingLevel(object):

    def __init__(self, code, pl_def, exp):
        self.ProcessingLevelCode = code
        self.Definition = pl_def
        self.Explanation = exp


class TaxonomicClassifier(object):

    def __init__(self, tc_type, name, com_name, desc, pt_id):
        self.TaxonomicClassifierTypeCV = tc_type
        self.TaxonomicClassifierName = name
        self.TaxonomicClassifierCommonName = com_name
        self.TaxonomicClassifierDescription = desc
        self.ParentTaxonomicClassifierID = pt_id
