# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


# Create your models here.
class Affiliations(object):

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
