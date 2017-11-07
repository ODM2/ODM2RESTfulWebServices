# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from collections import OrderedDict

from rest_framework.serializers import Serializer

import odm2api.ODM2.models as odm2_mod

from utils import (get_col, lower_keys)


def get_sertype_dict(odm2_model):
    """
    Function to get serialization types for rest framework from sqlalchemy field types.

    Args:
        odm2_model (object):  ODM2 SQLAlchemy model class object.

    Returns:
        dict: Dictionary of {field:type} to create a Serializer object.

    """
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
    'Person': PeopleSerializer(),
    'Organization': OrganizationSerializer()
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


# --- Method Serializer ---
Method_dct = get_sertype_dict(odm2_mod.Methods)
Method_dct.update({
    'Organization': OrganizationSerializer()
})
MethodSerializer = type(
    str('MethodSerializer'),
    (Serializer,),
    Method_dct
)


# --- FeatureAction Serializer ---
FeatureAction_dct = get_sertype_dict(odm2_mod.FeatureActions)
FeatureAction_dct.update({
    'SamplingFeature': SamplingFeatureSerializer(),
    'Action': ActionSerializer()
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


# --- DataSets Serializer ---
DataSet_dct = get_sertype_dict(odm2_mod.DataSets)
DataSetSerializer = type(
    str('DataSetSerializer'),
    (Serializer,),
    DataSet_dct
)

# RESULT VALUES SERIALIZERS
# --- CategoricalResultValues Serializer ---
CategoricalResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.CategoricalResultValues))
CategoricalResultValuesSerializer = type(
    str('CategoricalResultValuesSerializer'),
    (Serializer,),
    CategoricalResultValues_dct
)


# --- MeasurementResultValues Serializer ---
MeasurementResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.MeasurementResultValues))
MeasurementResultValuesSerializer = type(
    str('MeasurementResultValuesSerializer'),
    (Serializer,),
    MeasurementResultValues_dct
)


# --- PointCoverageResultValues Serializer ---
PointCoverageResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.PointCoverageResultValues))
PointCoverageResultValuesSerializer = type(
    str('PointCoverageResultValuesSerializer'),
    (Serializer,),
    PointCoverageResultValues_dct
)


# --- ProfileResultValues Serializer ---
ProfileResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.ProfileResultValues))
ProfileResultValuesSerializer = type(
    str('ProfileResultValuesSerializer'),
    (Serializer,),
    ProfileResultValues_dct
)


# --- SectionResults Serializer ---
SectionResults_dct = lower_keys(get_sertype_dict(odm2_mod.SectionResults))
SectionResultsSerializer = type(
    str('SectionResultsSerializer'),
    (Serializer,),
    SectionResults_dct
)


# --- SpectraResultValues Serializer ---
SpectraResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.SpectraResultValues))
SpectraResultValuesSerializer = type(
    str('SpectraResultValuesSerializer'),
    (Serializer,),
    SpectraResultValues_dct
)


# ---TimeSeriesResultValues Serializer ---
TimeSeriesResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.TimeSeriesResultValues))
TimeSeriesResultValuesSerializer = type(
    str('TimeSeriesResultValuesSerializer'),
    (Serializer,),
    TimeSeriesResultValues_dct
)


# --- TrajectoryResultValues Serializer ---
TrajectoryResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.TrajectoryResultValues))
TrajectoryResultValuesSerializer = type(
    str('TrajectoryResultValuesSerializer'),
    (Serializer,),
    TrajectoryResultValues_dct
)


# --- TransectResultValues Serializer ---
TransectResultValues_dct = lower_keys(get_sertype_dict(odm2_mod.TransectResultValues))
TransectResultValuesSerializer = type(
    str('TransectResultValuesSerializer'),
    (Serializer,),
    TransectResultValues_dct
)
