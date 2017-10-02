# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from rest_framework.serializers import Serializer

import odm2api.ODM2.models as odm2_mod

from utils import (get_col, OrderedDict)


def get_sertype_dict(odm2_model):
    '''
    Function to get serialization types for rest framework from sqlalchemy field types.

    :param odm2_model: ODM2 SQLAlchemy model.
    :return: Dictionary of field:type to create a Serializer object.
    '''
    dct = OrderedDict()
    for field, val in get_col(odm2_model, True):
        dct.update({
            field: val
        })

    return dct


# --- SamplingFeatures Serializer ---
SamplingFeatures_dct = get_sertype_dict(odm2_mod.SamplingFeatures)
SamplingFeatureSerializer = type(
    str('SamplingFeatureSerializer'),
    (Serializer,),
    SamplingFeatures_dct
)

# --- People Serializer ---
People_dct = get_sertype_dict(odm2_mod.People)
PeopleSerializer = type(
    str('PeopleSerializer'),
    (Serializer,),
    People_dct
)


# --- Organization Serializer ---
Organization_dct = get_sertype_dict(odm2_mod.Organizations)
OrganizationSerializer = type(
    str('OrganizationSerializer'),
    (Serializer,),
    Organization_dct
)


# --- Affiliations Serializer ---
Affiliations_dct = get_sertype_dict(odm2_mod.Affiliations)
Affiliations_dct.update({
    'Person':PeopleSerializer(),
    'Organization':OrganizationSerializer()
})
AffiliationSerializer = type(
    str('AffiliationSerializer'),
    (Serializer,),
    Affiliations_dct
)


# --- Variable Serializer ---
Variable_dct = get_sertype_dict(odm2_mod.Variables)
VariableSerializer = type(
    str('VariableSerializer'),
    (Serializer,),
    Variable_dct
)


# --- Unit Serializer ---
Unit_dct = get_sertype_dict(odm2_mod.Units)
UnitSerializer = type(
    str('UnitSerializer'),
    (Serializer,),
    Unit_dct
)


# --- Action Serializer ---
Action_dct = get_sertype_dict(odm2_mod.Actions)
ActionSerializer = type(
    str('ActionSerializer'),
    (Serializer,),
    Action_dct
)


# --- FeatureAction Serializer ---
FeatureAction_dct = get_sertype_dict(odm2_mod.FeatureActions)
FeatureAction_dct.update({
    'SamplingFeature':SamplingFeatureSerializer(),
    'Action':ActionSerializer()
})
FeatureActionSerializer = type(
    str('FeatureActionSerializer'),
    (Serializer,),
    FeatureAction_dct
)


# --- ProcessingLevel Serializer---
ProcessingLevel_dct = get_sertype_dict(odm2_mod.ProcessingLevels)
ProcessingLevelSerializer = type(
    str('ProcessingLevelSerializer'),
    (Serializer,),
    ProcessingLevel_dct
)


# --- TaxonomicClassifier Serializer---
TaxonomicClassifier_dct = get_sertype_dict(odm2_mod.TaxonomicClassifiers)
TaxonomicClassifierSerializer = type(
    str('TaxonomicClassifierSerializer'),
    (Serializer,),
    TaxonomicClassifier_dct
)


# --- Result Serializer ---
Result_dct = get_sertype_dict(odm2_mod.Results)
Result_dct.update({
    'FeatureAction': FeatureActionSerializer(),
    'ProcessingLevel': ProcessingLevelSerializer(),
    'TaxonomicClassifier': TaxonomicClassifierSerializer(),
    'Unit': UnitSerializer(),
    'Variable': VariableSerializer()
})
ResultSerializer = type(
    str('ResultSerializer'),
    (Serializer,),
    Result_dct
)
