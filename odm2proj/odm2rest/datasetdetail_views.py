
from django.http import HttpResponse
from rest_framework.renderers import JSONRenderer
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

import csv
from odm2service import Service
from negotiation import IgnoreClientContentNegotiation
from ODM2ALLServices import odm2Service as ODM2Read
from dict2xml import dict2xml as xmlify

class DatasetDetailViewSet(APIView):
    """
    All ODM2 dataset Retrieval
    """
    content_negotiation_class = IgnoreClientContentNegotiation

    def get(self, request, format=None, datasetUUID=None):
        """
        ---
        parameters:
            - name: format    
              description: The format type is "yaml", "json", "csv" or "xml". The default type is "json".
              required: false
              type: string
              paramType: query
            - name: page
              description: the default page number is 0. 
              required: false
              type: integer
              paramType: query
            - name: page_size
              description: The default page size is 100 records.
              required: false
              type: integer
              paramType: query

        omit_serializer: true

        responseMessages:
            - code: 401
              message: Not authenticated
        """
        if datasetUUID is None:
            return Response(status=status.HTTP_400_BAD_REQUEST)

        #accept = request.accepted_renderer.media_type
        page = request.QUERY_PARAMS.get('page','0')
        page_size = request.QUERY_PARAMS.get('page_size','100')

        page = int(page)
        page_size = int(page_size)

        mr = MultipleRepresentations()
        format = request.query_params.get('format', mr.default_format)
        readConn = mr.readService()

        count = readConn.getCountForDataSetResultsByUUID(datasetUUID)
        if count > 500:
            items = readConn.getDataSetResultsByUUIDByPage(datasetUUID,page,page_size)
        else:
            items = readConn.getDataSetResultsByUUID(datasetUUID)

        if items == None or len(items) == 0:
            return Response('"%s" is not existed.' % datasetUUID,
                            status=status.HTTP_400_BAD_REQUEST)

        return mr.content_format(items, format)

