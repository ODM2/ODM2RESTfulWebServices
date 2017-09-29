# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


from .base import *

DEBUG = True

ALLOWED_HOSTS = ['127.0.0.1',]

# SQLAlchemy settings
ODM2DATABASE = {
    'engine': 'db engine',
    'address': 'localhost',
    'db': 'db name',
    'user': 'username',
    'password': 'mypassword'
}
