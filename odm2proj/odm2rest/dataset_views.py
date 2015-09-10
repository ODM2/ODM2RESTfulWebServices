import sys

sys.path.append('ODM2PythonAPI')

# from rest_framework import viewsets

from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer

# Create your views here.

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

from collections import OrderedDict

import csv
import pyaml

from odm2rest.odm2service import Service
from negotiation import IgnoreClientContentNegotiation

from dict2xml import dict2xml as xmlify


class DatasetViewSet(APIView):
    """
    All ODM2 dataset Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "xml" or "csv". The default type is "yaml".
              required: false
              type: string
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """

        format = request.query_params.get('format', 'yaml')
        # accept = request.accepted_renderer.media_type
        mr = MultipleRepresentations()
        readConn = mr.readService()
        items = readConn.getDataSets()
        if items == None or len(items) == 0:
            return Response('The data is not existed.',
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)


class MultipleRepresentations(Service):
    def json_format(self):

        return self.sqlalchemy_object_to_dict()

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="datasets.csv"'

        item_csv_header = ["#fields=DataSetID", "DataSetUUID[type='string']", "DataSetTypeCV[type='string']",
                           "DataSetCode[type='string']", "DataSetTitle[type='string']",
                           "DataSetAbstract[type='string']"]

        writer = csv.writer(response)
        writer.writerow(item_csv_header)

        for item in self.items:
            row = []
            row.append(item.DatasetID)
            row.append(item.DatasetUUID)
            row.append(item.DatasetTypeCV)
            row.append(item.DatasetCode)
            row.append(item.DatasetTitle)
            row.append(item.DatasetAbstract)

            writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="datasets.yaml"'

        response.write("---\n")
        allitems = {}
        records = self.sqlalchemy_object_to_dict()
        allitems["DataSets"] = records
        response.write(pyaml.dump(allitems, vspacing=[0, 0]))
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="datasets.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")
        records = self.sqlalchemy_object_to_dict()
        response.write(xmlify({'Dataset': records}, wrap="Datasets", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        records = []
        for item in self.items:
            queryset = OrderedDict()
            queryset["DatasetID"] = item.DatasetID
            queryset["DatasetUUID"] = str(item.DatasetUUID)
            queryset["DatasetTypeCV"] = item.DatasetTypeCV
            queryset["DatasetCode"] = item.DatasetCode
            queryset["DatasetTitle"] = item.DatasetTitle
            queryset["DatasetAbstract"] = item.DatasetAbstract
            records.append(queryset)

        self._session.close()
        return records


class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """

    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)
