import sys
sys.path.append('ODM2PythonAPI')

from rest_framework import serializers
from src.api.ODM2.models import Variables

from sqlalchemy.ext.declarative import DeclarativeMeta
import json
from django.forms import widgets
from django.contrib.auth.models import User, Group

class UserSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'groups')

class Odm2JsonSerializer:

    def serialize(self, obj):

        try:            
            #content = [u.__dict__.copy() for u in obj]
            content = [u.__dict__ for u in obj]
            for e in content:
                for d in [None, '', '_sa_instance_state', '_labels']:
                    if d in e:
                        del e[d]
        except TypeError:
            #content = obj.__dict__.copy()
            content = obj.__dict__
            for d in [None, '', '_sa_instance_state', '_labels']:
                if d in content:
                    del content[d]
        return content


class AlchemyEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj.__class__, DeclarativeMeta):
            # an SQLAlchemy class
            fields = {}
            for field in [x for x in dir(obj) if not x.startswith('_') and x != 'metadata']:
                data = obj.__getattribute__(field)
                try:
                    json.dumps(data) # this will fail on non-encodable values, like other classes
                    fields[field] = data
                except TypeError:
                    fields[field] = None
                    # a json-encodable dict
                    return fields

        return json.JSONEncoder.default(self, obj)

class DummySerializer(serializers.Serializer):
    def restore_object(self, attrs, instance=None):

        if instance is not None:
            return instance

#from odm2rest.models import Variable
class VariableSerializer(serializers.Serializer):
    """
    VariableID = Column(Integer, primary_key=True)
    VariableTypeCV = Column(String(255, u'SQL_Latin1_General_CP1_CI_AS'), nullable=False)
    VariableCode = Column(String(50, u'SQL_Latin1_General_CP1_CI_AS'), nullable=False)
    VariableNameCV = Column(String(255, u'SQL_Latin1_General_CP1_CI_AS'), nullable=False)
    VariableDefinition = Column(String(500, u'SQL_Latin1_General_CP1_CI_AS'))
    SpeciationCV = Column(String(255, u'SQL_Latin1_General_CP1_CI_AS'))
    NoDataValue = Column(Float(53), nullable=False)

    instance. = attrs.get('', instance.)
    """

    #VariableID = serializers.IntegerField()
    VariableTypeCV = serializers.CharField(max_length=255)
    VariableCode = serializers.CharField(max_length=50)
    VariableNameCV = serializers.CharField(max_length=255)
    VariableDefinition = serializers.CharField(max_length=500,required=False)
    #VariableDefinition = serializers.CharField(widget=widgets.Textarea, required=False)
    SpeciationCV = serializers.CharField(max_length=255, required=False)
    NoDataValue = serializers.FloatField()

    def restore_object(self, attrs, instance=None):

        if instance is not None:
            instance.VariableID = attrs.get('VariableID', instance.VariableID)
            instance.VariableTypeCV = attrs.get('VariableTypeCV', instance.VariableTypeCV)
            instance.VariableCode = attrs.get('VariableCode', instance.VariableCode)
            instance.VariableNameCV = attrs.get('VariableNameCV', instance.VariableNameCV)
            instance.VariableDefinition = attrs.get('VariableDefinition', instance.VariableDefinition)
            instance.SpeciationCV = attrs.get('SpeciationCV', instance.SpeciationCV)
            instance.NoDataValue = attrs.get('NoDataValue', instance.NoDataValue)

            return instance
#        return Variable(**attrs)

class PersonSerializer(serializers.Serializer):

    PersonID = serializers.IntegerField()
    PersonFirstName = serializers.CharField(max_length=255)
    PersonMiddleName = serializers.CharField(max_length=255)
    PersonLastName = serializers.CharField(max_length=255)

    def restore_object(self, attrs, instance=None):

        if instance is not None:
            instance.PersonID = attrs.get('PersonID', instance.PersonID)
            instance.PersonFirstName = attrs.get('PersonFirstName', instance.PersonFirstName)
            instance.PersonMiddleName = attrs.get('PersonMiddleName', instance.PersonMiddleName)
            instance.PersonLastName = attrs.get('PersonLastName', instance.PersonLastName)
            return instance
#        return Variable(**attrs)
