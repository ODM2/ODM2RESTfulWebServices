# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

import os
import yaml
import json

from django.conf import settings

from collections import OrderedDict

from sqlalchemy.orm.properties import ColumnProperty, RelationshipProperty


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

from odm2api.ODM2.models import (
    BigIntegerType,
    DateTimeType
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
        DateTimeType.__visit_name__: DateTimeField,
        BigIntegerType.__visit_name__: IntegerField,
        Boolean.__visit_name__: BooleanField,
        CLOB.__visit_name__: CharField,
        DECIMAL.__visit_name__: DecimalField,
        Date.__visit_name__: DateTimeField,
        Variant.__visit_name__: IntegerField
}


def get_col(sqlalch_obj, serializer=False):
    """
    This function gets a list of columns from a SQLAlchemy object.

    Args:
        sqlalch_obj (object): SQLAlchemy object to extract.
        serializer (bool, optional): Boolean to indicate whether the result is for a Serializer or not.
                                     If it is then the field types are also exported.

    Returns:
        list: List of tuples from SQLAlchemy object of (field name, type).

    """
    d = []
    for col_prop in sqlalch_obj.__mapper__.iterate_properties:
        if isinstance(col_prop, ColumnProperty):
            field_nm = str(col_prop).split('.')[1]
            field_cls = col_prop.columns[0].type.__class__
            if not field_nm.startswith('_'):
                if serializer:
                    if 'datetime' in field_nm.lower() and 'utcoffset' not in field_nm.lower():
                        d.append((field_nm, DateTimeField()))
                    else:
                        d.append((field_nm, field_mapping[field_cls.__visit_name__]()))
                else:
                    d.append((field_nm, None))

        if isinstance(col_prop, RelationshipProperty):
            field_nm_rel = str(col_prop).split('.')[1].replace('Obj', '')
            if not serializer:
                d.append((field_nm_rel, None))

    return d


def get_vals(sqlalch_obj):
    """
    This function is used to extract the values from a sqlalchemy objects.

    Args:
        sqlalch_obj (object): SQLAlchemy Object to extract values from.

    Returns:
        dict: Dictionary of SQLAchemy Object field names and its value.

    """
    d = OrderedDict()
    for col_prop in sqlalch_obj.__mapper__.iterate_properties:
        if isinstance(col_prop, ColumnProperty):
            field_nm = str(col_prop).split('.')[1]
            if not field_nm.startswith('_'):
                d.update({
                    field_nm: getattr(sqlalch_obj, field_nm)
                })

    return d


def swagger_convert():
    """
    This functions converts the api/swagger/swagger.yaml to swagger.json for Swagger UI

    Returns:
        None
    """
    with open(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'swagger', 'swagger.yaml')) as f:
        yaml_data = yaml.load(f)
        yaml_data['host'] = settings.SWAGGER_SETTINGS['BASE_DOMAIN']
        with open(os.path.join(settings.STATICFILES_DIRS[0], 'js', 'swagger.json'), 'w') as json_file:
            json_file.write(json.dumps(yaml_data, sort_keys=False, indent=2, separators=(',', ': ')))
            # print(json.dumps(yaml_data, sort_keys=False, indent=2, separators=(',', ': ')))


def lower_keys(dct):
    newdct = OrderedDict()
    for k, v in dct.items():
        newdct[k.lower()] = v
    return newdct
