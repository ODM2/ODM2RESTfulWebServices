# -*- coding: utf-8 -*-
from __future__ import print_function
from __future__ import unicode_literals
from __future__ import division


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


class DataSets(BASEMODEL):
    pass


class Methods(BASEMODEL):
    pass
