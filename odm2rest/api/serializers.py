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


class AffiliationsSerializer(Serializer):
    Person = PeopleSerializer()
    Organization = OrganizationSerializer()
    IsPrimaryOrganizationContact = BooleanField()
    AffiliationStartDate = DateTimeField()
    AffiliationEndDate = DateTimeField()
    PrimaryPhone = CharField()
    PrimaryEmail = CharField()
    PrimaryAddress = CharField()
    PersonLink = CharField()
