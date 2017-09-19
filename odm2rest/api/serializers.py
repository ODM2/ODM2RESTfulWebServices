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


class PersonSerializer(Serializer):
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
    Person = PersonSerializer()
    Organization = OrganizationSerializer()
    IsPrimaryOrganizationContact = BooleanField()
    AffiliationStartDate = DateTimeField()
    AffiliationEndDate = DateTimeField()
    PrimaryPhone = CharField()
    PrimaryEmail = CharField()
    PrimaryAddress = CharField()
    PersonLink = CharField()
