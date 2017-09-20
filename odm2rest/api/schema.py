# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

import coreapi

SCHEMA = coreapi.Document(
    title='ODM2 REST API',
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
                            )
                        ],
                        description='All ODM2 people retrieval.'
                    )
                }
    }
)