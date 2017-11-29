# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from .base import *

DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1',]

# Application base domain.
# If IP Address also include port
# else only need domain name
SWAGGER_SETTINGS['BASE_DOMAIN'] = '127.0.0.1:8000'

# SQLAlchemy settings
ODM2DATABASE = {
    'engine': 'postgresql',
    'address': 'localhost',
    'port': 5432,
    'db': 'odm2',
    'user': 'postgres',
    'password': 'passwd'
}