class MultipleRepresentations(Service):

    def json_format(self):

        dataset, results = self.sqlalchemy_object_to_dict()
        dataset['Results'] = results
        return dataset

    def csv_format(self):

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = 'attachment; filename="datasets.csv"'

        item_csv_header = []
        item_csv_header.extend(["#fields=DataSet.DataSetID","DataSet.DataSetUUID[type='string']","DataSet.DataSetTypeCV[type='string']","DataSet.DataSetCode[type='string']","DataSet.DataSetTitle[type='string']","DataSet.DataSetAbstract[type='string']"])
        item_csv_header.extend(["Result.ResultUUID[type='string']","Result.ResultTypeCV[type='string']", "Result.ResultDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Result.ResultDateTimeUTCOffset","Result.StatusCV[type='string']","Result.SampledMediumCV[type='string']","Result.ValueCount"])
        item_csv_header.extend(["SamplingFeature.SamplingFeatureUUID[type='string']","SamplingFeature.SamplingFeatureTypeCV[type='string']","SamplingFeature.SamplingFeatureCode[type='string']","SamplingFeature.SamplingFeatureName[type='string']","SamplingFeature.SamplingFeatureDescription[type='string']","SamplingFeature.SamplingFeatureGeotypeCV[type='string']","SamplingFeature.Elevation_m[unit='m']","SamplingFeature.ElevationDatumCV[type='string']","SamplingFeature.FeatureGeometry[type='string']"])
        item_csv_header.extend(["Action.ActionTypeCV[type='string']","Action.ActionTypeCV[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.BeginDateTimeUTCOffset","Action.EndDateTime[type='date' format='yyyy-MM-dd HH:MM:SS']","Action.EndDateTimeUTCOffset","Method.MethodTypeCV[type='string']","Method.MethodCode[type='string']","Method.MethodName[type='string']"])
        item_csv_header.extend(["Variable.VariableTypeCV[type='string']","Variable.VariableCode[type='string']","Variable.VariableNameCV[type='string']","Variable.NoDataValue","Unit.UnitsTypeCV[type='string']","Unit.UnitsAbbreviation[type='string']","Unit.UnitsName[type='string']","ProcessingLevel.ProcessingLevelCode[type='string']","ProcessingLevel.Definition[type='string']","ProcessingLevel.Explanation[type='string']"])
        item_csv_header.extend(["Site.SiteTypeCV[type='string']","Site.Latitude[unit='degrees']","Site.Longitude[unit='degrees']","Site.SpatialReference.SRSCode[type='string']","Site.SpatialReference.SRSName[type='string']"])
        item_csv_header.extend(["RelatedFeature.RelationshipTypeCV[type='string']","RelatedFeature.SamplingFeatureUUID[type='string']","RelatedFeature.SamplingFeatureTypeCV[type='string']","RelatedFeature.SamplingFeatureCode[type='string']","RelatedFeature.SamplingFeatureName[type='string']","RelatedFeature.SamplingFeatureDescription[type='string']","RelatedFeature.SamplingFeatureGeotypeCV[type='string']","RelatedFeature.Elevation_m[unit='m']","RelatedFeature.ElevationDatumCV[type='string']","RelatedFeature.FeatureGeometry[type='string']","RelatedFeature.Site.SiteTypeCV[type='string']","RelatedFeature.Site.Latitude[unit='degrees']","RelatedFeature.Site.Longitude[unit='degrees']","RelatedFeature.Site.SpatialReference.SRSCode[type='string']","RelatedFeature.Site.SpatialReference.SRSName[type='string']"])

        writer = csv.writer(response)
        writer.writerow(item_csv_header)
        conn = ODM2Read(self._session)
            
        for value in self.items:
            row = []
            d_obj = value.DataSetObj
            r_obj = value.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj

            row.append(d_obj.DataSetID)
            row.append(d_obj.DataSetUUID)
            row.append(d_obj.DataSetTypeCV)
            row.append(d_obj.DataSetCode)
            row.append(d_obj.DataSetTitle)
            row.append(d_obj.DataSetAbstract)

            row.append(r_obj.ResultUUID)
            row.append(r_obj.ResultTypeCV)
            row.append(r_obj.ResultDateTime)
            row.append(r_obj.ResultDateTimeUTCOffset)
            row.append(r_obj.StatusCV)
            row.append(r_obj.SampledMediumCV)
            row.append(r_obj.ValueCount)

            row.append(sf_obj.SamplingFeatureUUID)
            row.append(sf_obj.SamplingFeatureTypeCV)
            row.append(sf_obj.SamplingFeatureCode)
            row.append(sf_obj.SamplingFeatureName)
            row.append(sf_obj.SamplingFeatureDescription)
            row.append(sf_obj.SamplingFeatureGeotypeCV)
            row.append(str(sf_obj.Elevation_m))
            row.append(sf_obj.ElevationDatumCV)
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            row.append(fg)

            row.append(a_obj.ActionTypeCV)
            row.append(a_obj.BeginDateTime)
            row.append(a_obj.BeginDateTimeUTCOffset)
            row.append(a_obj.EndDateTime)
            row.append(a_obj.EndDateTimeUTCOffset)

            row.append(m_obj.MethodTypeCV)
            row.append(m_obj.MethodCode)
            row.append(m_obj.MethodName)

            row.append(v_obj.VariableTypeCV)
            row.append(v_obj.VariableCode)
            row.append(v_obj.VariableNameCV)
            row.append(v_obj.NoDataValue)

            row.append(u_obj.UnitsTypeCV)
            row.append(u_obj.UnitsAbbreviation)
            row.append(u_obj.UnitsName)
                    
            row.append(p_obj.ProcessingLevelCode)
            row.append(p_obj.Definition)
            row.append(p_obj.Explanation)

            sfid = sf_obj.SamplingFeatureID
            site = conn.getSiteBySFId(sfid)
            if site != None:
                row.append(site.SiteTypeCV)
                row.append(site.Latitude)
                row.append(site.Longitude)
                sr_obj = site.SpatialReferenceObj
                row.append(sr_obj.SRSCode)
                row.append(sr_obj.SRSName)
            else:
                for i in range(5):
                    row.append(None)

            rf_list = []
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                for x in rfeature:
                    row1 = []
                    rf_obj = x.RelatedFeatureObj
                    row1.append(x.RelationshipTypeCV)
                    row1.append(rf_obj.SamplingFeatureUUID)
                    row1.append(rf_obj.SamplingFeatureTypeCV)
                    row1.append(rf_obj.SamplingFeatureCode)
                    row1.append(rf_obj.SamplingFeatureName)
                    row1.append(rf_obj.SamplingFeatureDescription)
                    row1.append(rf_obj.SamplingFeatureGeotypeCV)
                    row1.append(str(rf_obj.Elevation_m))
                    row1.append(rf_obj.ElevationDatumCV)
                    fg = None
                    if rf_obj.FeatureGeometry is not None:
                        fg = rf_obj.shape().wkt
                    row1.append(fg)

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        row1.append(rsite.SiteTypeCV)
                        row1.append(rsite.Latitude)
                        row1.append(rsite.Longitude)
                        sr_obj = rsite.SpatialReferenceObj
                        row1.append(sr_obj.SRSCode)
                        row1.append(sr_obj.SRSName)
                    else:
                        for i in range(5):
                            row1.append(None)
                    rf_list.append(row1)

            else:
                row1 = []
                for i in range(15):
                    row1.append(None)
                rf_list.append(row1)
            
            for i in rf_list:
                row.extend(i)
                writer.writerow(row)

        self._session.close()
        return response

    def yaml_format(self):

        response = HttpResponse(content_type='application/yaml')
        response['Content-Disposition'] = 'attachment; filename="dataset.yaml"'

        response.write("---\n")
        response.write("DataSet:\n")

        flag = True
        conn = ODM2Read(self._session)

        for value in self.items:
            if flag:
                d_obj = value.DataSetObj
                q  = u'    DataSetID: %d\n' % d_obj.DataSetID
                q += u'    DataSetUUID: %s\n' % d_obj.DataSetUUID
                q += u'    DataSetTypeCV: %s\n' % d_obj.DataSetTypeCV
                q += u'    DataSetCode: %s\n' % d_obj.DataSetCode
                q += u'    DataSetTitle: %s\n' % d_obj.DataSetTitle
                q += u'    DataSetAbstract: %s\n' % d_obj.DataSetAbstract
                response.write(q)
                response.write("\n")
                response.write("Results:\n")
                flag = False

            r_obj = value.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj

            #r  = u' - ResultID: %d\n' % value.ResultID
            r  = u' - ResultUUID: "%s"\n' % r_obj.ResultUUID
            r += u'   ResultTypeCV: \'%s\'\n' % r_obj.ResultTypeCV
            r += u'   ResultDateTime: "%s"\n' % str(r_obj.ResultDateTime)
            r += u'   ResultDateTimeUTCOffset: %s\n' % str(r_obj.ResultDateTimeUTCOffset)
            r += u'   StatusCV: %s\n' % r_obj.StatusCV
            r += u'   SampledMediumCV: %s\n' % r_obj.SampledMediumCV
            r += u'   ValueCount: %d\n' % r_obj.ValueCount

            r += u'   FeatureAction: \n'
            #r += u'       FeatureActionID: %d\n' % value.FeatureActionObj.FeatureActionID
            r += u'       SamplingFeature:\n'
            #r += u'           SamplingFeatureID: %d\n' % sf_obj.SamplingFeatureID
            r += u'           SamplingFeatureUUID: %s\n' % sf_obj.SamplingFeatureUUID
            r += u'           SamplingFeatureTypeCV: %s\n' % sf_obj.SamplingFeatureTypeCV
            r += u'           SamplingFeatureCode: %s\n' % sf_obj.SamplingFeatureCode
            r += u'           SamplingFeatureName: "%s"\n' % sf_obj.SamplingFeatureName
            r += u'           SamplingFeatureDescription: "%s"\n' % sf_obj.SamplingFeatureDescription
            r += u'           SamplingFeatureGeotypeCV: "%s"\n' % sf_obj.SamplingFeatureGeotypeCV
            r += u'           Elevation_m: %s\n' % str(sf_obj.Elevation_m)
            r += u'           ElevationDatumCV: "%s"\n' % sf_obj.ElevationDatumCV
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            r += u'           FeatureGeometry: "%s"\n' % fg

            r += u'       Action:\n'
            #r += u'           ActionID: %d\n' % a_obj.ActionID
            r += u'           ActionTypeCV: "%s"\n' % a_obj.ActionTypeCV
            r += u'           BeginDateTime: "%s"\n' % str(a_obj.BeginDateTime)
            r += u'           BeginDateTimeUTCOffset: %s\n' % str(a_obj.BeginDateTimeUTCOffset)
            r += u'           EndDateTime: "%s"\n' % str(a_obj.EndDateTime)
            r += u'           EndDateTimeUTCOffset: %s\n' % str(a_obj.EndDateTimeUTCOffset)
            r += u'           Method:\n'
            #r += u'               MethodID: %d\n' % m_obj.MethodID
            r += u'               MethodTypeCV: %s\n' % m_obj.MethodTypeCV
            r += u'               MethodCode: %s\n' % m_obj.MethodCode
            r += u'               MethodName: %s\n' % m_obj.MethodName

            raction = conn.getRelatedActionsByActionID(a_obj.ActionID)
            if raction != None and len(raction) > 0:
                r += u'   RelatedActions:\n'
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj

                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    r += u'       BeginDateTime: "%s"\n' % str(ra_obj.BeginDateTime)
                    r += u'       BeginDateTimeUTCOffset: %s\n' % str(ra_obj.BeginDateTimeUTCOffset)
                    r += u'       EndDateTime: "%s"\n' % str(ra_obj.EndDateTime)
                    r += u'       EndDateTimeUTCOffset: %s\n' % str(ra_obj.EndDateTimeUTCOffset)
                    r += u'       Method:\n'
                    r += u'           MethodTypeCV: %s\n' % m_obj.MethodTypeCV
                    r += u'           MethodCode: %s\n' % ram_obj.MethodCode
                    r += u'           MethodName: %s\n' % ram_obj.MethodName

            sfid = sf_obj.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                r += u'   RelatedFeatures:\n'
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    r += u'     - RelationshipTypeCV: %s\n' % x.RelationshipTypeCV
                    #r += u'       SamplingFeatureID: %d\n' % rf_obj.SamplingFeatureID
                    r += u'       SamplingFeatureUUID: %s\n' % rf_obj.SamplingFeatureUUID
                    r += u'       SamplingFeatureTypeCV: %s\n' % rf_obj.SamplingFeatureTypeCV
                    r += u'       SamplingFeatureCode: %s\n' % rf_obj.SamplingFeatureCode
                    r += u'       SamplingFeatureName: "%s"\n' % rf_obj.SamplingFeatureName
                    r += u'       SamplingFeatureDescription: "%s"\n' % rf_obj.SamplingFeatureDescription
                    r += u'       SamplingFeatureGeotypeCV: "%s"\n' % rf_obj.SamplingFeatureGeotypeCV
                    r += u'       Elevation_m: %s\n' % str(rf_obj.Elevation_m)
                    r += u'       ElevationDatumCV: "%s"\n' % rf_obj.ElevationDatumCV
                    fg = None
                    if rf_obj.FeatureGeometry is not None:
                        fg = rf_obj.shape().wkt
                    r += u'       FeatureGeometry: "%s"\n' % fg

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        r += u'       Site:\n'
                        r += u'           SiteTypeCV: %s\n' % rsite.SiteTypeCV
                        r += u'           Latitude: %f\n' % rsite.Latitude
                        r += u'           Longitude: %f\n' % rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        r += u'           SpatialReference:\n'
                        #r += u'               SRSID: %d\n' % sr_obj.SpatialReferenceID
                        r += u'               SRSCode: "%s"\n' % sr_obj.SRSCode
                        r += u'               SRSName: %s\n' % sr_obj.SRSName

            site = conn.getSiteBySFId(sfid)
            if site != None:
                r += u'   Site:\n'
                r += u'       SiteTypeCV: %s\n' % site.SiteTypeCV
                r += u'       Latitude: %f\n' % site.Latitude
                r += u'       Longitude: %f\n' % site.Longitude
                sr_obj = site.SpatialReferenceObj
                r += u'       SpatialReference:\n'
                #r += u'           SRSID: %d\n' % sr_obj.SpatialReferenceID
                r += u'           SRSCode: "%s"\n' % sr_obj.SRSCode
                r += u'           SRSName: %s\n' % sr_obj.SRSName

            r += u'   Variable:\n'
            #r += u'       VariableID: %d\n' % v_obj.VariableID
            r += u'       VariableTypeCV: %s\n' % v_obj.VariableTypeCV
            r += u'       VariableCode: %s\n' % v_obj.VariableCode
            r += u'       VariableNameCV: %s\n' % v_obj.VariableNameCV
            r += u'       NoDataValue: %d\n' % v_obj.NoDataValue
            
            r += u'   Unit:\n'
            #r += u'       UnitID: %d\n' % u_obj.UnitsID
            r += u'       UnitsTypeCV: %s\n' % u_obj.UnitsTypeCV
            r += u'       UnitsAbbreviation: %s\n' % u_obj.UnitsAbbreviation
            r += u'       UnitsName: %s\n' % u_obj.UnitsName
            
            r += u'   ProcessingLevel:\n'
            #r += u'       ProcessingLevelID: %d\n' % p_obj.ProcessingLevelID
            r += u'       ProcessingLevelCode: "%s"\n' % p_obj.ProcessingLevelCode
            r += u'       Definition: "%s"\n' % p_obj.Definition
            r += u'       Explanation: "%s"\n' % p_obj.Explanation

            response.write(r)
            response.write('\n')

        self._session.close()
        return response

    def xml_format(self):

        response = HttpResponse(content_type='text/xml')
        response['Content-Disposition'] = 'attachment; filename="dataset.xml"'

        response.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n")

        dataset, results = self.sqlalchemy_object_to_dict()

        dataset['Results'] = {'Result': results }
        response.write(xmlify(dataset, wrap="DataSet", indent="  "))
        return response

    def sqlalchemy_object_to_dict(self):

        flag = True        
        dataset = {}
        results = []
        conn = ODM2Read(self._session)

        for value in self.items:
            if flag:
                d_obj = value.DataSetObj
                #dataset['DataSetID'] = d_obj.DataSetID
                dataset['DataSetUUID'] = d_obj.DataSetUUID
                dataset['DataSetTypeCV'] = d_obj.DataSetTypeCV
                dataset['DataSetCode'] = d_obj.DataSetCode
                dataset['DataSetTitle'] = d_obj.DataSetTitle
                dataset['DataSetAbstract'] = d_obj.DataSetAbstract
                flag = False

            r_obj = value.ResultObj
            result = {}
            result['ResultUUID'] = r_obj.ResultUUID
            result['ResultTypeCV'] = r_obj.ResultTypeCV
            results.append(result)

        self._session.close()
        return dataset,results

    def sqlalchemy_object_to_dict_org(self):

        flag = True        
        dataset = {}
        results = []
        conn = ODM2Read(self._session)

        for value in self.items:
            if flag:
                d_obj = value.DataSetObj
                dataset['DataSetID'] = d_obj.DataSetID
                dataset['DataSetUUID'] = d_obj.DataSetUUID
                dataset['DataSetTypeCV'] = d_obj.DataSetTypeCV
                dataset['DataSetCode'] = d_obj.DataSetCode
                dataset['DataSetTitle'] = d_obj.DataSetTitle
                dataset['DataSetAbstract'] = d_obj.DataSetAbstract
                flag = False

            r_obj = value.ResultObj
            sf_obj = r_obj.FeatureActionObj.SamplingFeatureObj
            a_obj = r_obj.FeatureActionObj.ActionObj
            m_obj = a_obj.MethodObj
            v_obj = r_obj.VariableObj
            u_obj = r_obj.UnitsObj
            p_obj = r_obj.ProcessingLevelObj

            result = {}
            result['ResultUUID'] = r_obj.ResultUUID
            result['ResultTypeCV'] = r_obj.ResultTypeCV
            result['ResultDateTime'] = str(r_obj.ResultDateTime)
            result['ResultDateTimeUTCOffset'] = str(r_obj.ResultDateTimeUTCOffset)
            result['StatusCV'] = r_obj.StatusCV
            result['SampledMediumCV'] = r_obj.SampledMediumCV
            result['ValueCount'] = r_obj.ValueCount

            samplingfeature = {}
            samplingfeature['SamplingFeatureUUID'] = sf_obj.SamplingFeatureUUID
            samplingfeature['SamplingFeatureTypeCV'] = sf_obj.SamplingFeatureTypeCV
            samplingfeature['SamplingFeatureCode'] = sf_obj.SamplingFeatureCode
            samplingfeature['SamplingFeatureName'] = sf_obj.SamplingFeatureName
            samplingfeature['SamplingFeatureDescription'] = sf_obj.SamplingFeatureDescription
            samplingfeature['SamplingFeatureGeotypeCV'] = sf_obj.SamplingFeatureGeotypeCV
            samplingfeature['Elevation_m'] = str(sf_obj.Elevation_m)
            samplingfeature['ElevationDatumCV'] = sf_obj.ElevationDatumCV
            fg = None
            if sf_obj.FeatureGeometry is not None:
                fg = sf_obj.shape().wkt
            samplingfeature['FeatureGeometry'] = fg

            action = {}
            action['ActionTypeCV'] = a_obj.ActionTypeCV
            action['BeginDateTime'] = str(a_obj.BeginDateTime)
            action['BeginDateTimeUTCOffset'] = a_obj.BeginDateTimeUTCOffset
            action['EndDateTime'] = str(a_obj.EndDateTime)
            action['EndDateTimeUTCOffset'] = str(a_obj.EndDateTimeUTCOffset)
            method = {}
            method['MethodTypeCV'] = m_obj.MethodTypeCV
            method['MethodCode'] = m_obj.MethodCode
            method['MethodName'] = m_obj.MethodName
            action['Method'] = method
            result['FeatureAction'] = {'SamplingFeature': samplingfeature, 'Action': action}

            raction = conn.getRelatedActionsByActionID(a_obj.ActionID)
            if raction != None and len(raction) > 0:
                ractions = []
                for x in raction:
                    ra_obj = x.RelatedActionObj
                    ram_obj = ra_obj.MethodObj
                    ra = {}
                    ra['RelationshipTypeCV'] = x.RelationshipTypeCV
                    ra['BeginDateTime'] = str(ra_obj.BeginDateTime)
                    ra['BeginDateTimeUTCOffset'] = str(ra_obj.BeginDateTimeUTCOffset)
                    ra['EndDateTime'] = str(ra_obj.EndDateTime)
                    ra['EndDateTimeUTCOffset'] = str(ra_obj.EndDateTimeUTCOffset)
                    ram = {}
                    ram['MethodTypeCV'] = ram_obj.MethodTypeCV
                    ram['MethodCode'] = ram_obj.MethodCode
                    ram['MethodName'] = ram_obj.MethodName
                    ra['Method'] = ram
                    ractions.append(ra)

            sfid = sf_obj.SamplingFeatureID
            rfeature = conn.getRelatedFeaturesBySamplingFeatureID(sfid)
            if rfeature != None and len(rfeature) > 0:
                rfeatures = []
                for x in rfeature:
                    rf_obj = x.RelatedFeatureObj
                    rf = {}
                    rf['RelationshipTypeCV'] = x.RelationshipTypeCV
                    rf['SamplingFeatureUUID'] = rf_obj.SamplingFeatureUUID
                    rf['SamplingFeatureTypeCV'] = rf_obj.SamplingFeatureTypeCV
                    rf['SamplingFeatureCode'] = rf_obj.SamplingFeatureCode
                    rf['SamplingFeatureName'] = rf_obj.SamplingFeatureName
                    rf['SamplingFeatureDescription'] = rf_obj.SamplingFeatureDescription
                    rf['SamplingFeatureGeotypeCV'] = rf_obj.SamplingFeatureGeotypeCV
                    rf['Elevation_m'] = str(rf_obj.Elevation_m)
                    rf['ElevationDatumCV'] = rf_obj.ElevationDatumCV
                    fg = None
                    if rf_obj.FeatureGeometry is not None:
                        fg = rf_obj.shape().wkt
                    rf['FeatureGeometry'] = fg

                    rsite = conn.getSiteBySFId(rf_obj.SamplingFeatureID)
                    if rsite != None:
                        rs = {}
                        rs['SiteTypeCV'] = rsite.SiteTypeCV
                        rs['Latitude'] = rsite.Latitude
                        rs['Longitude'] = rsite.Longitude
                        sr_obj = rsite.SpatialReferenceObj
                        rsr = {}
                        rsr['SRSCode'] = sr_obj.SRSCode
                        rsr['SRSName'] = sr_obj.SRSName
                        rs['SpatialReference'] = rsr
                        rf['Site'] = rs
                    rfeatures.append(rf)

                result['RelatedFeatures'] = rfeatures

            site = conn.getSiteBySFId(sfid)
            if site != None:
                s = {}
                s['SiteTypeCV'] = site.SiteTypeCV
                s['Latitude'] = site.Latitude
                s['Longitude'] = site.Longitude
                sr_obj = site.SpatialReferenceObj
                sr = {}
                sr['SRSCode'] = sr_obj.SRSCode
                sr['SRSName'] = sr_obj.SRSName
                s['SpatialReference'] = sr
                result['Site'] = s

            varone = {}
            varone['VariableTypeCV'] = v_obj.VariableTypeCV
            varone['VariableCode'] = v_obj.VariableCode
            varone['VariableNameCV'] = v_obj.VariableNameCV
            varone['NoDataValue'] = v_obj.NoDataValue
            result['Variable'] = varone
            
            unit = {}
            unit['UnitsTypeCV'] = u_obj.UnitsTypeCV
            unit['UnitsAbbreviation'] = u_obj.UnitsAbbreviation
            unit['UnitsName'] = u_obj.UnitsName
            result['Unit'] = unit
            
            pl = {}
            pl['ProcessingLevelCode'] = p_obj.ProcessingLevelCode
            pl['Definition'] = p_obj.Definition
            pl['Explanation'] = p_obj.Explanation
            result['ProcessingLevel'] = pl

            results.append(result)

        self._session.close()
        return dataset,results

class JSONResponse(HttpResponse):
    """
    An HttpResponse that renders its content into JSON.
    """
    def __init__(self, data, **kwargs):
        content = JSONRenderer().render(data)
        kwargs['content_type'] = 'application/json'
        super(JSONResponse, self).__init__(content, **kwargs)

