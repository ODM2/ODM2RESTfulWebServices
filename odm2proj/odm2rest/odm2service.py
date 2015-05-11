#import sys
#sys.path.append('ODM2PythonAPI')

#from ODM2.Core.services import readCore as CSread
#from ODM2.Results.services import readResults as Rread
#from ODM2.SamplingFeatures.services import readSamplingFeatures as SFread
#from ODM2.Provenance.services import readProvenance as Pread
from ODM2PythonAPI.ODMconnection import dbconnection
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read
from rest_framework.response import Response
from rest_framework import status

class Service:

    def __init__(self):
        self.engine = 'mysql'
        self.address = 'localhost'
        self.db = 'ODM2'
        self.user = 'xxx'
        self.password = 'xxx'

        self.items = []
        self.accept = ''

        self.resulttypecv = ''

        self.__json_format()
        self.__csv_format()
        self.__yaml_format()

    def connect(self):
        conn = dbconnection.createConnection(self.engine, self.address, self.db, self.user, self.password)
        return conn

    def readService(self):
        conn = self.connect()
        odm2_service = ODM2Read(conn)
        return odm2_service

    def content_format(self, data, mediaType):

        if isinstance(data,list):
            self.items = data
        else:
            self.items.append(data)

        self.accept = mediaType

        #if format == 'json' or accept == 'application/json':
        if self.accept == 'application/json' or self.accept == 'json':
            return Response(self.json_format())
        #elif format == 'csv' or accept == 'text/csv':
        elif self.accept == 'text/csv' or self.accept == 'csv':
            return self.csv_format()

        #elif format == 'yaml' or accept == 'application/yaml':
        elif self.accept == 'application/yaml' or self.accept == 'yaml':
            return self.yaml_format()
        else:
            #return Response(self.json_format())
            #return Response(self.yaml_format())
            return Response('format, %s is not existed.' % self.accept,
                            status=status.HTTP_400_BAD_REQUEST)

    def content_format_with_conn(self, data, mediaType, conn):

        if isinstance(data,list):
            self.items = data
        else:
            self.items.append(data)

        self.accept = mediaType
        self.conn = conn

        #if format == 'json' or accept == 'application/json':
        if self.accept == 'application/json' or self.accept == 'json':
            return Response(self.json_format())
        #elif format == 'csv' or accept == 'text/csv':
        elif self.accept == 'text/csv' or self.accept == 'csv':
            return self.csv_format()

        #elif format == 'yaml' or accept == 'application/yaml':
        elif self.accept == 'application/yaml' or self.accept == 'yaml':
            return self.yaml_format()
        else:
            #return Response(self.json_format())
            #return Response(self.yaml_format())
            return Response('format, %s is not existed.' % self.accept,
                            status=status.HTTP_400_BAD_REQUEST)

    def setResultTypeCV(self, typeCV):
        self.resulttypecv = typeCV

    def json_format(self):

        pass

    def csv_format(self):

        pass

    def yaml_format(self):

        pass

    __json_format = json_format
    __csv_format = csv_format
    __yaml_format = yaml_format
