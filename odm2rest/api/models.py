# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division

from collections import OrderedDict

from sqlalchemy.orm.properties import ColumnProperty, RelationshipProperty

from schema import field_mapping


def get_col(sqlalch_obj, serializer=False):
    d = []
    for col_prop in sqlalch_obj.__mapper__.iterate_properties:
        if isinstance(col_prop, ColumnProperty):
            field_nm = str(col_prop).split('.')[1]
            field_cls = col_prop.columns[0].type.__class__
            if not field_nm.startswith('_'):
                if serializer:
                    d.append((field_nm, field_mapping[field_cls.__visit_name__]()))
                else:
                    d.append((field_nm, None))

        if isinstance(col_prop, RelationshipProperty):
            field_nm_rel = str(col_prop).split('.')[1].replace('Obj', '')
            if not serializer:
                d.append((field_nm_rel, None))

    return d


def get_vals(sqlalch_obj):
    d = OrderedDict()
    for col_prop in sqlalch_obj.__mapper__.iterate_properties:
        if isinstance(col_prop, ColumnProperty):
            field_nm = str(col_prop).split('.')[1]
            if not field_nm.startswith('_'):
                d.update({
                    field_nm: getattr(sqlalch_obj, field_nm)
                })

    return d



class BASEMODEL(object):
    def __init__(self, dct):
        for field, val in dct.items():
            setattr(self, field, val)


class People(BASEMODEL):
    pass


class Organization(BASEMODEL):
    pass


class SamplingFeatures(BASEMODEL):
    pass


class Affiliation(BASEMODEL):
    pass


class Variable(BASEMODEL):
    pass


class Unit(BASEMODEL):
    pass


class FeatureAction(BASEMODEL):
    pass


class ProcessingLevel(BASEMODEL):
    pass


class TaxonomicClassifier(BASEMODEL):
    pass


class Result(BASEMODEL):
    pass
