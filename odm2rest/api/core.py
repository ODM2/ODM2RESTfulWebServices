# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from django.core.management import settings

from odm2api.ODMconnection import dbconnection
from odm2api.ODM2.services.readService import ReadODM2

from models import (
    Affiliations,
    Organization,
    People
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
            Affiliations(
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