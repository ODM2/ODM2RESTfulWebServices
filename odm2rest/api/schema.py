# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

import coreapi
from rest_framework.fields import (
    BooleanField,
    CharField,
    DateTimeField,
    DecimalField,
    FloatField,
    IntegerField,
)
from sqlalchemy.types import (
    Integer,
    BIGINT,
    CHAR,
    CLOB,
    DATE,
    DECIMAL,
    INTEGER,
    SMALLINT,
    TIMESTAMP,
    VARCHAR,
    BigInteger,
    Boolean,
    DateTime,
    Float,
    Numeric,
    String,
    Date,
    Variant
)

SCHEMA = coreapi.Document(
    title='ODM2 REST API 1.0',
    url='http://127.0.0.1:8000/',
    content={
        'affiliations': {
            'aff-list': coreapi.Link(
                url='/affiliations/',
                action='get',
                fields=[],
                description='All ODM2 affiliations retrieval.'
            ),
            'aff-detail': coreapi.Link(
                url='/affiliations/affiliationID/{affiliationID}/',
                action='get',
                fields=[coreapi.Field(
                    name='affiliationID',
                    required=True,
                    location='path',
                    description='Affiliation ID(s)'
                )],
                description='All ODM2 affiliations based on ID(s).'
            ),
            'org-detail': coreapi.Link(
                url='/affiliations/organizationCode/{organizationCode}/',
                action='get',
                fields=[coreapi.Field(
                    name='organizationCode',
                    required=True,
                    location='path',
                    description='Organization Code'
                )],
                description='All ODM2 affiliations based on Organization Code.'
            ),
            'person-first-detail': coreapi.Link(
                url='/affiliations/firstName/{firstName}/',
                action='get',
                fields=[coreapi.Field(
                    name='firstName',
                    required=True,
                    location='path',
                    description='Person First Name'
                )],
                description='All ODM2 affiliations based on Person First Name.'
            ),
            'person-last-detail': coreapi.Link(
                url='/affiliations/lastName/{lastName}/',
                action='get',
                fields=[coreapi.Field(
                    name='lastName',
                    required=True,
                    location='path',
                    description='Person Last Name'
                )],
                description='All ODM2 affiliations based on Person Last Name.'
            ),
            'person-detail': coreapi.Link(
                url='/affiliations/firstName/{firstName}/lastName/{lastName}',
                action='get',
                fields=[coreapi.Field(
                    name='firstName',
                    required=True,
                    location='path',
                    description='Person First Name'
                ), coreapi.Field(
                    name='lastName',
                    required=True,
                    location='path',
                    description='Person Last Name'
                )],
                description='All ODM2 affiliations based on Person First and Last Name.'
            )
        },
        'people': {
                    'list': coreapi.Link(
                        url='/people',
                        action='get',
                        fields=[
                            coreapi.Field(
                                name='peopleID',
                                required=False,
                                location='query',
                                description='Person ID(s)',
                            ),
                            coreapi.Field(
                                name='firstName',
                                required=False,
                                location='query',
                                description='Person First Name',
                            ),
                            coreapi.Field(
                                name='lastName',
                                required=False,
                                location='query',
                                description='Person Last Name',
                            )
                        ],
                        description='All ODM2 people retrieval.'
                    )
                },
        'results': {
                    'list': coreapi.Link(
                        url='/results',
                        action='get',
                        fields=[
                            coreapi.Field(
                                name='resultID',
                                required=False,
                                location='query',
                                description='Result ID(s)',
                            ),
                            coreapi.Field(
                                name='resultUUID',
                                required=False,
                                location='query',
                                description='Result UUID(s)',
                            ),
                            coreapi.Field(
                                name='resultType',
                                required=False,
                                location='query',
                                description='Result Type',
                            ),
                            coreapi.Field(
                                name='actionID',
                                required=False,
                                location='query',
                                description='Action ID',
                            ),
                            coreapi.Field(
                                name='samplingFeatureID',
                                required=False,
                                location='query',
                                description='Sampling Feature ID',
                            ),
                            coreapi.Field(
                                name='siteID',
                                required=False,
                                location='query',
                                description='Site ID',
                            ),
                            coreapi.Field(
                                name='variableID',
                                required=False,
                                location='query',
                                description='Variable ID',
                            ),
                            coreapi.Field(
                                name='simulationID',
                                required=False,
                                location='query',
                                description='Simulation ID',
                            ),
                        ],
                        description='All ODM2 results retrieval.'
                    )
                }
    }
)

field_mapping = {
        Integer.__visit_name__: IntegerField,
        String.__visit_name__: CharField,
        INTEGER.__visit_name__: IntegerField,
        SMALLINT.__visit_name__: IntegerField,
        BIGINT.__visit_name__: IntegerField,
        VARCHAR.__visit_name__: CharField,
        CHAR.__visit_name__: CharField,
        TIMESTAMP.__visit_name__: DateTimeField,
        DATE.__visit_name__: DateTimeField,
        Float.__visit_name__: FloatField,
        BigInteger.__visit_name__: IntegerField,
        Numeric.__visit_name__: IntegerField,
        DateTime.__visit_name__: DateTimeField,
        Boolean.__visit_name__: BooleanField,
        CLOB.__visit_name__: CharField,
        DECIMAL.__visit_name__: DecimalField,
        Date.__visit_name__: DateTimeField,
        Variant.__visit_name__: IntegerField
}