# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from rest_framework.fields import (
    BooleanField,
    CharField,
    DateTimeField,
    DecimalField,
    FloatField,
    IntegerField,
)

from rest_framework.serializers import Serializer

# Reference for serialization mapping
# Resource: https://github.com/dealertrack/djangorest-alchemy/blob/master/djangorest_alchemy/serializers.py
# sqlalchemy: restframework
# field_mapping = {
#         String: CharField,
#         INTEGER: IntegerField,
#         SMALLINT: IntegerField,
#         BIGINT: IntegerField,
#         VARCHAR: CharField,
#         CHAR: CharField,
#         TIMESTAMP: DateTimeField,
#         DATE: DateTimeField,
#         Float: FloatField,
#         BigInteger: IntegerField,
#         Numeric: IntegerField,
#         DateTime: DateTimeField,
#         Boolean: BooleanField,
#         CLOB: CharField,
#         DECIMAL: DecimalField,
# }


class PeopleSerializer(Serializer):
    PersonFirstName = CharField()
    PersonMiddleName = CharField()
    PersonLastName = CharField()


class OrganizationSerializer(Serializer):
    OrganizationTypeCV = CharField()
    OrganizationCode = CharField()
    OrganizationName = CharField()
    OrganizationDescription = CharField()
    OrganizationLink = CharField()

    ParentOrganizationID = IntegerField()


class AffiliationSerializer(Serializer):
    Person = PeopleSerializer()
    Organization = OrganizationSerializer()
    IsPrimaryOrganizationContact = BooleanField()
    AffiliationStartDate = DateTimeField()
    AffiliationEndDate = DateTimeField()
    PrimaryPhone = CharField()
    PrimaryEmail = CharField()
    PrimaryAddress = CharField()
    PersonLink = CharField()


class VariableSerializer(Serializer):
    VariableNameCV = CharField()
    VariableTypeCV = CharField()
    NoDataValue = FloatField()
    Speciation = CharField()
    VariableDefinition = CharField()
    VariableCode = CharField()


class UnitSerializer(Serializer):
    UnitsTypeCV = CharField()
    UnitsAbbreviation = CharField()
    UnitsName = CharField()
    UnitsLink = CharField()


class FeatureActionSerializer(Serializer):
    SamplingFeature = CharField()
    Action = CharField()


class ProcessingLevelSerializer(Serializer):
    ProcessingLevelCode = CharField()
    Definition = CharField()
    Explanation = CharField()


class TaxonomicClassifierSerializer(Serializer):
    TaxonomicClassifierTypeCV = CharField()
    TaxonomicClassifierName = CharField()
    TaxonomicClassifierCommonName = CharField()
    TaxonomicClassifierDescription = CharField()
    ParentTaxonomicClassifierID = IntegerField()


class ResultSerializer(Serializer):
    ResultUUID = CharField()
    FeatureAction = FeatureActionSerializer()
    ResultTypeCV = CharField()
    Variable = VariableSerializer()
    Unit = UnitSerializer()
    TaxonomicClassifier = TaxonomicClassifierSerializer()
    ResultDateTime = DateTimeField()
    ResultDateTimeUTCOffset = IntegerField()
    ValidDateTime = DateTimeField()
    ValidDateTimeUTCOffset = IntegerField()
    StatusCV = CharField()
    SampledMediumCV = CharField()
    ValueCount = IntegerField()
    ProcessingLevel = ProcessingLevelSerializer()
