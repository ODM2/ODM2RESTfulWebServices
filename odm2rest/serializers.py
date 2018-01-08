# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from collections import OrderedDict

from rest_framework.serializers import Serializer

import odm2api.ODM2.models as odm2_mod

from utils import get_col


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

# --- RelatedFeatures Serializer ---
RelatedFeatures_dct = get_sertype_dict(odm2_mod.RelatedFeatures)
RelatedFeatureSerializer = type(
    str('RelatedFeatureSerializer'),
    (Serializer,),
    RelatedFeatures_dct
)


# --- SamplingFeatures Serializer ---
SamplingFeatures_dct = get_sertype_dict(odm2_mod.SamplingFeatures)
SamplingFeatureSerializer = type(
    str('SamplingFeatureSerializer'),
    (Serializer,),
    SamplingFeatures_dct
)


# --- Specimens Serializer ---
Specimens_dct = get_sertype_dict(odm2_mod.Specimens)
SpecimensSerializer = type(
    str('SpecimensSerializer'),
    (Serializer,),
    Specimens_dct
)


# --- Sites Serializer ---
Sites_dct = get_sertype_dict(odm2_mod.Sites)
SitesSerializer = type(
    str('SitesSerializer'),
    (Serializer,),
    Sites_dct
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


# --- Action Serializer ---
Action_dct = get_sertype_dict(odm2_mod.Actions)
Action_dct.update({
    'Method': MethodSerializer()
})
ActionSerializer = type(
    str('ActionSerializer'),
    (Serializer,),
    Action_dct
)


# --- FeatureAction Serializer ---
# TODO: Need to make SamplingFeatureSerializer smarter!
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


# --- DataSetsResults Serializer ---
DataSetsResults_dct = get_sertype_dict(odm2_mod.DataSetsResults)
DataSetsResults_dct.update({
    'DataSet': DataSetSerializer(),
    'Result': ResultSerializer()
})

DataSetsResultsSerializer = type(
    str('DataSetsResultsSerializer'),
    (Serializer,),
    DataSetsResults_dct
)

# RESULT VALUES SERIALIZERS
# --- CategoricalResultValues Serializer ---
CategoricalResultValues_dct = get_sertype_dict(odm2_mod.CategoricalResultValues)
CategoricalResultValuesSerializer = type(
    str('CategoricalResultValuesSerializer'),
    (Serializer,),
    CategoricalResultValues_dct
)


# --- MeasurementResultValues Serializer ---
MeasurementResultValues_dct = get_sertype_dict(odm2_mod.MeasurementResultValues)
MeasurementResultValuesSerializer = type(
    str('MeasurementResultValuesSerializer'),
    (Serializer,),
    MeasurementResultValues_dct
)


# --- PointCoverageResultValues Serializer ---
PointCoverageResultValues_dct = get_sertype_dict(odm2_mod.PointCoverageResultValues)
PointCoverageResultValuesSerializer = type(
    str('PointCoverageResultValuesSerializer'),
    (Serializer,),
    PointCoverageResultValues_dct
)


# --- ProfileResultValues Serializer ---
ProfileResultValues_dct = get_sertype_dict(odm2_mod.ProfileResultValues)
ProfileResultValuesSerializer = type(
    str('ProfileResultValuesSerializer'),
    (Serializer,),
    ProfileResultValues_dct
)


# --- SectionResults Serializer ---
SectionResults_dct = get_sertype_dict(odm2_mod.SectionResults)
SectionResultsSerializer = type(
    str('SectionResultsSerializer'),
    (Serializer,),
    SectionResults_dct
)


# --- SpectraResultValues Serializer ---
SpectraResultValues_dct = get_sertype_dict(odm2_mod.SpectraResultValues)
SpectraResultValuesSerializer = type(
    str('SpectraResultValuesSerializer'),
    (Serializer,),
    SpectraResultValues_dct
)


# ---TimeSeriesResultValues Serializer ---
TimeSeriesResultValues_dct = get_sertype_dict(odm2_mod.TimeSeriesResultValues)
TimeSeriesResultValuesSerializer = type(
    str('TimeSeriesResultValuesSerializer'),
    (Serializer,),
    TimeSeriesResultValues_dct
)


# --- TrajectoryResultValues Serializer ---
TrajectoryResultValues_dct = get_sertype_dict(odm2_mod.TrajectoryResultValues)
TrajectoryResultValuesSerializer = type(
    str('TrajectoryResultValuesSerializer'),
    (Serializer,),
    TrajectoryResultValues_dct
)


# --- TransectResultValues Serializer ---
TransectResultValues_dct = get_sertype_dict(odm2_mod.TransectResultValues)
TransectResultValuesSerializer = type(
    str('TransectResultValuesSerializer'),
    (Serializer,),
    TransectResultValues_dct
)


# --- SamplingFeatureDatasets Serializers ---
DataSetRes_dct = get_sertype_dict(odm2_mod.DataSets)
DataSetRes_dct.update({
    'Results': ResultSerializer(many=True)
})
DataSetResSerializer = type(
    str('DataSetResSerializer'),
    (Serializer,),
    DataSetRes_dct
)

SamplingFeaturesDS_dct = get_sertype_dict(odm2_mod.SamplingFeatures)
SamplingFeaturesDS_dct.update({
    'Datasets': DataSetResSerializer(many=True),
})
SamplingFeatureDatasetSerializer = type(
    str('SamplingFeatureDatasetSerializer'),
    (Serializer,),
    SamplingFeaturesDS_dct
)
# --- FORSITES --
SitesDatasets_dct = get_sertype_dict(odm2_mod.Sites)
SitesDatasets_dct.update({
    'Datasets': DataSetResSerializer(many=True)
})
SitesDatasetSerializer = type(
    str('SitesDatasetSerializer'),
    (Serializer,),
    SitesDatasets_dct
)


# --- FOR SPECIMENS ---
SpecimensDatasets_dct = get_sertype_dict(odm2_mod.Specimens)
SpecimensDatasets_dct.update({
    'Datasets': DataSetResSerializer(many=True),
    'related_features': SamplingFeatureSerializer()

})
SpecimensDatasetSerializer = type(
    str('SpecimensDatasetSerializer'),
    (Serializer,),
    SpecimensDatasets_dct
)

# --------------------------------

