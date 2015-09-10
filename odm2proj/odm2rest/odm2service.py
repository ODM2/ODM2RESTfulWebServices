import sys

sys.path.append('ODM2PythonAPI')

from src.api.ODMconnection import dbconnection
from odm2rest.ODM2ALLServices import odm2Service as ODM2Read
from rest_framework.response import Response
from rest_framework import status


class Service:
    def __init__(self):
        # mysql
        # self.engine = 'mysql'
        # self.address = 'localhost'
        # self.db = 'ODM2'
        # self.user = 'cinergi'
        # self.password = 'cinergi'
        # postgresql
        self.engine = 'postgresql'
        self.address = 'sis-devel.cloudapp.net'
        self.db = 'marchantariats'
        self.user = 'postgres'
        self.password = 'cinergi'

        self.items = []
        self.accept = ''

        self.resulttypecv_to_id = {'Time series coverage': 'TSC', 'Measurement': 'M'}

        self.resulttypecv = ''
        self._session = None

        self.__json_format()
        self.__csv_format()
        self.__yaml_format()
        self.__xml_format()

    def connect(self):
        conn = dbconnection.createConnection(self.engine, self.address, self.db, self.user, self.password)
        return conn

    def readService(self):
        conn = self.connect()
        self._session = conn.getSession()
        odm2_service = ODM2Read(self._session)
        return odm2_service

    def content_format(self, data, mediaType):

        if isinstance(data, list):
            self.items = data
        else:
            self.items.append(data)

        self.accept = mediaType

        # if format == 'json' or accept == 'application/json':
        if self.accept == 'application/json' or self.accept == 'json':
            return Response(self.json_format())
        # elif format == 'csv' or accept == 'text/csv':
        elif self.accept == 'text/csv' or self.accept == 'csv':
            return self.csv_format()

        # elif format == 'yaml' or accept == 'application/yaml':
        elif self.accept == 'application/yaml' or self.accept == 'yaml':
            return self.yaml_format()
        elif self.accept == 'text/xml' or self.accept == 'xml':
            return self.xml_format()
        else:
            # return Response(self.json_format())
            # return Response(self.yaml_format())
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

    def xml_format(self):

        pass

    __json_format = json_format
    __csv_format = csv_format
    __yaml_format = yaml_format
    __xml_format = xml_format
