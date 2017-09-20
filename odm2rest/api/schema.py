# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

import coreapi

SCHEMA = coreapi.Document(
    title='ODM2 REST API 1.0',
    url='http://127.0.0.1:8000/',
    content={
        'affiliations': {
            'list': coreapi.Link(
                url='/affiliations',
                action='get',
                fields=[
                    coreapi.Field(
                        name='affiliationID',
                        required=False,
                        location='query',
                        description='Affiliation ID(s)',
                    ),
                    coreapi.Field(
                        name='firstName',
                        required=False,
                        location='query',
                        description='Affiliation First Name',
                    ),
                    coreapi.Field(
                        name='lastName',
                        required=False,
                        location='query',
                        description='Affiliation Last Name',
                    ),
                    coreapi.Field(
                        name='organizationCode',
                        required=False,
                        location='query',
                        description='Affiliation Organization Code',
                    )
                ],
                description='All ODM2 affiliations retrieval.'
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