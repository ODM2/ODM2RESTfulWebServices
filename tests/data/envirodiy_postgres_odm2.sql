--
-- PostgreSQL database dump
--

-- Dumped from database version 9.1.24
-- Dumped by pg_dump version 9.5.1

-- Started on 2017-09-25 12:57:20 PDT

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 3554 (class 1262 OID 17756)
-- Name: odm2; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE odm2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


\connect odm2

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 17757)
-- Name: odm2; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA odm2;


--
-- TOC entry 2 (class 3079 OID 11645)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 3556 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- TOC entry 1 (class 3079 OID 20417)
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- TOC entry 3557 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- TOC entry 3 (class 3079 OID 17758)
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


SET search_path = public, pg_catalog;

--
-- TOC entry 408 (class 1255 OID 17769)
-- Name: reset_sequence(text, text, text); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION reset_sequence(tablename text, columnname text, sequence_name text) RETURNS void
    LANGUAGE plpgsql
    AS $$  
      DECLARE 
      BEGIN 
	  IF (tablename != 'django_migrations' ) THEN
      	EXECUTE 'SELECT setval( ''' || sequence_name  || ''', ' || '(SELECT MAX(' || columnname || ') FROM ' || 'odm2.' || tablename || ')' || '+1)';
      END IF;
      END;  
    $$;


SET search_path = odm2, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 165 (class 1259 OID 17770)
-- Name: actionannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE actionannotations (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 166 (class 1259 OID 17773)
-- Name: actionannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE actionannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 166
-- Name: actionannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE actionannotations_bridgeid_seq OWNED BY actionannotations.bridgeid;


--
-- TOC entry 167 (class 1259 OID 17775)
-- Name: actionby; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE actionby (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    affiliationid integer NOT NULL,
    isactionlead boolean NOT NULL,
    roledescription character varying(5000)
);


--
-- TOC entry 168 (class 1259 OID 17781)
-- Name: actionby_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE actionby_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 168
-- Name: actionby_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE actionby_bridgeid_seq OWNED BY actionby.bridgeid;


--
-- TOC entry 169 (class 1259 OID 17783)
-- Name: actiondirectives; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE actiondirectives (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    directiveid integer NOT NULL
);


--
-- TOC entry 170 (class 1259 OID 17786)
-- Name: actiondirectives_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE actiondirectives_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 170
-- Name: actiondirectives_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE actiondirectives_bridgeid_seq OWNED BY actiondirectives.bridgeid;


--
-- TOC entry 171 (class 1259 OID 17788)
-- Name: actionextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE actionextensionpropertyvalues (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 172 (class 1259 OID 17791)
-- Name: actionextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE actionextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 172
-- Name: actionextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE actionextensionpropertyvalues_bridgeid_seq OWNED BY actionextensionpropertyvalues.bridgeid;


--
-- TOC entry 173 (class 1259 OID 17793)
-- Name: actions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE actions (
    actionid integer NOT NULL,
    actiontypecv character varying(255) NOT NULL,
    methodid integer NOT NULL,
    begindatetime timestamp without time zone NOT NULL,
    begindatetimeutcoffset integer NOT NULL,
    enddatetime timestamp without time zone,
    enddatetimeutcoffset integer,
    actiondescription character varying(5000),
    actionfilelink character varying(255)
);


--
-- TOC entry 174 (class 1259 OID 17799)
-- Name: actions_actionid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE actions_actionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 174
-- Name: actions_actionid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE actions_actionid_seq OWNED BY actions.actionid;


--
-- TOC entry 175 (class 1259 OID 17801)
-- Name: affiliations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE affiliations (
    affiliationid integer NOT NULL,
    personid integer NOT NULL,
    organizationid integer,
    isprimaryorganizationcontact boolean,
    affiliationstartdate date NOT NULL,
    affiliationenddate date,
    primaryphone character varying(50),
    primaryemail character varying(255) NOT NULL,
    primaryaddress character varying(255),
    personlink character varying(255)
);


--
-- TOC entry 176 (class 1259 OID 17807)
-- Name: affiliations_affiliationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE affiliations_affiliationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 176
-- Name: affiliations_affiliationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE affiliations_affiliationid_seq OWNED BY affiliations.affiliationid;


--
-- TOC entry 177 (class 1259 OID 17809)
-- Name: annotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE annotations (
    annotationid integer NOT NULL,
    annotationtypecv character varying(255) NOT NULL,
    annotationcode character varying(50),
    annotationtext character varying(500) NOT NULL,
    annotationdatetime timestamp without time zone,
    annotationutcoffset integer,
    annotationlink character varying(255),
    annotatorid integer,
    citationid integer
);


--
-- TOC entry 178 (class 1259 OID 17815)
-- Name: annotations_annotationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE annotations_annotationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 178
-- Name: annotations_annotationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE annotations_annotationid_seq OWNED BY annotations.annotationid;


--
-- TOC entry 179 (class 1259 OID 17817)
-- Name: authorlists; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE authorlists (
    bridgeid integer NOT NULL,
    citationid integer NOT NULL,
    personid integer NOT NULL,
    authororder integer NOT NULL
);


--
-- TOC entry 180 (class 1259 OID 17820)
-- Name: authorlists_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE authorlists_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 180
-- Name: authorlists_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE authorlists_bridgeid_seq OWNED BY authorlists.bridgeid;


--
-- TOC entry 181 (class 1259 OID 17822)
-- Name: calibrationactions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE calibrationactions (
    actionid integer NOT NULL,
    calibrationcheckvalue double precision,
    instrumentoutputvariableid integer NOT NULL,
    calibrationequation character varying(255)
);


--
-- TOC entry 182 (class 1259 OID 17825)
-- Name: calibrationreferenceequipment; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE calibrationreferenceequipment (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    equipmentid integer NOT NULL
);


--
-- TOC entry 183 (class 1259 OID 17828)
-- Name: calibrationreferenceequipment_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE calibrationreferenceequipment_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 183
-- Name: calibrationreferenceequipment_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE calibrationreferenceequipment_bridgeid_seq OWNED BY calibrationreferenceequipment.bridgeid;


--
-- TOC entry 184 (class 1259 OID 17830)
-- Name: calibrationstandards; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE calibrationstandards (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    referencematerialid integer NOT NULL
);


--
-- TOC entry 185 (class 1259 OID 17833)
-- Name: calibrationstandards_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE calibrationstandards_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 185
-- Name: calibrationstandards_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE calibrationstandards_bridgeid_seq OWNED BY calibrationstandards.bridgeid;


--
-- TOC entry 186 (class 1259 OID 17835)
-- Name: categoricalresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE categoricalresults (
    resultid bigint NOT NULL,
    xlocation double precision,
    xlocationunitsid integer,
    ylocation double precision,
    ylocationunitsid integer,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    qualitycodecv character varying(255) NOT NULL
);


--
-- TOC entry 187 (class 1259 OID 17838)
-- Name: categoricalresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE categoricalresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 188 (class 1259 OID 17841)
-- Name: categoricalresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE categoricalresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3569 (class 0 OID 0)
-- Dependencies: 188
-- Name: categoricalresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE categoricalresultvalueannotations_bridgeid_seq OWNED BY categoricalresultvalueannotations.bridgeid;


--
-- TOC entry 189 (class 1259 OID 17843)
-- Name: categoricalresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE categoricalresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue character varying(255) NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL
);


--
-- TOC entry 190 (class 1259 OID 17846)
-- Name: categoricalresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE categoricalresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3570 (class 0 OID 0)
-- Dependencies: 190
-- Name: categoricalresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE categoricalresultvalues_valueid_seq OWNED BY categoricalresultvalues.valueid;


--
-- TOC entry 191 (class 1259 OID 17848)
-- Name: citationextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE citationextensionpropertyvalues (
    bridgeid integer NOT NULL,
    citationid integer NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 192 (class 1259 OID 17851)
-- Name: citationextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE citationextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3571 (class 0 OID 0)
-- Dependencies: 192
-- Name: citationextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE citationextensionpropertyvalues_bridgeid_seq OWNED BY citationextensionpropertyvalues.bridgeid;


--
-- TOC entry 193 (class 1259 OID 17853)
-- Name: citationexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE citationexternalidentifiers (
    bridgeid integer NOT NULL,
    citationid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    citationexternalidentifier character varying(255) NOT NULL,
    citationexternalidentifieruri character varying(255)
);


--
-- TOC entry 194 (class 1259 OID 17859)
-- Name: citationexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE citationexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3572 (class 0 OID 0)
-- Dependencies: 194
-- Name: citationexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE citationexternalidentifiers_bridgeid_seq OWNED BY citationexternalidentifiers.bridgeid;


--
-- TOC entry 195 (class 1259 OID 17861)
-- Name: citations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE citations (
    citationid integer NOT NULL,
    title character varying(255) NOT NULL,
    publisher character varying(255) NOT NULL,
    publicationyear integer NOT NULL,
    citationlink character varying(255)
);


--
-- TOC entry 196 (class 1259 OID 17867)
-- Name: citations_citationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE citations_citationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3573 (class 0 OID 0)
-- Dependencies: 196
-- Name: citations_citationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE citations_citationid_seq OWNED BY citations.citationid;


--
-- TOC entry 197 (class 1259 OID 17869)
-- Name: cv_actiontype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_actiontype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 198 (class 1259 OID 17875)
-- Name: cv_aggregationstatistic; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_aggregationstatistic (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 199 (class 1259 OID 17881)
-- Name: cv_annotationtype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_annotationtype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 200 (class 1259 OID 17887)
-- Name: cv_censorcode; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_censorcode (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 201 (class 1259 OID 17893)
-- Name: cv_dataqualitytype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_dataqualitytype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 202 (class 1259 OID 17899)
-- Name: cv_datasettype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_datasettype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 203 (class 1259 OID 17905)
-- Name: cv_directivetype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_directivetype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 204 (class 1259 OID 17911)
-- Name: cv_elevationdatum; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_elevationdatum (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 205 (class 1259 OID 17917)
-- Name: cv_equipmenttype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_equipmenttype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 206 (class 1259 OID 17923)
-- Name: cv_medium; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_medium (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 207 (class 1259 OID 17929)
-- Name: cv_methodtype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_methodtype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 208 (class 1259 OID 17935)
-- Name: cv_organizationtype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_organizationtype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 209 (class 1259 OID 17941)
-- Name: cv_propertydatatype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_propertydatatype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 210 (class 1259 OID 17947)
-- Name: cv_qualitycode; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_qualitycode (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 211 (class 1259 OID 17953)
-- Name: cv_relationshiptype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_relationshiptype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 212 (class 1259 OID 17959)
-- Name: cv_resulttype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_resulttype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 213 (class 1259 OID 17965)
-- Name: cv_samplingfeaturegeotype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_samplingfeaturegeotype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 214 (class 1259 OID 17971)
-- Name: cv_samplingfeaturetype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_samplingfeaturetype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 215 (class 1259 OID 17977)
-- Name: cv_sitetype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_sitetype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 216 (class 1259 OID 17983)
-- Name: cv_spatialoffsettype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_spatialoffsettype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 217 (class 1259 OID 17989)
-- Name: cv_speciation; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_speciation (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 218 (class 1259 OID 17995)
-- Name: cv_specimentype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_specimentype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 219 (class 1259 OID 18001)
-- Name: cv_status; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_status (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 220 (class 1259 OID 18007)
-- Name: cv_taxonomicclassifiertype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_taxonomicclassifiertype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 221 (class 1259 OID 18013)
-- Name: cv_unitstype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_unitstype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 222 (class 1259 OID 18019)
-- Name: cv_variablename; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_variablename (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 223 (class 1259 OID 18025)
-- Name: cv_variabletype; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE cv_variabletype (
    term character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    definition character varying(5000),
    category character varying(255),
    sourcevocabularyuri character varying(255)
);


--
-- TOC entry 224 (class 1259 OID 18031)
-- Name: dataloggerfilecolumns; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE dataloggerfilecolumns (
    dataloggerfilecolumnid integer NOT NULL,
    resultid bigint,
    dataloggerfileid integer NOT NULL,
    instrumentoutputvariableid integer NOT NULL,
    columnlabel character varying(50) NOT NULL,
    columndescription character varying(5000),
    measurementequation character varying(255),
    scaninterval double precision,
    scanintervalunitsid integer,
    recordinginterval double precision,
    recordingintervalunitsid integer,
    aggregationstatisticcv character varying(255)
);


--
-- TOC entry 225 (class 1259 OID 18037)
-- Name: dataloggerfilecolumns_dataloggerfilecolumnid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE dataloggerfilecolumns_dataloggerfilecolumnid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3574 (class 0 OID 0)
-- Dependencies: 225
-- Name: dataloggerfilecolumns_dataloggerfilecolumnid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE dataloggerfilecolumns_dataloggerfilecolumnid_seq OWNED BY dataloggerfilecolumns.dataloggerfilecolumnid;


--
-- TOC entry 226 (class 1259 OID 18039)
-- Name: dataloggerfiles; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE dataloggerfiles (
    dataloggerfileid integer NOT NULL,
    programid integer NOT NULL,
    dataloggerfilename character varying(255) NOT NULL,
    dataloggerfiledescription character varying(5000),
    dataloggerfilelink character varying(255)
);


--
-- TOC entry 227 (class 1259 OID 18045)
-- Name: dataloggerfiles_dataloggerfileid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE dataloggerfiles_dataloggerfileid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3575 (class 0 OID 0)
-- Dependencies: 227
-- Name: dataloggerfiles_dataloggerfileid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE dataloggerfiles_dataloggerfileid_seq OWNED BY dataloggerfiles.dataloggerfileid;


--
-- TOC entry 228 (class 1259 OID 18047)
-- Name: dataloggerprogramfiles; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE dataloggerprogramfiles (
    programid integer NOT NULL,
    affiliationid integer NOT NULL,
    programname character varying(255) NOT NULL,
    programdescription character varying(5000),
    programversion character varying(50),
    programfilelink character varying(255)
);


--
-- TOC entry 229 (class 1259 OID 18053)
-- Name: dataloggerprogramfiles_programid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE dataloggerprogramfiles_programid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3576 (class 0 OID 0)
-- Dependencies: 229
-- Name: dataloggerprogramfiles_programid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE dataloggerprogramfiles_programid_seq OWNED BY dataloggerprogramfiles.programid;


--
-- TOC entry 230 (class 1259 OID 18055)
-- Name: dataquality; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE dataquality (
    dataqualityid integer NOT NULL,
    dataqualitytypecv character varying(255) NOT NULL,
    dataqualitycode character varying(255) NOT NULL,
    dataqualityvalue double precision,
    dataqualityvalueunitsid integer,
    dataqualitydescription character varying(5000),
    dataqualitylink character varying(255)
);


--
-- TOC entry 231 (class 1259 OID 18061)
-- Name: datasetcitations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE datasetcitations (
    bridgeid integer NOT NULL,
    datasetid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    citationid integer NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 18064)
-- Name: datasetcitations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE datasetcitations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3577 (class 0 OID 0)
-- Dependencies: 232
-- Name: datasetcitations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE datasetcitations_bridgeid_seq OWNED BY datasetcitations.bridgeid;


--
-- TOC entry 233 (class 1259 OID 18066)
-- Name: datasets; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE datasets (
    datasetid integer NOT NULL,
    datasetuuid uuid NOT NULL,
    datasettypecv character varying(255) NOT NULL,
    datasetcode character varying(50) NOT NULL,
    datasettitle character varying(255) NOT NULL,
    datasetabstract character varying(5000) NOT NULL
);


--
-- TOC entry 234 (class 1259 OID 18072)
-- Name: datasets_datasetid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE datasets_datasetid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3578 (class 0 OID 0)
-- Dependencies: 234
-- Name: datasets_datasetid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE datasets_datasetid_seq OWNED BY datasets.datasetid;


--
-- TOC entry 235 (class 1259 OID 18074)
-- Name: datasetsresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE datasetsresults (
    bridgeid integer NOT NULL,
    datasetid integer NOT NULL,
    resultid bigint NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 18077)
-- Name: datasetsresults_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE datasetsresults_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3579 (class 0 OID 0)
-- Dependencies: 236
-- Name: datasetsresults_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE datasetsresults_bridgeid_seq OWNED BY datasetsresults.bridgeid;


--
-- TOC entry 237 (class 1259 OID 18079)
-- Name: derivationequations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE derivationequations (
    derivationequationid integer NOT NULL,
    derivationequation character varying(255) NOT NULL
);


--
-- TOC entry 238 (class 1259 OID 18082)
-- Name: derivationequations_derivationequationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE derivationequations_derivationequationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3580 (class 0 OID 0)
-- Dependencies: 238
-- Name: derivationequations_derivationequationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE derivationequations_derivationequationid_seq OWNED BY derivationequations.derivationequationid;


--
-- TOC entry 239 (class 1259 OID 18084)
-- Name: directives; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE directives (
    directiveid integer NOT NULL,
    directivetypecv character varying(255) NOT NULL,
    directivedescription character varying(5000) NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 18090)
-- Name: directives_directiveid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE directives_directiveid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3581 (class 0 OID 0)
-- Dependencies: 240
-- Name: directives_directiveid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE directives_directiveid_seq OWNED BY directives.directiveid;


--
-- TOC entry 241 (class 1259 OID 18092)
-- Name: equipment; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE equipment (
    equipmentid integer NOT NULL,
    equipmentcode character varying(50) NOT NULL,
    equipmentname character varying(255) NOT NULL,
    equipmenttypecv character varying(255) NOT NULL,
    equipmentmodelid integer NOT NULL,
    equipmentserialnumber character varying(50) NOT NULL,
    equipmentownerid integer NOT NULL,
    equipmentvendorid integer NOT NULL,
    equipmentpurchasedate timestamp without time zone NOT NULL,
    equipmentpurchaseordernumber character varying(50),
    equipmentdescription character varying(5000),
    equipmentdocumentationlink character varying(255)
);


--
-- TOC entry 242 (class 1259 OID 18098)
-- Name: equipment_equipmentid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE equipment_equipmentid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3582 (class 0 OID 0)
-- Dependencies: 242
-- Name: equipment_equipmentid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE equipment_equipmentid_seq OWNED BY equipment.equipmentid;


--
-- TOC entry 243 (class 1259 OID 18100)
-- Name: equipmentannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE equipmentannotations (
    bridgeid integer NOT NULL,
    equipmentid integer NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 18103)
-- Name: equipmentannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE equipmentannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3583 (class 0 OID 0)
-- Dependencies: 244
-- Name: equipmentannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE equipmentannotations_bridgeid_seq OWNED BY equipmentannotations.bridgeid;


--
-- TOC entry 245 (class 1259 OID 18105)
-- Name: equipmentmodels; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE equipmentmodels (
    equipmentmodelid integer NOT NULL,
    modelmanufacturerid integer NOT NULL,
    modelpartnumber character varying(50),
    modelname character varying(255) NOT NULL,
    modeldescription character varying(5000),
    isinstrument boolean NOT NULL,
    modelspecificationsfilelink character varying(255),
    modellink character varying(255)
);


--
-- TOC entry 246 (class 1259 OID 18111)
-- Name: equipmentmodels_equipmentmodelid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE equipmentmodels_equipmentmodelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 246
-- Name: equipmentmodels_equipmentmodelid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE equipmentmodels_equipmentmodelid_seq OWNED BY equipmentmodels.equipmentmodelid;


--
-- TOC entry 247 (class 1259 OID 18113)
-- Name: equipmentused; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE equipmentused (
    bridgeid integer NOT NULL,
    actionid integer NOT NULL,
    equipmentid integer NOT NULL
);


--
-- TOC entry 248 (class 1259 OID 18116)
-- Name: equipmentused_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE equipmentused_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 248
-- Name: equipmentused_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE equipmentused_bridgeid_seq OWNED BY equipmentused.bridgeid;


--
-- TOC entry 249 (class 1259 OID 18118)
-- Name: extensionproperties; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE extensionproperties (
    propertyid integer NOT NULL,
    propertyname character varying(255) NOT NULL,
    propertydescription character varying(5000),
    propertydatatypecv character varying(255) NOT NULL,
    propertyunitsid integer
);


--
-- TOC entry 250 (class 1259 OID 18124)
-- Name: extensionproperties_propertyid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE extensionproperties_propertyid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 250
-- Name: extensionproperties_propertyid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE extensionproperties_propertyid_seq OWNED BY extensionproperties.propertyid;


--
-- TOC entry 251 (class 1259 OID 18126)
-- Name: externalidentifiersystems; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE externalidentifiersystems (
    externalidentifiersystemid integer NOT NULL,
    externalidentifiersystemname character varying(255) NOT NULL,
    identifiersystemorganizationid integer NOT NULL,
    externalidentifiersystemdescription character varying(5000),
    externalidentifiersystemurl character varying(255)
);


--
-- TOC entry 252 (class 1259 OID 18132)
-- Name: externalidentifiersystems_externalidentifiersystemid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE externalidentifiersystems_externalidentifiersystemid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 252
-- Name: externalidentifiersystems_externalidentifiersystemid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE externalidentifiersystems_externalidentifiersystemid_seq OWNED BY externalidentifiersystems.externalidentifiersystemid;


--
-- TOC entry 253 (class 1259 OID 18134)
-- Name: featureactions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE featureactions (
    featureactionid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    actionid integer NOT NULL
);


--
-- TOC entry 254 (class 1259 OID 18137)
-- Name: featureactions_featureactionid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE featureactions_featureactionid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 254
-- Name: featureactions_featureactionid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE featureactions_featureactionid_seq OWNED BY featureactions.featureactionid;


--
-- TOC entry 255 (class 1259 OID 18139)
-- Name: instrumentoutputvariables; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE instrumentoutputvariables (
    instrumentoutputvariableid integer NOT NULL,
    modelid integer NOT NULL,
    variableid integer NOT NULL,
    instrumentmethodid integer NOT NULL,
    instrumentresolution character varying(255),
    instrumentaccuracy character varying(255),
    instrumentrawoutputunitsid integer NOT NULL
);


--
-- TOC entry 256 (class 1259 OID 18145)
-- Name: instrumentoutputvariables_instrumentoutputvariableid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE instrumentoutputvariables_instrumentoutputvariableid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 256
-- Name: instrumentoutputvariables_instrumentoutputvariableid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE instrumentoutputvariables_instrumentoutputvariableid_seq OWNED BY instrumentoutputvariables.instrumentoutputvariableid;


--
-- TOC entry 257 (class 1259 OID 18147)
-- Name: maintenanceactions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE maintenanceactions (
    actionid integer NOT NULL,
    isfactoryservice boolean NOT NULL,
    maintenancecode character varying(50),
    maintenancereason character varying(500)
);


--
-- TOC entry 258 (class 1259 OID 18153)
-- Name: measurementresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE measurementresults (
    resultid bigint NOT NULL,
    xlocation double precision,
    xlocationunitsid integer,
    ylocation double precision,
    ylocationunitsid integer,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    aggregationstatisticcv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 259 (class 1259 OID 18159)
-- Name: measurementresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE measurementresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 260 (class 1259 OID 18162)
-- Name: measurementresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE measurementresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 260
-- Name: measurementresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE measurementresultvalueannotations_bridgeid_seq OWNED BY measurementresultvalueannotations.bridgeid;


--
-- TOC entry 261 (class 1259 OID 18164)
-- Name: measurementresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE measurementresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL
);


--
-- TOC entry 262 (class 1259 OID 18167)
-- Name: measurementresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE measurementresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 262
-- Name: measurementresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE measurementresultvalues_valueid_seq OWNED BY measurementresultvalues.valueid;


--
-- TOC entry 263 (class 1259 OID 18169)
-- Name: methodannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE methodannotations (
    bridgeid integer NOT NULL,
    methodid integer NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 264 (class 1259 OID 18172)
-- Name: methodannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE methodannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 264
-- Name: methodannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE methodannotations_bridgeid_seq OWNED BY methodannotations.bridgeid;


--
-- TOC entry 265 (class 1259 OID 18174)
-- Name: methodcitations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE methodcitations (
    bridgeid integer NOT NULL,
    methodid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    citationid integer NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 18177)
-- Name: methodcitations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE methodcitations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 266
-- Name: methodcitations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE methodcitations_bridgeid_seq OWNED BY methodcitations.bridgeid;


--
-- TOC entry 267 (class 1259 OID 18179)
-- Name: methodextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE methodextensionpropertyvalues (
    bridgeid integer NOT NULL,
    methodid integer NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 268 (class 1259 OID 18182)
-- Name: methodextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE methodextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 268
-- Name: methodextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE methodextensionpropertyvalues_bridgeid_seq OWNED BY methodextensionpropertyvalues.bridgeid;


--
-- TOC entry 269 (class 1259 OID 18184)
-- Name: methodexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE methodexternalidentifiers (
    bridgeid integer NOT NULL,
    methodid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    methodexternalidentifier character varying(255) NOT NULL,
    methodexternalidentifieruri character varying(255)
);


--
-- TOC entry 270 (class 1259 OID 18190)
-- Name: methodexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE methodexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 270
-- Name: methodexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE methodexternalidentifiers_bridgeid_seq OWNED BY methodexternalidentifiers.bridgeid;


--
-- TOC entry 271 (class 1259 OID 18192)
-- Name: methods; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE methods (
    methodid integer NOT NULL,
    methodtypecv character varying(255) NOT NULL,
    methodcode character varying(50) NOT NULL,
    methodname character varying(255) NOT NULL,
    methoddescription character varying(5000),
    methodlink character varying(255),
    organizationid integer
);


--
-- TOC entry 272 (class 1259 OID 18198)
-- Name: methods_methodid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE methods_methodid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 272
-- Name: methods_methodid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE methods_methodid_seq OWNED BY methods.methodid;


--
-- TOC entry 273 (class 1259 OID 18200)
-- Name: modelaffiliations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE modelaffiliations (
    bridgeid integer NOT NULL,
    modelid integer NOT NULL,
    affiliationid integer NOT NULL,
    isprimary boolean NOT NULL,
    roledescription character varying(5000)
);


--
-- TOC entry 274 (class 1259 OID 18206)
-- Name: modelaffiliations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE modelaffiliations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 274
-- Name: modelaffiliations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE modelaffiliations_bridgeid_seq OWNED BY modelaffiliations.bridgeid;


--
-- TOC entry 275 (class 1259 OID 18208)
-- Name: models; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE models (
    modelid integer NOT NULL,
    modelcode character varying(50) NOT NULL,
    modelname character varying(255) NOT NULL,
    modeldescription character varying(5000),
    version character varying(255),
    modellink character varying(255)
);


--
-- TOC entry 276 (class 1259 OID 18214)
-- Name: models_modelid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE models_modelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 276
-- Name: models_modelid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE models_modelid_seq OWNED BY models.modelid;


--
-- TOC entry 277 (class 1259 OID 18216)
-- Name: organizations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE organizations (
    organizationid integer NOT NULL,
    organizationtypecv character varying(255) NOT NULL,
    organizationcode character varying(50) NOT NULL,
    organizationname character varying(255) NOT NULL,
    organizationdescription character varying(5000),
    organizationlink character varying(255),
    parentorganizationid integer
);


--
-- TOC entry 278 (class 1259 OID 18222)
-- Name: organizations_organizationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE organizations_organizationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 278
-- Name: organizations_organizationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE organizations_organizationid_seq OWNED BY organizations.organizationid;


--
-- TOC entry 279 (class 1259 OID 18224)
-- Name: people; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE people (
    personid integer NOT NULL,
    personfirstname character varying(255) NOT NULL,
    personmiddlename character varying(255),
    personlastname character varying(255) NOT NULL
);


--
-- TOC entry 280 (class 1259 OID 18230)
-- Name: people_personid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE people_personid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 280
-- Name: people_personid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE people_personid_seq OWNED BY people.personid;


--
-- TOC entry 281 (class 1259 OID 18232)
-- Name: personexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE personexternalidentifiers (
    bridgeid integer NOT NULL,
    personid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    personexternalidentifier character varying(255) NOT NULL,
    personexternalidentifieruri character varying(255)
);


--
-- TOC entry 282 (class 1259 OID 18238)
-- Name: personexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE personexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 282
-- Name: personexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE personexternalidentifiers_bridgeid_seq OWNED BY personexternalidentifiers.bridgeid;


--
-- TOC entry 283 (class 1259 OID 18240)
-- Name: pointcoverageresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE pointcoverageresults (
    resultid bigint NOT NULL,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    intendedxspacing double precision,
    intendedxspacingunitsid integer,
    intendedyspacing double precision,
    intendedyspacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 284 (class 1259 OID 18243)
-- Name: pointcoverageresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE pointcoverageresultvalueannotations (
    bridgeid bigint NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 285 (class 1259 OID 18246)
-- Name: pointcoverageresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE pointcoverageresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 285
-- Name: pointcoverageresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE pointcoverageresultvalueannotations_bridgeid_seq OWNED BY pointcoverageresultvalueannotations.bridgeid;


--
-- TOC entry 286 (class 1259 OID 18248)
-- Name: pointcoverageresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE pointcoverageresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    xlocation double precision NOT NULL,
    xlocationunitsid integer NOT NULL,
    ylocation double precision NOT NULL,
    ylocationunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL
);


--
-- TOC entry 287 (class 1259 OID 18254)
-- Name: pointcoverageresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE pointcoverageresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 287
-- Name: pointcoverageresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE pointcoverageresultvalues_valueid_seq OWNED BY pointcoverageresultvalues.valueid;


--
-- TOC entry 288 (class 1259 OID 18256)
-- Name: processinglevels; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE processinglevels (
    processinglevelid integer NOT NULL,
    processinglevelcode character varying(50) NOT NULL,
    definition character varying(5000),
    explanation character varying(5000)
);


--
-- TOC entry 289 (class 1259 OID 18262)
-- Name: processinglevels_processinglevelid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE processinglevels_processinglevelid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 289
-- Name: processinglevels_processinglevelid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE processinglevels_processinglevelid_seq OWNED BY processinglevels.processinglevelid;


--
-- TOC entry 290 (class 1259 OID 18264)
-- Name: profileresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE profileresults (
    resultid bigint NOT NULL,
    xlocation double precision,
    xlocationunitsid integer,
    ylocation double precision,
    ylocationunitsid integer,
    spatialreferenceid integer,
    intendedzspacing double precision,
    intendedzspacingunitsid integer,
    intendedtimespacing double precision,
    intendedtimespacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 291 (class 1259 OID 18267)
-- Name: profileresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE profileresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 292 (class 1259 OID 18270)
-- Name: profileresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE profileresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 292
-- Name: profileresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE profileresultvalueannotations_bridgeid_seq OWNED BY profileresultvalueannotations.bridgeid;


--
-- TOC entry 293 (class 1259 OID 18272)
-- Name: profileresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE profileresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    zlocation double precision NOT NULL,
    zaggregationinterval double precision NOT NULL,
    zlocationunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 294 (class 1259 OID 18278)
-- Name: profileresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE profileresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 294
-- Name: profileresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE profileresultvalues_valueid_seq OWNED BY profileresultvalues.valueid;


--
-- TOC entry 295 (class 1259 OID 18280)
-- Name: referencematerialexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE referencematerialexternalidentifiers (
    bridgeid integer NOT NULL,
    referencematerialid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    referencematerialexternalidentifier character varying(255) NOT NULL,
    referencematerialexternalidentifieruri character varying(255)
);


--
-- TOC entry 296 (class 1259 OID 18286)
-- Name: referencematerialexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE referencematerialexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 296
-- Name: referencematerialexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE referencematerialexternalidentifiers_bridgeid_seq OWNED BY referencematerialexternalidentifiers.bridgeid;


--
-- TOC entry 297 (class 1259 OID 18288)
-- Name: referencematerials; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE referencematerials (
    referencematerialid integer NOT NULL,
    referencematerialmediumcv character varying(255) NOT NULL,
    referencematerialorganizationid integer NOT NULL,
    referencematerialcode character varying(50) NOT NULL,
    referencemateriallotcode character varying(255),
    referencematerialpurchasedate timestamp without time zone,
    referencematerialexpirationdate timestamp without time zone,
    referencematerialcertificatelink character varying(255),
    samplingfeatureid integer
);


--
-- TOC entry 298 (class 1259 OID 18294)
-- Name: referencematerials_referencematerialid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE referencematerials_referencematerialid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 298
-- Name: referencematerials_referencematerialid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE referencematerials_referencematerialid_seq OWNED BY referencematerials.referencematerialid;


--
-- TOC entry 299 (class 1259 OID 18296)
-- Name: referencematerialvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE referencematerialvalues (
    referencematerialvalueid integer NOT NULL,
    referencematerialid integer NOT NULL,
    referencematerialvalue double precision NOT NULL,
    referencematerialaccuracy double precision,
    variableid integer NOT NULL,
    unitsid integer NOT NULL,
    citationid integer
);


--
-- TOC entry 300 (class 1259 OID 18299)
-- Name: referencematerialvalues_referencematerialvalueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE referencematerialvalues_referencematerialvalueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 300
-- Name: referencematerialvalues_referencematerialvalueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE referencematerialvalues_referencematerialvalueid_seq OWNED BY referencematerialvalues.referencematerialvalueid;


--
-- TOC entry 301 (class 1259 OID 18301)
-- Name: relatedactions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedactions (
    relationid integer NOT NULL,
    actionid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedactionid integer NOT NULL
);


--
-- TOC entry 302 (class 1259 OID 18304)
-- Name: relatedactions_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedactions_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 302
-- Name: relatedactions_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedactions_relationid_seq OWNED BY relatedactions.relationid;


--
-- TOC entry 303 (class 1259 OID 18306)
-- Name: relatedannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedannotations (
    relationid integer NOT NULL,
    annotationid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedannotationid integer NOT NULL
);


--
-- TOC entry 304 (class 1259 OID 18309)
-- Name: relatedannotations_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedannotations_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 304
-- Name: relatedannotations_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedannotations_relationid_seq OWNED BY relatedannotations.relationid;


--
-- TOC entry 305 (class 1259 OID 18311)
-- Name: relatedcitations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedcitations (
    relationid integer NOT NULL,
    citationid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedcitationid integer NOT NULL
);


--
-- TOC entry 306 (class 1259 OID 18314)
-- Name: relatedcitations_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedcitations_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 306
-- Name: relatedcitations_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedcitations_relationid_seq OWNED BY relatedcitations.relationid;


--
-- TOC entry 307 (class 1259 OID 18316)
-- Name: relateddatasets; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relateddatasets (
    relationid integer NOT NULL,
    datasetid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relateddatasetid integer NOT NULL,
    versioncode character varying(50)
);


--
-- TOC entry 308 (class 1259 OID 18319)
-- Name: relateddatasets_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relateddatasets_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 308
-- Name: relateddatasets_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relateddatasets_relationid_seq OWNED BY relateddatasets.relationid;


--
-- TOC entry 309 (class 1259 OID 18321)
-- Name: relatedequipment; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedequipment (
    relationid integer NOT NULL,
    equipmentid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedequipmentid integer NOT NULL,
    relationshipstartdatetime timestamp without time zone NOT NULL,
    relationshipstartdatetimeutcoffset integer NOT NULL,
    relationshipenddatetime timestamp without time zone,
    relationshipenddatetimeutcoffset integer
);


--
-- TOC entry 310 (class 1259 OID 18324)
-- Name: relatedequipment_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedequipment_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 310
-- Name: relatedequipment_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedequipment_relationid_seq OWNED BY relatedequipment.relationid;


--
-- TOC entry 311 (class 1259 OID 18326)
-- Name: relatedfeatures; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedfeatures (
    relationid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedfeatureid integer NOT NULL,
    spatialoffsetid integer
);


--
-- TOC entry 312 (class 1259 OID 18329)
-- Name: relatedfeatures_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedfeatures_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 312
-- Name: relatedfeatures_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedfeatures_relationid_seq OWNED BY relatedfeatures.relationid;


--
-- TOC entry 313 (class 1259 OID 18331)
-- Name: relatedmodels; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedmodels (
    relatedid integer NOT NULL,
    modelid integer NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedmodelid integer NOT NULL
);


--
-- TOC entry 314 (class 1259 OID 18334)
-- Name: relatedmodels_relatedid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedmodels_relatedid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 314
-- Name: relatedmodels_relatedid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedmodels_relatedid_seq OWNED BY relatedmodels.relatedid;


--
-- TOC entry 315 (class 1259 OID 18336)
-- Name: relatedresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE relatedresults (
    relationid integer NOT NULL,
    resultid bigint NOT NULL,
    relationshiptypecv character varying(255) NOT NULL,
    relatedresultid bigint NOT NULL,
    versioncode character varying(50),
    relatedresultsequencenumber integer
);


--
-- TOC entry 316 (class 1259 OID 18339)
-- Name: relatedresults_relationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE relatedresults_relationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 316
-- Name: relatedresults_relationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE relatedresults_relationid_seq OWNED BY relatedresults.relationid;


--
-- TOC entry 317 (class 1259 OID 18341)
-- Name: resultannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE resultannotations (
    bridgeid integer NOT NULL,
    resultid bigint NOT NULL,
    annotationid integer NOT NULL,
    begindatetime timestamp without time zone NOT NULL,
    enddatetime timestamp without time zone NOT NULL
);


--
-- TOC entry 318 (class 1259 OID 18344)
-- Name: resultannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE resultannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 318
-- Name: resultannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE resultannotations_bridgeid_seq OWNED BY resultannotations.bridgeid;


--
-- TOC entry 319 (class 1259 OID 18346)
-- Name: resultderivationequations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE resultderivationequations (
    resultid bigint NOT NULL,
    derivationequationid integer NOT NULL
);


--
-- TOC entry 320 (class 1259 OID 18349)
-- Name: resultextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE resultextensionpropertyvalues (
    bridgeid integer NOT NULL,
    resultid bigint NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 321 (class 1259 OID 18352)
-- Name: resultextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE resultextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 321
-- Name: resultextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE resultextensionpropertyvalues_bridgeid_seq OWNED BY resultextensionpropertyvalues.bridgeid;


--
-- TOC entry 322 (class 1259 OID 18354)
-- Name: resultnormalizationvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE resultnormalizationvalues (
    resultid bigint NOT NULL,
    normalizedbyreferencematerialvalueid integer NOT NULL
);


--
-- TOC entry 323 (class 1259 OID 18357)
-- Name: results; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE results (
    resultid bigint NOT NULL,
    resultuuid uuid NOT NULL,
    featureactionid integer NOT NULL,
    resulttypecv character varying(255) NOT NULL,
    variableid integer NOT NULL,
    unitsid integer NOT NULL,
    taxonomicclassifierid integer,
    processinglevelid integer NOT NULL,
    resultdatetime timestamp without time zone,
    resultdatetimeutcoffset bigint,
    validdatetime timestamp without time zone,
    validdatetimeutcoffset bigint,
    statuscv character varying(255),
    sampledmediumcv character varying(255) NOT NULL,
    valuecount integer NOT NULL
);


--
-- TOC entry 324 (class 1259 OID 18363)
-- Name: results_resultid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE results_resultid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 324
-- Name: results_resultid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE results_resultid_seq OWNED BY results.resultid;


--
-- TOC entry 325 (class 1259 OID 18365)
-- Name: resultsdataquality; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE resultsdataquality (
    bridgeid integer NOT NULL,
    resultid bigint NOT NULL,
    dataqualityid integer NOT NULL
);


--
-- TOC entry 326 (class 1259 OID 18368)
-- Name: resultsdataquality_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE resultsdataquality_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 326
-- Name: resultsdataquality_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE resultsdataquality_bridgeid_seq OWNED BY resultsdataquality.bridgeid;


--
-- TOC entry 327 (class 1259 OID 18370)
-- Name: samplingfeatureannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE samplingfeatureannotations (
    bridgeid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 328 (class 1259 OID 18373)
-- Name: samplingfeatureannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE samplingfeatureannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 328
-- Name: samplingfeatureannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE samplingfeatureannotations_bridgeid_seq OWNED BY samplingfeatureannotations.bridgeid;


--
-- TOC entry 329 (class 1259 OID 18375)
-- Name: samplingfeatureextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE samplingfeatureextensionpropertyvalues (
    bridgeid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 330 (class 1259 OID 18378)
-- Name: samplingfeatureextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE samplingfeatureextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 330
-- Name: samplingfeatureextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE samplingfeatureextensionpropertyvalues_bridgeid_seq OWNED BY samplingfeatureextensionpropertyvalues.bridgeid;


--
-- TOC entry 331 (class 1259 OID 18380)
-- Name: samplingfeatureexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE samplingfeatureexternalidentifiers (
    bridgeid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    samplingfeatureexternalidentifier character varying(255) NOT NULL,
    samplingfeatureexternalidentifieruri character varying(255)
);


--
-- TOC entry 332 (class 1259 OID 18386)
-- Name: samplingfeatureexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE samplingfeatureexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 332
-- Name: samplingfeatureexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE samplingfeatureexternalidentifiers_bridgeid_seq OWNED BY samplingfeatureexternalidentifiers.bridgeid;


--
-- TOC entry 333 (class 1259 OID 18388)
-- Name: samplingfeatures; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE samplingfeatures (
    samplingfeatureid integer NOT NULL,
    samplingfeatureuuid uuid NOT NULL,
    samplingfeaturetypecv character varying(255) NOT NULL,
    samplingfeaturecode character varying(50) NOT NULL,
    samplingfeaturename character varying(255),
    samplingfeaturedescription character varying(5000),
    samplingfeaturegeotypecv character varying(255),
    featuregeometry character varying(8000),
    featuregeometrywkt character varying(8000),
    elevation_m double precision,
    elevationdatumcv character varying(255)
);


--
-- TOC entry 334 (class 1259 OID 18394)
-- Name: samplingfeatures_samplingfeatureid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE samplingfeatures_samplingfeatureid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 334
-- Name: samplingfeatures_samplingfeatureid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE samplingfeatures_samplingfeatureid_seq OWNED BY samplingfeatures.samplingfeatureid;


--
-- TOC entry 335 (class 1259 OID 18396)
-- Name: sectionresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE sectionresults (
    resultid bigint NOT NULL,
    ylocation double precision,
    ylocationunitsid integer,
    spatialreferenceid integer,
    intendedxspacing double precision,
    intendedxspacingunitsid integer,
    intendedzspacing double precision,
    intendedzspacingunitsid integer,
    intendedtimespacing double precision,
    intendedtimespacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 336 (class 1259 OID 18399)
-- Name: sectionresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE sectionresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 337 (class 1259 OID 18402)
-- Name: sectionresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE sectionresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 337
-- Name: sectionresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE sectionresultvalueannotations_bridgeid_seq OWNED BY sectionresultvalueannotations.bridgeid;


--
-- TOC entry 338 (class 1259 OID 18404)
-- Name: sectionresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE sectionresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    xlocation double precision NOT NULL,
    xaggregationinterval double precision NOT NULL,
    xlocationunitsid integer NOT NULL,
    zlocation bigint NOT NULL,
    zaggregationinterval double precision NOT NULL,
    zlocationunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    aggregationstatisticcv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 339 (class 1259 OID 18410)
-- Name: sectionresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE sectionresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 339
-- Name: sectionresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE sectionresultvalues_valueid_seq OWNED BY sectionresultvalues.valueid;


--
-- TOC entry 340 (class 1259 OID 18412)
-- Name: simulations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE simulations (
    simulationid integer NOT NULL,
    actionid integer NOT NULL,
    simulationname character varying(255) NOT NULL,
    simulationdescription character varying(5000),
    simulationstartdatetime timestamp without time zone NOT NULL,
    simulationstartdatetimeutcoffset integer NOT NULL,
    simulationenddatetime timestamp without time zone NOT NULL,
    simulationenddatetimeutcoffset integer NOT NULL,
    timestepvalue double precision NOT NULL,
    timestepunitsid integer NOT NULL,
    inputdatasetid integer,
    modelid integer NOT NULL
);


--
-- TOC entry 341 (class 1259 OID 18418)
-- Name: simulations_simulationid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE simulations_simulationid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 341
-- Name: simulations_simulationid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE simulations_simulationid_seq OWNED BY simulations.simulationid;


--
-- TOC entry 342 (class 1259 OID 18420)
-- Name: sites; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE sites (
    samplingfeatureid integer NOT NULL,
    sitetypecv character varying(255) NOT NULL,
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    spatialreferenceid integer NOT NULL
);


--
-- TOC entry 343 (class 1259 OID 18423)
-- Name: spatialoffsets; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spatialoffsets (
    spatialoffsetid integer NOT NULL,
    spatialoffsettypecv character varying(255) NOT NULL,
    offset1value double precision NOT NULL,
    offset1unitid integer NOT NULL,
    offset2value double precision,
    offset2unitid integer,
    offset3value double precision,
    offset3unitid integer
);


--
-- TOC entry 344 (class 1259 OID 18426)
-- Name: spatialoffsets_spatialoffsetid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE spatialoffsets_spatialoffsetid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 344
-- Name: spatialoffsets_spatialoffsetid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE spatialoffsets_spatialoffsetid_seq OWNED BY spatialoffsets.spatialoffsetid;


--
-- TOC entry 345 (class 1259 OID 18428)
-- Name: spatialreferenceexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spatialreferenceexternalidentifiers (
    bridgeid integer NOT NULL,
    spatialreferenceid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    spatialreferenceexternalidentifier character varying(255) NOT NULL,
    spatialreferenceexternalidentifieruri character varying(255)
);


--
-- TOC entry 346 (class 1259 OID 18434)
-- Name: spatialreferenceexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE spatialreferenceexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 346
-- Name: spatialreferenceexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE spatialreferenceexternalidentifiers_bridgeid_seq OWNED BY spatialreferenceexternalidentifiers.bridgeid;


--
-- TOC entry 347 (class 1259 OID 18436)
-- Name: spatialreferences; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spatialreferences (
    spatialreferenceid integer NOT NULL,
    srscode character varying(50),
    srsname character varying(255) NOT NULL,
    srsdescription character varying(5000),
    srslink character varying(255)
);


--
-- TOC entry 348 (class 1259 OID 18442)
-- Name: spatialreferences_spatialreferenceid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE spatialreferences_spatialreferenceid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 348
-- Name: spatialreferences_spatialreferenceid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE spatialreferences_spatialreferenceid_seq OWNED BY spatialreferences.spatialreferenceid;


--
-- TOC entry 349 (class 1259 OID 18444)
-- Name: specimenbatchpostions; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE specimenbatchpostions (
    featureactionid integer NOT NULL,
    batchpositionnumber integer NOT NULL,
    batchpositionlabel character varying(255)
);


--
-- TOC entry 350 (class 1259 OID 18447)
-- Name: specimens; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE specimens (
    samplingfeatureid integer NOT NULL,
    specimentypecv character varying(255) NOT NULL,
    specimenmediumcv character varying(255) NOT NULL,
    isfieldspecimen boolean NOT NULL
);


--
-- TOC entry 351 (class 1259 OID 18453)
-- Name: specimentaxonomicclassifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE specimentaxonomicclassifiers (
    bridgeid integer NOT NULL,
    samplingfeatureid integer NOT NULL,
    taxonomicclassifierid integer NOT NULL,
    citationid integer
);


--
-- TOC entry 352 (class 1259 OID 18456)
-- Name: specimentaxonomicclassifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE specimentaxonomicclassifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 352
-- Name: specimentaxonomicclassifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE specimentaxonomicclassifiers_bridgeid_seq OWNED BY specimentaxonomicclassifiers.bridgeid;


--
-- TOC entry 353 (class 1259 OID 18458)
-- Name: spectraresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spectraresults (
    resultid bigint NOT NULL,
    xlocation double precision,
    xlocationunitsid integer,
    ylocation double precision,
    ylocationunitsid integer,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    intendedwavelengthspacing double precision,
    intendedwavelengthspacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 354 (class 1259 OID 18461)
-- Name: spectraresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spectraresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 355 (class 1259 OID 18464)
-- Name: spectraresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE spectraresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 355
-- Name: spectraresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE spectraresultvalueannotations_bridgeid_seq OWNED BY spectraresultvalueannotations.bridgeid;


--
-- TOC entry 356 (class 1259 OID 18466)
-- Name: spectraresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE spectraresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    excitationwavelength double precision NOT NULL,
    emissionwavelength double precision NOT NULL,
    wavelengthunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 357 (class 1259 OID 18472)
-- Name: spectraresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE spectraresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 357
-- Name: spectraresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE spectraresultvalues_valueid_seq OWNED BY spectraresultvalues.valueid;


--
-- TOC entry 358 (class 1259 OID 18474)
-- Name: taxonomicclassifierexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE taxonomicclassifierexternalidentifiers (
    bridgeid integer NOT NULL,
    taxonomicclassifierid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    taxonomicclassifierexternalidentifier character varying(255) NOT NULL,
    taxonomicclassifierexternalidentifieruri character varying(255)
);


--
-- TOC entry 359 (class 1259 OID 18480)
-- Name: taxonomicclassifierexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE taxonomicclassifierexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 359
-- Name: taxonomicclassifierexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE taxonomicclassifierexternalidentifiers_bridgeid_seq OWNED BY taxonomicclassifierexternalidentifiers.bridgeid;


--
-- TOC entry 360 (class 1259 OID 18482)
-- Name: taxonomicclassifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE taxonomicclassifiers (
    taxonomicclassifierid integer NOT NULL,
    taxonomicclassifiertypecv character varying(255) NOT NULL,
    taxonomicclassifiername character varying(255) NOT NULL,
    taxonomicclassifiercommonname character varying(255),
    taxonomicclassifierdescription character varying(5000),
    parenttaxonomicclassifierid integer
);


--
-- TOC entry 361 (class 1259 OID 18488)
-- Name: taxonomicclassifiers_taxonomicclassifierid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE taxonomicclassifiers_taxonomicclassifierid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 361
-- Name: taxonomicclassifiers_taxonomicclassifierid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE taxonomicclassifiers_taxonomicclassifierid_seq OWNED BY taxonomicclassifiers.taxonomicclassifierid;


--
-- TOC entry 362 (class 1259 OID 18490)
-- Name: timeseriesresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE timeseriesresults (
    resultid bigint NOT NULL,
    xlocation double precision,
    xlocationunitsid integer,
    ylocation double precision,
    ylocationunitsid integer,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    intendedtimespacing double precision,
    intendedtimespacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 363 (class 1259 OID 18493)
-- Name: timeseriesresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE timeseriesresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 364 (class 1259 OID 18496)
-- Name: timeseriesresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE timeseriesresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 364
-- Name: timeseriesresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE timeseriesresultvalueannotations_bridgeid_seq OWNED BY timeseriesresultvalueannotations.bridgeid;


--
-- TOC entry 365 (class 1259 OID 18498)
-- Name: timeseriesresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE timeseriesresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 366 (class 1259 OID 18504)
-- Name: timeseriesresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE timeseriesresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 366
-- Name: timeseriesresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE timeseriesresultvalues_valueid_seq OWNED BY timeseriesresultvalues.valueid;


--
-- TOC entry 367 (class 1259 OID 18506)
-- Name: trajectoryresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE trajectoryresults (
    resultid bigint NOT NULL,
    spatialreferenceid integer,
    intendedtrajectoryspacing double precision,
    intendedtrajectoryspacingunitsid integer,
    intendedtimespacing double precision,
    intendedtimespacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 368 (class 1259 OID 18509)
-- Name: trajectoryresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE trajectoryresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 369 (class 1259 OID 18512)
-- Name: trajectoryresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE trajectoryresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 369
-- Name: trajectoryresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE trajectoryresultvalueannotations_bridgeid_seq OWNED BY trajectoryresultvalueannotations.bridgeid;


--
-- TOC entry 370 (class 1259 OID 18514)
-- Name: trajectoryresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE trajectoryresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    xlocation double precision NOT NULL,
    xlocationunitsid integer NOT NULL,
    ylocation double precision NOT NULL,
    ylocationunitsid integer NOT NULL,
    zlocation double precision NOT NULL,
    zlocationunitsid integer NOT NULL,
    trajectorydistance double precision NOT NULL,
    trajectorydistanceaggregationinterval double precision NOT NULL,
    trajectorydistanceunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 371 (class 1259 OID 18520)
-- Name: trajectoryresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE trajectoryresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 371
-- Name: trajectoryresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE trajectoryresultvalues_valueid_seq OWNED BY trajectoryresultvalues.valueid;


--
-- TOC entry 372 (class 1259 OID 18522)
-- Name: transectresults; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE transectresults (
    resultid bigint NOT NULL,
    zlocation double precision,
    zlocationunitsid integer,
    spatialreferenceid integer,
    intendedtransectspacing double precision,
    intendedtransectspacingunitsid integer,
    intendedtimespacing double precision,
    intendedtimespacingunitsid integer,
    aggregationstatisticcv character varying(255) NOT NULL
);


--
-- TOC entry 373 (class 1259 OID 18525)
-- Name: transectresultvalueannotations; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE transectresultvalueannotations (
    bridgeid integer NOT NULL,
    valueid bigint NOT NULL,
    annotationid integer NOT NULL
);


--
-- TOC entry 374 (class 1259 OID 18528)
-- Name: transectresultvalueannotations_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE transectresultvalueannotations_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 374
-- Name: transectresultvalueannotations_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE transectresultvalueannotations_bridgeid_seq OWNED BY transectresultvalueannotations.bridgeid;


--
-- TOC entry 375 (class 1259 OID 18530)
-- Name: transectresultvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE transectresultvalues (
    valueid bigint NOT NULL,
    resultid bigint NOT NULL,
    datavalue double precision NOT NULL,
    valuedatetime timestamp without time zone NOT NULL,
    valuedatetimeutcoffset integer NOT NULL,
    xlocation double precision NOT NULL,
    xlocationunitsid integer NOT NULL,
    ylocation double precision NOT NULL,
    ylocationunitsid integer NOT NULL,
    transectdistance double precision NOT NULL,
    transectdistanceaggregationinterval double precision NOT NULL,
    transectdistanceunitsid integer NOT NULL,
    censorcodecv character varying(255) NOT NULL,
    qualitycodecv character varying(255) NOT NULL,
    aggregationstatisticcv character varying(255) NOT NULL,
    timeaggregationinterval double precision NOT NULL,
    timeaggregationintervalunitsid integer NOT NULL
);


--
-- TOC entry 376 (class 1259 OID 18536)
-- Name: transectresultvalues_valueid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE transectresultvalues_valueid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 376
-- Name: transectresultvalues_valueid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE transectresultvalues_valueid_seq OWNED BY transectresultvalues.valueid;


--
-- TOC entry 377 (class 1259 OID 18538)
-- Name: units; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE units (
    unitsid integer NOT NULL,
    unitstypecv character varying(255) NOT NULL,
    unitsabbreviation character varying(50) NOT NULL,
    unitsname character varying(255) NOT NULL,
    unitslink character varying(255)
);


--
-- TOC entry 378 (class 1259 OID 18544)
-- Name: units_unitsid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE units_unitsid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 378
-- Name: units_unitsid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE units_unitsid_seq OWNED BY units.unitsid;


--
-- TOC entry 379 (class 1259 OID 18546)
-- Name: variableextensionpropertyvalues; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE variableextensionpropertyvalues (
    bridgeid integer NOT NULL,
    variableid integer NOT NULL,
    propertyid integer NOT NULL,
    propertyvalue character varying(255) NOT NULL
);


--
-- TOC entry 380 (class 1259 OID 18549)
-- Name: variableextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE variableextensionpropertyvalues_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 380
-- Name: variableextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE variableextensionpropertyvalues_bridgeid_seq OWNED BY variableextensionpropertyvalues.bridgeid;


--
-- TOC entry 381 (class 1259 OID 18551)
-- Name: variableexternalidentifiers; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE variableexternalidentifiers (
    bridgeid integer NOT NULL,
    variableid integer NOT NULL,
    externalidentifiersystemid integer NOT NULL,
    variableexternalidentifer character varying(255) NOT NULL,
    variableexternalidentifieruri character varying(255)
);


--
-- TOC entry 382 (class 1259 OID 18557)
-- Name: variableexternalidentifiers_bridgeid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE variableexternalidentifiers_bridgeid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 382
-- Name: variableexternalidentifiers_bridgeid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE variableexternalidentifiers_bridgeid_seq OWNED BY variableexternalidentifiers.bridgeid;


--
-- TOC entry 383 (class 1259 OID 18559)
-- Name: variables; Type: TABLE; Schema: odm2; Owner: -
--

CREATE TABLE variables (
    variableid integer NOT NULL,
    variabletypecv character varying(255) NOT NULL,
    variablecode character varying(50) NOT NULL,
    variablenamecv character varying(255) NOT NULL,
    variabledefinition character varying(5000),
    speciationcv character varying(255),
    nodatavalue double precision NOT NULL
);


--
-- TOC entry 384 (class 1259 OID 18565)
-- Name: variables_variableid_seq; Type: SEQUENCE; Schema: odm2; Owner: -
--

CREATE SEQUENCE variables_variableid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 384
-- Name: variables_variableid_seq; Type: SEQUENCE OWNED BY; Schema: odm2; Owner: -
--

ALTER SEQUENCE variables_variableid_seq OWNED BY variables.variableid;


SET search_path = public, pg_catalog;

--
-- TOC entry 385 (class 1259 OID 18567)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


--
-- TOC entry 386 (class 1259 OID 18573)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 386
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


SET search_path = odm2, pg_catalog;

--
-- TOC entry 2545 (class 2604 OID 18575)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionannotations ALTER COLUMN bridgeid SET DEFAULT nextval('actionannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2546 (class 2604 OID 18576)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionby ALTER COLUMN bridgeid SET DEFAULT nextval('actionby_bridgeid_seq'::regclass);


--
-- TOC entry 2547 (class 2604 OID 18577)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actiondirectives ALTER COLUMN bridgeid SET DEFAULT nextval('actiondirectives_bridgeid_seq'::regclass);


--
-- TOC entry 2548 (class 2604 OID 18578)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('actionextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2549 (class 2604 OID 18579)
-- Name: actionid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actions ALTER COLUMN actionid SET DEFAULT nextval('actions_actionid_seq'::regclass);


--
-- TOC entry 2550 (class 2604 OID 18580)
-- Name: affiliationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY affiliations ALTER COLUMN affiliationid SET DEFAULT nextval('affiliations_affiliationid_seq'::regclass);


--
-- TOC entry 2551 (class 2604 OID 18581)
-- Name: annotationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY annotations ALTER COLUMN annotationid SET DEFAULT nextval('annotations_annotationid_seq'::regclass);


--
-- TOC entry 2552 (class 2604 OID 18582)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY authorlists ALTER COLUMN bridgeid SET DEFAULT nextval('authorlists_bridgeid_seq'::regclass);


--
-- TOC entry 2553 (class 2604 OID 18583)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationreferenceequipment ALTER COLUMN bridgeid SET DEFAULT nextval('calibrationreferenceequipment_bridgeid_seq'::regclass);


--
-- TOC entry 2554 (class 2604 OID 18584)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationstandards ALTER COLUMN bridgeid SET DEFAULT nextval('calibrationstandards_bridgeid_seq'::regclass);


--
-- TOC entry 2555 (class 2604 OID 18585)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('categoricalresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2556 (class 2604 OID 18586)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalues ALTER COLUMN valueid SET DEFAULT nextval('categoricalresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2557 (class 2604 OID 18587)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('citationextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2558 (class 2604 OID 18588)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('citationexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2559 (class 2604 OID 18589)
-- Name: citationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citations ALTER COLUMN citationid SET DEFAULT nextval('citations_citationid_seq'::regclass);


--
-- TOC entry 2560 (class 2604 OID 18590)
-- Name: dataloggerfilecolumnid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns ALTER COLUMN dataloggerfilecolumnid SET DEFAULT nextval('dataloggerfilecolumns_dataloggerfilecolumnid_seq'::regclass);


--
-- TOC entry 2561 (class 2604 OID 18591)
-- Name: dataloggerfileid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfiles ALTER COLUMN dataloggerfileid SET DEFAULT nextval('dataloggerfiles_dataloggerfileid_seq'::regclass);


--
-- TOC entry 2562 (class 2604 OID 18592)
-- Name: programid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerprogramfiles ALTER COLUMN programid SET DEFAULT nextval('dataloggerprogramfiles_programid_seq'::regclass);


--
-- TOC entry 2563 (class 2604 OID 18593)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetcitations ALTER COLUMN bridgeid SET DEFAULT nextval('datasetcitations_bridgeid_seq'::regclass);


--
-- TOC entry 2564 (class 2604 OID 18594)
-- Name: datasetid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasets ALTER COLUMN datasetid SET DEFAULT nextval('datasets_datasetid_seq'::regclass);


--
-- TOC entry 2565 (class 2604 OID 18595)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetsresults ALTER COLUMN bridgeid SET DEFAULT nextval('datasetsresults_bridgeid_seq'::regclass);


--
-- TOC entry 2566 (class 2604 OID 18596)
-- Name: derivationequationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY derivationequations ALTER COLUMN derivationequationid SET DEFAULT nextval('derivationequations_derivationequationid_seq'::regclass);


--
-- TOC entry 2567 (class 2604 OID 18597)
-- Name: directiveid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY directives ALTER COLUMN directiveid SET DEFAULT nextval('directives_directiveid_seq'::regclass);


--
-- TOC entry 2568 (class 2604 OID 18598)
-- Name: equipmentid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment ALTER COLUMN equipmentid SET DEFAULT nextval('equipment_equipmentid_seq'::regclass);


--
-- TOC entry 2569 (class 2604 OID 18599)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentannotations ALTER COLUMN bridgeid SET DEFAULT nextval('equipmentannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2570 (class 2604 OID 18600)
-- Name: equipmentmodelid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentmodels ALTER COLUMN equipmentmodelid SET DEFAULT nextval('equipmentmodels_equipmentmodelid_seq'::regclass);


--
-- TOC entry 2571 (class 2604 OID 18601)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentused ALTER COLUMN bridgeid SET DEFAULT nextval('equipmentused_bridgeid_seq'::regclass);


--
-- TOC entry 2572 (class 2604 OID 18602)
-- Name: propertyid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY extensionproperties ALTER COLUMN propertyid SET DEFAULT nextval('extensionproperties_propertyid_seq'::regclass);


--
-- TOC entry 2573 (class 2604 OID 18603)
-- Name: externalidentifiersystemid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY externalidentifiersystems ALTER COLUMN externalidentifiersystemid SET DEFAULT nextval('externalidentifiersystems_externalidentifiersystemid_seq'::regclass);


--
-- TOC entry 2574 (class 2604 OID 18604)
-- Name: featureactionid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY featureactions ALTER COLUMN featureactionid SET DEFAULT nextval('featureactions_featureactionid_seq'::regclass);


--
-- TOC entry 2575 (class 2604 OID 18605)
-- Name: instrumentoutputvariableid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables ALTER COLUMN instrumentoutputvariableid SET DEFAULT nextval('instrumentoutputvariables_instrumentoutputvariableid_seq'::regclass);


--
-- TOC entry 2576 (class 2604 OID 18606)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('measurementresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2577 (class 2604 OID 18607)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalues ALTER COLUMN valueid SET DEFAULT nextval('measurementresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2578 (class 2604 OID 18608)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodannotations ALTER COLUMN bridgeid SET DEFAULT nextval('methodannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2579 (class 2604 OID 18609)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodcitations ALTER COLUMN bridgeid SET DEFAULT nextval('methodcitations_bridgeid_seq'::regclass);


--
-- TOC entry 2580 (class 2604 OID 18610)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('methodextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2581 (class 2604 OID 18611)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('methodexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2582 (class 2604 OID 18612)
-- Name: methodid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methods ALTER COLUMN methodid SET DEFAULT nextval('methods_methodid_seq'::regclass);


--
-- TOC entry 2583 (class 2604 OID 18613)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY modelaffiliations ALTER COLUMN bridgeid SET DEFAULT nextval('modelaffiliations_bridgeid_seq'::regclass);


--
-- TOC entry 2584 (class 2604 OID 18614)
-- Name: modelid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY models ALTER COLUMN modelid SET DEFAULT nextval('models_modelid_seq'::regclass);


--
-- TOC entry 2585 (class 2604 OID 18615)
-- Name: organizationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN organizationid SET DEFAULT nextval('organizations_organizationid_seq'::regclass);


--
-- TOC entry 2586 (class 2604 OID 18616)
-- Name: personid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY people ALTER COLUMN personid SET DEFAULT nextval('people_personid_seq'::regclass);


--
-- TOC entry 2587 (class 2604 OID 18617)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY personexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('personexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2588 (class 2604 OID 18618)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('pointcoverageresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2589 (class 2604 OID 18619)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues ALTER COLUMN valueid SET DEFAULT nextval('pointcoverageresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2590 (class 2604 OID 18620)
-- Name: processinglevelid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY processinglevels ALTER COLUMN processinglevelid SET DEFAULT nextval('processinglevels_processinglevelid_seq'::regclass);


--
-- TOC entry 2591 (class 2604 OID 18621)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('profileresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2592 (class 2604 OID 18622)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues ALTER COLUMN valueid SET DEFAULT nextval('profileresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2593 (class 2604 OID 18623)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('referencematerialexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2594 (class 2604 OID 18624)
-- Name: referencematerialid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials ALTER COLUMN referencematerialid SET DEFAULT nextval('referencematerials_referencematerialid_seq'::regclass);


--
-- TOC entry 2595 (class 2604 OID 18625)
-- Name: referencematerialvalueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues ALTER COLUMN referencematerialvalueid SET DEFAULT nextval('referencematerialvalues_referencematerialvalueid_seq'::regclass);


--
-- TOC entry 2596 (class 2604 OID 18626)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedactions ALTER COLUMN relationid SET DEFAULT nextval('relatedactions_relationid_seq'::regclass);


--
-- TOC entry 2597 (class 2604 OID 18627)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedannotations ALTER COLUMN relationid SET DEFAULT nextval('relatedannotations_relationid_seq'::regclass);


--
-- TOC entry 2598 (class 2604 OID 18628)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedcitations ALTER COLUMN relationid SET DEFAULT nextval('relatedcitations_relationid_seq'::regclass);


--
-- TOC entry 2599 (class 2604 OID 18629)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relateddatasets ALTER COLUMN relationid SET DEFAULT nextval('relateddatasets_relationid_seq'::regclass);


--
-- TOC entry 2600 (class 2604 OID 18630)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedequipment ALTER COLUMN relationid SET DEFAULT nextval('relatedequipment_relationid_seq'::regclass);


--
-- TOC entry 2601 (class 2604 OID 18631)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures ALTER COLUMN relationid SET DEFAULT nextval('relatedfeatures_relationid_seq'::regclass);


--
-- TOC entry 2602 (class 2604 OID 18632)
-- Name: relatedid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedmodels ALTER COLUMN relatedid SET DEFAULT nextval('relatedmodels_relatedid_seq'::regclass);


--
-- TOC entry 2603 (class 2604 OID 18633)
-- Name: relationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedresults ALTER COLUMN relationid SET DEFAULT nextval('relatedresults_relationid_seq'::regclass);


--
-- TOC entry 2604 (class 2604 OID 18634)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultannotations ALTER COLUMN bridgeid SET DEFAULT nextval('resultannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2605 (class 2604 OID 18635)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('resultextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2606 (class 2604 OID 18636)
-- Name: resultid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results ALTER COLUMN resultid SET DEFAULT nextval('results_resultid_seq'::regclass);


--
-- TOC entry 2607 (class 2604 OID 18637)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultsdataquality ALTER COLUMN bridgeid SET DEFAULT nextval('resultsdataquality_bridgeid_seq'::regclass);


--
-- TOC entry 2608 (class 2604 OID 18638)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureannotations ALTER COLUMN bridgeid SET DEFAULT nextval('samplingfeatureannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2609 (class 2604 OID 18639)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('samplingfeatureextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2610 (class 2604 OID 18640)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('samplingfeatureexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2611 (class 2604 OID 18641)
-- Name: samplingfeatureid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures ALTER COLUMN samplingfeatureid SET DEFAULT nextval('samplingfeatures_samplingfeatureid_seq'::regclass);


--
-- TOC entry 2612 (class 2604 OID 18642)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('sectionresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2613 (class 2604 OID 18643)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues ALTER COLUMN valueid SET DEFAULT nextval('sectionresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2614 (class 2604 OID 18644)
-- Name: simulationid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY simulations ALTER COLUMN simulationid SET DEFAULT nextval('simulations_simulationid_seq'::regclass);


--
-- TOC entry 2615 (class 2604 OID 18645)
-- Name: spatialoffsetid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets ALTER COLUMN spatialoffsetid SET DEFAULT nextval('spatialoffsets_spatialoffsetid_seq'::regclass);


--
-- TOC entry 2616 (class 2604 OID 18646)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferenceexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('spatialreferenceexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2617 (class 2604 OID 18647)
-- Name: spatialreferenceid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferences ALTER COLUMN spatialreferenceid SET DEFAULT nextval('spatialreferences_spatialreferenceid_seq'::regclass);


--
-- TOC entry 2618 (class 2604 OID 18648)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimentaxonomicclassifiers ALTER COLUMN bridgeid SET DEFAULT nextval('specimentaxonomicclassifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2619 (class 2604 OID 18649)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('spectraresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2620 (class 2604 OID 18650)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues ALTER COLUMN valueid SET DEFAULT nextval('spectraresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2621 (class 2604 OID 18651)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifierexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('taxonomicclassifierexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2622 (class 2604 OID 18652)
-- Name: taxonomicclassifierid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifiers ALTER COLUMN taxonomicclassifierid SET DEFAULT nextval('taxonomicclassifiers_taxonomicclassifierid_seq'::regclass);


--
-- TOC entry 2623 (class 2604 OID 18653)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('timeseriesresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2624 (class 2604 OID 18654)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues ALTER COLUMN valueid SET DEFAULT nextval('timeseriesresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2625 (class 2604 OID 18655)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('trajectoryresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2626 (class 2604 OID 18656)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues ALTER COLUMN valueid SET DEFAULT nextval('trajectoryresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2627 (class 2604 OID 18657)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalueannotations ALTER COLUMN bridgeid SET DEFAULT nextval('transectresultvalueannotations_bridgeid_seq'::regclass);


--
-- TOC entry 2628 (class 2604 OID 18658)
-- Name: valueid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues ALTER COLUMN valueid SET DEFAULT nextval('transectresultvalues_valueid_seq'::regclass);


--
-- TOC entry 2629 (class 2604 OID 18659)
-- Name: unitsid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY units ALTER COLUMN unitsid SET DEFAULT nextval('units_unitsid_seq'::regclass);


--
-- TOC entry 2630 (class 2604 OID 18660)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableextensionpropertyvalues ALTER COLUMN bridgeid SET DEFAULT nextval('variableextensionpropertyvalues_bridgeid_seq'::regclass);


--
-- TOC entry 2631 (class 2604 OID 18661)
-- Name: bridgeid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableexternalidentifiers ALTER COLUMN bridgeid SET DEFAULT nextval('variableexternalidentifiers_bridgeid_seq'::regclass);


--
-- TOC entry 2632 (class 2604 OID 18662)
-- Name: variableid; Type: DEFAULT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables ALTER COLUMN variableid SET DEFAULT nextval('variables_variableid_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- TOC entry 2633 (class 2604 OID 18663)
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


SET search_path = odm2, pg_catalog;

--
-- TOC entry 3328 (class 0 OID 17770)
-- Dependencies: 165
-- Data for Name: actionannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 166
-- Name: actionannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('actionannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3330 (class 0 OID 17775)
-- Dependencies: 167
-- Data for Name: actionby; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO actionby VALUES (56, 59, 43, true, '');
INSERT INTO actionby VALUES (57, 60, 43, true, '');
INSERT INTO actionby VALUES (58, 61, 40, true, '');
INSERT INTO actionby VALUES (59, 62, 44, true, '');
INSERT INTO actionby VALUES (60, 63, 44, true, '');
INSERT INTO actionby VALUES (61, 64, 44, true, '');
INSERT INTO actionby VALUES (62, 65, 44, true, '');
INSERT INTO actionby VALUES (63, 66, 42, true, '');
INSERT INTO actionby VALUES (64, 67, 42, true, '');
INSERT INTO actionby VALUES (65, 68, 45, true, '');
INSERT INTO actionby VALUES (66, 69, 45, true, '');
INSERT INTO actionby VALUES (67, 70, 45, true, '');


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 168
-- Name: actionby_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('actionby_bridgeid_seq', 280, true);


--
-- TOC entry 3332 (class 0 OID 17783)
-- Dependencies: 169
-- Data for Name: actiondirectives; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 170
-- Name: actiondirectives_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('actiondirectives_bridgeid_seq', 1, false);


--
-- TOC entry 3334 (class 0 OID 17788)
-- Dependencies: 171
-- Data for Name: actionextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 172
-- Name: actionextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('actionextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3336 (class 0 OID 17793)
-- Dependencies: 173
-- Data for Name: actions; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO actions VALUES (59, 'Instrument deployment', 2, '2017-02-01 22:38:21', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (60, 'Instrument deployment', 2, '2017-02-01 22:38:21', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (61, 'Instrument deployment', 2, '2017-02-01 22:43:16', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (62, 'Instrument deployment', 2, '2017-02-02 21:55:36', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (63, 'Instrument deployment', 2, '2017-02-02 21:55:36', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (64, 'Instrument deployment', 2, '2017-02-02 21:55:36', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (65, 'Instrument deployment', 2, '2017-02-02 21:55:36', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (66, 'Instrument deployment', 2, '2017-02-02 22:32:12', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (67, 'Instrument deployment', 2, '2017-02-02 22:32:12', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (68, 'Instrument deployment', 2, '2017-02-05 05:17:59', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (69, 'Instrument deployment', 2, '2017-02-06 21:45:03', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (70, 'Instrument deployment', 2, '2017-02-06 21:45:03', -7, NULL, NULL, '', '');
INSERT INTO actions VALUES (25, 'Instrument deployment', 2, '2016-10-19 22:02:14', -7, NULL, NULL, '', NULL);
INSERT INTO actions VALUES (26, 'Instrument deployment', 2, '2016-10-24 16:56:39', -7, NULL, NULL, '', NULL);
INSERT INTO actions VALUES (27, 'Instrument deployment', 2, '2016-10-24 17:17:15', -7, NULL, NULL, '', NULL);
INSERT INTO actions VALUES (28, 'Instrument deployment', 2, '2016-10-24 18:26:51', -7, NULL, NULL, '', NULL);


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 174
-- Name: actions_actionid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('actions_actionid_seq', 313, true);


--
-- TOC entry 3338 (class 0 OID 17801)
-- Dependencies: 175
-- Data for Name: affiliations; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO affiliations VALUES (39, 43, 47, NULL, '2017-01-27', NULL, '', 'aaufdenkampe@limno.com', '', '');
INSERT INTO affiliations VALUES (40, 41, NULL, NULL, '2017-01-27', NULL, '', 'mauriel.ramirez@gmail.com', '', '');
INSERT INTO affiliations VALUES (41, 44, NULL, NULL, '2017-01-28', NULL, '', 'mariomatos889@gmail.com', '', '');
INSERT INTO affiliations VALUES (42, 42, 48, NULL, '2017-01-30', NULL, '', 'juan.caraballo17@gmail.com', '', '');
INSERT INTO affiliations VALUES (43, 45, 48, NULL, '2017-02-01', NULL, '', 'someemail@email.email', '', '');
INSERT INTO affiliations VALUES (44, 46, NULL, NULL, '2017-02-02', NULL, '', 'shicks@stroudcenter.org', '', '');
INSERT INTO affiliations VALUES (45, 47, 49, NULL, '2017-02-02', NULL, '', 'sdamiano@stroudcenter.org', '', '');
INSERT INTO affiliations VALUES (46, 48, 48, NULL, '2017-02-07', NULL, '', 'jeff.horsburgh@usu.edu', '', '');
INSERT INTO affiliations VALUES (47, 49, 49, NULL, '2017-02-08', NULL, '', 'darscott@stroudcenter.org', '', '');
INSERT INTO affiliations VALUES (48, 50, 47, NULL, '2017-02-15', NULL, '', 'ngrewe@limno.com', '', '');
INSERT INTO affiliations VALUES (49, 51, 47, NULL, '2017-02-15', NULL, '', 'bcrary@limno.com', '', '');
INSERT INTO affiliations VALUES (50, 52, 47, NULL, '2017-02-15', NULL, '', 'ctaylor@limno.com', '', '');
INSERT INTO affiliations VALUES (51, 53, NULL, NULL, '2017-02-21', NULL, '', 'beth.fisher001@gmail.com', '', '');
INSERT INTO affiliations VALUES (52, 54, NULL, NULL, '2017-03-14', NULL, '', 'leonmi@sas.upenn.edu', '', '');
INSERT INTO affiliations VALUES (53, 55, 49, NULL, '2017-03-17', NULL, '', 'staryshark@gmail.com', '', '');
INSERT INTO affiliations VALUES (54, 56, 54, NULL, '2017-03-17', NULL, '', 'TKESSLER@gilmore-assoc.com', '', '');
INSERT INTO affiliations VALUES (55, 57, 54, NULL, '2017-03-17', NULL, '', 'dennis.shelly@peerenviro.net', '', '');
INSERT INTO affiliations VALUES (56, 58, 54, NULL, '2017-03-17', NULL, '', 'Ziwen.yu@drexel.edu', '', '');
INSERT INTO affiliations VALUES (57, 59, 54, NULL, '2017-03-17', NULL, '', 'johnr@melioradesign.com', '', '');
INSERT INTO affiliations VALUES (1, 1, 48, NULL, '2017-03-29', NULL, '', 'fryarludwi.g@gmail.com', '', '');
INSERT INTO affiliations VALUES (58, 60, 55, NULL, '2017-03-28', NULL, '', 'kim.hachadoorian@tnc.org', '', '');
INSERT INTO affiliations VALUES (59, 61, 56, NULL, '2017-04-03', NULL, '', 'nancy@musconetcong.org', '', '');
INSERT INTO affiliations VALUES (60, 62, 57, NULL, '2017-04-03', NULL, '', 'pwilson@esu.edu', '', '');
INSERT INTO affiliations VALUES (61, 63, 55, NULL, '2017-04-03', NULL, '', 'michelle.diblasio@tnc.org', '', '');
INSERT INTO affiliations VALUES (63, 65, 59, NULL, '2017-04-19', NULL, '', 'dave.eiriksson@utah.edu', '', '');
INSERT INTO affiliations VALUES (64, 66, 47, NULL, '2017-04-21', NULL, '', 'envirodiy@limno.com', '', '');
INSERT INTO affiliations VALUES (65, 67, 48, NULL, '2017-05-05', NULL, '', 'fryarludwig@gmail.com', '', '');


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 176
-- Name: affiliations_affiliationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('affiliations_affiliationid_seq', 65, true);


--
-- TOC entry 3340 (class 0 OID 17809)
-- Dependencies: 177
-- Data for Name: annotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 178
-- Name: annotations_annotationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('annotations_annotationid_seq', 1, false);


--
-- TOC entry 3342 (class 0 OID 17817)
-- Dependencies: 179
-- Data for Name: authorlists; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 180
-- Name: authorlists_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('authorlists_bridgeid_seq', 1, false);


--
-- TOC entry 3344 (class 0 OID 17822)
-- Dependencies: 181
-- Data for Name: calibrationactions; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3345 (class 0 OID 17825)
-- Dependencies: 182
-- Data for Name: calibrationreferenceequipment; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 183
-- Name: calibrationreferenceequipment_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('calibrationreferenceequipment_bridgeid_seq', 1, false);


--
-- TOC entry 3347 (class 0 OID 17830)
-- Dependencies: 184
-- Data for Name: calibrationstandards; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 185
-- Name: calibrationstandards_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('calibrationstandards_bridgeid_seq', 1, false);


--
-- TOC entry 3349 (class 0 OID 17835)
-- Dependencies: 186
-- Data for Name: categoricalresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3350 (class 0 OID 17838)
-- Dependencies: 187
-- Data for Name: categoricalresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 188
-- Name: categoricalresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('categoricalresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3352 (class 0 OID 17843)
-- Dependencies: 189
-- Data for Name: categoricalresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 190
-- Name: categoricalresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('categoricalresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3354 (class 0 OID 17848)
-- Dependencies: 191
-- Data for Name: citationextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 192
-- Name: citationextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('citationextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3356 (class 0 OID 17853)
-- Dependencies: 193
-- Data for Name: citationexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 194
-- Name: citationexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('citationexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3358 (class 0 OID 17861)
-- Dependencies: 195
-- Data for Name: citations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 196
-- Name: citations_citationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('citations_citationid_seq', 1, false);


--
-- TOC entry 3360 (class 0 OID 17869)
-- Dependencies: 197
-- Data for Name: cv_actiontype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_actiontype VALUES ('equipmentProgramming', 'Equipment programming', 'The act of creating or modifying the data collection program running on a datalogger or other equipment deployed at a monitoring site.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/equipmentProgramming');
INSERT INTO cv_actiontype VALUES ('fieldActivity', 'Field activity', 'A generic, non-specific action type performed in the field at or on a sampling feature.', 'FieldActivity', 'http://vocabulary.odm2.org/actiontype/fieldActivity');
INSERT INTO cv_actiontype VALUES ('siteVisit', 'Site visit', 'A field visit action in which a single site is visited for one or more other possible actions (i.e., specimen collection, equipment maintenance, etc.).  Site visit actions are typically parents to other related actions.', 'FieldActivity', 'http://vocabulary.odm2.org/actiontype/siteVisit');
INSERT INTO cv_actiontype VALUES ('instrumentDeployment', 'Instrument deployment', 'The act of deploying an in situ instrument or sensor that creates an observation result.  This term is a specific form of the Observation actions category of actions, which is the only category of actions that can produce observation results.', 'Observation', 'http://vocabulary.odm2.org/actiontype/instrumentDeployment');
INSERT INTO cv_actiontype VALUES ('observation', 'Observation', 'The general act of making an observation. This term should be used when a Result is generated but the more specific terms of Instrument deployment or Specimen analysis are not applicable.', 'Observation', 'http://vocabulary.odm2.org/actiontype/observation');
INSERT INTO cv_actiontype VALUES ('derivation', 'Derivation', 'The act of creating results by deriving them from other results.', 'Observation', 'http://vocabulary.odm2.org/actiontype/derivation');
INSERT INTO cv_actiontype VALUES ('equipmentRetrieval', 'Equipment retrieval', 'The act of recovering a piece of equipment that made no observations from a deployment at a sampling feature or other location. For instruments, the more specific term Instrument retrieval should be used.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/equipmentRetrieval');
INSERT INTO cv_actiontype VALUES ('dataRetrieval', 'Data retrieval', 'The act of retrieving data from a datalogger deployed at a monitoring site.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/dataRetrieval');
INSERT INTO cv_actiontype VALUES ('equipmentMaintenance', 'Equipment maintenance', 'The act of performing regular or periodic upkeep or servicing of field or laboratory equipment. Maintenance may be performed in the field, in a laboratory, or at a factory maintenance center.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/equipmentMaintenance');
INSERT INTO cv_actiontype VALUES ('cruise', 'Cruise', 'A specialized form of an expedition action that involves an ocean-going vessel. Cruise actions are typically parents to other related Actions.', 'FieldActivity', 'http://vocabulary.odm2.org/actiontype/cruise');
INSERT INTO cv_actiontype VALUES ('simulation', 'Simulation', 'The act of calculating results through the use of a simulation model.', 'Observation', 'http://vocabulary.odm2.org/actiontype/simulation');
INSERT INTO cv_actiontype VALUES ('instrumentCalibration', 'Instrument calibration', 'The act of calibrating an instrument either in the field or in a laboratory. The instrument may be an in situ field sensor or a laboratory instrument.  An instrument is the subclass of equipment that is capable of making an observation to produce a result.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/instrumentCalibration');
INSERT INTO cv_actiontype VALUES ('genericNonObservation', 'Generic non-observation', 'A generic, non-specific action type that does not produce a result.', 'Other', 'http://vocabulary.odm2.org/actiontype/genericNonObservation');
INSERT INTO cv_actiontype VALUES ('specimenPreparation', 'Specimen preparation', 'The processing of a specimen collected in the field to produce a sample suitable for analysis using a particular analytical procedure.', 'SamplingFeature', 'http://vocabulary.odm2.org/actiontype/specimenPreparation');
INSERT INTO cv_actiontype VALUES ('specimenCollection', 'Specimen collection', 'The collection of a specimen in the field.', 'SamplingFeature', 'http://vocabulary.odm2.org/actiontype/specimenCollection');
INSERT INTO cv_actiontype VALUES ('estimation', 'Estimation', 'The act of creating results by estimation or professional judgement.', 'Observation', 'http://vocabulary.odm2.org/actiontype/estimation');
INSERT INTO cv_actiontype VALUES ('specimenPreservation', 'Specimen preservation', 'The act of preserving a specimen collected in the field to produce a sample suitable for analysis using a particular analytical procedure.', 'SamplingFeature', 'http://vocabulary.odm2.org/actiontype/specimenPreservation');
INSERT INTO cv_actiontype VALUES ('equipmentDeployment', 'Equipment deployment', 'The act of placing equipment that will not make observations at or within a sampling feature. Actions involving the deployment of instruments should use the more specific term Instrument deployment.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/equipmentDeployment');
INSERT INTO cv_actiontype VALUES ('specimenFractionation', 'Specimen fractionation', 'The process of separating a specimen into multiple different fractions or size classes.', 'SamplingFeature', 'http://vocabulary.odm2.org/actiontype/specimenFractionation');
INSERT INTO cv_actiontype VALUES ('specimenAnalysis', 'Specimen analysis', 'The analysis of a specimen ex situ using an instrument, typically in a laboratory, for the purpose of measuring properties of that specimen.', 'Observation', 'http://vocabulary.odm2.org/actiontype/specimenAnalysis');
INSERT INTO cv_actiontype VALUES ('expedition', 'Expedition', 'A field visit action in which many sites are visited over a continguous period of time, often involving serveral investigators, and typically having a specific purpose.  Expedition actions are typically parents to other related Actions.', 'FieldActivity', 'http://vocabulary.odm2.org/actiontype/expedition');
INSERT INTO cv_actiontype VALUES ('submersibleLaunch', 'Submersible launch', 'The act of deploying a submersible from a vessel or ship.', 'FieldActivity', 'http://vocabulary.odm2.org/actiontype/submersibleLaunch');
INSERT INTO cv_actiontype VALUES ('instrumentRetrieval', 'Instrument retrieval', 'The act of recovering an in situ instrument (which made observations) from a sampling feature. This action ends an instrument deployment action.', 'Equipment', 'http://vocabulary.odm2.org/actiontype/instrumentRetrieval');


--
-- TOC entry 3361 (class 0 OID 17875)
-- Dependencies: 198
-- Data for Name: cv_aggregationstatistic; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_aggregationstatistic VALUES ('maximum', 'Maximum', 'The values are the maximum values occurring at some time during a time interval, such as annual maximum discharge or a daily maximum air temperature.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/maximum');
INSERT INTO cv_aggregationstatistic VALUES ('continuous', 'Continuous', 'A quantity specified at a particular instant in time measured with sufficient frequency (small spacing) to be interpreted as a continuous record of the phenomenon.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/continuous');
INSERT INTO cv_aggregationstatistic VALUES ('unknown', 'Unknown', 'The aggregation statistic is unknown.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/unknown');
INSERT INTO cv_aggregationstatistic VALUES ('variance', 'Variance', 'The values represent the variance of a set of observations made over a time interval. Variance computed using the unbiased formula SUM((Xi-mean)^2)/(n-1) are preferred. The specific formula used to compute variance can be noted in the methods description.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/variance');
INSERT INTO cv_aggregationstatistic VALUES ('confidenceInterval', 'Confidence Interval', 'In statistics, a confidence interval (CI) is a type of interval estimate of a statistical parameter. It is an observed interval (i.e., it is calculated from the observations), in principle different from sample to sample, that frequently includes the value of an unobservable parameter of interest if the experiment is repeated. How frequently the observed interval contains the parameter is determined by the confidence level or confidence coefficient.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/confidenceInterval');
INSERT INTO cv_aggregationstatistic VALUES ('minimum', 'Minimum', 'The values are the minimum values occurring at some time during a time interval, such as 7-day low flow for a year or the daily minimum temperature.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/minimum');
INSERT INTO cv_aggregationstatistic VALUES ('standardErrorOfMean', 'Standard error of mean', 'The standard error of the mean (SEM) quantifies the precision of the mean. It is a measure of how far your sample mean is likely to be from the true population mean. It is expressed in the same units as the data.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/standardErrorOfMean');
INSERT INTO cv_aggregationstatistic VALUES ('incremental', 'Incremental', 'The values represent the incremental value of a variable over a time interval, such as the incremental volume of flow or incremental precipitation.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/incremental');
INSERT INTO cv_aggregationstatistic VALUES ('sporadic', 'Sporadic', 'The phenomenon is sampled at a particular instant in time but with a frequency that is too coarse for interpreting the record as continuous. This would be the case when the spacing is significantly larger than the support and the time scale of fluctuation of the phenomenon, such as for example infrequent water quality samples.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/sporadic');
INSERT INTO cv_aggregationstatistic VALUES ('constantOverInterval', 'Constant over interval', 'The values are quantities that can be interpreted as constant for all time, or over the time interval to a subsequent measurement of the same variable at the same site.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/constantOverInterval');
INSERT INTO cv_aggregationstatistic VALUES ('bestEasySystematicEstimator', 'Best easy systematic estimator', 'Best Easy Systematic Estimator BES = (Q1 +2Q2 +Q3)/4. Q1, Q2, and Q3 are first, second, and third quartiles. See Woodcock, F. and Engel, C., 2005: Operational Consensus Forecasts.Weather and Forecasting, 20, 101-111. (http://www.bom.gov.au/nmoc/bulletins/60/article_by_Woodcock_in_Weather_and_Forecasting.pdf) and Wonnacott, T. H., and R. J. Wonnacott, 1972: Introductory Statistics. Wiley, 510 pp.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/bestEasySystematicEstimator');
INSERT INTO cv_aggregationstatistic VALUES ('mode', 'Mode', 'The values are the most frequent values occurring at some time during a time interval, such as annual most frequent wind direction.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/mode');
INSERT INTO cv_aggregationstatistic VALUES ('average', 'Average', 'The values represent the average over a time interval, such as daily mean discharge or daily mean temperature.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/average');
INSERT INTO cv_aggregationstatistic VALUES ('cumulative', 'Cumulative', 'The values represent the cumulative value of a variable measured or calculated up to a given instant of time, such as cumulative volume of flow or cumulative precipitation.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/cumulative');
INSERT INTO cv_aggregationstatistic VALUES ('standardDeviation', 'Standard deviation', 'The values represent the standard deviation of a set of observations made over a time interval. Standard deviation computed using the unbiased formula SQRT(SUM((Xi-mean)^2)/(n-1)) are preferred. The specific formula used to compute variance can be noted in the methods description.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/standardDeviation');
INSERT INTO cv_aggregationstatistic VALUES ('median', 'Median', 'The values represent the median over a time interval, such as daily median discharge or daily median temperature.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/median');
INSERT INTO cv_aggregationstatistic VALUES ('categorical', 'Categorical', 'The values are categorical rather than continuous valued quantities.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/categorical');
INSERT INTO cv_aggregationstatistic VALUES ('standardErrorOfTheMean', 'Standard error of the mean', 'The standard error of the mean (SEM) quantifies the precision of the mean. It is a measure of how far your sample mean is likely to be from the true population mean. It is expressed in the same units as the data.', NULL, 'http://vocabulary.odm2.org/aggregationstatistic/standardErrorOfTheMean');


--
-- TOC entry 3362 (class 0 OID 17881)
-- Dependencies: 199
-- Data for Name: cv_annotationtype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_annotationtype VALUES ('valueGroup', 'Value group', 'A group of data values such as those from a profile, analysis, spectra, publication table, dataset, incident reports, etc.', 'Group', 'http://vocabulary.odm2.org/annotationtype/valueGroup');
INSERT INTO cv_annotationtype VALUES ('actionAnnotation', 'Action annotation', 'An annotation or qualifying comment about an Action', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/actionAnnotation');
INSERT INTO cv_annotationtype VALUES ('methodAnnotation', 'Method annotation', 'An annotation or qualifiying comment about a Method', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/methodAnnotation');
INSERT INTO cv_annotationtype VALUES ('siteGroup', 'Site group', 'A group of sites such as a transect, station, observatory, monitoring collection, etc.', 'Group', 'http://vocabulary.odm2.org/annotationtype/siteGroup');
INSERT INTO cv_annotationtype VALUES ('actionGroup', 'Action group', 'A group of actions such as those that are part of a cruise, expedition, experiment, project, etc.', 'Group', 'http://vocabulary.odm2.org/annotationtype/actionGroup');
INSERT INTO cv_annotationtype VALUES ('siteAnnotation', 'Site annotation', 'An annotation or qualifying comment about a Site', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/siteAnnotation');
INSERT INTO cv_annotationtype VALUES ('categoricalResultValueAnnotation', 'Categorical result value annotation', 'An annotation or data qualifying comment applied to a data value from a categorical Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/categoricalResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('pointCoverageResultValueAnnotation', 'Point coverage result value annotation', 'An annotation or data qualifying comment applied to a data value from a point coverage Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/pointCoverageResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('resultAnnotation', 'Result annotation', 'An annotation or qualifying comment about a Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/resultAnnotation');
INSERT INTO cv_annotationtype VALUES ('sectionResultValueAnnotation', 'Section result value annotation', 'An annotation or data qualifying comment applied to a data value from a section Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/sectionResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('profileResultValueAnnotation', 'Profile result value annotation', 'An annotation or data qualifying comment applied to a data value from a profile Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/profileResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('transectResultValueAnnotation', 'Transect result value annotation', 'An annotation or data qualifying comment applied to a data value from a transect Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/transectResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('variableAnnotation', 'Variable annotation', 'An annotation or qualifying comment about a Variable', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/variableAnnotation');
INSERT INTO cv_annotationtype VALUES ('samplingFeatureAnnotation', 'Sampling feature annotation', 'An annotation or qualifiying comment about a SamplingFeature', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/samplingFeatureAnnotation');
INSERT INTO cv_annotationtype VALUES ('dataSetAnnotation', 'Dataset annotation', 'An annotation or qualifying comment about a DataSet', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/dataSetAnnotation');
INSERT INTO cv_annotationtype VALUES ('personGroup', 'Person group', 'A group of people such as a research team, project team, etc.', 'Group', 'http://vocabulary.odm2.org/annotationtype/personGroup');
INSERT INTO cv_annotationtype VALUES ('organizationAnnotation', 'Organization annotation', 'An annotation or qualifiying comment about an Organization', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/organizationAnnotation');
INSERT INTO cv_annotationtype VALUES ('specimenGroup', 'Specimen group', 'A group of specimens such as an analysis batch, profile, experiment, etc.', 'Group', 'http://vocabulary.odm2.org/annotationtype/specimenGroup');
INSERT INTO cv_annotationtype VALUES ('equipmentAnnotation', 'Equipment annotation', 'An annotation or qualifying comment about a piece of Equipment', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/equipmentAnnotation');
INSERT INTO cv_annotationtype VALUES ('trajectoryResultValueAnnotation', 'Trajectory result value annotation', 'An annotation or data qualifying comment applied to a data value from a trajectory Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/trajectoryResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('timeSeriesResultValueAnnotation', 'Time series result value annotation', 'An annotation or data qualifying comment applied to a data value from a time series Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/timeSeriesResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('spectraResultValueAnnotation', 'Spectra result value annotation', 'An annotation or data qualifying comment applied to a data value from a spectra Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/spectraResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('measurementResultValueAnnotation', 'Measurement result value annotation', 'An annotation or data qualifying comment applied to a data value from a measurement Result', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/measurementResultValueAnnotation');
INSERT INTO cv_annotationtype VALUES ('personAnnotation', 'Person annotation', 'An annotation or qualifying comment about a Person', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/personAnnotation');
INSERT INTO cv_annotationtype VALUES ('specimenAnnotation', 'Specimen annotation', 'An annotation or qualifying comment about a Specimen', 'Annotation', 'http://vocabulary.odm2.org/annotationtype/specimenAnnotation');


--
-- TOC entry 3363 (class 0 OID 17887)
-- Dependencies: 200
-- Data for Name: cv_censorcode; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_censorcode VALUES ('notCensored', 'Not censored', 'The reported value is not censored.', NULL, 'http://vocabulary.odm2.org/censorcode/notCensored');
INSERT INTO cv_censorcode VALUES ('unknown', 'Unknown', 'It is unknown whether the data value as reported is censored.', NULL, 'http://vocabulary.odm2.org/censorcode/unknown');
INSERT INTO cv_censorcode VALUES ('nonDetect', 'Non-detect', 'The value was reported as a non-detect. The recorded value represents the level at which the anlalyte can be detected.', NULL, 'http://vocabulary.odm2.org/censorcode/nonDetect');
INSERT INTO cv_censorcode VALUES ('presentButNotQuantified', 'Present but not quantified', 'The anlayte is known to be present, but was not quantified. The recorded value represents the level below which the analyte can no longer be quantified.', NULL, 'http://vocabulary.odm2.org/censorcode/presentButNotQuantified');
INSERT INTO cv_censorcode VALUES ('lessThan', 'Less than', 'The value is known to be less than the recorded value.', NULL, 'http://vocabulary.odm2.org/censorcode/lessThan');
INSERT INTO cv_censorcode VALUES ('greaterThan', 'Greater than', 'The value is known to be greater than the recorded value.', NULL, 'http://vocabulary.odm2.org/censorcode/greaterThan');


--
-- TOC entry 3364 (class 0 OID 17893)
-- Dependencies: 201
-- Data for Name: cv_dataqualitytype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_dataqualitytype VALUES ('methodDetectionLimit', 'Method detection limit', 'The minimum concentration of a substance that can be distinguished from the absence of that substance within a stated confidence limit (generally 1%) given a particular analytical method.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/methodDetectionLimit');
INSERT INTO cv_dataqualitytype VALUES ('precision', 'Precision', 'The degree to which repeated measurements under unchanged conditions show the same results.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/precision');
INSERT INTO cv_dataqualitytype VALUES ('physicalLimitLowerBound', 'Physical limit lower bound', 'This describes a numeric value below which measured values should be considered suspect. This numeric value should be empirically derived.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/physicalLimitLowerBound');
INSERT INTO cv_dataqualitytype VALUES ('accuracy', 'Accuracy', 'The degree of closeness of a measurement of a quantity to that quantity''s true value.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/accuracy');
INSERT INTO cv_dataqualitytype VALUES ('physicalLimitUpperBound', 'Physical limit upper bound', 'This describes a numeric value above which measured values should be considered suspect. This numeric value should be empirically derived.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/physicalLimitUpperBound');
INSERT INTO cv_dataqualitytype VALUES ('reportingLevel', 'Reporting level', 'The smallest concentration of analyte that can be reported by laboratory.', NULL, 'http://vocabulary.odm2.org/dataqualitytype/reportingLevel');


--
-- TOC entry 3365 (class 0 OID 17899)
-- Dependencies: 202
-- Data for Name: cv_datasettype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_datasettype VALUES ('specimenTimeSeries', 'Specimen time series', 'A dataset that contains multiple measurement Results derived from Specimens. This corresponds to the YAML Observations Data Archive (YODA) specimen time series profile.', NULL, 'http://vocabulary.odm2.org/datasettype/specimenTimeSeries');
INSERT INTO cv_datasettype VALUES ('other', 'Other', 'A set of Results that has been grouped into a Dataset because they are logically related. The group does not conform to any particular profile.', NULL, 'http://vocabulary.odm2.org/datasettype/other');
INSERT INTO cv_datasettype VALUES ('multiVariableSpecimenMeasurements', 'Multi-variable specimen measurements', 'A dataset that contains multiple measurement Results derived from Specimens. This corresponds to the YAML Observations Data Archive (YODA) specimen time series profile.', NULL, 'http://vocabulary.odm2.org/datasettype/multiVariableSpecimenMeasurements');
INSERT INTO cv_datasettype VALUES ('multiTimeSeries', 'Multi-time series', 'A Dataset that contains multiple time series Results. This corresponds to the YAML Observations Data Archive (YODA) multi-time series profile.', NULL, 'http://vocabulary.odm2.org/datasettype/multiTimeSeries');
INSERT INTO cv_datasettype VALUES ('singleTimeSeries', 'Single time series', 'A Dataset that contains a single time series Result. This corresponds to the YAML Observations Data Archive (YODA) singe time series profile.', NULL, 'http://vocabulary.odm2.org/datasettype/singleTimeSeries');


--
-- TOC entry 3366 (class 0 OID 17905)
-- Dependencies: 203
-- Data for Name: cv_directivetype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_directivetype VALUES ('monitoringProgram', 'Monitoring program', 'Environmental monitoring that is conducted according to a formal plan that may reflect the overall objectives of an organization, references specific strategies that help deliver the objectives and details of specific projects or tasks, and that contains a listing of what is being monitored, how that monitoring is taking place, and the time-scale over which monitoring should take place.', NULL, 'http://vocabulary.odm2.org/directivetype/monitoringProgram');
INSERT INTO cv_directivetype VALUES ('project', 'Project', 'A collaborative enterprise, involving research or design, the is carefully planned to achieve a particular aim.', NULL, 'http://vocabulary.odm2.org/directivetype/project');
INSERT INTO cv_directivetype VALUES ('fieldCampaign', 'Field campaign', 'A sampling event conducted in the field during which instruments may be deployed and during which samples may be collected. Field campaigns typically have a focus such as characterizing a particular environment, quantifying a particular phenomenon, answering a particular research question, etc. and may last for hours, days, weeks, months, or even longer.', NULL, 'http://vocabulary.odm2.org/directivetype/fieldCampaign');


--
-- TOC entry 3367 (class 0 OID 17911)
-- Dependencies: 204
-- Data for Name: cv_elevationdatum; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_elevationdatum VALUES ('NAVD88', 'NAVD88', 'North American Vertical Datum of 1988', NULL, 'http://vocabulary.odm2.org/elevationdatum/NAVD88');
INSERT INTO cv_elevationdatum VALUES ('Unknown', 'Unknown', 'The vertical datum is unknown', NULL, 'http://vocabulary.odm2.org/elevationdatum/Unknown');
INSERT INTO cv_elevationdatum VALUES ('NGVD29', 'NGVD29', 'National Geodetic Vertical Datum of 1929', NULL, 'http://vocabulary.odm2.org/elevationdatum/NGVD29');
INSERT INTO cv_elevationdatum VALUES ('EGM96', 'EGM96', 'EGM96 (Earth Gravitational Model 1996) is a geopotential model of the Earth consisting of spherical harmonic coefficients complete to degree and order 360.', NULL, 'http://vocabulary.odm2.org/elevationdatum/EGM96');
INSERT INTO cv_elevationdatum VALUES ('MSL', 'MSL', 'Mean Sea Level', NULL, 'http://vocabulary.odm2.org/elevationdatum/MSL');


--
-- TOC entry 3368 (class 0 OID 17917)
-- Dependencies: 205
-- Data for Name: cv_equipmenttype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_equipmenttype VALUES ('antenna', 'Antenna', 'An electrical device that converts electric power into radio waves and vice versa.', 'Communications component', 'http://vocabulary.odm2.org/equipmenttype/antenna');
INSERT INTO cv_equipmenttype VALUES ('interface', 'Interface', 'A device used to couple multiple other devices.', NULL, 'http://vocabulary.odm2.org/equipmenttype/interface');
INSERT INTO cv_equipmenttype VALUES ('radio', 'Radio', 'A device that transfers information via electromagnetic signals through the atmosphere or free space.', 'Communications component', 'http://vocabulary.odm2.org/equipmenttype/radio');
INSERT INTO cv_equipmenttype VALUES ('enclosure', 'Enclosure', 'A cabinet or box within which electrical or electronic equipment are mounted to protect them from the environment.', 'Platform', 'http://vocabulary.odm2.org/equipmenttype/enclosure');
INSERT INTO cv_equipmenttype VALUES ('solarPanel', 'Solar panel', 'A photovoltaic module that is electrically connected and mounted on a supporting structure.  Used to generate and supply electricity.', 'Power component', 'http://vocabulary.odm2.org/equipmenttype/solarPanel');
INSERT INTO cv_equipmenttype VALUES ('powerSupply', 'Power supply', 'An electronic device that supplies electric energy to an electrical load. The primary function of a power supply is to convert one form of electrical energy to another (e.g., solar to chemical).', 'Power component', 'http://vocabulary.odm2.org/equipmenttype/powerSupply');
INSERT INTO cv_equipmenttype VALUES ('measurementTower', 'Measurement tower', 'A free standing tower that supports measuring instruments or sensors.', 'Observation platform', 'http://vocabulary.odm2.org/equipmenttype/measurementTower');
INSERT INTO cv_equipmenttype VALUES ('totalStation', 'Total station', 'An electronic and optical instrument used in modern surveying and building construction.  A total station is an electronic theodoloite integrated with an electronic distance meter to read slope distances from the instrument to a particular point.', 'Instrument', 'http://vocabulary.odm2.org/equipmenttype/totalStation');
INSERT INTO cv_equipmenttype VALUES ('turbidimeter', 'Turbidimeter', 'A water quality sensor that monitors light reflected off the particles suspended in water.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/turbidimeter');
INSERT INTO cv_equipmenttype VALUES ('waterQualitySonde', 'Water quality sonde', 'A water quality monitoring instrument having multiple attached sensors.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/waterQualitySonde');
INSERT INTO cv_equipmenttype VALUES ('levelStaff', 'Level staff', 'A graduate wooden, fiberglass, or aluminum rod used to determine differences in elevation.', 'Instrument', 'http://vocabulary.odm2.org/equipmenttype/levelStaff');
INSERT INTO cv_equipmenttype VALUES ('globalPositioningSystemReceiver', 'Global positioning system receiver', 'A device that accurately calculates geographical location by receiving information from Global Positioning System satellites.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/globalPositioningSystemReceiver');
INSERT INTO cv_equipmenttype VALUES ('sensor', 'Sensor', 'A device that detects events or changes in quantities and provides a corresponding output, generally as an electrical or optical signal.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/sensor');
INSERT INTO cv_equipmenttype VALUES ('chargeRegulator', 'Charge regulator', 'An electroinic device that limits the rate at which electric current is added to or drawn from electric batteries.', 'Power component', 'http://vocabulary.odm2.org/equipmenttype/chargeRegulator');
INSERT INTO cv_equipmenttype VALUES ('tripod', 'Tripod', 'A portable, three-legged frame used as a platform for supporting the weight and maintaining the stability of some other object. Typically used as a data collection platform to which sensors are attached.', 'Observation platform', 'http://vocabulary.odm2.org/equipmenttype/tripod');
INSERT INTO cv_equipmenttype VALUES ('battery', 'Battery', 'A device consisting of one or more electrochemical cells that convert stored chemical energy into electrical energy.', 'Power component', 'http://vocabulary.odm2.org/equipmenttype/battery');
INSERT INTO cv_equipmenttype VALUES ('pressureTransducer', 'Pressure transducer', 'A sensor that measures pressure, typically of gases or liquids.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/pressureTransducer');
INSERT INTO cv_equipmenttype VALUES ('fluorometer', 'Fluorometer', 'A device used to measure paramters of flouroescence, including its intensity and wavelength distribution of emission spectrum after excitation by a certain spectrum of light.', 'Sensor', 'http://vocabulary.odm2.org/equipmenttype/fluorometer');
INSERT INTO cv_equipmenttype VALUES ('sampler', 'Sampler', 'A device used to collect specimens for later ex situ analysis.', 'Sampling device', 'http://vocabulary.odm2.org/equipmenttype/sampler');
INSERT INTO cv_equipmenttype VALUES ('stormBox', 'Storm box', 'An enclosure used to protect electronic equipment used for stormwater sampling.', 'Platform', 'http://vocabulary.odm2.org/equipmenttype/stormBox');
INSERT INTO cv_equipmenttype VALUES ('camera', 'Camera', 'A device used to create photographic images', NULL, 'http://vocabulary.odm2.org/equipmenttype/camera');
INSERT INTO cv_equipmenttype VALUES ('cable', 'Cable', 'Two or more wires running side by side and bonded, twisted, or braided together to form a single assembly.', 'Peripheral component', 'http://vocabulary.odm2.org/equipmenttype/cable');
INSERT INTO cv_equipmenttype VALUES ('datalogger', 'Datalogger', 'An electronic device that records data over time or in relation to location either with a built in instrument or sensor or via external instruments and sensors.', 'Datalogger', 'http://vocabulary.odm2.org/equipmenttype/datalogger');
INSERT INTO cv_equipmenttype VALUES ('automaticLevel', 'Automatic level', 'A survey level that makes use of a compensator that ensures the line of sight remains horizontal once the operator has roughly leveled the instrument.', 'Instrument', 'http://vocabulary.odm2.org/equipmenttype/automaticLevel');
INSERT INTO cv_equipmenttype VALUES ('mast', 'Mast', 'A pole that supports sensors, instruments, or measurement peripherals.', 'Observation platform', 'http://vocabulary.odm2.org/equipmenttype/mast');
INSERT INTO cv_equipmenttype VALUES ('multiplexer', 'Multiplexer', 'A device that selects one of several analog or digital input signals and forwards the selected input into a single line.', NULL, 'http://vocabulary.odm2.org/equipmenttype/multiplexer');
INSERT INTO cv_equipmenttype VALUES ('electronicDevice', 'Electronic device', 'A generic electronic device', NULL, 'http://vocabulary.odm2.org/equipmenttype/electronicDevice');
INSERT INTO cv_equipmenttype VALUES ('laboratoryInstrument', 'Laboratory instrument', 'Any type of equipment, apparatus or device designed, constructed and refined to use well proven physical principles, relationships or technology to facilitate or enable the pursuit, acquisition, transduction and storage of repeatable, verifiable data, usually consisting of sets numerical measurements made upon otherwise unknown, unproven quantities, properties, phenomena, materials, forces or etc.', 'Instrument', 'http://vocabulary.odm2.org/equipmenttype/laboratoryInstrument');


--
-- TOC entry 3369 (class 0 OID 17923)
-- Dependencies: 206
-- Data for Name: cv_medium; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_medium VALUES ('vegetation', 'Vegetation', 'The plants of an area considered in general or as communities, but not taxonomically.', NULL, 'http://vocabulary.odm2.org/medium/vegetation');
INSERT INTO cv_medium VALUES ('habitat', 'Habitat', 'A habitat is an ecological or environmental area that is inhabited by a particular species of animal, plant, or other type of organism.', NULL, 'http://vocabulary.odm2.org/medium/habitat');
INSERT INTO cv_medium VALUES ('tissue', 'Tissue', 'Sample of a living organism''s tissue or sensor emplaced to measure property of tissue.', NULL, 'http://vocabulary.odm2.org/medium/tissue');
INSERT INTO cv_medium VALUES ('gas', 'Gas', 'Gas phase specimen or sensor emplaced to measure properties of a gas.', NULL, 'http://vocabulary.odm2.org/medium/gas');
INSERT INTO cv_medium VALUES ('organism', 'Organism', 'Data collected about a species at organism level.', NULL, 'http://vocabulary.odm2.org/medium/organism');
INSERT INTO cv_medium VALUES ('other', 'Other', 'Other.', NULL, 'http://vocabulary.odm2.org/medium/other');
INSERT INTO cv_medium VALUES ('particulate', 'Particulate', 'Specimen collected from particulates suspended in a paticulate-fluid mixture. Examples include particulates in water or air.', NULL, 'http://vocabulary.odm2.org/medium/particulate');
INSERT INTO cv_medium VALUES ('air', 'Air', 'Specimen collection of ambient air or sensor emplaced to measure properties of ambient air.', NULL, 'http://vocabulary.odm2.org/medium/air');
INSERT INTO cv_medium VALUES ('soil', 'Soil', 'Specimen collected from soil or sensor emplaced to measure properties of soil. Soil includes the mixture of minerals, organic matter, gasses, liquids, and organisms that make up the upper layer of earth in which plants grow. ', NULL, 'http://vocabulary.odm2.org/medium/soil');
INSERT INTO cv_medium VALUES ('liquidOrganic', 'Liquid organic', 'Specimen collected as an organic liquid.', NULL, 'http://vocabulary.odm2.org/medium/liquidOrganic');
INSERT INTO cv_medium VALUES ('sediment', 'Sediment', 'Specimen collected from material broken down by processes of weathering and erosion and subsequently transported by the action of wind, water, or ice, and/or by the force of gravity acting on the particles. Sensors may also be emplaced to measure sediment properties.', NULL, 'http://vocabulary.odm2.org/medium/sediment');
INSERT INTO cv_medium VALUES ('ice', 'Ice', 'Sample collected as frozen water or sensor emplaced to measure properties of ice.', NULL, 'http://vocabulary.odm2.org/medium/ice');
INSERT INTO cv_medium VALUES ('notApplicable', 'Not applicable', 'There is no applicable sampled medium.  ', NULL, 'http://vocabulary.odm2.org/medium/notApplicable');
INSERT INTO cv_medium VALUES ('regolith', 'Regolith', 'The entire unconsolidated or secondarily recemented cover that overlies more coherent bedrock, that has been formed by weathering, erosion, transport and/or deposition of the older material. The regolith thus includes fractured and weathered basement rocks, saprolites, soils, organic accumulations, volcanic material, glacial deposits, colluvium, alluvium, evaporitic sediments, aeolian deposits and ground water.\r\nEverything from fresh rock to fresh air.', NULL, 'http://vocabulary.odm2.org/medium/regolith');
INSERT INTO cv_medium VALUES ('unknown', 'Unknown', 'The sampled medium is unknown.', NULL, 'http://vocabulary.odm2.org/medium/unknown');
INSERT INTO cv_medium VALUES ('snow', 'Snow', 'Observation in, of or sample taken from snow.', NULL, 'http://vocabulary.odm2.org/medium/snow');
INSERT INTO cv_medium VALUES ('rock', 'Rock', 'Specimen collected from a naturally occuring solid aggregate of one or more minerals.', NULL, 'http://vocabulary.odm2.org/medium/rock');
INSERT INTO cv_medium VALUES ('liquidAqueous', 'Liquid aqueous', 'Specimen collected as liquid water or sensor emplaced to measure properties of water in sampled environment.', NULL, 'http://vocabulary.odm2.org/medium/liquidAqueous');
INSERT INTO cv_medium VALUES ('mineral', 'Mineral', 'Specimen collected as a mineral.', NULL, 'http://vocabulary.odm2.org/medium/mineral');


--
-- TOC entry 3370 (class 0 OID 17929)
-- Dependencies: 207
-- Data for Name: cv_methodtype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_methodtype VALUES ('expedition', 'Expedition', 'A method for performing an expedition action.', 'FieldActivity', 'http://vocabulary.odm2.org/methodtype/expedition');
INSERT INTO cv_methodtype VALUES ('specimenPreservation', 'Specimen preservation', 'A method for preserving a specimen either in the field or in a laboratory prior to ex situ analysis.', 'SamplingFeature', 'http://vocabulary.odm2.org/methodtype/specimenPreservation');
INSERT INTO cv_methodtype VALUES ('estimation', 'Estimation', 'A method for creating results by estimation or professional judgement.', 'Observation', 'http://vocabulary.odm2.org/methodtype/estimation');
INSERT INTO cv_methodtype VALUES ('specimenAnalysis', 'Specimen analysis', 'A method for ex situ analysis of a specimen using an instrument, typically in a laboratory, for the purpose of measuring properties of a specimen.', 'Observation', 'http://vocabulary.odm2.org/methodtype/specimenAnalysis');
INSERT INTO cv_methodtype VALUES ('cruise', 'Cruise', 'A method for performing a cruise action.', 'FieldActivity', 'http://vocabulary.odm2.org/methodtype/cruise');
INSERT INTO cv_methodtype VALUES ('equipmentDeployment', 'Equipment deployment', 'A method for deploying a piece of equipment that will not make observations at a sampling feature.', 'Observation', 'http://vocabulary.odm2.org/methodtype/equipmentDeployment');
INSERT INTO cv_methodtype VALUES ('simulation', 'Simulation', 'A method for creating results by running a simulation model.', 'Observation', 'http://vocabulary.odm2.org/methodtype/simulation');
INSERT INTO cv_methodtype VALUES ('genericNonObservation', 'Generic non-observation', 'A method for completing a non-specific action that does not produce a result.', 'Other', 'http://vocabulary.odm2.org/methodtype/genericNonObservation');
INSERT INTO cv_methodtype VALUES ('siteVisit', 'Site visit', 'A method for performing a site visit action.', 'FieldActivity', 'http://vocabulary.odm2.org/methodtype/siteVisit');
INSERT INTO cv_methodtype VALUES ('dataRetrieval', 'Data retrieval', 'A method for retrieving data from a datalogger deployed at a monitoring site.', 'Equipment', 'http://vocabulary.odm2.org/methodtype/dataRetrieval');
INSERT INTO cv_methodtype VALUES ('equipmentRetrieval', 'Equipment retrieval', 'A method for retrieving equipment from a sampling feature at which or on which it was deployed.', 'Equipment', 'http://vocabulary.odm2.org/methodtype/equipmentRetrieval');
INSERT INTO cv_methodtype VALUES ('observation', 'Observation', 'A method for creating observation results. This term should be used when a Result is generated but the more specific terms of Instrument deployment or Specimen analysis are not applicable.', 'Observation', 'http://vocabulary.odm2.org/methodtype/observation');
INSERT INTO cv_methodtype VALUES ('derivation', 'Derivation', 'A method for creating results by deriving them from other results.', 'Observation', 'http://vocabulary.odm2.org/methodtype/derivation');
INSERT INTO cv_methodtype VALUES ('equipmentMaintenance', 'Equipment maintenance', 'A method for performing periodic upkeep or servicing of field or laboratory equipment. Maintenance may be performed in the field, in a laboratory, or at a factory maintenance center.', 'Equipment', 'http://vocabulary.odm2.org/methodtype/equipmentMaintenance');
INSERT INTO cv_methodtype VALUES ('specimenFractionation', 'Specimen fractionation', 'A method for separating a specimen into multiple different fractions or size classes.', 'SamplingFeature', 'http://vocabulary.odm2.org/methodtype/specimenFractionation');
INSERT INTO cv_methodtype VALUES ('unknown', 'Unknown', 'The method type is unknown.', 'Other', 'http://vocabulary.odm2.org/methodtype/unknown');
INSERT INTO cv_methodtype VALUES ('specimenCollection', 'Specimen collection', 'A method for collecting a specimen for ex situ analysis.', 'SamplingFeature', 'http://vocabulary.odm2.org/methodtype/specimenCollection');
INSERT INTO cv_methodtype VALUES ('submersibleLaunch', 'Submersible launch', 'A method for launching a submersible from a vessel or ship.', 'FieldActivity', 'http://vocabulary.odm2.org/methodtype/submersibleLaunch');
INSERT INTO cv_methodtype VALUES ('instrumentCalibration', 'Instrument calibration', 'A method for calibrating an instrument either in the field or in the laboratory. ', 'Equipment', 'http://vocabulary.odm2.org/methodtype/instrumentCalibration');
INSERT INTO cv_methodtype VALUES ('instrumentDeployment', 'Instrument deployment', 'A method for deploying an instrument to make observations at a sampling feature.', 'Observation', 'http://vocabulary.odm2.org/methodtype/instrumentDeployment');
INSERT INTO cv_methodtype VALUES ('instrumentContinuingCalibrationVerification', 'Instrument Continuing Calibration Verification', 'A method for verifying the instrument or meter calibration by measuring a calibration standard of known value as if it were a sample and comparing the measured result to the calibration acceptance criteria listed in the Standard Operating Procedure.', 'Method', 'http://vocabulary.odm2.org/methodtype/instrumentContinuingCalibrationVerification');
INSERT INTO cv_methodtype VALUES ('fieldActivity', 'Field activity', 'A method for performing an activity in the field at or on a sampling feature.', 'FieldActivity', 'http://vocabulary.odm2.org/methodtype/fieldActivity');
INSERT INTO cv_methodtype VALUES ('instrumentRetrieval', 'Instrument retrieval', 'A method for retrieving or recovering an instrument that has been deployed at a smpling feature.', 'Equipment', 'http://vocabulary.odm2.org/methodtype/instrumentRetrieval');
INSERT INTO cv_methodtype VALUES ('equipmentProgramming', 'Equipment programming', 'A method for creating or modifying the data collection program running on a datalogger or other equipment deployed at a monitoring site. ', NULL, 'http://vocabulary.odm2.org/methodtype/equipmentProgramming');
INSERT INTO cv_methodtype VALUES ('specimenPreparation', 'Specimen preparation', 'A method for processing a specimen collected in the field to produce a sample suitable for analysis using a particular analytical procedure.', 'SamplingFeature', 'http://vocabulary.odm2.org/methodtype/specimenPreparation');


--
-- TOC entry 3371 (class 0 OID 17935)
-- Dependencies: 208
-- Data for Name: cv_organizationtype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_organizationtype VALUES ('researchAgency', 'Research agency', 'A department or other administrative unit of a government with the express purpose of conducting research.', NULL, 'http://vocabulary.odm2.org/organizationtype/researchAgency');
INSERT INTO cv_organizationtype VALUES ('vendor', 'Vendor', 'A person or company that sells a product.', NULL, 'http://vocabulary.odm2.org/organizationtype/vendor');
INSERT INTO cv_organizationtype VALUES ('studentOrganization', 'Student organization', 'A group of students who associate for a particular purpose. ', NULL, 'http://vocabulary.odm2.org/organizationtype/studentOrganization');
INSERT INTO cv_organizationtype VALUES ('unknown', 'Unknown', 'The organization type is unknown.', NULL, 'http://vocabulary.odm2.org/organizationtype/unknown');
INSERT INTO cv_organizationtype VALUES ('program', 'Program', 'A set of structured activities.', NULL, 'http://vocabulary.odm2.org/organizationtype/program');
INSERT INTO cv_organizationtype VALUES ('library', 'Library', 'An institution that holds books and or other forms of stored information for use by the public or other experts.', NULL, 'http://vocabulary.odm2.org/organizationtype/library');
INSERT INTO cv_organizationtype VALUES ('division', 'Division', 'A section of a large company, agency, or organization.', NULL, 'http://vocabulary.odm2.org/organizationtype/division');
INSERT INTO cv_organizationtype VALUES ('institute', 'Institute', 'An organization founded to promote a cause.', NULL, 'http://vocabulary.odm2.org/organizationtype/institute');
INSERT INTO cv_organizationtype VALUES ('department', 'Department', 'A subdivision or unit within a university, institution, or agency.', NULL, 'http://vocabulary.odm2.org/organizationtype/department');
INSERT INTO cv_organizationtype VALUES ('company', 'Company', 'An business entity that provides services.', NULL, 'http://vocabulary.odm2.org/organizationtype/company');
INSERT INTO cv_organizationtype VALUES ('center', 'Center', 'A place where some function or activity occurs.', NULL, 'http://vocabulary.odm2.org/organizationtype/center');
INSERT INTO cv_organizationtype VALUES ('fundingOrganization', 'Funding organization', 'An organization that funds research or creative works.', NULL, 'http://vocabulary.odm2.org/organizationtype/fundingOrganization');
INSERT INTO cv_organizationtype VALUES ('researchOrganization', 'Research organization', 'A group of cooperating researchers.', NULL, 'http://vocabulary.odm2.org/organizationtype/researchOrganization');
INSERT INTO cv_organizationtype VALUES ('university', 'University', 'An institution of higher education.', NULL, 'http://vocabulary.odm2.org/organizationtype/university');
INSERT INTO cv_organizationtype VALUES ('museum', 'Museum', 'A building or institution dedicated to the acquisition, conservation, study, exhibition, and educational interpretation of objects having scientific, historical, cultural, or artistic value.', NULL, 'http://vocabulary.odm2.org/organizationtype/museum');
INSERT INTO cv_organizationtype VALUES ('school', 'School', 'An educational institution providing primary or secondary education.', NULL, 'http://vocabulary.odm2.org/organizationtype/school');
INSERT INTO cv_organizationtype VALUES ('governmentAgency', 'Government agency', 'A department or other administrative unit of a government.', NULL, 'http://vocabulary.odm2.org/organizationtype/governmentAgency');
INSERT INTO cv_organizationtype VALUES ('analyticalLaboratory', 'Analytical laboratory', 'A laboratory within which ex situ analysis of of environmental samples is performed.', NULL, 'http://vocabulary.odm2.org/organizationtype/analyticalLaboratory');
INSERT INTO cv_organizationtype VALUES ('publisher', 'Publisher', 'An organization that publishes data.', NULL, 'http://vocabulary.odm2.org/organizationtype/publisher');
INSERT INTO cv_organizationtype VALUES ('consortium', 'Consortium', 'An association of individuals or organizations for the purpose of engaging in a joint venture.', NULL, 'http://vocabulary.odm2.org/organizationtype/consortium');
INSERT INTO cv_organizationtype VALUES ('manufacturer', 'Manufacturer', 'A person or company that makes a product.', NULL, 'http://vocabulary.odm2.org/organizationtype/manufacturer');
INSERT INTO cv_organizationtype VALUES ('college', 'College', 'An institution of higher education.', NULL, 'http://vocabulary.odm2.org/organizationtype/college');
INSERT INTO cv_organizationtype VALUES ('researchInstitute', 'Research institute', 'An organization founded to conduct research.', NULL, 'http://vocabulary.odm2.org/organizationtype/researchInstitute');
INSERT INTO cv_organizationtype VALUES ('laboratory', 'Laboratory', 'A room, building, or institution equipped for scientific research, experimentation, or analysis.', NULL, 'http://vocabulary.odm2.org/organizationtype/laboratory');
INSERT INTO cv_organizationtype VALUES ('association', 'Association', 'A group of persons associated for a common purpose.', NULL, 'http://vocabulary.odm2.org/organizationtype/association');
INSERT INTO cv_organizationtype VALUES ('foundation', 'Foundation', 'An institution or organization supported by a donation or legacy appropriation.', NULL, 'http://vocabulary.odm2.org/organizationtype/foundation');


--
-- TOC entry 3372 (class 0 OID 17941)
-- Dependencies: 209
-- Data for Name: cv_propertydatatype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_propertydatatype VALUES ('integer', 'Integer', 'An integer data type can hold a whole number, but no fraction. Integers may be either signed (allowing negative values) or unsigned (nonnegative values only). ', NULL, 'http://vocabulary.odm2.org/propertydatatype/integer');
INSERT INTO cv_propertydatatype VALUES ('boolean', 'Boolean', 'A boolean type is typically a logical type that can be either "true" or "false".', NULL, 'http://vocabulary.odm2.org/propertydatatype/boolean');
INSERT INTO cv_propertydatatype VALUES ('string', 'String', 'An array of characters including letters, digits, punctuation marks, symbols, etc.', NULL, 'http://vocabulary.odm2.org/propertydatatype/string');
INSERT INTO cv_propertydatatype VALUES ('controlledList', 'Controlled list', 'A predefined list of strings that a user can select from.', NULL, 'http://vocabulary.odm2.org/propertydatatype/controlledList');
INSERT INTO cv_propertydatatype VALUES ('floatingPointNumber', 'Floating point number', 'A floating-point number represents a limited-precision rational number that may have a fractional part. ', NULL, 'http://vocabulary.odm2.org/propertydatatype/floatingPointNumber');


--
-- TOC entry 3373 (class 0 OID 17947)
-- Dependencies: 210
-- Data for Name: cv_qualitycode; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_qualitycode VALUES ('none', 'None', 'No data quality assessment has been made.', NULL, 'http://vocabulary.odm2.org/qualitycode/none');
INSERT INTO cv_qualitycode VALUES ('bad', 'Bad', 'A quality assessment has been made and enough of the data quality objectives have not been met that the observation has been assessed to be of bad quality.', NULL, 'http://vocabulary.odm2.org/qualitycode/bad');
INSERT INTO cv_qualitycode VALUES ('marginal', 'Marginal', 'A quality assessment has been made and one or more data quality objectives has not been met. The observation may be suspect and has been assessed to be of marginal quality.', NULL, 'http://vocabulary.odm2.org/qualitycode/marginal');
INSERT INTO cv_qualitycode VALUES ('good', 'Good', 'A quality assessment has been made and all data quality objectives have been met.', NULL, 'http://vocabulary.odm2.org/qualitycode/good');
INSERT INTO cv_qualitycode VALUES ('unknown', 'Unknown', 'The quality of the observation is unknown.', NULL, 'http://vocabulary.odm2.org/qualitycode/unknown');


--
-- TOC entry 3374 (class 0 OID 17953)
-- Dependencies: 211
-- Data for Name: cv_relationshiptype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_relationshiptype VALUES ('isRelatedTo', 'Is related to', 'Used to indicate that one entity has a complex relationship with another entity that is not a simple, hierarchical parent-child relationship. For example, this term can be used to express the fact that an instrument cleaning Action is related to an instrument deployment action even though it may be performed as part of a separate site visit.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isRelatedTo');
INSERT INTO cv_relationshiptype VALUES ('hasPart', 'Has part', 'Use to indicate the resource is a container of another resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/hasPart');
INSERT INTO cv_relationshiptype VALUES ('isPartOf', 'Is part of', 'Use to indicate the resource is a portion of another resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isPartOf');
INSERT INTO cv_relationshiptype VALUES ('isDerivedFrom', 'Is derived from', 'Used to indicate the relation to the works from which the resource was derived.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isDerivedFrom');
INSERT INTO cv_relationshiptype VALUES ('isSupplementTo', 'Is supplement to', 'Use to indicate the relation to the work to which the resource is a supplement.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isSupplementTo');
INSERT INTO cv_relationshiptype VALUES ('isReviewedBy', 'Is reviewed by', 'Used to indicate that the work is reviewed by another resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isReviewedBy');
INSERT INTO cv_relationshiptype VALUES ('references', 'References', 'Use to indicate the relation to the work which is used as a source of information of the resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/references');
INSERT INTO cv_relationshiptype VALUES ('isSupplementedBy', 'Is supplemented by', 'Use to indicate the relation to the work(s) which are supplements of the resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isSupplementedBy');
INSERT INTO cv_relationshiptype VALUES ('isNewVersionOf', 'Is new version of', 'Use to indicate the resource is a new edition of an old resource, where the new edition has been modified or updated.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isNewVersionOf');
INSERT INTO cv_relationshiptype VALUES ('isCitedBy', 'Is cited by', 'Use to indicate the relation to a work that cites/quotes this data.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isCitedBy');
INSERT INTO cv_relationshiptype VALUES ('Reviews', 'Reviews', 'Used to indicate that the work reviews another resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/Reviews');
INSERT INTO cv_relationshiptype VALUES ('isChildOf', 'Is child of', 'Used to indicate that one entity is an immediate child of another entity. For example, this term can be used to express the fact that an instrument deployment Action is the child of a site visit Action.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isChildOf');
INSERT INTO cv_relationshiptype VALUES ('cites', 'Cites', 'Use to indicate a relation to the work that the resource is citing/quoting.', NULL, 'http://vocabulary.odm2.org/relationshiptype/cites');
INSERT INTO cv_relationshiptype VALUES ('isPreviousVersionOf', 'Is previous version of', 'Use to indicate the resource is a previous edition of a newer resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isPreviousVersionOf');
INSERT INTO cv_relationshiptype VALUES ('compiles', 'Compiles', 'One to many relationship that denotes that the one source resource has been assembled from the target resources through a process of integration and harmonization (as opposed to simple aggregation).', 'aggregate', 'http://vocabulary.odm2.org/relationshiptype/compiles');
INSERT INTO cv_relationshiptype VALUES ('isContinuedBy', 'Is continued by', 'Use to indicate the resource is continued by the work referenced by the related identifier.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isContinuedBy');
INSERT INTO cv_relationshiptype VALUES ('wasCollectedAt', 'Was collected at', 'Used to indicate that one entity was collected at the location of another entity. For example, thirs term can be used to express the fact that a specimen SamplingFeature was collected at a site SamplingFeature.', NULL, 'http://vocabulary.odm2.org/relationshiptype/wasCollectedAt');
INSERT INTO cv_relationshiptype VALUES ('isVariantFormOf', 'Is variant form of', 'Use to indicate the resource is a variant or different form of another resource, e.g. calculated or calibrated form or different packaging.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isVariantFormOf');
INSERT INTO cv_relationshiptype VALUES ('documents', 'Documents', 'Use to indicate the relation to the work which is documentation.', NULL, 'http://vocabulary.odm2.org/relationshiptype/documents');
INSERT INTO cv_relationshiptype VALUES ('isCitationFor', 'Is citation for', 'Used to indicate the relationship between a Citation and the entity for which it is the Citation.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isCitationFor');
INSERT INTO cv_relationshiptype VALUES ('isRetrievalfor', 'Is retrieval for', 'Use to indicate the action is a retrieval of a previous deployment.', 'Action', 'http://vocabulary.odm2.org/relationshiptype/isRetrievalfor');
INSERT INTO cv_relationshiptype VALUES ('continues', 'Continues', 'Use to indicate the resource is a continuation of the work referenced by the related identifier.', NULL, 'http://vocabulary.odm2.org/relationshiptype/continues');
INSERT INTO cv_relationshiptype VALUES ('isIdenticalTo', 'Is identical to', 'Used to indicate the relation to a work that is identical to the resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isIdenticalTo');
INSERT INTO cv_relationshiptype VALUES ('isDocumentedBy', 'Is documented by', 'Use to indicate the work is documentation about/explaining the resource referenced by the related identifier.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isDocumentedBy');
INSERT INTO cv_relationshiptype VALUES ('isOriginalFormOf', 'Is original form of', 'Use to indicate the relation to the works which are variant or different forms of the resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isOriginalFormOf');
INSERT INTO cv_relationshiptype VALUES ('isReferencedBy', 'Is referenced by', 'Use to indicate the resource is used as a source of information by another resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isReferencedBy');
INSERT INTO cv_relationshiptype VALUES ('isSourceOf', 'Is source of', 'Used to indicate the relation to the works that were the source of the resource.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isSourceOf');
INSERT INTO cv_relationshiptype VALUES ('isCompiledBy', 'Is compiled by', 'Use to indicate the resource or data is compiled/created by using another resource or dataset.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isCompiledBy');
INSERT INTO cv_relationshiptype VALUES ('isAttachedTo', 'Is attached to', 'Used to indicate that one entity is attached to another. For example this term can be used to express the fact that a piece of equipment is attached to a related piece of equipment.', NULL, 'http://vocabulary.odm2.org/relationshiptype/isAttachedTo');


--
-- TOC entry 3375 (class 0 OID 17959)
-- Dependencies: 212
-- Data for Name: cv_resulttype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_resulttype VALUES ('categoryObservation', 'Category observation', 'A single ResultValue for a single Variable, measured on or at a single SamplingFeature, using a single Method.', 'Measurement', 'http://vocabulary.odm2.org/resulttype/categoryObservation');
INSERT INTO cv_resulttype VALUES ('temporalObservation', 'Temporal observation', 'A single ResultValue for a single Variable, measured on or at a SamplingFeature, using a single Method, with specific Units, and having a specific ProcessingLevel.', 'Measurement', 'http://vocabulary.odm2.org/resulttype/temporalObservation');
INSERT INTO cv_resulttype VALUES ('transectCoverage', 'Transect coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over multiple locations along a transect having varying location dimensions (e.g.,  X and/or Y, where X and Y are horizontal coordintes). ValueDateTime may be fixed or controlled.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/transectCoverage');
INSERT INTO cv_resulttype VALUES ('profileCoverage', 'Profile coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over multiple locations along a depth profile with only one varying location dimension (e.g., Z, where Z is depth). ValueDateTime may be fixed or controlled.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/profileCoverage');
INSERT INTO cv_resulttype VALUES ('truthObservation', 'Truth observation', 'A single ResultValue for a single Variable, measured on or at a single SamplingFeature, using a single Method.', 'Measurement', 'http://vocabulary.odm2.org/resulttype/truthObservation');
INSERT INTO cv_resulttype VALUES ('measurement', 'Measurement', 'A single ResultValue for a single Variable, measured on or at a SamplingFeature, using a single Method, with specific Units, and having a specific ProcessingLevel.', 'Measurement', 'http://vocabulary.odm2.org/resulttype/measurement');
INSERT INTO cv_resulttype VALUES ('pointCoverage', 'Point coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, with a fixed ValueDateTime, but measured over varying X,Y locations, where X and Y are horizontal coordinates.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/pointCoverage');
INSERT INTO cv_resulttype VALUES ('sectionCoverage', 'Section coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over varying X (horizontal) and Z (depth) coordinates. ValueDateTime may be fixed or controlled.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/sectionCoverage');
INSERT INTO cv_resulttype VALUES ('spectraCoverage', 'Spectra coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over multiple wavelengths of light. ValueDateTime may be fixed or controlled.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/spectraCoverage');
INSERT INTO cv_resulttype VALUES ('countObservation', 'Count observation', 'A single ResultValue for a single Variable, counted on or at a single SamplingFeature, using a single Method, and having a specific ProcessingLevel.', 'Measurement', 'http://vocabulary.odm2.org/resulttype/countObservation');
INSERT INTO cv_resulttype VALUES ('timeSeriesCoverage', 'Time series coverage', 'A series of ResultValues for a single Variable, measured on or at a single SamplingFeature of fixed location, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over time.', 'Coverage', 'http://vocabulary.odm2.org/resulttype/timeSeriesCoverage');
INSERT INTO cv_resulttype VALUES ('trajectoryCoverage', 'Trajectory coverage', 'A series of ResultValues for a single Variable, measured on a single SamplingFeature, using a single Method, with specific Units, having a specific ProcessingLevel, but measured over varying X,Y, Z, and D locations, where X and Y are horizontal coordinates, Z is a vertical coordinate, and D is the distance along the trajectory. ValueDateTime may be fixed (DTS Temperature) or controlled (glider).', 'Coverage', 'http://vocabulary.odm2.org/resulttype/trajectoryCoverage');


--
-- TOC entry 3376 (class 0 OID 17965)
-- Dependencies: 213
-- Data for Name: cv_samplingfeaturegeotype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_samplingfeaturegeotype VALUES ('multiLineString', 'Multi line string', 'A collection of individual lines, used as a single feature. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/multiLineString');
INSERT INTO cv_samplingfeaturegeotype VALUES ('point', 'Point', 'Topological 0-dimensional geometric primitive representing a position. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/point');
INSERT INTO cv_samplingfeaturegeotype VALUES ('lineString', 'Line string', 'A subclass of a Curve using linear interpolation between points. A Curve is a 1-dimensional geometric object usually stored as a sequence of Points. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/lineString');
INSERT INTO cv_samplingfeaturegeotype VALUES ('multiPolygon', 'Multi polygon', 'A collection of individual polygons, used as a single feature. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/multiPolygon');
INSERT INTO cv_samplingfeaturegeotype VALUES ('volume', 'Volume', 'A three dimensional space enclosed by some closed boundary.', '3D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/volume');
INSERT INTO cv_samplingfeaturegeotype VALUES ('multiPoint', 'Multi point', 'A collection of individual points, used as a single feature. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/multiPoint');
INSERT INTO cv_samplingfeaturegeotype VALUES ('notApplicable', 'Not applicable', 'The sampling feature has no applicable geospatial feature type', 'Non-spatial', 'http://vocabulary.odm2.org/samplingfeaturegeotype/notApplicable');
INSERT INTO cv_samplingfeaturegeotype VALUES ('polygon', 'Polygon', 'A planar Surface defined by 1 exterior boundary and 0 or more interior boundaries. Each interior boundary defines a hole in the Polygon. Polygons are topologically closed. Polygons are a subclass of Surface that is planar. A Surface is a 2-dimensonal geometric object. Represented in 2D coordinates by FeatureGeometry.', '2D', 'http://vocabulary.odm2.org/samplingfeaturegeotype/polygon');


--
-- TOC entry 3377 (class 0 OID 17971)
-- Dependencies: 214
-- Data for Name: cv_samplingfeaturetype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_samplingfeaturetype VALUES ('observationWell', 'Observation well', 'A hole or shaft constructed in the earth intended to be used to locate, sample, or develop groundwater, oil, gas, or some other subsurface material. The diameter of a well is typically much smaller than the depth. Wells are also used to artificially recharge groundwater or to pressurize oil and gas production zones. Specific kinds of wells should be specified in the SamplingFeature description. For example, underground waste-disposal wells should be classified as waste injection wells.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/observationWell');
INSERT INTO cv_samplingfeaturetype VALUES ('weatherStation', 'Weather station', 'A facility, either on land or sea, with instruments and equipment for measuring atmospheric conditions to provide information for weather forecasts and to study weather and climate.', 'SamplingPoint', 'http://vocabulary.odm2.org/samplingfeaturetype/weatherStation');
INSERT INTO cv_samplingfeaturetype VALUES ('shipsTrack', 'Ships track', 'A path along which a ship or vessel travels while measuring a phenomena of study.  Represented as a line connecting the ship''s consecutive positions on the surface of the earth.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/shipsTrack');
INSERT INTO cv_samplingfeaturetype VALUES ('waterQualityStation', 'Water quality station', 'A location used to monitor and test the quality of terrestrial bodies of water. Water quality stations may be locations at which physical water samples are collected for ex situ analysis.  Water qulaity stations may also have instruments and equipment for continuous, in situ measurement of water quality variables. ', 'SamplingPoint', 'http://vocabulary.odm2.org/samplingfeaturetype/waterQualityStation');
INSERT INTO cv_samplingfeaturetype VALUES ('scene', 'Scene', 'A two-dimensional visual extent within a physical environment.', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/scene');
INSERT INTO cv_samplingfeaturetype VALUES ('site', 'Site', 'A facility or location at which observations have been collected. A site may have instruments or equipment installed and may contain multiple other sampling features (e.g., a stream gage, weather station, observation well, etc.). Additionally, many specimen sampling features may be collected at a site. Sites are also often referred to as stations. A site is represented as a point, but it may have a geographical footprint that is not a point. The site coordinates serve as a reference for the site and offsets may be specified from this reference location.', 'SamplingPoint', 'http://vocabulary.odm2.org/samplingfeaturetype/site');
INSERT INTO cv_samplingfeaturetype VALUES ('excavation', 'Excavation', 'An artificially constructed cavity in the earth that is deeper than the soil, larger than a well bore, and substantially open to the atmosphere. The diameter of an excavation is typically similar or larger than the depth. Excavations include building-foundation diggings, roadway cuts, and surface mines.', 'SamplingSolid', 'http://vocabulary.odm2.org/samplingfeaturetype/excavation');
INSERT INTO cv_samplingfeaturetype VALUES ('trajectory', 'Trajectory', 'The path that a moving object follows through space as a function of time. A trajectory can be described by the geometry of the path or as the position of the object over time. ', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/trajectory');
INSERT INTO cv_samplingfeaturetype VALUES ('specimen', 'Specimen', 'A physical sample (object or entity) obtained for observations, typically performed ex situ, often in a laboratory.  ', 'Specimen', 'http://vocabulary.odm2.org/samplingfeaturetype/specimen');
INSERT INTO cv_samplingfeaturetype VALUES ('ecologicalLandClassification', 'Ecological land classification', 'Ecological land classification is a cartographical delineation of distinct ecological areas, identified by their geology, topography, soils, vegetation, climate conditions, living species, habitats, water resources, as well as anthropic factors. These factors control and influence biotic composition and ecological processes.', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/ecologicalLandClassification');
INSERT INTO cv_samplingfeaturetype VALUES ('traverse', 'Traverse', 'A field control network consisting of survey stations placed along a line or path of travel.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/traverse');
INSERT INTO cv_samplingfeaturetype VALUES ('soilPitSection', 'Soil pit section', 'Two-dimensional vertical face of a soil pit that is described and sampled.', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/soilPitSection');
INSERT INTO cv_samplingfeaturetype VALUES ('profile', 'Profile', 'A one-dimensional grid at fixed (x, y, t) coordinates within a four-dimensional (x, y, z, t) coordinate reference system. The grid axis is aligned with the coordinate reference system z-axis. Typically used to characterize or measure phenomena as a function of depth.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/profile');
INSERT INTO cv_samplingfeaturetype VALUES ('crossSection', 'Cross section', 'The intersection of a body in three-dimensional space with a plane.  Represented as a polygon. ', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/crossSection');
INSERT INTO cv_samplingfeaturetype VALUES ('transect', 'Transect', 'A path along which ocurrences of a phenomena of study are counted or measured.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/transect');
INSERT INTO cv_samplingfeaturetype VALUES ('depthInterval', 'Depth interval', 'A discrete segment along a longer vertical path, such as a borehole, soil profile or other depth profile, in which an observation or specimen is collected over the distance between the upper and lower depth limits of the interval. A Depth Interval is a sub-type of Interval.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/depthInterval');
INSERT INTO cv_samplingfeaturetype VALUES ('quadrat', 'Quadrat', 'A small plot used to isolate a standard unit of area for study of the distribution of an item over a large area.', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/quadrat');
INSERT INTO cv_samplingfeaturetype VALUES ('CTD', 'CTD', 'A CTD (Conductivity, Temperature, and Depth) cast is a water column depth profile collected over a specific and relatively short date-time range, that can be considered as a parent specimen.', 'Specimen', 'http://vocabulary.odm2.org/samplingfeaturetype/CTD');
INSERT INTO cv_samplingfeaturetype VALUES ('borehole', 'Borehole', 'A narrow shaft bored into the ground, either vertically or horizontally. A borehole includes the hole cavity and walls surrounding that cavity.  ', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/borehole');
INSERT INTO cv_samplingfeaturetype VALUES ('fieldArea', 'Field area', 'A location at which field experiments or observations of ambient conditions are conducted. A field area may contain many sites and has a geographical footprint that can be represented by a polygon.', 'SamplingSurface', 'http://vocabulary.odm2.org/samplingfeaturetype/fieldArea');
INSERT INTO cv_samplingfeaturetype VALUES ('interval', 'Interval', 'A discrete segment along a longer path in which an observation or specimen is collected over the distance between the upper and lower bounds of the interval. A Depth Interval is a sub-type of Interval.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/interval');
INSERT INTO cv_samplingfeaturetype VALUES ('streamGage', 'Stream gage', 'A location used to monitor and test terrestrial bodies of water. Hydrometric measurements of water level, surface elevation ("stage") and/or volumetric discharge (flow) are generally taken, and observations of biota and water quality may also be made. ', 'SamplingPoint', 'http://vocabulary.odm2.org/samplingfeaturetype/streamGage');
INSERT INTO cv_samplingfeaturetype VALUES ('flightline', 'Flightline', 'A path along which an aircraft travels while measuring a phenomena of study.', 'SamplingCurve', 'http://vocabulary.odm2.org/samplingfeaturetype/flightline');


--
-- TOC entry 3378 (class 0 OID 17977)
-- Dependencies: 215
-- Data for Name: cv_sitetype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_sitetype VALUES ('aggregateWaterUseEstablishment', 'Aggregate water-use establishment', 'An Aggregate Water-Use Establishment represents an aggregate class of water-using establishments or individuals that are associated with a specific geographic location and water-use category, such as all the industrial users located within a county or all self-supplied domestic users in a county. An aggregate water-use establishment site type is used when specific information needed to create sites for the individual facilities or users is not available or when it is not desirable to store the site-specific information in the database. ', 'Aggregated Use Sites', 'http://vocabulary.odm2.org/sitetype/aggregateWaterUseEstablishment');
INSERT INTO cv_sitetype VALUES ('waterSupplyTreatmentPlant', 'Water-supply treatment plant', 'A facility where water is treated prior to use for consumption or other purpose.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/waterSupplyTreatmentPlant');
INSERT INTO cv_sitetype VALUES ('sinkhole', 'Sinkhole', 'A crater formed when the roof of a cavern collapses; usually found in limestone areas. Surface water and precipitation that enters a sinkhole usually evaporates or infiltrates into the ground, rather than draining into a stream.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/sinkhole');
INSERT INTO cv_sitetype VALUES ('shore', 'Shore', 'The land along the edge of the sea, a lake, or a wide river where the investigator considers the proximity of the water body to be important. Land adjacent to a reservoir, lake, impoundment, or oceanic site type is considered part of the shore when it includes a beach or bank between the high and low water marks.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/shore');
INSERT INTO cv_sitetype VALUES ('wastewaterLandApplication', 'Wastewater land application', 'A site where the disposal of waste water on land occurs. Use "waste-injection well" for underground waste-disposal sites.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/wastewaterLandApplication');
INSERT INTO cv_sitetype VALUES ('criticalZoneObservatories', 'Critical Zone Observatories', 'Critical Zone Observatories (CZOs) address pressing interdisciplinary scientific questions concerning geological, physical, chemical, and biological processes and their couplings that govern critical zone system dynamics.', 'Observatory Sites', 'http://vocabulary.odm2.org/sitetype/criticalZoneObservatories');
INSERT INTO cv_sitetype VALUES ('playa', 'Playa', 'A dried-up, vegetation-free, flat-floored area composed of thin, evenly stratified sheets of fine clay, silt or sand, and represents the bottom part of a shallow, completely closed or undrained desert lake basin in which water accumulates and is quickly evaporated, usually leaving deposits of soluble salts.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/playa');
INSERT INTO cv_sitetype VALUES ('outcrop', 'Outcrop', 'The part of a rock formation that appears at the surface of the surrounding land.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/outcrop');
INSERT INTO cv_sitetype VALUES ('combinedSewer', 'Combined sewer', 'An underground conduit created to convey storm drainage and waste products into a wastewater-treatment plant, stream, reservoir, or disposal site.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/combinedSewer');
INSERT INTO cv_sitetype VALUES ('soilHole', 'Soil hole', 'A small excavation into soil at the top few meters of earth surface. Soil generally includes some organic matter derived from plants. Soil holes are created to measure soil composition and properties. Sometimes electronic probes are inserted into soil holes to measure physical properties, and (or) the extracted soil is analyzed.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/soilHole');
INSERT INTO cv_sitetype VALUES ('waterUseEstablishment', 'Water-use establishment', 'A place-of-use (a water using facility that is associated with a specific geographical point location, such as a business or industrial user) that cannot be specified with any other facility secondary type. Water-use place-of-use sites are establishments such as a factory, mill, store, warehouse, farm, ranch, or bank. See also: Aggregate water-use-establishment.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/waterUseEstablishment');
INSERT INTO cv_sitetype VALUES ('cave', 'Cave', 'A natural open space within a rock formation large enough to accommodate a human. A cave may have an opening to the outside, is always underground, and sometimes submerged. Caves commonly occur by the dissolution of soluble rocks, generally limestone, but may also be created within the voids of large-rock aggregations, in openings along seismic faults, and in lava formations.', 'Groundwater Sites', 'http://vocabulary.odm2.org/sitetype/cave');
INSERT INTO cv_sitetype VALUES ('unsaturatedZone', 'Unsaturated zone', 'A site equipped to measure conditions in the subsurface deeper than a soil hole, but above the water table or other zone of saturation.', 'Groundwater Sites', 'http://vocabulary.odm2.org/sitetype/unsaturatedZone');
INSERT INTO cv_sitetype VALUES ('facility', 'Facility', 'A non-ambient location where environmental measurements are expected to be strongly influenced by current or previous activities of humans. *Sites identified with a "facility" primary site type must be further classified with one of the applicable secondary site types.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/facility');
INSERT INTO cv_sitetype VALUES ('cistern', 'Cistern', 'An artificial, non-pressurized reservoir filled by gravity flow and used for water storage. The reservoir may be located above, at, or below ground level. The water may be supplied from diversion of precipitation, surface, or groundwater sources.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/cistern');
INSERT INTO cv_sitetype VALUES ('aggregateGroundwaterUse', 'Aggregate groundwater use', 'An Aggregate Groundwater Withdrawal/Return site represents an aggregate of specific sites where groundwater is withdrawn or returned which is defined by a geographic area or some other common characteristic. An aggregate groundwater site type is used when it is not possible or practical to describe the specific sites as springs or as any type of well including ''multiple wells'', or when water-use information is only available for the aggregate. ', 'Aggregated Use Sites', 'http://vocabulary.odm2.org/sitetype/aggregateGroundwaterUse');
INSERT INTO cv_sitetype VALUES ('spring', 'Spring', 'A location at which the water table intersects the land surface, resulting in a natural flow of groundwater to the surface. Springs may be perennial, intermittent, or ephemeral.', 'Spring Sites', 'http://vocabulary.odm2.org/sitetype/spring');
INSERT INTO cv_sitetype VALUES ('canal', 'Canal', 'An artificial watercourse designed for navigation, drainage, or irrigation by connecting two or more bodies of water; it is larger than a ditch.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/canal');
INSERT INTO cv_sitetype VALUES ('wastewaterSewer', 'Wastewater sewer', 'An underground conduit created to convey liquid and semisolid domestic, commercial, or industrial waste into a treatment plant, stream, reservoir, or disposal site. If the sewer also conveys storm water, then the "combined sewer" secondary site type should be used.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/wastewaterSewer');
INSERT INTO cv_sitetype VALUES ('waterDistributionSystem', 'Water-distribution system', 'A site located somewhere on a networked infrastructure that distributes treated or untreated water to multiple domestic, industrial, institutional, and (or) commercial users. May be owned by a municipality or community, a water district, or a private concern.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/waterDistributionSystem');
INSERT INTO cv_sitetype VALUES ('networkInfrastructure', 'Network infrastructure', 'A site that is primarily associated with monitoring or telemetry network infrastructure. For example a radio repeater or remote radio base station.', 'infrastructure', 'http://vocabulary.odm2.org/sitetype/networkInfrastructure');
INSERT INTO cv_sitetype VALUES ('wetland', 'Wetland', 'Land where saturation with water is the dominant factor determining the nature of soil development and the types of plant and animal communities living in the soil and on its surface (Cowardin, December 1979). Wetlands are found from the tundra to the tropics and on every continent except Antarctica. Wetlands are areas that are inundated or saturated by surface or groundwater at a frequency and duration sufficient to support, and that under normal circumstances do support, a prevalence of vegetation typically adapted for life in saturated soil conditions. Wetlands generally include swamps, marshes, bogs and similar areas. Wetlands may be forested or unforested, and naturally or artificially created.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/wetland');
INSERT INTO cv_sitetype VALUES ('diversion', 'Diversion', 'A site where water is withdrawn or diverted from a surface-water body (e.g. the point where the upstream end of a canal intersects a stream, or point where water is withdrawn from a reservoir). Includes sites where water is pumped for use elsewhere.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/diversion');
INSERT INTO cv_sitetype VALUES ('golfCourse', 'Golf course', 'A place-of-use, either public or private, where the game of golf is played. A golf course typically uses water for irrigation purposes. Should not be used if the site is a specific hydrologic feature or facility; but can be used especially for the water-use sites.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/golfCourse');
INSERT INTO cv_sitetype VALUES ('estuary', 'Estuary', 'A coastal inlet of the sea or ocean; esp. the mouth of a river, where tide water normally mixes with stream water (modified, Webster). Salinity in estuaries typically ranges from 1 to 25 Practical Salinity Units (psu), as compared oceanic values around 35-psu. See also: tidal stream and coastal.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/estuary');
INSERT INTO cv_sitetype VALUES ('composite', 'Composite', 'A Composite site represents an aggregation of specific sites defined by a geographic location at which multiple sampling features have been installed. For example, a composite site might consist of a location on a stream where a streamflow gage, weather station, and shallow groundwater well have been installed.', 'Composite Sites', 'http://vocabulary.odm2.org/sitetype/composite');
INSERT INTO cv_sitetype VALUES ('subsurface', 'Subsurface', 'A location below the land surface, but not a well, soil hole, or excavation.', 'Groundwater Sites', 'http://vocabulary.odm2.org/sitetype/subsurface');
INSERT INTO cv_sitetype VALUES ('tunnelShaftMine', 'Tunnel, shaft, or mine', 'A constructed subsurface open space large enough to accommodate a human that is not substantially open to the atmosphere and is not a well. The excavation may have been for minerals, transportation, or other purposes. See also: Excavation.', 'Groundwater Sites', 'http://vocabulary.odm2.org/sitetype/tunnelShaftMine');
INSERT INTO cv_sitetype VALUES ('stream', 'Stream', 'A body of running water moving under gravity flow in a defined channel. The channel may be entirely natural, or altered by engineering practices through straightening, dredging, and (or) lining. An entirely artificial channel should be qualified with the "canal" or "ditch" secondary site type.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/stream');
INSERT INTO cv_sitetype VALUES ('animalWasteLagoon', 'Animal waste lagoon', 'A facility for storage and/or biological treatment of wastes from livestock operations. Animal-waste lagoons are earthen structures ranging from pits to large ponds, and contain manure which has been diluted with building washwater, rainfall, and surface runoff. In treatment lagoons, the waste becomes partially liquefied and stabilized by bacterial action before the waste is disposed of on the land and the water is discharged or re-used.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/animalWasteLagoon');
INSERT INTO cv_sitetype VALUES ('glacier', 'Glacier', 'Body of land ice that consists of recrystallized snow accumulated on the surface of the ground and moves slowly downslope (WSP-1541A) over a period of years or centuries. Since glacial sites move, the lat-long precision for these sites is usually coarse.', 'Glacier Sites', 'http://vocabulary.odm2.org/sitetype/glacier');
INSERT INTO cv_sitetype VALUES ('coastal', 'Coastal', 'An oceanic site that is located off-shore beyond the tidal mixing zone (estuary) but close enough to the shore that the investigator considers the presence of the coast to be important. Coastal sites typically are within three nautical miles of the shore.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/coastal');
INSERT INTO cv_sitetype VALUES ('pavement', 'Pavement', 'A surface site where the land surface is covered by a relatively impermeable material, such as concrete or asphalt. Pavement sites are typically part of transportation infrastructure, such as roadways, parking lots, or runways.', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/pavement');
INSERT INTO cv_sitetype VALUES ('landfill', 'Landfill', 'A typically dry location on the surface of the land where primarily solid waste products are currently, or previously have been, aggregated and sometimes covered with a veneer of soil. See also: Wastewater disposal and waste-injection well.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/landfill');
INSERT INTO cv_sitetype VALUES ('tidalStream', 'Tidal stream', 'A stream reach where the flow is influenced by the tide, but where the water chemistry is not normally influenced. A site where ocean water typically mixes with stream water should be coded as an estuary.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/tidalStream');
INSERT INTO cv_sitetype VALUES ('unknown', 'Unknown', 'Site type is unknown.', 'Unknown', 'http://vocabulary.odm2.org/sitetype/unknown');
INSERT INTO cv_sitetype VALUES ('wastewaterTreatmentPlant', 'Wastewater-treatment plant', 'A facility where wastewater is treated to reduce concentrations of dissolved and (or) suspended materials prior to discharge or reuse.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/wastewaterTreatmentPlant');
INSERT INTO cv_sitetype VALUES ('ocean', 'Ocean', 'Site in the open ocean, gulf, or sea. (See also: Coastal, Estuary, and Tidal stream).', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/ocean');
INSERT INTO cv_sitetype VALUES ('ditch', 'Ditch', 'An excavation artificially dug in the ground, either lined or unlined, for conveying water for drainage or irrigation; it is smaller than a canal.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/ditch');
INSERT INTO cv_sitetype VALUES ('laboratoryOrSamplePreparationArea', 'Laboratory or sample-preparation area', 'A site where some types of quality-control samples are collected, and where equipment and supplies for environmental sampling are prepared. Equipment blank samples are commonly collected at this site type, as are samples of locally produced deionized water. This site type is typically used when the data are either not associated with a unique environmental data-collection site, or where blank water supplies are designated by Center offices with unique station IDs.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/laboratoryOrSamplePreparationArea');
INSERT INTO cv_sitetype VALUES ('fieldPastureOrchardOrNursery', 'Field, Pasture, Orchard, or Nursery', 'A water-using facility characterized by an area where plants are grown for transplanting, for use as stocks for budding and grafting, or for sale. Irrigation water may or may not be applied.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/fieldPastureOrchardOrNursery');
INSERT INTO cv_sitetype VALUES ('groundwaterDrain', 'Groundwater drain', 'An underground pipe or tunnel through which groundwater is artificially diverted to surface water for the purpose of reducing erosion or lowering the water table. A drain is typically open to the atmosphere at the lowest elevation, in contrast to a well which is open at the highest point.', 'Groundwater Sites', 'http://vocabulary.odm2.org/sitetype/groundwaterDrain');
INSERT INTO cv_sitetype VALUES ('stormSewer', 'Storm sewer', 'An underground conduit created to convey storm drainage into a stream channel or reservoir. If the sewer also conveys liquid waste products, then the "combined sewer" secondary site type should be used.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/stormSewer');
INSERT INTO cv_sitetype VALUES ('volcanicVent', 'Volcanic vent', 'Vent from which volcanic gases escape to the atmosphere. Also known as fumarole.', 'Geologic Sites', 'http://vocabulary.odm2.org/sitetype/volcanicVent');
INSERT INTO cv_sitetype VALUES ('house', 'House', 'A residential building for a single or small number of families.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/house');
INSERT INTO cv_sitetype VALUES ('hydroelectricPlant', 'Hydroelectric plant', 'A facility that generates electric power by converting potential energy of water into kinetic energy. Typically, turbine generators are turned by falling water.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/hydroelectricPlant');
INSERT INTO cv_sitetype VALUES ('lakeReservoirImpoundment', 'Lake, Reservoir, Impoundment', 'An inland body of standing fresh or saline water that is generally too deep to permit submerged aquatic vegetation to take root across the entire body (cf: wetland). This site type includes an expanded part of a river, a reservoir behind a dam, and a natural or excavated depression containing a water body without surface-water inlet and/or outlet.', 'Surface Water Sites', 'http://vocabulary.odm2.org/sitetype/lakeReservoirImpoundment');
INSERT INTO cv_sitetype VALUES ('aggregateSurfaceWaterUse', 'Aggregate surface-water-use', 'An Aggregate Surface-Water Diversion/Return site represents an aggregate of specific sites where surface water is diverted or returned which is defined by a geographic area or some other common characteristic. An aggregate surface-water site type is used when it is not possible or practical to describe the specific sites as diversions, outfalls, or land application sites, or when water-use information is only available for the aggregate. ', 'Aggregated Use Sites', 'http://vocabulary.odm2.org/sitetype/aggregateSurfaceWaterUse');
INSERT INTO cv_sitetype VALUES ('thermoelectricPlant', 'Thermoelectric plant', 'A facility that uses water in the generation of electricity from heat. Typically turbine generators are driven by steam. The heat may be caused by various means, including combustion, nuclear reactions, and geothermal processes.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/thermoelectricPlant');
INSERT INTO cv_sitetype VALUES ('land', 'Land', 'A location on the surface of the earth that is not normally saturated with water. Land sites are appropriate for sampling vegetation, overland flow of water, or measuring land-surface properties such as temperature. (See also: Wetland).', 'Land Sites', 'http://vocabulary.odm2.org/sitetype/land');
INSERT INTO cv_sitetype VALUES ('atmosphere', 'Atmosphere', 'A site established primarily to measure meteorological properties or atmospheric deposition.', 'Atmospheric Sites', 'http://vocabulary.odm2.org/sitetype/atmosphere');
INSERT INTO cv_sitetype VALUES ('outfall', 'Outfall', 'A site where water or wastewater is returned to a surface-water body, e.g. the point where wastewater is returned to a stream. Typically, the discharge end of an effluent pipe.', 'Facility Sites', 'http://vocabulary.odm2.org/sitetype/outfall');
INSERT INTO cv_sitetype VALUES ('septicSystem', 'Septic system', 'A site within or in close proximity to a subsurface sewage disposal system that generally consists of: (1) a septic tank where settling of solid material occurs, (2) a distribution system that transfers fluid from the tank to (3) a leaching system that disperses the effluent into the ground.', 'Water Infrastructure Sites', 'http://vocabulary.odm2.org/sitetype/septicSystem');


--
-- TOC entry 3379 (class 0 OID 17983)
-- Dependencies: 216
-- Data for Name: cv_spatialoffsettype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_spatialoffsettype VALUES ('heightInterval', 'Height interval', 'Height interval above the earth or water surface. The minimum height value is expressed first and then the maximum height value. Values increase in the upward direction.', '2D', 'http://vocabulary.odm2.org/spatialoffsettype/heightInterval');
INSERT INTO cv_spatialoffsettype VALUES ('cartesianOffset', 'Cartesian offset', 'Offset expressed using cartesian coordinates where X is distance along axis aligned with true north, Y is distace aligned with true east, and Z is distance aligned straight up. Depths are expressed a negative numbers. The origin of the coordinate system is typically defined in the site description. ', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/cartesianOffset');
INSERT INTO cv_spatialoffsettype VALUES ('height', 'Height', 'Height above the earth or water surface. Values are positive and increase in the upward direction.', '1D', 'http://vocabulary.odm2.org/spatialoffsettype/height');
INSERT INTO cv_spatialoffsettype VALUES ('longitudinalInterval', 'Longitudinal interval', 'Interval along a horizontal or longitudinal ray. The first coordinate is the angle from north expressed in degrees of the longitudinal array. The second coordinate is the minimum distance along the ray at which the longitudinal interval begins. The third coordinate is the maximium distance along the ray at which the longitudinal interval ends.', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/longitudinalInterval');
INSERT INTO cv_spatialoffsettype VALUES ('radialHorizontalOffset', 'Radial horizontal offset', 'Offset expressed as a distance along a ray that originates from a central point. The angle of the ray is expressed as the first offset coordinate in degrees. The distance along the ray is expressed as the second offset coordinate.', '2D', 'http://vocabulary.odm2.org/spatialoffsettype/radialHorizontalOffset');
INSERT INTO cv_spatialoffsettype VALUES ('heightDirectional', 'Height, directional', 'Height above the earth or water surface along a non-vertical line. The first coordinate is the angle of the ray from north expressed in degrees. The second coordinate is the angle of the ray from horizontal expressed in positive degrees. The distance along the ray is expressed as a positive number that increases with distance along the ray. ', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/heightDirectional');
INSERT INTO cv_spatialoffsettype VALUES ('radialHorizontalOffsetWithHeight', 'Radial horizontal offset with height', 'Offset expressed as a distance along a ray that originates from a central point with a third coordinate that indicates the height above the earth or water surface. The angle of the ray is expressed as the first offset coordinate in degrees. The distance along the ray is expressed as the second offset coordinate. The height above the earth or water surface is expressed as the third coordinate.', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/radialHorizontalOffsetWithHeight');
INSERT INTO cv_spatialoffsettype VALUES ('depthInterval', 'Depth interval', 'Depth interval below the earth or water surface. The mininum depth value is expressed first and then maximum depth value. Values are expresssed as negative numbers and become more negative in the downward direction.', '2D', 'http://vocabulary.odm2.org/spatialoffsettype/depthInterval');
INSERT INTO cv_spatialoffsettype VALUES ('radialHorizontalOffsetWithDepth', 'Radial horizontal offset with depth', 'Offset expressed as a distance along a ray that originates from a central point with a third coordinate that indicates the depth below the earth or water surface. The angle of the ray is expressed as the first offset coordinate in degrees. The distance along the ray is expressed as the second offset coordinate. The depth below the earth or water surface is expressed as the third coordinate.', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/radialHorizontalOffsetWithDepth');
INSERT INTO cv_spatialoffsettype VALUES ('depthDirectional', 'Depth, directional', 'Depth below the earth or water surface along a non-vertical line. The first coordinate is the angle of the ray from north expressed in degrees. The second coordinate is the angle of the ray from horizontal expressed in negative degrees. The distance along the ray is expressed as a positive number that increases with distance along the ray. ', '3D', 'http://vocabulary.odm2.org/spatialoffsettype/depthDirectional');
INSERT INTO cv_spatialoffsettype VALUES ('depth', 'Depth', 'Depth below the earth or water surface. Values are expressed as negative numbers and become more negative in the downward direction.', '1D', 'http://vocabulary.odm2.org/spatialoffsettype/depth');


--
-- TOC entry 3380 (class 0 OID 17989)
-- Dependencies: 217
-- Data for Name: cv_speciation; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_speciation VALUES ('F', 'F', 'Expressed as fluorine', NULL, 'http://vocabulary.odm2.org/speciation/F');
INSERT INTO cv_speciation VALUES ('Th', 'Th', 'Expressed as thorium', NULL, 'http://vocabulary.odm2.org/speciation/Th');
INSERT INTO cv_speciation VALUES ('Co', 'Co', 'Expressed as cobalt', NULL, 'http://vocabulary.odm2.org/speciation/Co');
INSERT INTO cv_speciation VALUES ('SO4', 'SO4', 'Expressed as Sulfate', NULL, 'http://vocabulary.odm2.org/speciation/SO4');
INSERT INTO cv_speciation VALUES ('H2O', 'H2O', 'Expressed as water', NULL, 'http://vocabulary.odm2.org/speciation/H2O');
INSERT INTO cv_speciation VALUES ('C19H14', 'C19H14', 'Expressed as methylchrysene', NULL, 'http://vocabulary.odm2.org/speciation/C19H14');
INSERT INTO cv_speciation VALUES ('C5Cl6', 'C5Cl6', 'Expressed as hexachlorocyclopentadiene', NULL, 'http://vocabulary.odm2.org/speciation/C5Cl6');
INSERT INTO cv_speciation VALUES ('Ra', 'Ra', 'Expressed as Radium. Also known as "radium equivalent." The radium equivalent concept allows a single index or number to describe the gamma output from different mixtures of uranium (i.e., radium), thorium, and 40K in a material.', NULL, 'http://vocabulary.odm2.org/speciation/Ra');
INSERT INTO cv_speciation VALUES ('C7H6N2O4', 'C7H6N2O4', 'Expressed as dinitrotoluene', NULL, 'http://vocabulary.odm2.org/speciation/C7H6N2O4');
INSERT INTO cv_speciation VALUES ('C8H8', 'C8H8', 'Expressed as styrene', NULL, 'http://vocabulary.odm2.org/speciation/C8H8');
INSERT INTO cv_speciation VALUES ('Re', 'Re', 'Expressed as rhenium', NULL, 'http://vocabulary.odm2.org/speciation/Re');
INSERT INTO cv_speciation VALUES ('Se', 'Se', 'Expressed as selenium', NULL, 'http://vocabulary.odm2.org/speciation/Se');
INSERT INTO cv_speciation VALUES ('C2H2Cl4', 'C2H2Cl4', 'Expressed as tetrachloroethane', NULL, 'http://vocabulary.odm2.org/speciation/C2H2Cl4');
INSERT INTO cv_speciation VALUES ('C16H10', 'C16H10', 'Expressed as C16H10, e.g., fluoranthene, pyrene', NULL, 'http://vocabulary.odm2.org/speciation/C16H10');
INSERT INTO cv_speciation VALUES ('C12H10', 'C12H10', 'Expressed as C12H10, e.g., acenaphthene, biphenyl', NULL, 'http://vocabulary.odm2.org/speciation/C12H10');
INSERT INTO cv_speciation VALUES ('C6H4_CH3_2', 'C6H4(CH3)2', 'Expressed as xylenes', NULL, 'http://vocabulary.odm2.org/speciation/C6H4_CH3_2');
INSERT INTO cv_speciation VALUES ('C9H14O', 'C9H14O', 'Expressed as isophorone', NULL, 'http://vocabulary.odm2.org/speciation/C9H14O');
INSERT INTO cv_speciation VALUES ('P', 'P', 'Expressed as phosphorus', NULL, 'http://vocabulary.odm2.org/speciation/P');
INSERT INTO cv_speciation VALUES ('CO2', 'CO2', 'Expressed as carbon dioxide', NULL, 'http://vocabulary.odm2.org/speciation/CO2');
INSERT INTO cv_speciation VALUES ('C6H5OH', 'C6H5OH', 'Expressed as phenol', NULL, 'http://vocabulary.odm2.org/speciation/C6H5OH');
INSERT INTO cv_speciation VALUES ('C6HCl5O', 'C6HCl5O', 'Expressed as pentachlorophenol', NULL, 'http://vocabulary.odm2.org/speciation/C6HCl5O');
INSERT INTO cv_speciation VALUES ('C2H3Cl3', 'C2H3Cl3', 'Expressed as trichloroethane', NULL, 'http://vocabulary.odm2.org/speciation/C2H3Cl3');
INSERT INTO cv_speciation VALUES ('C17H12', 'C17H12', 'Expressed as C17H12, e.g., benzo(a)fluorene, methylfluoranthene, methylpyrene', NULL, 'http://vocabulary.odm2.org/speciation/C17H12');
INSERT INTO cv_speciation VALUES ('CH4', 'CH4', 'Expressed as methane', NULL, 'http://vocabulary.odm2.org/speciation/CH4');
INSERT INTO cv_speciation VALUES ('C3H6O', 'C3H6O', 'Expressed as acetone', NULL, 'http://vocabulary.odm2.org/speciation/C3H6O');
INSERT INTO cv_speciation VALUES ('NO2', 'NO2', 'Expressed as nitrite', NULL, 'http://vocabulary.odm2.org/speciation/NO2');
INSERT INTO cv_speciation VALUES ('C6H4N2O5', 'C6H4N2O5', 'Expressed as dinitrophenol', NULL, 'http://vocabulary.odm2.org/speciation/C6H4N2O5');
INSERT INTO cv_speciation VALUES ('C13H10', 'C13H10', 'Expressed as fluorene', NULL, 'http://vocabulary.odm2.org/speciation/C13H10');
INSERT INTO cv_speciation VALUES ('pH', 'pH', 'Expressed as pH', NULL, 'http://vocabulary.odm2.org/speciation/pH');
INSERT INTO cv_speciation VALUES ('C20H42', 'C20H42', 'Expressed as C20 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C20H42');
INSERT INTO cv_speciation VALUES ('C14H10', 'C14H10', 'Expressed as phenanthrene', NULL, 'http://vocabulary.odm2.org/speciation/C14H10');
INSERT INTO cv_speciation VALUES ('delta2H', 'delta 2H', 'Expressed as deuterium', NULL, 'http://vocabulary.odm2.org/speciation/delta2H');
INSERT INTO cv_speciation VALUES ('C19H20O4', 'C19H20O4', 'Expressed as benzyl butyl pththalate', NULL, 'http://vocabulary.odm2.org/speciation/C19H20O4');
INSERT INTO cv_speciation VALUES ('deltaN15', 'delta N15', 'Expressed as nitrogen-15', NULL, 'http://vocabulary.odm2.org/speciation/deltaN15');
INSERT INTO cv_speciation VALUES ('C27H56', 'C27H56', 'Expressed as C27 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C27H56');
INSERT INTO cv_speciation VALUES ('Zr', 'Zr', 'Expressed as zirconium', NULL, 'http://vocabulary.odm2.org/speciation/Zr');
INSERT INTO cv_speciation VALUES ('C2H6', 'C2H6', 'Expressed as ethane', NULL, 'http://vocabulary.odm2.org/speciation/C2H6');
INSERT INTO cv_speciation VALUES ('Zn', 'Zn', 'Expressed as zinc', NULL, 'http://vocabulary.odm2.org/speciation/Zn');
INSERT INTO cv_speciation VALUES ('U', 'U', 'Expressed as uranium', NULL, 'http://vocabulary.odm2.org/speciation/U');
INSERT INTO cv_speciation VALUES ('Ca', 'Ca', 'Expressed as calcium', NULL, 'http://vocabulary.odm2.org/speciation/Ca');
INSERT INTO cv_speciation VALUES ('C2Cl4', 'C2Cl4', 'Expressed as tetrachloroethylene', NULL, 'http://vocabulary.odm2.org/speciation/C2Cl4');
INSERT INTO cv_speciation VALUES ('Tl', 'Tl', 'Expressed as thallium', NULL, 'http://vocabulary.odm2.org/speciation/Tl');
INSERT INTO cv_speciation VALUES ('TA', 'TA', 'Expressed as total alkalinity', NULL, 'http://vocabulary.odm2.org/speciation/TA');
INSERT INTO cv_speciation VALUES ('C6H3Cl3', 'C6H3Cl3', 'Expressed as trichlorobenzene', NULL, 'http://vocabulary.odm2.org/speciation/C6H3Cl3');
INSERT INTO cv_speciation VALUES ('Br', 'Br', 'Expressed as bromine', NULL, 'http://vocabulary.odm2.org/speciation/Br');
INSERT INTO cv_speciation VALUES ('Mg', 'Mg', 'Expressed as magnesium', NULL, 'http://vocabulary.odm2.org/speciation/Mg');
INSERT INTO cv_speciation VALUES ('Cr', 'Cr', 'Expressed as chromium', NULL, 'http://vocabulary.odm2.org/speciation/Cr');
INSERT INTO cv_speciation VALUES ('Cd', 'Cd', 'Expressed as cadmium', NULL, 'http://vocabulary.odm2.org/speciation/Cd');
INSERT INTO cv_speciation VALUES ('C10H8', 'C10H8', 'Expressed as naphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H8');
INSERT INTO cv_speciation VALUES ('C2H6O2', 'C2H6O2', 'Expressed as Ethylene glycol', NULL, 'http://vocabulary.odm2.org/speciation/C2H6O2');
INSERT INTO cv_speciation VALUES ('deltaO18', 'delta O18', 'Expressed as oxygen-18', NULL, 'http://vocabulary.odm2.org/speciation/deltaO18');
INSERT INTO cv_speciation VALUES ('C25H52', 'C25H52', 'Expressed as C25 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C25H52');
INSERT INTO cv_speciation VALUES ('C20H12', 'C20H12', 'Expressed as C20H12, e.g., benzo(b)fluoranthene, benzo(e)pyrene, perylene', NULL, 'http://vocabulary.odm2.org/speciation/C20H12');
INSERT INTO cv_speciation VALUES ('CHCl3', 'CHCl3', 'Expressed as chloroform', NULL, 'http://vocabulary.odm2.org/speciation/CHCl3');
INSERT INTO cv_speciation VALUES ('C4H8Cl2O', 'C4H8Cl2O', 'Expressed as bis(chloroethyl) ether', NULL, 'http://vocabulary.odm2.org/speciation/C4H8Cl2O');
INSERT INTO cv_speciation VALUES ('Mo', 'Mo', 'Expressed as molybdenum', NULL, 'http://vocabulary.odm2.org/speciation/Mo');
INSERT INTO cv_speciation VALUES ('SiO2', 'SiO2', 'Expressed as silicate', NULL, 'http://vocabulary.odm2.org/speciation/SiO2');
INSERT INTO cv_speciation VALUES ('CO3', 'CO3', 'Expressed as carbonate', NULL, 'http://vocabulary.odm2.org/speciation/CO3');
INSERT INTO cv_speciation VALUES ('CH3Hg', 'CH3Hg', 'Expressed at methylmercury', NULL, 'http://vocabulary.odm2.org/speciation/CH3Hg');
INSERT INTO cv_speciation VALUES ('C10H10O4', 'C10H10O4', 'Expressed as dimethyl terephthalate', NULL, 'http://vocabulary.odm2.org/speciation/C10H10O4');
INSERT INTO cv_speciation VALUES ('C6H6', 'C6H6', 'Expressed as benzene', NULL, 'http://vocabulary.odm2.org/speciation/C6H6');
INSERT INTO cv_speciation VALUES ('C10H4_CH3_4', 'C10H4(CH3)4', 'Expressed as tetramethylnaphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H4_CH3_4');
INSERT INTO cv_speciation VALUES ('Na', 'Na', 'Expressed as sodium', NULL, 'http://vocabulary.odm2.org/speciation/Na');
INSERT INTO cv_speciation VALUES ('PO4', 'PO4', 'Expressed as phosphate', NULL, 'http://vocabulary.odm2.org/speciation/PO4');
INSERT INTO cv_speciation VALUES ('V', 'V', 'Expressed as vanadium', NULL, 'http://vocabulary.odm2.org/speciation/V');
INSERT INTO cv_speciation VALUES ('C31H64', 'C31H64', 'Expressed as C31 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C31H64');
INSERT INTO cv_speciation VALUES ('C7H8', 'C7H8', 'Expressed as Toluene', NULL, 'http://vocabulary.odm2.org/speciation/C7H8');
INSERT INTO cv_speciation VALUES ('Fe', 'Fe', 'Expressed as iron', NULL, 'http://vocabulary.odm2.org/speciation/Fe');
INSERT INTO cv_speciation VALUES ('C4Cl6', 'C4Cl6', 'Expressed as hexchlorobutadiene', NULL, 'http://vocabulary.odm2.org/speciation/C4Cl6');
INSERT INTO cv_speciation VALUES ('NO3', 'NO3', 'Expressed as nitrate', NULL, 'http://vocabulary.odm2.org/speciation/NO3');
INSERT INTO cv_speciation VALUES ('C2HCl3', 'C2HCl3', 'Expressed as trichloroethylene', NULL, 'http://vocabulary.odm2.org/speciation/C2HCl3');
INSERT INTO cv_speciation VALUES ('CN-', 'CN-', 'Expressed as cyanide', NULL, 'http://vocabulary.odm2.org/speciation/CN-');
INSERT INTO cv_speciation VALUES ('C16H14', 'C16H14', 'Expressed as dimethylphenanthrene', NULL, 'http://vocabulary.odm2.org/speciation/C16H14');
INSERT INTO cv_speciation VALUES ('C2H5Cl', 'C2H5Cl', 'Expressed as chloroethane', NULL, 'http://vocabulary.odm2.org/speciation/C2H5Cl');
INSERT INTO cv_speciation VALUES ('CHBr2Cl', 'CHBr2Cl', 'Expressed as dibromochloromethane', NULL, 'http://vocabulary.odm2.org/speciation/CHBr2Cl');
INSERT INTO cv_speciation VALUES ('Ag', 'Ag', 'Expressed as silver', NULL, 'http://vocabulary.odm2.org/speciation/Ag');
INSERT INTO cv_speciation VALUES ('C10H5_CH3_3', 'C10H5(CH3)3', 'Expressed as trimethylnaphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H5_CH3_3');
INSERT INTO cv_speciation VALUES ('Ti', 'Ti', 'Expressed as titanium', NULL, 'http://vocabulary.odm2.org/speciation/Ti');
INSERT INTO cv_speciation VALUES ('C12H9N', 'C12H9N', 'Expressed as carbazole', NULL, 'http://vocabulary.odm2.org/speciation/C12H9N');
INSERT INTO cv_speciation VALUES ('NH4', 'NH4', 'Expressed as ammonium', NULL, 'http://vocabulary.odm2.org/speciation/NH4');
INSERT INTO cv_speciation VALUES ('CH3Br', 'CH3Br', 'Expressed as bromomethane', NULL, 'http://vocabulary.odm2.org/speciation/CH3Br');
INSERT INTO cv_speciation VALUES ('CH2Cl2', 'CH2Cl2', 'Expressed as dichloromethane', NULL, 'http://vocabulary.odm2.org/speciation/CH2Cl2');
INSERT INTO cv_speciation VALUES ('EC', 'EC', 'Expressed as electrical conductivity', NULL, 'http://vocabulary.odm2.org/speciation/EC');
INSERT INTO cv_speciation VALUES ('C18H38', 'C18H38', 'Expressed as C18 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C18H38');
INSERT INTO cv_speciation VALUES ('C6H4Cl2', 'C6H4Cl2', 'Expressed as dichlorobenzene', NULL, 'http://vocabulary.odm2.org/speciation/C6H4Cl2');
INSERT INTO cv_speciation VALUES ('CaCO3', 'CaCO3', 'Expressed as calcium carbonate', NULL, 'http://vocabulary.odm2.org/speciation/CaCO3');
INSERT INTO cv_speciation VALUES ('C10H7C2H5', 'C10H7C2H5', 'Expressed as ethylnaphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H7C2H5');
INSERT INTO cv_speciation VALUES ('Pb', 'Pb', 'Expressed as lead', NULL, 'http://vocabulary.odm2.org/speciation/Pb');
INSERT INTO cv_speciation VALUES ('N', 'N', 'Expressed as nitrogen', NULL, 'http://vocabulary.odm2.org/speciation/N');
INSERT INTO cv_speciation VALUES ('C13H10S', 'C13H10S', 'Expressed as methyldibenzothiophene', NULL, 'http://vocabulary.odm2.org/speciation/C13H10S');
INSERT INTO cv_speciation VALUES ('Sn', 'Sn', 'Expressed as tin', NULL, 'http://vocabulary.odm2.org/speciation/Sn');
INSERT INTO cv_speciation VALUES ('C6H5NO2', 'C6H5NO2', 'Expressed as nitrobenzene', NULL, 'http://vocabulary.odm2.org/speciation/C6H5NO2');
INSERT INTO cv_speciation VALUES ('C26H54', 'C26H54', 'Expressed as C26 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C26H54');
INSERT INTO cv_speciation VALUES ('C24H50', 'C24H50', 'Expressed as C24 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C24H50');
INSERT INTO cv_speciation VALUES ('CHBrCl2', 'CHBrCl2', 'Expressed as bromodichloromethane', NULL, 'http://vocabulary.odm2.org/speciation/CHBrCl2');
INSERT INTO cv_speciation VALUES ('Sb', 'Sb', 'Expressed as antimony', NULL, 'http://vocabulary.odm2.org/speciation/Sb');
INSERT INTO cv_speciation VALUES ('C6H5Cl', 'C6H5Cl', 'Expressed as chlorobenzene', NULL, 'http://vocabulary.odm2.org/speciation/C6H5Cl');
INSERT INTO cv_speciation VALUES ('Cl', 'Cl', 'Expressed as chlorine', NULL, 'http://vocabulary.odm2.org/speciation/Cl');
INSERT INTO cv_speciation VALUES ('Mn', 'Mn', 'Expressed as manganese', NULL, 'http://vocabulary.odm2.org/speciation/Mn');
INSERT INTO cv_speciation VALUES ('Cu', 'Cu', 'Expressed as copper', NULL, 'http://vocabulary.odm2.org/speciation/Cu');
INSERT INTO cv_speciation VALUES ('K', 'K', 'Expressed as potassium', NULL, 'http://vocabulary.odm2.org/speciation/K');
INSERT INTO cv_speciation VALUES ('C15H12', 'C15H12', 'Expressed as C15H12, e.g., methylphenanthrene, Methylanthracene', NULL, 'http://vocabulary.odm2.org/speciation/C15H12');
INSERT INTO cv_speciation VALUES ('C12H8', 'C12H8', 'Expressed as acenaphthylene', NULL, 'http://vocabulary.odm2.org/speciation/C12H8');
INSERT INTO cv_speciation VALUES ('C12H8O', 'C12H8O', 'Expressed as dibenzofuran', NULL, 'http://vocabulary.odm2.org/speciation/C12H8O');
INSERT INTO cv_speciation VALUES ('C15H32', 'C15H32', 'Expressed as C15 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C15H32');
INSERT INTO cv_speciation VALUES ('C17H36', 'C17H36', 'Expressed as C17 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C17H36');
INSERT INTO cv_speciation VALUES ('C29H60', 'C29H60', 'Expressed as C29 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C29H60');
INSERT INTO cv_speciation VALUES ('CHBr3', 'CHBr3', 'Expressed as bromoform', NULL, 'http://vocabulary.odm2.org/speciation/CHBr3');
INSERT INTO cv_speciation VALUES ('C12H14O4', 'C12H14O4', 'Expressed as diethyl phthalate', NULL, 'http://vocabulary.odm2.org/speciation/C12H14O4');
INSERT INTO cv_speciation VALUES ('HCO3', 'HCO3', 'Expressed as hydrogen carbonate', NULL, 'http://vocabulary.odm2.org/speciation/HCO3');
INSERT INTO cv_speciation VALUES ('Ni', 'Ni', 'Expressed as nickel', NULL, 'http://vocabulary.odm2.org/speciation/Ni');
INSERT INTO cv_speciation VALUES ('Hg', 'Hg', 'Expressed as mercury', NULL, 'http://vocabulary.odm2.org/speciation/Hg');
INSERT INTO cv_speciation VALUES ('As', 'As', 'Expressed as arsenic', NULL, 'http://vocabulary.odm2.org/speciation/As');
INSERT INTO cv_speciation VALUES ('C19H40', 'C19H40', 'Expressed as C19 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C19H40');
INSERT INTO cv_speciation VALUES ('C', 'C', 'Expressed as carbon', NULL, 'http://vocabulary.odm2.org/speciation/C');
INSERT INTO cv_speciation VALUES ('C22H14', 'C22H14', 'Expressed as Dibenz(a,h)anthracene', NULL, 'http://vocabulary.odm2.org/speciation/C22H14');
INSERT INTO cv_speciation VALUES ('C2Cl6', 'C2Cl6', 'Expressed as hexachloroethane', NULL, 'http://vocabulary.odm2.org/speciation/C2Cl6');
INSERT INTO cv_speciation VALUES ('C2H3Cl', 'C2H3Cl', 'Expressed as vinyl chloride', NULL, 'http://vocabulary.odm2.org/speciation/C2H3Cl');
INSERT INTO cv_speciation VALUES ('C23H48', 'C23H48', 'Expressed as C23 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C23H48');
INSERT INTO cv_speciation VALUES ('B', 'B', 'Expressed as boron', NULL, 'http://vocabulary.odm2.org/speciation/B');
INSERT INTO cv_speciation VALUES ('Si', 'Si', 'Expressed as silicon', NULL, 'http://vocabulary.odm2.org/speciation/Si');
INSERT INTO cv_speciation VALUES ('C6Cl6', 'C6Cl6', 'Expressed as hexachlorobenzene', NULL, 'http://vocabulary.odm2.org/speciation/C6Cl6');
INSERT INTO cv_speciation VALUES ('C10H6_CH3_2', 'C10H6(CH3)2', 'Expressed as dimethylnaphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H6_CH3_2');
INSERT INTO cv_speciation VALUES ('C18H12', 'C18H12', 'Expressed as C18H12, e.g., benz(a)anthracene, chrysene, triphenylene', NULL, 'http://vocabulary.odm2.org/speciation/C18H12');
INSERT INTO cv_speciation VALUES ('C18H18', 'C18H18', 'Expressed as retene', NULL, 'http://vocabulary.odm2.org/speciation/C18H18');
INSERT INTO cv_speciation VALUES ('CH3Cl', 'CH3Cl', 'Expressed as chloromethane', NULL, 'http://vocabulary.odm2.org/speciation/CH3Cl');
INSERT INTO cv_speciation VALUES ('O2', 'O2', 'Expressed as oxygen (O2)', NULL, 'http://vocabulary.odm2.org/speciation/O2');
INSERT INTO cv_speciation VALUES ('S', 'S', 'Expressed as Sulfur', NULL, 'http://vocabulary.odm2.org/speciation/S');
INSERT INTO cv_speciation VALUES ('C6H5NH2', 'C6H5NH2', 'Expressed as aniline', NULL, 'http://vocabulary.odm2.org/speciation/C6H5NH2');
INSERT INTO cv_speciation VALUES ('C4H8O', 'C4H8O', 'Expressed as butanone', NULL, 'http://vocabulary.odm2.org/speciation/C4H8O');
INSERT INTO cv_speciation VALUES ('C14H12', 'C14H12', 'Expressed as methylfluorene', NULL, 'http://vocabulary.odm2.org/speciation/C14H12');
INSERT INTO cv_speciation VALUES ('Be', 'Be', 'Expressed as beryllium', NULL, 'http://vocabulary.odm2.org/speciation/Be');
INSERT INTO cv_speciation VALUES ('Ba', 'Ba', 'Expressed as barium', NULL, 'http://vocabulary.odm2.org/speciation/Ba');
INSERT INTO cv_speciation VALUES ('C21H44', 'C21H44', 'Expressed as C21 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C21H44');
INSERT INTO cv_speciation VALUES ('unknown', 'Unknown', 'Speciation is unknown', NULL, 'http://vocabulary.odm2.org/speciation/unknown');
INSERT INTO cv_speciation VALUES ('C8H10', 'C8H10', 'Expressed as ethylbenzene', NULL, 'http://vocabulary.odm2.org/speciation/C8H10');
INSERT INTO cv_speciation VALUES ('C2H4Cl2', 'C2H4Cl2', 'Expressed as dichloroethane', NULL, 'http://vocabulary.odm2.org/speciation/C2H4Cl2');
INSERT INTO cv_speciation VALUES ('C22H46', 'C22H46', 'Expressed as C22 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C22H46');
INSERT INTO cv_speciation VALUES ('notApplicable', 'Not Applicable', 'Speciation is not applicable', NULL, 'http://vocabulary.odm2.org/speciation/notApplicable');
INSERT INTO cv_speciation VALUES ('Al', 'Al', 'Expressed as aluminium', NULL, 'http://vocabulary.odm2.org/speciation/Al');
INSERT INTO cv_speciation VALUES ('C16H34', 'C16H34', 'Expressed as C16 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C16H34');
INSERT INTO cv_speciation VALUES ('C10H7CH3', 'C10H7CH3', 'Expressed as methylnaphthalene', NULL, 'http://vocabulary.odm2.org/speciation/C10H7CH3');
INSERT INTO cv_speciation VALUES ('Sr', 'Sr', 'Expressed as strontium', NULL, 'http://vocabulary.odm2.org/speciation/Sr');
INSERT INTO cv_speciation VALUES ('C28H58', 'C28H58', 'Expressed as C28 n-alkane', NULL, 'http://vocabulary.odm2.org/speciation/C28H58');
INSERT INTO cv_speciation VALUES ('C12H8S', 'C12H8S', 'Expressed as dibenzothiophene', NULL, 'http://vocabulary.odm2.org/speciation/C12H8S');


--
-- TOC entry 3381 (class 0 OID 17995)
-- Dependencies: 218
-- Data for Name: cv_specimentype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_specimentype VALUES ('precipitationBulk', 'Precipitation bulk', 'Sample from bulk precipitation', NULL, 'http://vocabulary.odm2.org/specimentype/precipitationBulk');
INSERT INTO cv_specimentype VALUES ('litterFallDigestion', 'Litter fall digestion', 'Sample that consists of a digestion of litter fall', NULL, 'http://vocabulary.odm2.org/specimentype/litterFallDigestion');
INSERT INTO cv_specimentype VALUES ('core', 'Core', 'Long cylindrical cores', NULL, 'http://vocabulary.odm2.org/specimentype/core');
INSERT INTO cv_specimentype VALUES ('forestFloorDigestion', 'Forest floor digestion', 'Sample that consists of a digestion of forest floor material', NULL, 'http://vocabulary.odm2.org/specimentype/forestFloorDigestion');
INSERT INTO cv_specimentype VALUES ('coreSectionHalf', 'Core section half', 'Half-cylindrical products of along-axis split of a section or its component fragments through a selected diameter.', NULL, 'http://vocabulary.odm2.org/specimentype/coreSectionHalf');
INSERT INTO cv_specimentype VALUES ('orientedCore', 'Oriented core', 'Core that can be positioned on the surface in the same way that it was arranged in the borehole before extraction.', NULL, 'http://vocabulary.odm2.org/specimentype/orientedCore');
INSERT INTO cv_specimentype VALUES ('cuttings', 'Cuttings', 'Loose, coarse, unconsolidated material suspended in drilling fluid.', NULL, 'http://vocabulary.odm2.org/specimentype/cuttings');
INSERT INTO cv_specimentype VALUES ('standardReferenceSpecimen', 'Standard reference specimen', 'Standard reference specimen', NULL, 'http://vocabulary.odm2.org/specimentype/standardReferenceSpecimen');
INSERT INTO cv_specimentype VALUES ('other', 'Other', 'Sample does not fit any of the existing type designations. It is expected that further detailed description of the particular sample be provided.', NULL, 'http://vocabulary.odm2.org/specimentype/other');
INSERT INTO cv_specimentype VALUES ('coreHalfRound', 'Core half round', 'Half-cylindrical products of along-axis split of a whole round', NULL, 'http://vocabulary.odm2.org/specimentype/coreHalfRound');
INSERT INTO cv_specimentype VALUES ('terrestrialSection', 'Terrestrial section', 'A sample of a section of the near-surface Earth, generally in the critical zone.', NULL, 'http://vocabulary.odm2.org/specimentype/terrestrialSection');
INSERT INTO cv_specimentype VALUES ('rockPowder', 'Rock powder', 'A sample created from pulverizing a rock to powder.', NULL, 'http://vocabulary.odm2.org/specimentype/rockPowder');
INSERT INTO cv_specimentype VALUES ('individualSample', 'Individual sample', 'A sample that is an individual unit, including rock hand samples, a biological specimen, or a bottle of fluid.', NULL, 'http://vocabulary.odm2.org/specimentype/individualSample');
INSERT INTO cv_specimentype VALUES ('foliageLeaching', 'Foliage leaching', 'Sample that consists of leachate from foliage', NULL, 'http://vocabulary.odm2.org/specimentype/foliageLeaching');
INSERT INTO cv_specimentype VALUES ('corePiece', 'Core piece', 'Material occurring between unambiguous [as curated] breaks in recovery.', NULL, 'http://vocabulary.odm2.org/specimentype/corePiece');
INSERT INTO cv_specimentype VALUES ('coreSub-Piece', 'Core sub-piece', 'Unambiguously mated portion of a larger piece noted for curatorial management of the material.', NULL, 'http://vocabulary.odm2.org/specimentype/coreSub-Piece');
INSERT INTO cv_specimentype VALUES ('automated', 'Automated', 'Sample collected using an automated sampler.', NULL, 'http://vocabulary.odm2.org/specimentype/automated');
INSERT INTO cv_specimentype VALUES ('dredge', 'Dredge', 'A group of rocks collected by dragging a dredge along the seafloor.', NULL, 'http://vocabulary.odm2.org/specimentype/dredge');
INSERT INTO cv_specimentype VALUES ('grab', 'Grab', 'A sample (sometimes mechanically collected) from a deposit or area, not intended to be representative of the deposit or area.', NULL, 'http://vocabulary.odm2.org/specimentype/grab');
INSERT INTO cv_specimentype VALUES ('theSpecimenTypeIsUnknown', 'The specimen type is unknown', 'The specimen type is unknown', NULL, 'http://vocabulary.odm2.org/specimentype/theSpecimenTypeIsUnknown');
INSERT INTO cv_specimentype VALUES ('thinSection', 'Thin section', 'Thin section', NULL, 'http://vocabulary.odm2.org/specimentype/thinSection');
INSERT INTO cv_specimentype VALUES ('coreQuarterRound', 'Core quarter round', 'Quarter-cylindrical products of along-axis split of a half round.', NULL, 'http://vocabulary.odm2.org/specimentype/coreQuarterRound');
INSERT INTO cv_specimentype VALUES ('coreSection', 'Core section', 'Arbitrarily cut segments of a "core"', NULL, 'http://vocabulary.odm2.org/specimentype/coreSection');
INSERT INTO cv_specimentype VALUES ('foliageDigestion', 'Foliage digestion', 'Sample that consists of a digestion of plant foliage', NULL, 'http://vocabulary.odm2.org/specimentype/foliageDigestion');
INSERT INTO cv_specimentype VALUES ('petriDishDryDeposition', 'Petri dish (dry deposition)', 'Sample from dry deposition in a petri dish', NULL, 'http://vocabulary.odm2.org/specimentype/petriDishDryDeposition');
INSERT INTO cv_specimentype VALUES ('coreWholeRound', 'Core whole round', 'Cylindrical segments of core or core section material.', NULL, 'http://vocabulary.odm2.org/specimentype/coreWholeRound');


--
-- TOC entry 3382 (class 0 OID 18001)
-- Dependencies: 219
-- Data for Name: cv_status; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_status VALUES ('planned', 'Planned', 'Data collection is planned. Resulting data values do not yet exist, but will eventually.', NULL, 'http://vocabulary.odm2.org/status/planned');
INSERT INTO cv_status VALUES ('unknown', 'Unknown', 'The status of data collection is unknown.', NULL, 'http://vocabulary.odm2.org/status/unknown');
INSERT INTO cv_status VALUES ('ongoing', 'Ongoing', 'Data collection is ongoing.  New data values will be added periodically.', NULL, 'http://vocabulary.odm2.org/status/ongoing');
INSERT INTO cv_status VALUES ('complete', 'Complete', 'Data collection is complete. No new data values will be added.', NULL, 'http://vocabulary.odm2.org/status/complete');


--
-- TOC entry 3383 (class 0 OID 18007)
-- Dependencies: 220
-- Data for Name: cv_taxonomicclassifiertype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_taxonomicclassifiertype VALUES ('hydrology', 'Hydrology', 'A taxonomy containing terms associated with hydrologic variables or processes.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/hydrology');
INSERT INTO cv_taxonomicclassifiertype VALUES ('soilStructure', 'Soil structure', 'A taxonomy containing terms describing soil structure.', 'Soil', 'http://vocabulary.odm2.org/taxonomicclassifiertype/soilStructure');
INSERT INTO cv_taxonomicclassifiertype VALUES ('soilColor', 'Soil color', 'A taxonomy containing terms describing soil color.', 'Soil', 'http://vocabulary.odm2.org/taxonomicclassifiertype/soilColor');
INSERT INTO cv_taxonomicclassifiertype VALUES ('chemistry', 'Chemistry', 'A taxonomy containing terms associated with chemistry, chemical analysis or processes.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/chemistry');
INSERT INTO cv_taxonomicclassifiertype VALUES ('soilHorizon', 'Soil horizon', 'A taxonomy containing terms describing soil horizons.', 'Soil', 'http://vocabulary.odm2.org/taxonomicclassifiertype/soilHorizon');
INSERT INTO cv_taxonomicclassifiertype VALUES ('soil', 'Soil', 'A taxonomy containing terms associated with soil variables or processes', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/soil');
INSERT INTO cv_taxonomicclassifiertype VALUES ('soilTexture', 'Soil texture', 'A taxonomy containing terms describing soil texture.', 'Soil', 'http://vocabulary.odm2.org/taxonomicclassifiertype/soilTexture');
INSERT INTO cv_taxonomicclassifiertype VALUES ('climate', 'Climate', 'A taxonomy containing terms associated with the climate, weather, or atmospheric processes.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/climate');
INSERT INTO cv_taxonomicclassifiertype VALUES ('instrumentation', 'Instrumentation', 'A taxonomy containing terms associated with instrumentation and instrument properties such as battery voltages, data logger temperatures, often useful for diagnosis.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/instrumentation');
INSERT INTO cv_taxonomicclassifiertype VALUES ('waterQuality', 'Water quality', 'A taxonomy containing terms associated with water quality variables or processes.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/waterQuality');
INSERT INTO cv_taxonomicclassifiertype VALUES ('lithology', 'Lithology', 'A taxonomy containing terms associated with lithology.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/lithology');
INSERT INTO cv_taxonomicclassifiertype VALUES ('geology', 'Geology', 'A taxonomy containing terms associated with geology or geological processes.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/geology');
INSERT INTO cv_taxonomicclassifiertype VALUES ('rock', 'Rock', 'A taxonomy containing terms describing rocks.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/rock');
INSERT INTO cv_taxonomicclassifiertype VALUES ('biology', 'Biology', 'A taxonomy containing terms associated with biological organisms.', NULL, 'http://vocabulary.odm2.org/taxonomicclassifiertype/biology');


--
-- TOC entry 3384 (class 0 OID 18013)
-- Dependencies: 221
-- Data for Name: cv_unitstype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_unitstype VALUES ('radioactivity', 'Radioactivity', 'Activity is the term used to characterise the number of nuclei which disintegrate in a radioactive substance per unit time. Activity is usually measured in Becquerels (Bq), where 1 Bq is 1 disintegration per second.', 'Quantum Mechanics', 'http://vocabulary.odm2.org/unitstype/radioactivity');
INSERT INTO cv_unitstype VALUES ('linearEnergyTransfer', 'Linear energy transfer', 'Linear energy transfer (LET) is a term used in dosimetry. It describes the action of radiation upon matter. It is identical to the retarding force acting on a charged ionizing particle travelling through the matter.  It describes how much energy an ionising particle transfers to the material transversed per unit distance. By definition, LET is a positive quantity. LET depends on the nature of the radiation as well as on the material traversed. [Wikipedia: https://en.wikipedia.org/wiki/Linear_energy_transfer]', 'Atomic Physics', 'http://vocabulary.odm2.org/unitstype/linearEnergyTransfer');
INSERT INTO cv_unitstype VALUES ('linearVelocity', 'Linear velocity', 'Velocity is the rate of change of the position of an object, equivalent to a specification of its speed and direction of motion.Velocity is an important concept in kinematics, the branch of classical mechanics which describes the motion of bodies.Velocity is a vector physical quantity; both magnitude and direction are required to define it. The scalar absolute value (magnitude) of velocity is called "speed", a quantity that is measured in metres per second (m/s or m\xb7s?1) in the SI (metric) system.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/linearVelocity');
INSERT INTO cv_unitstype VALUES ('massFlux', 'Mass flux', 'In physics and engineering, mass flux is the rate of mass flow per unit area, perfectly overlapping with the momentum density, the momentum per unit volume. The common symbols are j, J, q, Q, ?, or ? (Greek lower or capital Phi), sometimes with subscript m to indicate mass is the flowing quantity. Its SI units are kg s?1 m?2. Mass flux can also refer to an alternate form of flux in Fick''s law that includes the molecular mass, or in Darcy''s law that includes the mass density.  [Wikipedia: https://en.wikipedia.org/wiki/Mass_flux]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massFlux');
INSERT INTO cv_unitstype VALUES ('fluidPermeance', 'Fluid permeance', 'Permeance is closely related to permeability, but it refers to the extent of penetration of a specific object with given thickness by a liquid or a gas.  It is the degee to which a materal or membrane transmits another substance.  Units of permeance are volumetric output per unit membrane area per unit trans-membrane pressure. Permeance is also referred to as pressure-normalized flux.', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/fluidPermeance');
INSERT INTO cv_unitstype VALUES ('particleLoading', 'Particle loading', 'The number of particles, organisms, or moles of substance appearing in a given amount of time.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/particleLoading');
INSERT INTO cv_unitstype VALUES ('inverseEnergy', 'Inverse energy', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/inverseEnergy');
INSERT INTO cv_unitstype VALUES ('absorbedDoseRate', 'Absorbed dose rate', 'Absorbed dose per unit time.', 'Radiology', 'http://vocabulary.odm2.org/unitstype/absorbedDoseRate');
INSERT INTO cv_unitstype VALUES ('forcePerLength', 'Force per length', 'The amount of force applied per unit length.  Frequenty used for surface tension.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/forcePerLength');
INSERT INTO cv_unitstype VALUES ('areaThermalExpansion', 'Area thermal expansion', 'When the temperature of a substance changes, the energy that is stored in the intermolecular bonds between atoms changes. When the stored energy increases, so does the length of the molecular bonds. As a result, solids typically expand in response to heating and contract on cooling; this dimensional response to temperature change is expressed by its coefficient of thermal expansion. Different coefficients of thermal expansion can be defined for a substance depending on whether the expansion is measured by: * linear thermal expansion * area thermal expansion * volumetric thermal expansion These characteristics are closely related. The volumetric thermal expansion coefficient can be defined for both liquids and solids. The linear thermal expansion can only be defined for solids, and is common in engineering applications. Some substances expand when cooled, such as freezing water, so they have negative thermal expansion coefficients. [Wikipedia: https://en.wikipedia.org/wiki/Thermal_expansion]', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/areaThermalExpansion');
INSERT INTO cv_unitstype VALUES ('radiance', 'Radiance', 'In radiometry, radiance is the radiant flux emitted, reflected, transmitted or received by a surface, per unit solid angle per unit projected area. Radiance is used to characterize diffuse emission and reflection of electromagnetic radiation, or to quantify emission of neutrinos and other particles. This is a directional quantity. Historically, radiance is called "intensity" and spectral radiance is called "specific intensity". [Wikipedia: https://en.wikipedia.org/wiki/Radiance]', 'Radiology', 'http://vocabulary.odm2.org/unitstype/radiance');
INSERT INTO cv_unitstype VALUES ('powerPerElectricalCharge', 'Power per electrical charge', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/powerPerElectricalCharge');
INSERT INTO cv_unitstype VALUES ('electricalChargeLineDensity', 'Electrical charge line density', 'The linear charge density is the amount of electric charge in a line. It is measured in coulombs per metre (C/m). Since there are positive as well as negative charges, the charge density can take on negative values. [Wikipedia]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalChargeLineDensity');
INSERT INTO cv_unitstype VALUES ('electricalFluxDensity', 'Electrical flux density', 'In physics, the electric flux density (or electric displacement field), denoted by D, is a vector field that appears in Maxwell''s equations. It accounts for the effects of free and bound charge within materials. "D" stands for "displacement", as in the related concept of displacement current in dielectrics. In free space, the electric displacement field is equivalent to flux density, a concept that lends understanding to Gauss''s law.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalFluxDensity');
INSERT INTO cv_unitstype VALUES ('magneticFlux', 'Magnetic flux', 'Magnetic Flux is the product of the average magnetic field times the perpendicular area that it penetrates.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticFlux');
INSERT INTO cv_unitstype VALUES ('luminance', 'Luminance', 'Luminance is a photometric measure of the luminous intensity per unit area of light travelling in a given direction. It describes the amount of light that passes through or is emitted from a particular area, and falls within a given solid angle.', 'Photometry', 'http://vocabulary.odm2.org/unitstype/luminance');
INSERT INTO cv_unitstype VALUES ('energyFlux', 'Energy flux', 'Energy flux is the rate of transfer of energy through a surface. The quantity is defined in two different ways, depending on the context.  In the first context, it is the rate of energy transfer per unit area (SI units: W\xb7m?2 = J\xb7m?2\xb7s?1). This is a vector quantity, its components being determined in terms of the normal (perpendicular) direction to the surface of measurement. This is sometimes called energy flux density, to distinguish it from the second definition. Radiative flux, heat flux, and sound energy flux are specific cases of energy flux density. In the second context, it is the total rate of energy transfer (SI units: W = J\xb7s?1). This is sometimes informally called energy current.', NULL, 'http://vocabulary.odm2.org/unitstype/energyFlux');
INSERT INTO cv_unitstype VALUES ('electricalChargePerMass', 'Electrical charge per mass', 'Unit group for radiation exposure and gyromagnetic ratios', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalChargePerMass');
INSERT INTO cv_unitstype VALUES ('linearThermalExpansion', 'Linear thermal expansion', 'When the temperature of a substance changes, the energy that is stored in the intermolecular bonds between atoms changes. When the stored energy increases, so does the length of the molecular bonds. As a result, solids typically expand in response to heating and contract on cooling; this dimensional response to temperature change is expressed by its coefficient of thermal expansion. Different coefficients of thermal expansion can be defined for a substance depending on whether the expansion is measured by: * linear thermal expansion * area thermal expansion * volumetric thermal expansion These characteristics are closely related. The volumetric thermal expansion coefficient can be defined for both liquids and solids. The linear thermal expansion can only be defined for solids, and is common in engineering applications. Some substances expand when cooled, such as freezing water, so they have negative thermal expansion coefficients. [Wikipedia: https://en.wikipedia.org/wiki/Thermal_expansion]', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/linearThermalExpansion');
INSERT INTO cv_unitstype VALUES ('electricalConductance', 'Electrical conductance', 'Conductance is the reciprocal of resistance and is different from conductivitiy (specific conductance).  Conductance is the ease with which an electric current passes through a conductor.  The SI unit of electrical resistance is the ohm (?), while electrical conductance is measured in siemens (S).  [Wikipedia: https://en.wikipedia.org/wiki/Electrical_resistance_and_conductance]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalConductance');
INSERT INTO cv_unitstype VALUES ('electricalPermittivity', 'Electrical permittivity', 'In electromagnetism, absolute permittivity is the measure of the resistance that is encountered when forming an electric field in a medium. In other words, permittivity is a measure of how an electric field affects, and is affected by, a dielectric medium. The permittivity of a medium describes how much electric field (more correctly, flux) is ''generated'' per unit charge in that medium. More electric flux exists in a medium with a low permittivity (per unit charge) because of polarization effects. Permittivity is directly related to electric susceptibility, which is a measure of how easily a dielectric polarizes in response to an electric field. Thus, permittivity relates to a material''s ability to resist an electric field and "permit" is a misnomer.  In SI units, permittivity ? is measured in farads per meter (F/m)', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalPermittivity');
INSERT INTO cv_unitstype VALUES ('lengthPerMagneticFlux', 'Length per magnetic flux', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/lengthPerMagneticFlux');
INSERT INTO cv_unitstype VALUES ('inverseLength', 'Inverse length', 'The inverse of length - frequently used for absorption or attenuation coefficients and wave numbers.  This can also be used to for extrinsic curvature where the unit ''diopter'' is used.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/inverseLength');
INSERT INTO cv_unitstype VALUES ('frequency', 'Frequency', 'Frequency is the number of occurrences of a repeating event per unit time. The repetition of the events may be periodic (i.e. the length of time between event repetitions is fixed) or aperiodic (i.e. the length of time between event repetitions varies). Therefore, we distinguish between periodic and aperiodic frequencies. In the SI system, periodic frequency is measured in hertz (Hz) or multiples of hertz, while aperiodic frequency is measured in becquerel (Bq).', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/frequency');
INSERT INTO cv_unitstype VALUES ('dataRate', 'Data rate', 'The frequency derived from the period of time required to transmit one bit. This represents the amount of data transferred per second by a communications channel or a computing or storage device. Data rate is measured in units of bits per second (written "b/s" or "bps"), bytes per second (Bps), or baud. When applied to data rate, the multiplier prefixes "kilo-", "mega-", "giga-", etc. (and their abbreviations, "k", "M", "G", etc.) always denote powers of 1000. For example, 64 kbps is 64,000 bits per second. This contrasts with units of storage which use different prefixes to denote multiplication by powers of 1024, e.g. 1 kibibit = 1024 bits.', 'Information', 'http://vocabulary.odm2.org/unitstype/dataRate');
INSERT INTO cv_unitstype VALUES ('magneticFluxPerLength', 'Magnetic flux per length', 'Magnetic Flux Per Unit Length', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticFluxPerLength');
INSERT INTO cv_unitstype VALUES ('force', 'Force', 'Force is an influence that causes mass to accelerate. It may be experienced as a lift, a push, or a pull. Force is defined by Newton''s Second Law as F = m \xb7 a, where F is force, m is mass and a is acceleration. Net force is mathematically equal to the time rate of change of the momentum of the body on which it acts. Since momentum is a vector quantity (has both a magnitude and direction), force also is a vector quantity.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/force');
INSERT INTO cv_unitstype VALUES ('snap', 'Snap', 'In physics, jounce or snap is the fourth derivative of the position vector with respect to time, with the first, second, and third derivatives being velocity, acceleration, and jerk, respectively; hence, the jounce is the rate of change of the jerk with respect to time. [Wikipedia: https://en.wikipedia.org/wiki/Jounce]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/snap');
INSERT INTO cv_unitstype VALUES ('thermalInsulance', 'Thermal insulance', 'The inverse of the heat transfer coefficient.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/thermalInsulance');
INSERT INTO cv_unitstype VALUES ('areaTime', 'Area time', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/areaTime');
INSERT INTO cv_unitstype VALUES ('electricalCharge', 'Electrical charge', 'Electric charge is the physical property of matter that causes it to experience a force when placed in an electromagnetic field. The SI derived unit of electric charge is the coulomb (C), although in electrical engineering it is also common to use the ampere-hour (Ah), and in chemistry it is common to use the elementary charge (e) as a unit. The symbol Q is often used to denote charge. [Wikipedia: https://en.wikipedia.org/wiki/Electric_charge]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalCharge');
INSERT INTO cv_unitstype VALUES ('electricalCurrentPerAngle', 'Electrical current per angle', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalCurrentPerAngle');
INSERT INTO cv_unitstype VALUES ('concentrationCountPerCount', 'Concentration count per count', 'The count of one substance per unit count of another substance, also known as mole fraction or numeric concentration.', 'Dimensionless Ratio', 'http://vocabulary.odm2.org/unitstype/concentrationCountPerCount');
INSERT INTO cv_unitstype VALUES ('heatCapacity', 'Heat capacity', 'Heat capacity, or thermal capacity, is a measurable physical quantity equal to the ratio of the heat added to (or removed from) an object to the resulting temperature change. The SI unit of heat capacity is joule per kelvin and the dimensional form is L2MT?2??1. [Wikipedia: https://en.wikipedia.org/wiki/Heat_capacity]', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/heatCapacity');
INSERT INTO cv_unitstype VALUES ('jerk', 'Jerk', 'In physics, jerk, also known as jolt, surge, or lurch, is the rate of change of acceleration; that is, the derivative of acceleration with respect to time, and as such the second derivative of velocity, or the third derivative of position. [Wikipedia: https://en.wikipedia.org/wiki/Jerk_%28physics%29]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/jerk');
INSERT INTO cv_unitstype VALUES ('areaTimeTemperature', 'Area time temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/areaTimeTemperature');
INSERT INTO cv_unitstype VALUES ('inverseSquareEnergy', 'Inverse square energy', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/inverseSquareEnergy');
INSERT INTO cv_unitstype VALUES ('radiantIntensity', 'Radiant Intensity', 'Radiant flux emitted, reflected, transmitted or received, per unit solid angle. This is a directional quantity. [Wikipedia: https://en.wikipedia.org/wiki/Radiant_intensity]', 'Radiology', 'http://vocabulary.odm2.org/unitstype/radiantIntensity');
INSERT INTO cv_unitstype VALUES ('currency', 'Currency', 'A currency (from Middle English: curraunt, "in circulation", from Latin: currens, -entis) in the most specific use of the word refers to money in any form when in actual use or circulation as a medium of exchange, especially circulating banknotes and coins.  A more general definition is that a currency is a system of money (monetary units) in common use, especially in a nation. [Wikipedia; https://en.wikipedia.org/wiki/Currency]', 'Financial', 'http://vocabulary.odm2.org/unitstype/currency');
INSERT INTO cv_unitstype VALUES ('angularMass', 'Angular mass', 'The units of angular mass have dimensions of mass * area. They are used to measure the moment of inertia or rotational inertia.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/angularMass');
INSERT INTO cv_unitstype VALUES ('angularMomentum', 'Angular momentum', 'Quantity of rotational motion. Linear momentum is the quantity obtained by multiplying the mass of a body by its linear velocity. Angular momentum is the quantity obtained by multiplying the moment of inertia of a body by its angular velocity. The momentum of a system of particles is given by the sum of the momenta of the individual particles which make up the system or by the product of the total mass of the system and the velocity of the center of gravity of the system. The momentum of a continuous medium is given by the integral of the velocity over the mass of the medium or by the product of the total mass of the medium and the velocity of the center of gravity of the medium. In physics, the angular momentum of an object rotating about some reference point is the measure of the extent to which the object will continue to rotate about that point unless acted upon by an external torque. In particular, if a point mass rotates about an axis, then the angular momentum with respect to a point on the axis is related to the mass of the object, the velocity and the distance of the mass to the axis. While the motion associated with linear momentum has no absolute frame of reference, the rotation associated with angular momentum is sometimes spoken of as being measured relative to the fixed stars.  The physical quantity "action" has the same units as angular momentum.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/angularMomentum');
INSERT INTO cv_unitstype VALUES ('molarAngularMomentum', 'Molar angular momentum', 'The angular momentum per mole of substance.  Used for measuring electron orbitals.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/molarAngularMomentum');
INSERT INTO cv_unitstype VALUES ('lengthIntegratedMassConcentration', 'Length integrated mass concentration', 'A mass concentration per unit length.  These units can be used to measure concentration inputs of a chemical along the length of a waterway.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/lengthIntegratedMassConcentration');
INSERT INTO cv_unitstype VALUES ('concentrationCountPerMass', 'Concentration count per mass', 'Amount of substance or a count/number of items per unit mass.  This is most often called molality or molal concentration. This contrasts with the definition of molarity which is based on a specified volume of solution. A commonly used unit for molality used in chemistry is mol/kg. A solution of concentration 1 mol/kg is also sometimes denoted as 1 molal.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/concentrationCountPerMass');
INSERT INTO cv_unitstype VALUES ('inverseTimeTemperature', 'Inverse time temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/inverseTimeTemperature');
INSERT INTO cv_unitstype VALUES ('fluidity', 'Fluidity', 'The reciprocal of viscosity is fluidity, usually symbolized by ?\xa0=\xa01\xa0/\xa0? or F\xa0=\xa01\xa0/\xa0?, depending on the convention used, measured in reciprocal poise (cm\xb7s\xb7g?1), sometimes called the rhe. Fluidity is seldom used in engineering practice. [Wikipedia: https://en.wikipedia.org/wiki/Viscosity]', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/fluidity');
INSERT INTO cv_unitstype VALUES ('polarizability', 'Polarizability', 'Polarizability is the relative tendency of a charge distribution, like the electron cloud of an atom or molecule, to be distorted from its normal shape by an external electric field, which may be caused by the presence of a nearby ion or dipole.  The electronic polarizability ? is defined as the ratio of the induced dipole moment of an atom to the electric field that produces this dipole moment. Polarizability is often a scalar valued quantity, however in the general case it is tensor-valued.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/polarizability');
INSERT INTO cv_unitstype VALUES ('solidAngle', 'Solid angle', 'The solid angle subtended by a surface S is defined as the surface area of a unit sphere covered by the surface S''s projection onto the sphere. A solid angle is related to the surface of a sphere in the same way an ordinary angle is related to the circumference of a circle. Since the total surface area of the unit sphere is 4*pi, the measure of solid angle will always be between 0 and 4*pi.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/solidAngle');
INSERT INTO cv_unitstype VALUES ('energyPerSquareMagneticFluxDensity', 'Energy per square magnetic flux density', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/energyPerSquareMagneticFluxDensity');
INSERT INTO cv_unitstype VALUES ('powerPerArea', 'Power per area', 'A general term for heat flow rate per unit area, power per unit area, irradiance, radient emmitance, and radiosity.  All these terms are sometimes referred to as "intensity."', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/powerPerArea');
INSERT INTO cv_unitstype VALUES ('specificRadioactivity', 'Specific radioactivity', 'Specific activity is the activity per mass quantity of a radionuclide and is a physical property of that radionuclide. [Wikipedia: https://en.wikipedia.org/wiki/Specific_activity]', 'Quantum Mechanics', 'http://vocabulary.odm2.org/unitstype/specificRadioactivity');
INSERT INTO cv_unitstype VALUES ('angularAcceleration', 'Angular acceleration', 'Angular acceleration is the rate of change of angular velocity over time. Measurement of the change made in the rate of change of an angle that a spinning object undergoes per unit time. It is a vector quantity. Also called Rotational acceleration. In SI units, it is measured in radians per second squared (rad/s^2), and is usually denoted by the Greek letter alpha.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/angularAcceleration');
INSERT INTO cv_unitstype VALUES ('illuminance', 'Illuminance', 'Illuminance (also know as luminous emittance or luminous flux per area), is the total luminous flux incident on a surface, per unit area. It is a measure of the intensity of the incident light, wavelength-weighted by the luminosity function to correlate with human brightness perception.', 'Photometry', 'http://vocabulary.odm2.org/unitstype/illuminance');
INSERT INTO cv_unitstype VALUES ('volumetricHeatCapacity', 'Volumetric heat capacity', 'Volumetric heat capacity (VHC), also termed volume-specific heat capacity, describes the ability of a given volume of a substance to store internal energy while undergoing a given temperature change, but without undergoing a phase transition. It is different from specific heat capacity in that the VHC is a ''per unit volume'' measure of the relationship between thermal energy and temperature of a material, while the specific heat is a ''per unit mass'' measure (or occasionally per molar quantity of the material).', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/volumetricHeatCapacity');
INSERT INTO cv_unitstype VALUES ('electricalResistance', 'Electrical resistance', 'Electrical resistance is a ratio of the degree to which an object opposes an electric current through it, measured in ohms. Its reciprocal quantity is electrical conductance measured in siemens.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalResistance');
INSERT INTO cv_unitstype VALUES ('amountOfInformation', 'Amount of Information', 'In computing and telecommunications, a unit of information is the capacity of some standard data storage system or communication channel, used to measure the capacities of other systems and channels. In information theory, units of information are also used to measure the information contents or entropy of random variables.', 'Information', 'http://vocabulary.odm2.org/unitstype/amountOfInformation');
INSERT INTO cv_unitstype VALUES ('molarMass', 'Molar mass', 'In chemistry, the molar mass M is a physical property defined as the mass of a given substance (chemical element or chemical compound) divided by its amount of substance.  The base SI unit for molar mass is kg/mol. However, for historical reasons, molar masses are almost always expressed in g/mol. [Wikipedia: https://en.wikipedia.org/wiki/Molar_mass]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/molarMass');
INSERT INTO cv_unitstype VALUES ('salinity', 'Salinity', 'Salinity is the saltiness or dissolved salt content of a body of water. Salinity is an important factor in determining many aspects of the chemistryof natural waters and of biological processes within it, and is a thermodynamic state variable that, along with temperature and pressure, governs physical characteristics like the density and heat capacity of the water. The use of electrical conductivity measurements to estimate the ionic content of seawater led to the development of the so-called practical salinity scale 1978 (PSS-78). Salinities measured using PSS-78 do not have units. The ''unit'' of PSU (denoting practical salinity unit) is sometimes added to PSS-78 measurements, however this is officially discouraged.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/salinity');
INSERT INTO cv_unitstype VALUES ('temperaturePerTime', 'Temperature per time', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/temperaturePerTime');
INSERT INTO cv_unitstype VALUES ('specificHeatPressure', 'Specific heat pressure', 'Specific heat at a constant pressure.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/specificHeatPressure');
INSERT INTO cv_unitstype VALUES ('powerPerAreaQuarticTemperature', 'Power per area quartic temperature', 'The units of the Stefan-Boltzmann constant.  The Stefan\u2013Boltzmann law states that the total energy radiated per unit surface area of a black body across all wavelengths per unit time (also known as the black-body radiant exitance or emissive power), j*, is directly proportional to the fourth power of the black body''s thermodynamic temperature.  The constant of proportionality ?, called the Stefan\u2013Boltzmann constant or Stefan''s constant, derives from other known constants of nature. The value of the constant is5.670373 x 10^8 Wm^-2K^-4.  [Wikipedia: https://en.wikipedia.org/wiki/Stefan%E2%80%93Boltzmann_constant]', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/powerPerAreaQuarticTemperature');
INSERT INTO cv_unitstype VALUES ('specificVolume', 'Specific volume', 'Specific volume (?) is the volume occupied by a unit of mass of a material. It is equal to the inverse of density.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/specificVolume');
INSERT INTO cv_unitstype VALUES ('electricalDipoleMoment', 'Electrical dipole moment', 'In physics, the electric dipole moment is a measure of the separation of positive and negative electrical charges in a system of electric charges, that is, a measure of the charge system''s overall polarity. The SI units are Coulomb-meter (C m). [Wikipedia: https://en.wikipedia.org/wiki/Electric_dipole_moment]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalDipoleMoment');
INSERT INTO cv_unitstype VALUES ('particleFlux', 'Particle flux', 'The number of particles, organisms, or moles of substance going through a specific area in a given amount of time.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/particleFlux');
INSERT INTO cv_unitstype VALUES ('molarConductivity', 'Molar conductivity', 'Molar conductivity is defined as the conductivity of an electrolyte solution divided by the molar concentration of the electrolyte, and so measures the efficiency with which a given electrolyte conducts electricity in solution. Its units are siemens per meter per molarity, or siemens meter-squared per mole. The usual symbol is a capital lambda, ?, or ?m. Or Molar conductivity of a solution at a given concentration is the conductance of the volume (V) of the solution containing one mole of electrolyte kept between two electrodes with area of cross section (A) and at a distance of unit length. [Wikipedia: https://en.wikipedia.org/wiki/Molar_conductivity]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/molarConductivity');
INSERT INTO cv_unitstype VALUES ('angularVelocityOrFrequency', 'Angular velocity or frequency', 'The change of angle per unit time; specifically, in celestial mechanics, the change in angle of the radius vector per unit time.  Angular frequency is a scalar measure of rotation rate. It is the magnitude of the vector quantity angular velocity.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/angularVelocityOrFrequency');
INSERT INTO cv_unitstype VALUES ('molarHeatCapacity', 'Molar heat capacity', 'The molar heat capacity is the heat capacity per unit amount of a pure substance. [Wikipedia: https://en.wikipedia.org/wiki/Heat_capacity]', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/molarHeatCapacity');
INSERT INTO cv_unitstype VALUES ('electricalResistivity', 'Electrical resistivity', 'Electrical resistivity (also known as resistivity, specific electrical resistance, or volume resistivity) is an intrinsic property that quantifies how strongly a given material opposes the flow of electric current. A low resistivity indicates a material that readily allows the movement of electric charge. Resistivity is commonly represented by the Greek letter ? (rho). The SI unit of electrical resistivity is the ohm?metre (??m)[1][2][3] although other units like ohm?centimetre (??cm) are also in use. [Wikipedia: https://en.wikipedia.org/wiki/Electrical_resistivity_and_conductivity]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalResistivity');
INSERT INTO cv_unitstype VALUES ('thermalResistance', 'Thermal resistance', 'Thermal resistance is a heat property and a measurement of a temperature difference by which an object or material resists a heat flow. Thermal resistance is the reciprocal of thermal conductance. (Absolute) thermal resistance R in K/W is a property of a particular component. For example, a characteristic of a heat sink. Specific thermal resistance or specific thermal resistivity R? in (K\xb7m)/W is a material constant.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/thermalResistance');
INSERT INTO cv_unitstype VALUES ('torque', 'Torque', 'In physics, a torque (?) is a vector that measures the tendency of a force to rotate an object about some axis [1]. The magnitude of a torque is defined as force times its lever arm [2]. Just as a force is a push or a pull, a torque can be thought of as a twist. The SI unit for torque is newton meters (N m). In U.S. customary units, it is measured in foot pounds (ft lbf) (also known as ''pounds feet''). Mathematically, the torque on a particle (which has the position r in some reference frame) can be defined as the cross product: ? = r x F where r is the particle''s position vector relative to the fulcrum F is the force acting on the particles, or, more generally, torque can be defined as the rate of change of angular momentum, ? = dL/dt where L is the angular momentum vector t stands for time.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/torque');
INSERT INTO cv_unitstype VALUES ('luminousFlux', 'Luminous flux', 'Luminous Flux or Luminous Power is the measure of the perceived power of light. It differs from radiant flux, the measure of the total power of light emitted, in that luminous flux is adjusted to reflect the varying sensitivity of the human eye to different wavelengths of light.', 'Photometry', 'http://vocabulary.odm2.org/unitstype/luminousFlux');
INSERT INTO cv_unitstype VALUES ('electricalConductivity', 'Electrical conductivity', 'Electrical conductivity or specific conductance is the reciprocal of electrical resistivity, and measures a material''s ability to conduct an electric current. It is commonly represented by the Greek letter ? (sigma), but ? (kappa) (especially in electrical engineering) or ? (gamma) are also occasionally used. Its SI unit is siemens per metre (S/m) and CGSE unit is reciprocal second (s?1).  [Wikipedia: https://en.wikipedia.org/wiki/Electrical_resistivity_and_conductivity]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalConductivity');
INSERT INTO cv_unitstype VALUES ('mass', 'Mass', 'In physics, mass is a property of a physical body which determines the strength of its mutual gravitational attraction to other bodies, its resistance to being accelerated by a force, and in the theory of relativity gives the mass\u2013energy content of a system. The SI unit of mass is the kilogram (kg).', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/mass');
INSERT INTO cv_unitstype VALUES ('dimensionless', 'Dimensionless', 'Any unit or combination of units that has no dimensions.  A Dimensionless Unit is a quantity for which all the exponents of the factors corresponding to the base quantities in its quantity dimension are zero.', 'Dimensionless', 'http://vocabulary.odm2.org/unitstype/dimensionless');
INSERT INTO cv_unitstype VALUES ('electricalFieldStrength', 'Electrical field strength', 'The strength of the electric field at a given point is defined as the force that would be exerted on a positive test charge of +1 coulomb placed at that point; the direction of the field is given by the direction of that force. Electric fields contain electrical energy with energy density proportional to the square of the field intensity. The electric field is to charge as gravitational acceleration is to mass and force density is to volume.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalFieldStrength');
INSERT INTO cv_unitstype VALUES ('volumeThermalExpansion', 'Volume thermal expansion', 'When the temperature of a substance changes, the energy that is stored in the intermolecular bonds between atoms changes. When the stored energy increases, so does the length of the molecular bonds. As a result, solids typically expand in response to heating and contract on cooling; this dimensional response to temperature change is expressed by its coefficient of thermal expansion. Different coefficients of thermal expansion can be defined for a substance depending on whether the expansion is measured by: * linear thermal expansion * area thermal expansion * volumetric thermal expansion These characteristics are closely related. The volumetric thermal expansion coefficient can be defined for both liquids and solids. The linear thermal expansion can only be defined for solids, and is common in engineering applications. Some substances expand when cooled, such as freezing water, so they have negative thermal expansion coefficients.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/volumeThermalExpansion');
INSERT INTO cv_unitstype VALUES ('massCount', 'Mass count', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massCount');
INSERT INTO cv_unitstype VALUES ('fluorescence', 'Fluorescence', 'Fluorescence is the emission of light by a substance that has absorbed light or other electromagnetic radiation.', 'Dimensionless', 'http://vocabulary.odm2.org/unitstype/fluorescence');
INSERT INTO cv_unitstype VALUES ('massTemperature', 'Mass temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/massTemperature');
INSERT INTO cv_unitstype VALUES ('timeSquared', 'Time squared', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/timeSquared');
INSERT INTO cv_unitstype VALUES ('fluidResistance', 'Fluid resistance', 'In fluid dynamics, drag (sometimes called air resistance, a type of friction, or fluid resistance, another type of friction or fluid friction) refers to forces acting opposite to the relative motion of any object moving with respect to a surrounding fluid. [Wikipedia: https://en.wikipedia.org/wiki/Drag_%28physics%29]', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/fluidResistance');
INSERT INTO cv_unitstype VALUES ('area', 'Area', 'Area is a quantity expressing the two-dimensional size of a defined part of a surface, typically a region bounded by a closed curve.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/area');
INSERT INTO cv_unitstype VALUES ('electricalChargePerCount', 'Electrical charge per count', 'The amount of electrical charge within a given count of something.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalChargePerCount');
INSERT INTO cv_unitstype VALUES ('temperatureCount', 'Temperature count', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/temperatureCount');
INSERT INTO cv_unitstype VALUES ('volumetricFlowRate', 'Volumetric flow rate', 'Volume Per Unit Time, or Volumetric flow rate, is the volume of fluid that passes through a given surface per unit of time (as opposed to a unit surface).', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/volumetricFlowRate');
INSERT INTO cv_unitstype VALUES ('power', 'Power', 'Power is the rate at which work is performed or energy is transmitted, or the amount of energy required or expended for a given unit of time. As a rate of change of work done or the energy of a subsystem, power is: P = W/t where P is power W is work t is time.  Heat flow rate follows identical units to Power', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/power');
INSERT INTO cv_unitstype VALUES ('energyPerArea', 'Energy per area', 'Energy per area density is the amount of energy stored in a given system or region of space per unit area.  Has the same dimensionality as force per unit length.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/energyPerArea');
INSERT INTO cv_unitstype VALUES ('other', 'Other', 'A unit that does not belong in any of the other groups.  These units have dimensionality, but are generally strangely compounded or calculated', 'Dimensionless', 'http://vocabulary.odm2.org/unitstype/other');
INSERT INTO cv_unitstype VALUES ('electricalCurrent', 'Electrical current', 'An electric current is a flow of electric charge. In electric circuits this charge is often carried by moving electrons in a wire. It can also be carried by ions in an electrolyte, or by both ions and electrons such as in a plasma.  The SI unit for measuring an electric current is the ampere, which is the flow of electric charge across a surface at the rate of one coulomb per second. [Wikipedia: https://en.wikipedia.org/wiki/Electric_current]', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/electricalCurrent');
INSERT INTO cv_unitstype VALUES ('linearMomentum', 'Linear momentum', 'In classical mechanics, linear momentum or translational momentum (pl. momenta; SI unit kg m/s, or equivalently, N s) is the product of the mass and velocity of an object.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/linearMomentum');
INSERT INTO cv_unitstype VALUES ('specificEnergy', 'Specific energy', 'Specific energy is energy per unit mass. (It is also sometimes called "energy density," though "energy density" more precisely means energy per unit volume.) The SI unit for specific energy is the joule per kilogram (J/kg). Other units still in use in some contexts are the kilocalorie per gram (Cal/g or kcal/g), mostly in food-related topics, watt hours per kilogram in the field of batteries, and the Imperial unit BTU per pound (BTU/lb), in some engineering and applied technical fields.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/specificEnergy');
INSERT INTO cv_unitstype VALUES ('countPerLength', 'Count per length', 'The length density of a given amount of a substance.  This unit group is also used for image and TV resolutions measured in lines.  This is distinct from "inverse length" in that there is something specific being counted per unit length, that is, the numerator is not dimensionless.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/countPerLength');
INSERT INTO cv_unitstype VALUES ('potentialVorticity', 'Potential vorticity', 'Potential vorticity (PV) is a quantity which is proportional to the dot product of vorticity and stratification that, following a parcel of air or water, can only be changed by diabatic or frictional processes. It is a useful concept for understanding the generation of vorticity in cyclogenesis (the birth and development of a cyclone), especially along the polar front, and in analyzing flow in the ocean. [Wikipedia: https://en.wikipedia.org/wiki/Potential_vorticity]', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/potentialVorticity');
INSERT INTO cv_unitstype VALUES ('inverseCount', 'Inverse count', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/inverseCount');
INSERT INTO cv_unitstype VALUES ('magneticPermeability', 'Magnetic permeability', 'Permeability is the degree of magnetization of a material that responds linearly to an applied magnetic field. In general permeability is a tensor-valued quantity.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticPermeability');
INSERT INTO cv_unitstype VALUES ('massPerArea', 'Mass per area', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massPerArea');
INSERT INTO cv_unitstype VALUES ('catalyticActivity', 'Catalytic activity', 'Catalytic activity is usually denoted by the symbol z and measured in mol/s, a unit which was called katal and defined the SI unit for catalytic activity since 1999. Catalytic activity is not a kind of reaction rate, but a property of the catalyst under certain conditions, in relation to a specific chemical reaction. Catalytic activity of one katal (Symbol 1 kat = 1mol/s) of a catalyst means an amount of that catalyst (substance, in Mol) that leads to a net reaction of one Mol per second of the reactants to the resulting reagents or other outcome which was intended for this chemical reaction. A catalyst may and usually will have different catalytic activity for distinct reactions. [Wikipedia: https://en.wikipedia.org/wiki/Catalysis]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/catalyticActivity');
INSERT INTO cv_unitstype VALUES ('Hyperpolarizability', 'Hyperpolarizability', 'The hyperpolarizability, a nonlinear-optical property of a molecule, is the second-order electric susceptibility per unit volume. [Wikipedia: https://en.wikipedia.org/wiki/Hyperpolarizability]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/Hyperpolarizability');
INSERT INTO cv_unitstype VALUES ('massNormalizedParticleLoading', 'Mass normalized particle loading', 'The number of particles or organisms per unit time per unit mass.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massNormalizedParticleLoading');
INSERT INTO cv_unitstype VALUES ('electricalCurrentPerEnergy', 'Electrical current per energy', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalCurrentPerEnergy');
INSERT INTO cv_unitstype VALUES ('volumetricProductivity', 'Volumetric productivity', 'In ecology, productivity or production refers to the rate of generation of biomass in an ecosystem. It is usually expressed in units of mass per unit surface (or volume) per unit time, for instance grams per square metre per day (g m?2 d?1). The mass unit may relate to dry matter or to the mass of carbon generated. Productivity of autotrophs such as plants is called primary productivity, while that of heterotrophs such as animals is called secondary productivity. [Wikipedia: https://en.wikipedia.org/wiki/Productivity_%28ecology%29]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/volumetricProductivity');
INSERT INTO cv_unitstype VALUES ('pressureOrStress', 'Pressure or stress', 'Pressure is an effect which occurs when a force is applied on a surface. Pressure is the amount of force acting on a unit area. Pressure is distinct from stress, as the former is the ratio of the component of force normal to a surface to the surface area. Stress is a tensor that relates the vector force to the vector area.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/pressureOrStress');
INSERT INTO cv_unitstype VALUES ('doseEquivalent', 'Dose equivalent', 'Equivalent dose or radiation dosage is a dose quantity used in radiological protection to represent the stochastic health effects (probability of cancer induction and genetic damage) of low levels of ionizing radiation on the human body. It is based on the physical quantity absorbed dose, but takes into account the biological effectiveness of the radiation, which is dependent on the radiation type and energy. [Wikipedia: https://en.wikipedia.org/wiki/Absorbed_dose]', 'Radiology', 'http://vocabulary.odm2.org/unitstype/doseEquivalent');
INSERT INTO cv_unitstype VALUES ('stableIsotopeDelta', 'Stable isotope delta', 'For stable isotopes, isotope ratios are typically reported using the delta (?) notation where ? represents the ratio of heavy isotope to light isotope in the sample over the same ratio of a standard reference material, reported using units of in "per mil" (\u2030, parts per thousand) and reported relative to the specific standard reference material.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/stableIsotopeDelta');
INSERT INTO cv_unitstype VALUES ('specificHeatCapacity', 'Specific heat capacity', 'The specific heat capacity, often simply called specific heat, is the heat capacity per unit mass of a material.  It is the amount of heat needed to raise the temperature of a certain mass 1 degree Celsius.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/specificHeatCapacity');
INSERT INTO cv_unitstype VALUES ('radioactivityPerVolume', 'Radioactivity per volume', 'The amount of radioactivity per unit volume', 'Quantum Mechanics', 'http://vocabulary.odm2.org/unitstype/radioactivityPerVolume');
INSERT INTO cv_unitstype VALUES ('diffusivity', 'Diffusivity', 'Used for kinematic viscosity (also known as momentum diffusivity) and thermal diffusivity.  The Kinematic Viscosity of a fluid is the dynamic viscosity divided by the fluid density.  In heat transfer analysis, thermal diffusivity (usually denoted ? but a, ?, and D are also used) is the thermal conductivity divided by density and specific heat capacity at constant pressure. It measures the ability of a material to conduct thermal energy relative to its ability to store thermal energy.', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/diffusivity');
INSERT INTO cv_unitstype VALUES ('massPerLength', 'Mass per length', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/massPerLength');
INSERT INTO cv_unitstype VALUES ('massFraction', 'Mass fraction', 'In chemistry, the mass fraction is the ratio of one substance with mass to the mass of the total mixture , defined asThe sum of all the mass fractions is equal to 1:Mass fraction can also be expressed, with a denominator of 100, as percentage by weight (wt%). It is one way of expressing the composition of a mixture in a dimensionless size; mole fraction (percentage by moles, mol%) and volume fraction (percentage by volume, vol%) are others. For elemental analysis, mass fraction (or "mass percent composition") can also refer to the ratio of the mass of one element to the total mass of a compound. It can be calculated for any compound using its empirical formula. or its chemical formula', 'Dimensionless Ratio', 'http://vocabulary.odm2.org/unitstype/massFraction');
INSERT INTO cv_unitstype VALUES ('electricalCapacitance', 'Electrical capacitance', 'Capacitance is the ability of a body to store an electrical charge.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalCapacitance');
INSERT INTO cv_unitstype VALUES ('time', 'Time', 'Time is a basic component of the measuring system used to sequence events, to compare the durations of events and the intervals between them, and to quantify the motions of objects.', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/time');
INSERT INTO cv_unitstype VALUES ('pH', 'pH', 'In chemistry, pH (/pi??e?t?/) is a numeric scale used to specify the acidity or alkalinity of an aqueous solution. It is the negative of the logarithm to base 10 of the activity of the hydrogen ion. Solutions with a pH less than 7 are acidic and solutions with a pH greater than 7 are alkaline or basic. Pure water is neutral, being neither an acid nor a base. Contrary to popular belief, the pH value can be less than 0 or greater than 14 for very strong acids and bases respectively. [Wikipedia: https://en.wikipedia.org/wiki/PH]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/pH');
INSERT INTO cv_unitstype VALUES ('electricalFlux', 'Electrical flux', 'The Electric Flux through an area is defined as the electric field multiplied by the area of the surface projected in a plane perpendicular to the field. Electric Flux is a scalar-valued quantity.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalFlux');
INSERT INTO cv_unitstype VALUES ('inverseMagneticFlux', 'Inverse magnetic flux', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/inverseMagneticFlux');
INSERT INTO cv_unitstype VALUES ('luminousIntensity', 'Luminous intensity', 'Luminous Intensity is a measure of the wavelength-weighted power emitted by a light source in a particular direction per unit solid angle. The weighting is determined by the luminosity function, a standardized model of the sensitivity of the human eye to different wavelengths.', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/luminousIntensity');
INSERT INTO cv_unitstype VALUES ('thrustToMassRatio', 'Thrust to mass ratio', 'Thrust-to-weight ratio is a dimensionless ratio of thrust to weight of a rocket, jet engine, propeller engine, or a vehicle propelled by such an engine that indicates the performance of the engine or vehicle. [Wikipedia: https://en.wikipedia.org/wiki/Thrust-to-weight_ratio]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/thrustToMassRatio');
INSERT INTO cv_unitstype VALUES ('lengthTemperatureTime', 'Length temperature time', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/lengthTemperatureTime');
INSERT INTO cv_unitstype VALUES ('massPerTime', 'Mass per time', 'In physics and engineering, mass flow rate is the mass of a substance which passes per unit of time. [Wikipedia: https://en.wikipedia.org/wiki/Mass_flow_rate]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/massPerTime');
INSERT INTO cv_unitstype VALUES ('energyPerAreaElectricalCharge', 'Energy per area electrical charge', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/energyPerAreaElectricalCharge');
INSERT INTO cv_unitstype VALUES ('standardGravitationalParameter', 'Standard gravitational parameter', 'In celestial mechanics, the standard gravitational parameter ? of a celestial body is the product of the gravitational constant G and the mass M of the body. [Wikipedia: https://en.wikipedia.org/wiki/Standard_gravitational_parameter]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/standardGravitationalParameter');
INSERT INTO cv_unitstype VALUES ('areaPerLength', 'Area per length', 'A type of Linear Density.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/areaPerLength');
INSERT INTO cv_unitstype VALUES ('lengthFraction', 'Length fraction', 'The ratio or two lengths, often used to measure slope or scale.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/lengthFraction');
INSERT INTO cv_unitstype VALUES ('areaAngle', 'Area angle', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/areaAngle');
INSERT INTO cv_unitstype VALUES ('volumetricFlux', 'Volumetric flux', 'In fluid dynamics, the volumetric flux is the rate of volume flow across a unit area (m3\xb7s?1\xb7m?2). Volumetric flux = liters/(second*area). The density of a particular property in a fluid''s volume, multiplied with the volumetric flux of the fluid, thus defines the advective flux of that property.  The volumetric flux through a porous medium is often modelled using Darcy''s law. Volumetric flux is not to be confused with volumetric flow rate, which is the volume of fluid that passes through a given surface per unit of time (as opposed to a unit surface).  [Wikipedia: https://en.wikipedia.org/wiki/Volumetric_flux] Also used for hydraulic conductivity.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/volumetricFlux');
INSERT INTO cv_unitstype VALUES ('dynamicViscosity', 'Dynamic viscosity', 'The dynamic (shear) viscosity of a fluid expresses its resistance to shearing flows, where adjacent layers move parallel to each other with different speeds. Both the physical unit of dynamic viscosity in SI Poiseuille (Pl) and the cgs units Poise (P) come from Jean L\xe9onard Marie Poiseuille. The poiseuille, which is never used, is equivalent to the pascal-second (Pa\xb7s), or (N\xb7s)/m2, or kg/(m\xb7s).', 'Fluid Mechanics', 'http://vocabulary.odm2.org/unitstype/dynamicViscosity');
INSERT INTO cv_unitstype VALUES ('gravitationalAttraction', 'Gravitational attraction', 'Gravity or gravitation is a natural phenomenon by which all things attract one another including stars, planets, galaxies and even light and sub-atomic particles. Gravity is responsible for the formation of the universe (e.g. creating spheres of hydrogen, igniting them under pressure to form stars and grouping them in to galaxies). Without gravity, the universe would be without thermal energy and composed only of equally spaced particles. On Earth, gravity gives weight to physical objects and causes the tides. Gravity has an infinite range, and it cannot be absorbed, transformed, or shielded against. [Wikipedia: https://en.wikipedia.org/wiki/Gravity]', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/gravitationalAttraction');
INSERT INTO cv_unitstype VALUES ('areaTemperature', 'Area temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/areaTemperature');
INSERT INTO cv_unitstype VALUES ('thermalConductivity', 'Thermal conductivity', 'In physics, thermal conductivity (often denoted k, ?, or ?) is the property of a material to conduct heat. Thermal conductivity of materials is temperature dependent. The reciprocal of thermal conductivity is called thermal resistivity.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/thermalConductivity');
INSERT INTO cv_unitstype VALUES ('concentrationVolumePerVolume', 'Concentration volume per volume', 'The volume of one substance per unit volume of another substance. This is used for volume percents or the ppm of a gas mixture.', 'Dimensionless Ratio', 'http://vocabulary.odm2.org/unitstype/concentrationVolumePerVolume');
INSERT INTO cv_unitstype VALUES ('color', 'Color', 'Units used to describe hue and coloration.', 'Dimensionless', 'http://vocabulary.odm2.org/unitstype/color');
INSERT INTO cv_unitstype VALUES ('luminousEfficacy', 'Luminous efficacy', 'Luminous Efficacy is the ratio of luminous flux (in lumens) to power (usually measured in watts). Depending on context, the power can be either the radiant flux of the source''s output, or it can be the total electric power consumed by the source.', 'Photometry', 'http://vocabulary.odm2.org/unitstype/luminousEfficacy');
INSERT INTO cv_unitstype VALUES ('concentrationCountPerVolume', 'Concentration count per volume', 'Amount of substance or a count/number of items per unit volume. Concentration impliles the amount of one substance/item within another substance.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/concentrationCountPerVolume');
INSERT INTO cv_unitstype VALUES ('inverseLengthTemperature', 'Inverse length temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/inverseLengthTemperature');
INSERT INTO cv_unitstype VALUES ('linearAcceleration', 'Linear acceleration', 'Linear acceleration, in physics, is the rate at which the velocity of an object changes over time. Velocity and acceleration are vector quantities, with magnitude and direction that add according to the parallelogram law. The SI unit for acceleration is the metre per second squared (m/s2).', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/linearAcceleration');
INSERT INTO cv_unitstype VALUES ('level', 'Level', '"Psuedo Units" defined from a log ratio.  This includes any number of units like deciBels where the unit is derived as a log ratio of two other units.  The logarithm distinguishes these from other dimensionless ratios.', 'Dimensionless Ratio', 'http://vocabulary.odm2.org/unitstype/level');
INSERT INTO cv_unitstype VALUES ('inverseVolume', 'Inverse volume', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/inverseVolume');
INSERT INTO cv_unitstype VALUES ('magneticFieldStrength', 'Magnetic field strength', 'The magnetic field strength, H (also called magnetic field intensity, magnetizing field, or magnetic field), characterizes how the true Magnetic Field B influences the organization of magnetic dipoles in a given medium.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticFieldStrength');
INSERT INTO cv_unitstype VALUES ('absorbedDose', 'Absorbed dose', 'Absorbed dose (also known as Total Ionizing Dose, TID) is a measure of the energy deposited in a medium by ionizing radiation. It is equal to the energy deposited per unit mass of medium, and so has the unit J/kg, which is given the special name Gray (Gy). Note that the absorbed dose is not a good indicator of the likely biological effect. 1 Gy of alpha radiation would be much more biologically damaging than 1 Gy of photon radiation for example. Appropriate weighting factors can be applied reflecting the different relative biological effects to find the equivalent dose. The risk of stoctic effects due to radiation exposure can be quantified using the effective dose, which is a weighted average of the equivalent dose to each organ depending upon its radiosensitivity. When ionising radiation is used to treat cancer, the doctor will usually prescribe the radiotherapy treatment in Gy. When risk from ionising radiation is being discussed, a related unit, the Sievert is used.', 'Radiology', 'http://vocabulary.odm2.org/unitstype/absorbedDose');
INSERT INTO cv_unitstype VALUES ('volume', 'Volume', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/volume');
INSERT INTO cv_unitstype VALUES ('temperaturePerMagneticFluxDensity', 'Temperature per magnetic flux density', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/temperaturePerMagneticFluxDensity');
INSERT INTO cv_unitstype VALUES ('turbidity', 'Turbidity', 'Turbidity is the cloudiness or haziness of a fluid, or of air, caused by individual particles (suspended solids) that are generally invisible to the naked eye, similar to smoke in air. Turbidity in open water is often caused by phytoplankton and the measurement of turbidity is a key test of water quality. The higher the turbidity, the higher the risk of the drinkers developing gastrointestinal diseases, especially for immune-compromised people, because contaminants like virus or bacteria can become attached to the suspended solid. The suspended solids interfere with water disinfection with chlorine because the particles act as shields for the virus and bacteria. Similarly suspended solids can protect bacteria from UV sterilisation of water. Fluids can contain suspended solid matter consisting of particles of many different sizes. While some suspended material will be large enough and heavy enough to settle rapidly to the bottom container if a liquid sample is left to stand (the settleable solids), very small particles will settle only very slowly or not at all if the sample is regularly agitated or the particles are colloidal. These small solid particles cause the liquid to appear turbid.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/turbidity');
INSERT INTO cv_unitstype VALUES ('lengthEnergy', 'Length energy', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/lengthEnergy');
INSERT INTO cv_unitstype VALUES ('massPerElectricalCharge', 'Mass per electrical charge', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massPerElectricalCharge');
INSERT INTO cv_unitstype VALUES ('massCountTemperature', 'Mass count temperature', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/massCountTemperature');
INSERT INTO cv_unitstype VALUES ('molarVolume', 'Molar volume', 'The molar volume, symbol Vm, is the volume occupied by one mole of a substance (chemical element or chemical compound) at a given temperature and pressure. It is equal to the molar mass (M) divided by the mass density (?). [Wikipedia: https://en.wikipedia.org/wiki/Molar_volume]', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/molarVolume');
INSERT INTO cv_unitstype VALUES ('countPerArea', 'Count per area', 'The areal density of a given amount of a substance.  This unit group is also used for pixel densities (often incorrectly called resolution).', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/countPerArea');
INSERT INTO cv_unitstype VALUES ('heatTransferCoefficient', 'Heat transfer Coefficient', 'The heat transfer coefficient or film coefficient, in thermodynamics and in mechanics is the proportionality coefficient between the heat flux and the thermodynamic driving force for the flow of heat (i.e., the temperature difference, ?T)', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/heatTransferCoefficient');
INSERT INTO cv_unitstype VALUES ('magnetomotiveForce', 'Magnetomotive force', 'Magnetomotive force is any physical cause that produces magnetic flux. In other words, it is a field of magnetism (measured in tesla) that has area (measured in square meters), so that (Tesla)(Area)= Flux. It is analogous to electromotive force or voltage in electricity. MMF usually describes electric wire coils in a way so scientists can measure or predict the actual force a wire coil can generate. [Wikipedia: https://en.wikipedia.org/wiki/Magnetomotive_force]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magnetomotiveForce');
INSERT INTO cv_unitstype VALUES ('lengthMolarEnergy', 'Length molar energy', NULL, 'Chemistry', 'http://vocabulary.odm2.org/unitstype/lengthMolarEnergy');
INSERT INTO cv_unitstype VALUES ('electricalCurrentDensity', 'Electrical current density', 'Electric current density is a measure of the density of flow of electric charge; it is the electric current per unit area of cross section. Electric current density is a vector-valued quantity.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalCurrentDensity');
INSERT INTO cv_unitstype VALUES ('quarticElectricDipoleMomentPerCubicEnergy', 'Quartic electrical dipole moment per cubic energy', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/quarticElectricDipoleMomentPerCubicEnergy');
INSERT INTO cv_unitstype VALUES ('satelliteResolution', 'Satellite resolution', 'In remote sensing, a satellite''s resolution is defined as the size on the earth of the smallest individual component or dot (called a pixel) from which the image is constituted.  This is also reffered to as the ground sample distance.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/satelliteResolution');
INSERT INTO cv_unitstype VALUES ('count', 'Count', 'Count or amount of substance is a standards-defined quantity that measures the size of an ensemble of elementary entities, such as atoms, molecules, electrons, and other particles. It is a macroscopic property and it is sometimes referred to as chemical amount. The International System of Units (SI) defines the amount of substance to be proportional to the number of elementary entities present. The SI unit for amount of substance is the mole. It has the unit symbol mol.', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/count');
INSERT INTO cv_unitstype VALUES ('lengthTemperature', 'Length temperature', NULL, 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/lengthTemperature');
INSERT INTO cv_unitstype VALUES ('electricalChargeVolumeDensity', 'Electrical charge volume density', 'In electromagnetism, charge density is a measure of electric charge per unit volume of space, in one, two or three dimensions. More specifically: the linear, surface, or volume charge density is the amount of electric charge per unit length, surface area, or volume, respectively. The respective SI units are C\xb7m?1, C\xb7m?2 or C\xb7m?3.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalChargeVolumeDensity');
INSERT INTO cv_unitstype VALUES ('electromotiveForce', 'Electromotive force', 'In physics, electromotive force, or most commonly emf (seldom capitalized), voltage, or (occasionally) electromotance is "that which tends to cause current (actual electrons and ions) to flow.". More formally, emf is the external work expended per unit of charge to produce an electric potential difference across two open-circuited terminals.[2][3] The electric potential difference is created by separating positive and negative charges, thereby generating an electric field.[4][5] The created electrical potential difference drives current flow if a circuit is attached to the source of emf. When current flows, however, the voltage across the terminals of the source of emf is no longer the open-circuit value, due to voltage drops inside the device due to its internal resistance. [Wikipedia: https://en.wikipedia.org/wiki/Electromotive_force]', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electromotiveForce');
INSERT INTO cv_unitstype VALUES ('energyDensity', 'Energy density', 'Energy density is the amount of energy stored in a given system or region of space per unit volume or mass, though the latter is more accurately termed specific energy.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/energyDensity');
INSERT INTO cv_unitstype VALUES ('inversePermittivity', 'Inverse permittivity', NULL, 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/inversePermittivity');
INSERT INTO cv_unitstype VALUES ('magneticFluxDensity', 'Magnetic flux density', 'The Magnetic flux density, B (also called magnetic induction or magnetic field), is a fundamental field in electrodynamics which characterizes the magnetic force exerted by electric currents. It is closely related to the auxillary magnetic field H.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticFluxDensity');
INSERT INTO cv_unitstype VALUES ('specificHeatVolume', 'Specific heat volume', 'Specific heat per constant volume.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/specificHeatVolume');
INSERT INTO cv_unitstype VALUES ('pressureOrStressRate', 'Pressure or stress rate', NULL, 'Space and Time', 'http://vocabulary.odm2.org/unitstype/pressureOrStressRate');
INSERT INTO cv_unitstype VALUES ('concentrationOrDensityMassPerVolume', 'Concentration or density mass per volume', 'The mass of one substance per unit volume of another substance.  These units are commonly used in both density and concentration measurements', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/concentrationOrDensityMassPerVolume');
INSERT INTO cv_unitstype VALUES ('yank', 'Yank', 'Yank is the rate of change of force.', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/yank');
INSERT INTO cv_unitstype VALUES ('energy', 'Energy', 'In physics, energy is a property of objects which can be transferred to other objects or converted into different forms, but cannot be created or destroyed.  Energy, work, and heat all have identical units.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/energy');
INSERT INTO cv_unitstype VALUES ('angle', 'Angle', 'In geometry, an angle (or plane angle) is the figure formed by two rays or line segments, called the sides of the angle, sharing a common endpoint, called the vertex of the angle. Euclid defines a plane angle as the inclination to each other, in a plane, of two lines which meet each other, and do not lie straight with respect to each other.', 'Space and Time', 'http://vocabulary.odm2.org/unitstype/angle');
INSERT INTO cv_unitstype VALUES ('luminousEnergy', 'Luminous Energy', 'In photometry, luminous energy is the perceived energy of light. This is sometimes called the quantity of light. Luminous energy is not the same as radiant energy, the corresponding objective physical quantity. This is because the human eye can only see light in the visible spectrum and has different sensitivities to light of different wavelengths within the spectrum. When adapted for bright conditions (photopic vision), the eye is most sensitive to light at a wavelength of 555\xa0nm. Light with a given amount of radiant energy will have more luminous energy if the wavelength is 555\xa0nm than if the wavelength is longer or shorter. Light whose wavelength is well outside the visible spectrum has a luminous energy of zero, regardless of the amount of radiant energy present.', 'Photometry', 'http://vocabulary.odm2.org/unitstype/luminousEnergy');
INSERT INTO cv_unitstype VALUES ('molarEnergy', 'Molar energy', 'The amount of energy per mole of substance', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/molarEnergy');
INSERT INTO cv_unitstype VALUES ('powerArea', 'Power area', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/powerArea');
INSERT INTO cv_unitstype VALUES ('electricalQuadrupoleMoment', 'Electrical quadrupole moment', 'The Electric Quadrupole Moment is a quantity which describes the effective shape of the ellipsoid of nuclear charge distribution. A non-zero quadrupole moment Q indicates that the charge distribution is not spherically symmetric. By convention, the value of Q is taken to be positive if the ellipsoid is prolate and negative if it is oblate. In general, the electric quadrupole moment is tensor-valued.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/electricalQuadrupoleMoment');
INSERT INTO cv_unitstype VALUES ('temperature', 'Temperature', 'A temperature is a numerical measure of hot and cold. Its measurement is by detection of heat radiation or particle velocity or kinetic energy, or by the bulk behavior of a thermometric material. It may be calibrated in any of various temperature scales, Celsius, Fahrenheit, Kelvin, etc. The fundamental physical definition of temperature is provided by thermodynamics.', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/temperature');
INSERT INTO cv_unitstype VALUES ('specificSurfaceArea', 'Specific surface area', 'Specific surface area "SSA" is a property of solids which is the total surface area of a material per unit of mass. It is a derived scientific value that can be used to determine the type and properties of a material (e.g. soil, snow). It is defined by surface area divided by mass (with units of m\xb2/kg).', 'Mechanics', 'http://vocabulary.odm2.org/unitstype/specificSurfaceArea');
INSERT INTO cv_unitstype VALUES ('thermalResistivity', 'Thermal resistivity', 'The reciprocal of thermal conductivity is thermal resistivity, measured in kelvin-metres per watt (K*m/W). Also called Specific Thermal Resistance.', 'Thermodynamics', 'http://vocabulary.odm2.org/unitstype/thermalResistivity');
INSERT INTO cv_unitstype VALUES ('lengthMass', 'Length mass', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/lengthMass');
INSERT INTO cv_unitstype VALUES ('biologicalActivity', 'Biological activity', 'Units used mainly in chemical and biochemical laboratories.', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/biologicalActivity');
INSERT INTO cv_unitstype VALUES ('magneticDipoleMoment', 'Magnetic dipole moment', 'The magnetic moment of a system is a measure of the magnitude and the direction of its magnetism. Magnetic moment usually refers to its Magnetic Dipole Moment, and quantifies the contribution of the system''s internal magnetism to the external dipolar magnetic field produced by the system (that is, the component of the external magnetic field that is inversely proportional to the cube of the distance to the observer). The Magnetic Dipole Moment is a vector-valued quantity.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/magneticDipoleMoment');
INSERT INTO cv_unitstype VALUES ('length', 'Length', 'In the International System of Quantities, length is any quantity with dimension distance.  [Wikipedia: https://en.wikipedia.org/wiki/Length]', 'Base Quantity', 'http://vocabulary.odm2.org/unitstype/length');
INSERT INTO cv_unitstype VALUES ('powerAreaPerSolidAngle', 'Power area per solid angle', NULL, 'Mechanics', 'http://vocabulary.odm2.org/unitstype/powerAreaPerSolidAngle');
INSERT INTO cv_unitstype VALUES ('concentrationPercentSaturation', 'Concentration percent saturation', 'The amount of a substance dissolved in a solution compared with the amount dissolved in the solution at saturation concentration, expressed as a percent. ', 'Chemistry', 'http://vocabulary.odm2.org/unitstype/concentrationPercentSaturation');
INSERT INTO cv_unitstype VALUES ('inductance', 'Inductance', 'Inductance is an electromagentic quantity that characterizes a circuit''s resistance to any change of electric current; a change in the electric current through induces an opposing electromotive force (EMF). Quantitatively, inductance is proportional to the magnetic flux per unit of electric current.', 'Electricity and Magnetism', 'http://vocabulary.odm2.org/unitstype/inductance');


--
-- TOC entry 3385 (class 0 OID 18019)
-- Dependencies: 222
-- Data for Name: cv_variablename; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_variablename VALUES ('nitrogenDissolvedOrganic', 'Nitrogen, dissolved organic', 'Dissolved Organic Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedOrganic');
INSERT INTO cv_variablename VALUES ('nitrogen_15_StableIsotopeRatioDelta', 'Nitrogen-15, stable isotope ratio delta', 'Difference in the 15N:14N ratio between the sample and standard (del N 15)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogen_15_StableIsotopeRatioDelta');
INSERT INTO cv_variablename VALUES ('butyricAcid', 'Butyric Acid', 'Butyric Acid (C4H8O2)', NULL, 'http://vocabulary.odm2.org/variablename/butyricAcid');
INSERT INTO cv_variablename VALUES ('delta_13COfDIC', 'delta-13C of DIC', 'Isotope 13C of dissolved inorganic carbon (DIC)', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfDIC');
INSERT INTO cv_variablename VALUES ('volumetricWaterContent', 'Volumetric water content', 'Volume of liquid water relative to bulk volume. Used for example to quantify soil moisture', NULL, 'http://vocabulary.odm2.org/variablename/volumetricWaterContent');
INSERT INTO cv_variablename VALUES ('copperParticulate', 'Copper, particulate', 'Particulate copper (Cu) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/copperParticulate');
INSERT INTO cv_variablename VALUES ('squalene', 'Squalene', 'Squalene (C30H50)', NULL, 'http://vocabulary.odm2.org/variablename/squalene');
INSERT INTO cv_variablename VALUES ('Clay', 'Clay', 'USDA particle size distribution category. Less then 0.002 mm diameter fine earth particles. ', NULL, 'http://vocabulary.odm2.org/variablename/Clay');
INSERT INTO cv_variablename VALUES ('flashMemoryErrorCount', 'Flash memory error count', 'A counter which counts the number of  datalogger flash memory errors', NULL, 'http://vocabulary.odm2.org/variablename/flashMemoryErrorCount');
INSERT INTO cv_variablename VALUES ('lacticAcid', 'Lactic Acid', 'Lactic Acid (C3H6O3)', NULL, 'http://vocabulary.odm2.org/variablename/lacticAcid');
INSERT INTO cv_variablename VALUES ('betaGlucosidase', 'Beta-glucosidase', 'Beta-glucosidase catalyzes the hydrolysis of the glycosidic bonds to terminal non-reducing residues in beta-D-glucosides and oligosaccharides, with release of glucose.', 'Chemistry', 'http://vocabulary.odm2.org/variablename/betaGlucosidase');
INSERT INTO cv_variablename VALUES ('hexachloroethane', 'Hexachloroethane', 'Hexachloroethane (C2Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/hexachloroethane');
INSERT INTO cv_variablename VALUES ('antimonyDistributionCoefficient', 'Antimony, distribution coefficient', 'Ratio of concentrations of antimony in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/antimonyDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('methylmercury', 'Methylmercury', 'Methylmercury (CH3Hg)', NULL, 'http://vocabulary.odm2.org/variablename/methylmercury');
INSERT INTO cv_variablename VALUES ('1_4_Dichlorobenzene', '1,4-Dichlorobenzene', '1,4-Dichlorobenzene (C6H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_Dichlorobenzene');
INSERT INTO cv_variablename VALUES ('sensibleHeatFlux', 'Sensible heat flux', 'Sensible Heat Flux', NULL, 'http://vocabulary.odm2.org/variablename/sensibleHeatFlux');
INSERT INTO cv_variablename VALUES ('LSI', 'LSI', 'Langelier Saturation Index is an indicator of the degree of saturation of water with respect to calcium carbonate', NULL, 'http://vocabulary.odm2.org/variablename/LSI');
INSERT INTO cv_variablename VALUES ('1_2_4_Trimethylbenzene', '1,2,4-Trimethylbenzene', '1,2,4-Trimethylbenzene', NULL, 'http://vocabulary.odm2.org/variablename/1_2_4_Trimethylbenzene');
INSERT INTO cv_variablename VALUES ('tetrahydrofuran', 'Tetrahydrofuran', 'Tetrahydrofuran (C4H8O)', NULL, 'http://vocabulary.odm2.org/variablename/tetrahydrofuran');
INSERT INTO cv_variablename VALUES ('DNADamageTailLength', 'DNA damage, tail length', 'In a single cell gel electrophoresis assay (comet assay), tail length is the distance of DNA migration from the body of the nuclear core', NULL, 'http://vocabulary.odm2.org/variablename/DNADamageTailLength');
INSERT INTO cv_variablename VALUES ('windStress', 'Wind stress', 'Drag or trangential force per unit area exerted on a surface by the adjacent layer of moving air', NULL, 'http://vocabulary.odm2.org/variablename/windStress');
INSERT INTO cv_variablename VALUES ('endrinKetone', 'Endrin Ketone', 'Endrin Ketone (C12H9Cl5O)', NULL, 'http://vocabulary.odm2.org/variablename/endrinKetone');
INSERT INTO cv_variablename VALUES ('phorate', 'Phorate', 'Phorate (C7H17O2PS3)', NULL, 'http://vocabulary.odm2.org/variablename/phorate');
INSERT INTO cv_variablename VALUES ('n_Alkane_C15', 'n-alkane, C15', 'C15 alkane, normal (i.e. straight-chain) isomer, common name: n-Pentadecane, formula : C15H32', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C15');
INSERT INTO cv_variablename VALUES ('speedOfSound', 'Speed of sound', 'Speed of sound in the medium sampled', NULL, 'http://vocabulary.odm2.org/variablename/speedOfSound');
INSERT INTO cv_variablename VALUES ('waterLevel', 'Water level', 'Water level relative to datum. The datum may be local or global such as NGVD 1929 and should be specified in the method description for associated data values.', NULL, 'http://vocabulary.odm2.org/variablename/waterLevel');
INSERT INTO cv_variablename VALUES ('1_NaphthalenolMethylcarbamate', '1-Naphthalenol methylcarbamate', '1-Naphthalenol methylcarbamate (C12H11NO2)', NULL, 'http://vocabulary.odm2.org/variablename/1_NaphthalenolMethylcarbamate');
INSERT INTO cv_variablename VALUES ('fluorineDissolved', 'Fluorine, dissolved', 'Dissolved Fluorine (F2)', NULL, 'http://vocabulary.odm2.org/variablename/fluorineDissolved');
INSERT INTO cv_variablename VALUES ('isopentane', 'Isopentane', 'Isopentane', NULL, 'http://vocabulary.odm2.org/variablename/isopentane');
INSERT INTO cv_variablename VALUES ('ethylene', 'Ethylene', 'Ethylene (C2H4)', NULL, 'http://vocabulary.odm2.org/variablename/ethylene');
INSERT INTO cv_variablename VALUES ('BOD5Carbonaceous', 'BOD5, carbonaceous', '5-day Carbonaceous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD5Carbonaceous');
INSERT INTO cv_variablename VALUES ('phosphorusOrthophosphate', 'Phosphorus, orthophosphate', 'Orthophosphate Phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusOrthophosphate');
INSERT INTO cv_variablename VALUES ('indeno_1_2_3_cd_Pyrene', 'Indeno(1,2,3-cd)pyrene', 'Indeno(1,2,3-cd)pyrene (C22H12)', NULL, 'http://vocabulary.odm2.org/variablename/indeno_1_2_3_cd_Pyrene');
INSERT INTO cv_variablename VALUES ('manganeseParticulate', 'Manganese, particulate', 'Particulate manganese (Mn) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/manganeseParticulate');
INSERT INTO cv_variablename VALUES ('terbufos', 'Terbufos', 'Terbufos (C9H21O2PS3)', NULL, 'http://vocabulary.odm2.org/variablename/terbufos');
INSERT INTO cv_variablename VALUES ('waterColumnEquivalentHeightBarometric', 'Water column equivalent height, barometric', 'Barometric pressure expressed as an equivalent height of water over the sensor.', NULL, 'http://vocabulary.odm2.org/variablename/waterColumnEquivalentHeightBarometric');
INSERT INTO cv_variablename VALUES ('rainfallRate', 'Rainfall rate', 'A measure of the intensity of rainfall, calculated as the depth of water to fall over a given time period if the intensity were to remain constant over that time interval (in/hr, mm/hr, etc)', NULL, 'http://vocabulary.odm2.org/variablename/rainfallRate');
INSERT INTO cv_variablename VALUES ('BOD3Carbonaceous', 'BOD3, carbonaceous', '3-day Carbonaceous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD3Carbonaceous');
INSERT INTO cv_variablename VALUES ('methoxychlor', 'Methoxychlor', 'Methoxychlor (C16H15Cl3O2)', NULL, 'http://vocabulary.odm2.org/variablename/methoxychlor');
INSERT INTO cv_variablename VALUES ('strontiumDissolved', 'Strontium, dissolved', 'Dissolved Strontium (Sr)', NULL, 'http://vocabulary.odm2.org/variablename/strontiumDissolved');
INSERT INTO cv_variablename VALUES ('BOD2Carbonaceous', 'BOD2, carbonaceous', '2-day Carbonaceous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD2Carbonaceous');
INSERT INTO cv_variablename VALUES ('porosity', 'Porosity', 'Porosity or void fraction is a measure of the void (i.e. "empty") spaces in a material, and is a fraction of the volume of voids over the total volume, between 0 and 1, or as a percentage between 0 and 100%.', NULL, 'http://vocabulary.odm2.org/variablename/porosity');
INSERT INTO cv_variablename VALUES ('reductionPotential', 'Reduction potential', 'Oxidation-reduction potential', NULL, 'http://vocabulary.odm2.org/variablename/reductionPotential');
INSERT INTO cv_variablename VALUES ('voltage', 'Voltage', 'Voltage or Electrical Potential', NULL, 'http://vocabulary.odm2.org/variablename/voltage');
INSERT INTO cv_variablename VALUES ('hardnessMagnesium', 'Hardness, Magnesium', 'Hardness of magnesium', NULL, 'http://vocabulary.odm2.org/variablename/hardnessMagnesium');
INSERT INTO cv_variablename VALUES ('abundance', 'Abundance', 'The relative representation of a species in a particular ecosystem. If this generic term is used, the publisher should specify/qualify the species, class, etc. being measured in the method, qualifier, or other appropriate field.', NULL, 'http://vocabulary.odm2.org/variablename/abundance');
INSERT INTO cv_variablename VALUES ('tinTotal', 'Tin, total', 'Total tin (Sn)."Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/tinTotal');
INSERT INTO cv_variablename VALUES ('color', 'Color', 'Color in quantified in color units', NULL, 'http://vocabulary.odm2.org/variablename/color');
INSERT INTO cv_variablename VALUES ('chlorophyll_a', 'Chlorophyll a', 'Chlorophyll a', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_a');
INSERT INTO cv_variablename VALUES ('barometricPressure', 'Barometric pressure', 'Barometric pressure', NULL, 'http://vocabulary.odm2.org/variablename/barometricPressure');
INSERT INTO cv_variablename VALUES ('ammoniumFlux', 'Ammonium flux', 'Ammonium (NH4) flux', NULL, 'http://vocabulary.odm2.org/variablename/ammoniumFlux');
INSERT INTO cv_variablename VALUES ('oxygenUptake', 'Oxygen uptake', 'Consumption of oxygen by biological and/or chemical processes', NULL, 'http://vocabulary.odm2.org/variablename/oxygenUptake');
INSERT INTO cv_variablename VALUES ('sulfideDissolved', 'Sulfide, dissolved', 'Dissolved Sulfide', NULL, 'http://vocabulary.odm2.org/variablename/sulfideDissolved');
INSERT INTO cv_variablename VALUES ('3_Nitroaniline', '3-Nitroaniline', '3-Nitroaniline (C6H6N2O2)', NULL, 'http://vocabulary.odm2.org/variablename/3_Nitroaniline');
INSERT INTO cv_variablename VALUES ('suaedaLinearisCoverage', 'Suaeda linearis coverage', 'Areal coverage of the plant Suaeda linearis', NULL, 'http://vocabulary.odm2.org/variablename/suaedaLinearisCoverage');
INSERT INTO cv_variablename VALUES ('sulfurOrganic', 'Sulfur, organic', 'Organic Sulfur', NULL, 'http://vocabulary.odm2.org/variablename/sulfurOrganic');
INSERT INTO cv_variablename VALUES ('reservoirStorage', 'Reservoir storage', 'Reservoir water volume', NULL, 'http://vocabulary.odm2.org/variablename/reservoirStorage');
INSERT INTO cv_variablename VALUES ('sodiumFractionOfCations', 'Sodium, fraction of cations', 'Sodium, fraction of cations', NULL, 'http://vocabulary.odm2.org/variablename/sodiumFractionOfCations');
INSERT INTO cv_variablename VALUES ('2_Nitroaniline', '2-Nitroaniline', '2-Nitroaniline (C6H6N2O2)', NULL, 'http://vocabulary.odm2.org/variablename/2_Nitroaniline');
INSERT INTO cv_variablename VALUES ('organicMatter', 'Organic matter', 'The organic matter component of a complex material.', NULL, 'http://vocabulary.odm2.org/variablename/organicMatter');
INSERT INTO cv_variablename VALUES ('biomassTotal', 'Biomass, total', 'Total biomass', NULL, 'http://vocabulary.odm2.org/variablename/biomassTotal');
INSERT INTO cv_variablename VALUES ('n_Alkane_C29', 'n-alkane, C29', 'C29 alkane, normal (i.e. straight-chain) isomer, common name: n-Nonacosane, formula : C29H60', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C29');
INSERT INTO cv_variablename VALUES ('methanol', 'Methanol', 'Methanol (CH3OH)', NULL, 'http://vocabulary.odm2.org/variablename/methanol');
INSERT INTO cv_variablename VALUES ('nitrogenTotalNitrite', 'Nitrogen, total nitrite', 'Total nitrite (NO2)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenTotalNitrite');
INSERT INTO cv_variablename VALUES ('evaporation', 'Evaporation', 'Evaporation', NULL, 'http://vocabulary.odm2.org/variablename/evaporation');
INSERT INTO cv_variablename VALUES ('n_AlkaneTotal', 'n-alkane, total', 'Total alkane, normal (i.e. straight chain) isomer (isomer range of alkanes measured should be specified)', NULL, 'http://vocabulary.odm2.org/variablename/n_AlkaneTotal');
INSERT INTO cv_variablename VALUES ('temperatureSensor', 'Temperature, sensor', 'Temperature, raw data from sensor', NULL, 'http://vocabulary.odm2.org/variablename/temperatureSensor');
INSERT INTO cv_variablename VALUES ('nitrogenTotalOrganic', 'Nitrogen, total organic', 'Total (dissolved + particulate) organic nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenTotalOrganic');
INSERT INTO cv_variablename VALUES ('phenanthrene', 'Phenanthrene', 'Phenanthrene (C14H10), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/phenanthrene');
INSERT INTO cv_variablename VALUES ('styrene', 'Styrene', 'Styrene (C8H8)', NULL, 'http://vocabulary.odm2.org/variablename/styrene');
INSERT INTO cv_variablename VALUES ('1_3_5_Trimethylbenzene', '1,3,5-Trimethylbenzene', '1,3,5-Trimethylbenzene (C6H3(CH3)3)', NULL, 'http://vocabulary.odm2.org/variablename/1_3_5_Trimethylbenzene');
INSERT INTO cv_variablename VALUES ('tributoxyethylPhosphate', 'Tributoxyethyl phosphate', 'Tributoxyethyl phosphate (C42H87O13P)', NULL, 'http://vocabulary.odm2.org/variablename/tributoxyethylPhosphate');
INSERT INTO cv_variablename VALUES ('leafWetness', 'Leaf wetness', 'The effect of moisture settling on the surface of a leaf as a result of either condensation or rainfall.', NULL, 'http://vocabulary.odm2.org/variablename/leafWetness');
INSERT INTO cv_variablename VALUES ('waterUseDomesticWells', 'Water Use, Domestic wells', 'Water pumped by domestic wells; residents and landowners not using public supply. Nonagriculture wells.', NULL, 'http://vocabulary.odm2.org/variablename/waterUseDomesticWells');
INSERT INTO cv_variablename VALUES ('delta_DOfH2O', 'delta-D of H2O', 'hydrogen isotopes of water', NULL, 'http://vocabulary.odm2.org/variablename/delta_DOfH2O');
INSERT INTO cv_variablename VALUES ('delta_18OOfH2O', 'delta-18O of H2O', 'Isotope 18O of water', NULL, 'http://vocabulary.odm2.org/variablename/delta_18OOfH2O');
INSERT INTO cv_variablename VALUES ('chlorideTotal', 'Chloride, total', 'Total Chloride (Cl-)', NULL, 'http://vocabulary.odm2.org/variablename/chlorideTotal');
INSERT INTO cv_variablename VALUES ('remark', 'Remark', 'Manually added comment field to provide additional information about a particular record.', NULL, 'http://vocabulary.odm2.org/variablename/remark');
INSERT INTO cv_variablename VALUES ('BOD20', 'BOD20', '20-day Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD20');
INSERT INTO cv_variablename VALUES ('nitrogen_15', 'Nitrogen-15', '15 Nitrogen, Delta Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogen_15');
INSERT INTO cv_variablename VALUES ('cyanide', 'Cyanide', 'Cyanide (CN)', NULL, 'http://vocabulary.odm2.org/variablename/cyanide');
INSERT INTO cv_variablename VALUES ('chlorophyll_a_CorrectedForPheophytin', 'Chlorophyll a, corrected for pheophytin', 'Chlorphyll a corrected for pheophytin', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_a_CorrectedForPheophytin');
INSERT INTO cv_variablename VALUES ('radiationTotalIncoming', 'Radiation, total incoming', 'Total amount of incoming radiation from all frequencies', NULL, 'http://vocabulary.odm2.org/variablename/radiationTotalIncoming');
INSERT INTO cv_variablename VALUES ('lithiumDissolved', 'Lithium, dissolved', 'Dissolved Lithium (Li). For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/lithiumDissolved');
INSERT INTO cv_variablename VALUES ('tableOverrunErrorCount', 'Table overrun error count', 'A counter which counts the number of datalogger table overrun errors', NULL, 'http://vocabulary.odm2.org/variablename/tableOverrunErrorCount');
INSERT INTO cv_variablename VALUES ('shannonDiversityIndex', 'Shannon diversity index', 'A diversity index that is based on the number of taxa, and the proportion of individuals in each taxa relative to the entire community, evaluated as entropy. Also known as Shannon-Weaver diversity index, the Shannon-Wiener index, the Shannon index and the Shannon entropy.', NULL, 'http://vocabulary.odm2.org/variablename/shannonDiversityIndex');
INSERT INTO cv_variablename VALUES ('lowBatteryCount', 'Low battery count', 'A counter of the number of times the battery voltage dropped below a minimum threshold', NULL, 'http://vocabulary.odm2.org/variablename/lowBatteryCount');
INSERT INTO cv_variablename VALUES ('cadmiumDissolved', 'Cadmium, dissolved', 'Dissolved Cadmium. For chemical terms, "dissolved" indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/cadmiumDissolved');
INSERT INTO cv_variablename VALUES ('cyclohexane', 'Cyclohexane', 'Cyclohexane (C6H6Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/cyclohexane');
INSERT INTO cv_variablename VALUES ('cadmiumParticulate', 'Cadmium, particulate', 'Particulate cadmium (Cd) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/cadmiumParticulate');
INSERT INTO cv_variablename VALUES ('threshold', 'Threshold', 'A level above or below which an action is performed.', NULL, 'http://vocabulary.odm2.org/variablename/threshold');
INSERT INTO cv_variablename VALUES ('carbonDioxide', 'Carbon dioxide', 'Carbon dioxide', NULL, 'http://vocabulary.odm2.org/variablename/carbonDioxide');
INSERT INTO cv_variablename VALUES ('isophorone', 'Isophorone', 'Isophorone (C9H14O)', NULL, 'http://vocabulary.odm2.org/variablename/isophorone');
INSERT INTO cv_variablename VALUES ('2_Methylnaphthalene', '2-Methylnaphthalene', '2-Methylnaphthalene (C10H7CH3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_Methylnaphthalene');
INSERT INTO cv_variablename VALUES ('heatIndex', 'Heat index', 'The combination effect of heat and humidity on the temperature felt by people.', NULL, 'http://vocabulary.odm2.org/variablename/heatIndex');
INSERT INTO cv_variablename VALUES ('1_2_3_Trimethylbenzene', '1,2,3-Trimethylbenzene', '1,2,3-Trimethylbenzene (C9H12)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_3_Trimethylbenzene');
INSERT INTO cv_variablename VALUES ('programSignature', 'Program signature', 'A unique data recorder program identifier which is useful for knowing when the source code in the data recorder has been modified.', NULL, 'http://vocabulary.odm2.org/variablename/programSignature');
INSERT INTO cv_variablename VALUES ('sulfateDissolved', 'Sulfate, dissolved', 'Dissolved Sulfate (SO4)', NULL, 'http://vocabulary.odm2.org/variablename/sulfateDissolved');
INSERT INTO cv_variablename VALUES ('1_Methylanthracene', '1-Methylanthracene', '1-Methylanthracene (C15H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_Methylanthracene');
INSERT INTO cv_variablename VALUES ('realDielectricConstant', 'Real dielectric constant', 'Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the stored energy within the medium. This is the real portion of the complex dielectric constant.', NULL, 'http://vocabulary.odm2.org/variablename/realDielectricConstant');
INSERT INTO cv_variablename VALUES ('anthracene', 'Anthracene', 'Anthracene (C14H10), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/anthracene');
INSERT INTO cv_variablename VALUES ('batisMaritimaCoverage', 'Batis maritima Coverage', 'Areal coverage of the plant Batis maritima', NULL, 'http://vocabulary.odm2.org/variablename/batisMaritimaCoverage');
INSERT INTO cv_variablename VALUES ('waterContent', 'Water Content', 'Quantity of water contained in a material or organism', NULL, 'http://vocabulary.odm2.org/variablename/waterContent');
INSERT INTO cv_variablename VALUES ('pressureAbsolute', 'Pressure, absolute', 'Pressure', NULL, 'http://vocabulary.odm2.org/variablename/pressureAbsolute');
INSERT INTO cv_variablename VALUES ('2_3_5_Trimethylnaphthalene', '2,3,5-Trimethylnaphthalene', '2,3,5-Trimethylnaphthalene (C13H14), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_3_5_Trimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('radiationIncoming', 'Radiation, incoming', 'Incoming radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncoming');
INSERT INTO cv_variablename VALUES ('oxygenFlux', 'Oxygen flux', 'Oxygen (O2) flux', NULL, 'http://vocabulary.odm2.org/variablename/oxygenFlux');
INSERT INTO cv_variablename VALUES ('helium', 'Helium', 'Helium', NULL, 'http://vocabulary.odm2.org/variablename/helium');
INSERT INTO cv_variablename VALUES ('pentachlorophenol', 'Pentachlorophenol', 'Pentachlorophenol (C6HCl5O)', NULL, 'http://vocabulary.odm2.org/variablename/pentachlorophenol');
INSERT INTO cv_variablename VALUES ('lightAttenuationCoefficient', 'Light attenuation coefficient', 'Light attenuation coefficient', NULL, 'http://vocabulary.odm2.org/variablename/lightAttenuationCoefficient');
INSERT INTO cv_variablename VALUES ('tinDissolved', 'Tin, dissolved', 'Dissolved tin (Sn). "Dissolved " indicates a the measurement was made on a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/tinDissolved');
INSERT INTO cv_variablename VALUES ('waterPotential', 'Water potential', 'Water potential is the potential energy of water relative to pure free water (e.g. deionized water) in reference conditions. It quantifies the tendency of water to move from one area to another due to osmosis, gravity, mechanical pressure, or matrix effects including surface tension.', NULL, 'http://vocabulary.odm2.org/variablename/waterPotential');
INSERT INTO cv_variablename VALUES ('strontiumTotal', 'Strontium, total', 'Total Strontium (Sr)', NULL, 'http://vocabulary.odm2.org/variablename/strontiumTotal');
INSERT INTO cv_variablename VALUES ('9_10_Dimethylanthracene', '9,10-Dimethylanthracene', '9,10-Dimethylanthracene (C16H14), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/9_10_Dimethylanthracene');
INSERT INTO cv_variablename VALUES ('delta_13COfC4H10', 'delta-13C of C4H10', 'Isotope 13C of butane', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfC4H10');
INSERT INTO cv_variablename VALUES ('streptococciFecal', 'Streptococci, fecal', 'Fecal Streptococci', NULL, 'http://vocabulary.odm2.org/variablename/streptococciFecal');
INSERT INTO cv_variablename VALUES ('salicorniaVirginicaCoverage', 'Salicornia virginica coverage', 'Areal coverage of the plant Salicornia virginica', NULL, 'http://vocabulary.odm2.org/variablename/salicorniaVirginicaCoverage');
INSERT INTO cv_variablename VALUES ('ironFerric', 'Iron, ferric', 'Ferric Iron (Fe+3)', NULL, 'http://vocabulary.odm2.org/variablename/ironFerric');
INSERT INTO cv_variablename VALUES ('coliformFecal', 'Coliform, fecal', 'Fecal Coliform', NULL, 'http://vocabulary.odm2.org/variablename/coliformFecal');
INSERT INTO cv_variablename VALUES ('radon_222', 'Radon-222', 'An isotope of radon', NULL, 'http://vocabulary.odm2.org/variablename/radon_222');
INSERT INTO cv_variablename VALUES ('tetramethylnaphthalene', 'Tetramethylnaphthalene', 'Tetramethylnaphthalene (C10H4(CH3)4), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/tetramethylnaphthalene');
INSERT INTO cv_variablename VALUES ('silverDissolved', 'Silver, dissolved', 'Dissolved silver (Ag). For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/silverDissolved');
INSERT INTO cv_variablename VALUES ('electricalConductivity', 'Electrical conductivity', 'Electrical conductivity', NULL, 'http://vocabulary.odm2.org/variablename/electricalConductivity');
INSERT INTO cv_variablename VALUES ('1_Methylnaphthalene', '1-Methylnaphthalene', '1-Methylnaphthalene (C10H7CH3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_Methylnaphthalene');
INSERT INTO cv_variablename VALUES ('indicator', 'Indicator', 'Binary status to indicate the status of an instrument or other piece of equipment.', NULL, 'http://vocabulary.odm2.org/variablename/indicator');
INSERT INTO cv_variablename VALUES ('precipitation', 'Precipitation', 'Precipitation such as rainfall. Should not be confused with settling.', NULL, 'http://vocabulary.odm2.org/variablename/precipitation');
INSERT INTO cv_variablename VALUES ('pressureGauge', 'Pressure, gauge', 'Pressure relative to the local atmospheric or ambient pressure', NULL, 'http://vocabulary.odm2.org/variablename/pressureGauge');
INSERT INTO cv_variablename VALUES ('ethanol', 'Ethanol', 'Ethanol (C2H6O)', NULL, 'http://vocabulary.odm2.org/variablename/ethanol');
INSERT INTO cv_variablename VALUES ('2_Chloronaphthalene', '2-Chloronaphthalene', '2-Chloronaphthalene (C10H7Cl)', NULL, 'http://vocabulary.odm2.org/variablename/2_Chloronaphthalene');
INSERT INTO cv_variablename VALUES ('oxygen', 'Oxygen', 'Oxygen', NULL, 'http://vocabulary.odm2.org/variablename/oxygen');
INSERT INTO cv_variablename VALUES ('phosphorusParticulate', 'Phosphorus, particulate', 'Particulate phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusParticulate');
INSERT INTO cv_variablename VALUES ('piperonylButoxide', 'Piperonyl Butoxide', 'Piperonyl Butoxide (C19H30O5)', NULL, 'http://vocabulary.odm2.org/variablename/piperonylButoxide');
INSERT INTO cv_variablename VALUES ('uranium_234', 'Uranium-234', 'An isotope of uranium in the uranium-238 decay series', NULL, 'http://vocabulary.odm2.org/variablename/uranium_234');
INSERT INTO cv_variablename VALUES ('berylliumTotal', 'Beryllium, total', 'Total Beryllium (Be). For chemical terms, "total" indicates an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/berylliumTotal');
INSERT INTO cv_variablename VALUES ('nitrogenParticulateOrganic', 'Nitrogen, particulate organic', 'Particulate Organic Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenParticulateOrganic');
INSERT INTO cv_variablename VALUES ('4_4_DDE', '4,4-DDE', 'Dichlorodiphenyldichloroethylene (C14H8Cl4)', NULL, 'http://vocabulary.odm2.org/variablename/4_4_DDE');
INSERT INTO cv_variablename VALUES ('dinoseb', 'Dinoseb', 'Dinoseb (C10H12N2O5)', NULL, 'http://vocabulary.odm2.org/variablename/dinoseb');
INSERT INTO cv_variablename VALUES ('n_Alkane_C30', 'n-alkane, C30', 'C30 alkane, normal (i.e. straight-chain) isomer, common name: n-Triacontane, formula : C30H62', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C30');
INSERT INTO cv_variablename VALUES ('nitrogenDissolvedInorganic', 'Nitrogen, dissolved inorganic', 'Dissolved inorganic nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedInorganic');
INSERT INTO cv_variablename VALUES ('aroclor_1016', 'Aroclor-1016', 'Aroclor-1016 (C24H13Cl7), a PCB mixture', NULL, 'http://vocabulary.odm2.org/variablename/aroclor_1016');
INSERT INTO cv_variablename VALUES ('nitrousOxide', 'Nitrous oxide', 'Nitrous oxide (N2O)', NULL, 'http://vocabulary.odm2.org/variablename/nitrousOxide');
INSERT INTO cv_variablename VALUES ('heptachlor', 'Heptachlor', 'Heptachlor (C10H5Cl7)', NULL, 'http://vocabulary.odm2.org/variablename/heptachlor');
INSERT INTO cv_variablename VALUES ('carbonMonoxideDissolved', 'Carbon monoxide, dissolved', 'Dissolved carbon monoxide (CO)', NULL, 'http://vocabulary.odm2.org/variablename/carbonMonoxideDissolved');
INSERT INTO cv_variablename VALUES ('formate', 'Formate', 'Formate', NULL, 'http://vocabulary.odm2.org/variablename/formate');
INSERT INTO cv_variablename VALUES ('liverMass', 'Liver, mass', 'Mass of the sample of liver tissue used for analyses', NULL, 'http://vocabulary.odm2.org/variablename/liverMass');
INSERT INTO cv_variablename VALUES ('silicaDissolved', 'Silica, dissolved', 'Dissolved silica (SiO2)', NULL, 'http://vocabulary.odm2.org/variablename/silicaDissolved');
INSERT INTO cv_variablename VALUES ('zirconiumDissolved', 'Zirconium, dissolved', 'Dissolved Zirconium', NULL, 'http://vocabulary.odm2.org/variablename/zirconiumDissolved');
INSERT INTO cv_variablename VALUES ('sedimentRetainedOnSieve', 'Sediment, retained on sieve', 'The amount of sediment retained on a sieve in a gradation test', NULL, 'http://vocabulary.odm2.org/variablename/sedimentRetainedOnSieve');
INSERT INTO cv_variablename VALUES ('molybdenumTotal', 'Molybdenum, total', 'total Molybdenum (Mo). For chemical terms, total represents an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/molybdenumTotal');
INSERT INTO cv_variablename VALUES ('boronDissolved', 'Boron, dissolved', 'dissolved boron', NULL, 'http://vocabulary.odm2.org/variablename/boronDissolved');
INSERT INTO cv_variablename VALUES ('zirconDissolved', 'Zircon, dissolved', 'Dissolved Zircon (Zr)', NULL, 'http://vocabulary.odm2.org/variablename/zirconDissolved');
INSERT INTO cv_variablename VALUES ('2_4_6_Trichlorophenol', '2,4,6-Trichlorophenol', '2,4,6-Trichlorophenol (TCP) (C6H2Cl3OH)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_6_Trichlorophenol');
INSERT INTO cv_variablename VALUES ('triphenylene', 'Triphenylene', 'Triphenylene (C18H12)', NULL, 'http://vocabulary.odm2.org/variablename/triphenylene');
INSERT INTO cv_variablename VALUES ('phosphorusOrganic', 'Phosphorus, organic', 'Organic Phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusOrganic');
INSERT INTO cv_variablename VALUES ('antimonyTotal', 'Antimony, total', 'Total antimony (Sb). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/antimonyTotal');
INSERT INTO cv_variablename VALUES ('dibenzofuran', 'Dibenzofuran', 'Dibenzofuran (C12H8O)', NULL, 'http://vocabulary.odm2.org/variablename/dibenzofuran');
INSERT INTO cv_variablename VALUES ('acidNeutralizingCapacity', 'Acid neutralizing capacity', 'Acid neutralizing capacity', NULL, 'http://vocabulary.odm2.org/variablename/acidNeutralizingCapacity');
INSERT INTO cv_variablename VALUES ('copperDistributionCoefficient', 'Copper, distribution coefficient', 'Ratio of concentrations of copper in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/copperDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('solidsTotalFixed', 'Solids, total fixed', 'Total Fixed Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsTotalFixed');
INSERT INTO cv_variablename VALUES ('spartinaAlternifloraCoverage', 'Spartina alterniflora coverage', 'Areal coverage of the plant Spartina alterniflora', NULL, 'http://vocabulary.odm2.org/variablename/spartinaAlternifloraCoverage');
INSERT INTO cv_variablename VALUES ('luminousFlux', 'Luminous Flux', 'A measure of the total amount of visible light present', NULL, 'http://vocabulary.odm2.org/variablename/luminousFlux');
INSERT INTO cv_variablename VALUES ('groundwaterDepth', 'Groundwater Depth', 'Groundwater depth is the distance between the water surface and the ground surface at a specific location specified by the site location and offset.', NULL, 'http://vocabulary.odm2.org/variablename/groundwaterDepth');
INSERT INTO cv_variablename VALUES ('argonDissolved', 'Argon, dissolved', 'Dissolved Argon', NULL, 'http://vocabulary.odm2.org/variablename/argonDissolved');
INSERT INTO cv_variablename VALUES ('nitrogenOrganicKjeldahl', 'Nitrogen, organic kjeldahl', 'Organic Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4)) nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenOrganicKjeldahl');
INSERT INTO cv_variablename VALUES ('discharge', 'Discharge', 'Discharge', NULL, 'http://vocabulary.odm2.org/variablename/discharge');
INSERT INTO cv_variablename VALUES ('bodyLength', 'Body length', 'Length of the body of an organism', NULL, 'http://vocabulary.odm2.org/variablename/bodyLength');
INSERT INTO cv_variablename VALUES ('bromineDissolved', 'Bromine, dissolved', 'Dissolved Bromine (Br2)', NULL, 'http://vocabulary.odm2.org/variablename/bromineDissolved');
INSERT INTO cv_variablename VALUES ('BOD5Nitrogenous', 'BOD5, nitrogenous', '5-day Nitrogenous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD5Nitrogenous');
INSERT INTO cv_variablename VALUES ('bis_2_Chloroethoxy_Methane', 'Bis(2-chloroethoxy)methane', 'Bis(2-chloroethoxy)methane (C5H10Cl2O2)', NULL, 'http://vocabulary.odm2.org/variablename/bis_2_Chloroethoxy_Methane');
INSERT INTO cv_variablename VALUES ('radiationIncomingPAR', 'Radiation, incoming PAR', 'Incoming Photosynthetically-Active Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncomingPAR');
INSERT INTO cv_variablename VALUES ('frequencyOfRotation', 'Frequency of Rotation', 'Number of rotations within a time period', NULL, 'http://vocabulary.odm2.org/variablename/frequencyOfRotation');
INSERT INTO cv_variablename VALUES ('phenolicsTotal', 'Phenolics, total', 'Total Phenolics', NULL, 'http://vocabulary.odm2.org/variablename/phenolicsTotal');
INSERT INTO cv_variablename VALUES ('argon', 'Argon', 'Argon', NULL, 'http://vocabulary.odm2.org/variablename/argon');
INSERT INTO cv_variablename VALUES ('iodideDissolved', 'Iodide, dissolved', 'Dissolved Iodide (I-)', NULL, 'http://vocabulary.odm2.org/variablename/iodideDissolved');
INSERT INTO cv_variablename VALUES ('mass', 'Mass', 'Mass is a property of a physical body. It is generally a measure of an object''s resistance to changing its state of motion when a force is applied.', 'Physical Property', 'http://vocabulary.odm2.org/variablename/mass');
INSERT INTO cv_variablename VALUES ('transpiration', 'Transpiration', 'Transpiration', NULL, 'http://vocabulary.odm2.org/variablename/transpiration');
INSERT INTO cv_variablename VALUES ('zooplankton', 'Zooplankton', 'Zooplanktonic organisms, non-specific', NULL, 'http://vocabulary.odm2.org/variablename/zooplankton');
INSERT INTO cv_variablename VALUES ('rheniumTotal', 'Rhenium, total', 'Total Rhenium (Re)', NULL, 'http://vocabulary.odm2.org/variablename/rheniumTotal');
INSERT INTO cv_variablename VALUES ('methylchrysene', 'Methylchrysene', 'Methylchrysene (C19H14)', NULL, 'http://vocabulary.odm2.org/variablename/methylchrysene');
INSERT INTO cv_variablename VALUES ('monanthochloeLittoralisCoverage', 'Monanthochloe littoralis Coverage', 'Areal coverage of the plant Monanthochloe littoralis', NULL, 'http://vocabulary.odm2.org/variablename/monanthochloeLittoralisCoverage');
INSERT INTO cv_variablename VALUES ('phosphorusParticulateOrganic', 'Phosphorus, particulate organic', 'Particulate organic phosphorus in suspension', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusParticulateOrganic');
INSERT INTO cv_variablename VALUES ('1_Ethylnaphthalene', '1-Ethylnaphthalene', '1-Ethylnaphthalene (C10H7C2H5), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_Ethylnaphthalene');
INSERT INTO cv_variablename VALUES ('visibility', 'Visibility', 'Visibility', NULL, 'http://vocabulary.odm2.org/variablename/visibility');
INSERT INTO cv_variablename VALUES ('methaneDissolved', 'Methane, dissolved', 'Dissolved Methane (CH4)', NULL, 'http://vocabulary.odm2.org/variablename/methaneDissolved');
INSERT INTO cv_variablename VALUES ('sulfur', 'Sulfur', 'Sulfur (S)', NULL, 'http://vocabulary.odm2.org/variablename/sulfur');
INSERT INTO cv_variablename VALUES ('carbonDioxideDissolved', 'Carbon Dioxide, dissolved', 'Dissolved Carbon dioxide (CO2)', NULL, 'http://vocabulary.odm2.org/variablename/carbonDioxideDissolved');
INSERT INTO cv_variablename VALUES ('superoxideDismutaseActivity', 'Superoxide dismutase, activity', 'Superoxide dismutase (SOD) activity', NULL, 'http://vocabulary.odm2.org/variablename/superoxideDismutaseActivity');
INSERT INTO cv_variablename VALUES ('waterUseAgriculture', 'Water Use, Agriculture', 'Water pumped for Agriculture', NULL, 'http://vocabulary.odm2.org/variablename/waterUseAgriculture');
INSERT INTO cv_variablename VALUES ('N_Nitrosodi_n_Propylamine', 'N-Nitrosodi-n-propylamine', 'N-Nitrosodi-n-propylamine (C6H14N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosodi_n_Propylamine');
INSERT INTO cv_variablename VALUES ('radiationNetLongwave', 'Radiation, net longwave', 'Net Longwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationNetLongwave');
INSERT INTO cv_variablename VALUES ('waterVaporConcentration', 'Water vapor concentration', 'Water vapor concentration', NULL, 'http://vocabulary.odm2.org/variablename/waterVaporConcentration');
INSERT INTO cv_variablename VALUES ('4_BromophenylphenylEther', '4-Bromophenylphenyl ether', '4-Bromophenylphenyl ether (C12H9BrO)', NULL, 'http://vocabulary.odm2.org/variablename/4_BromophenylphenylEther');
INSERT INTO cv_variablename VALUES ('radiationIncomingUV_A', 'Radiation, incoming UV-A', 'Incoming Ultraviolet A Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncomingUV_A');
INSERT INTO cv_variablename VALUES ('acidityMineralAcidity', 'Acidity, mineral acidity', 'Mineral Acidity', NULL, 'http://vocabulary.odm2.org/variablename/acidityMineralAcidity');
INSERT INTO cv_variablename VALUES ('turbidity', 'Turbidity', 'Turbidity', NULL, 'http://vocabulary.odm2.org/variablename/turbidity');
INSERT INTO cv_variablename VALUES ('1_2_Dichloroethane', '1,2-Dichloroethane', '1,2-Dichloroethane (C2H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dichloroethane');
INSERT INTO cv_variablename VALUES ('n_Alkane_C28', 'n-alkane, C28', 'C28 alkane, normal (i.e. straight-chain) isomer, common name: n-Octacosane, formula : C28H58', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C28');
INSERT INTO cv_variablename VALUES ('permethrin', 'Permethrin', 'Permethrin (C21H20Cl2O3)', NULL, 'http://vocabulary.odm2.org/variablename/permethrin');
INSERT INTO cv_variablename VALUES ('1_5_Dimethylnaphthalene', '1,5-Dimethylnaphthalene', '1,5-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_5_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('nitrogen_NH3', 'Nitrogen, NH3', 'Free Ammonia (NH3)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogen_NH3');
INSERT INTO cv_variablename VALUES ('n_Alkane_C19', 'n-alkane, C19', 'C19 alkane, normal (i.e. straight-chain) isomer, common name: n-Nonadecane, formula : C19H40', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C19');
INSERT INTO cv_variablename VALUES ('intercept', 'Intercept', 'The point at which one of the variables in a function equals 0.', NULL, 'http://vocabulary.odm2.org/variablename/intercept');
INSERT INTO cv_variablename VALUES ('nitrogen_NH4', 'Nitrogen, NH4', 'Ammonium (NH4)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogen_NH4');
INSERT INTO cv_variablename VALUES ('waterDepthAveraged', 'Water depth, averaged', 'Water depth averaged over a channel cross-section or water body.  Averaging method to be specified in methods.', NULL, 'http://vocabulary.odm2.org/variablename/waterDepthAveraged');
INSERT INTO cv_variablename VALUES ('phosphorusDissolved', 'Phosphorus, dissolved', 'Dissolved Phosphorus (P)', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusDissolved');
INSERT INTO cv_variablename VALUES ('cuscutaSppCoverage', 'Cuscuta spp. coverage', 'Areal coverage of the plant Cuscuta spp.', NULL, 'http://vocabulary.odm2.org/variablename/cuscutaSppCoverage');
INSERT INTO cv_variablename VALUES ('electricPower', 'Electric Power', 'Electric Power', NULL, 'http://vocabulary.odm2.org/variablename/electricPower');
INSERT INTO cv_variablename VALUES ('2_4_Dichlorophenol', '2,4-Dichlorophenol', '2,4-Dichlorophenol (C6H4Cl2O)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_Dichlorophenol');
INSERT INTO cv_variablename VALUES ('2_4_Dinitrophenol', '2,4-Dinitrophenol', '2,4-Dinitrophenol (C6H4N2O5)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_Dinitrophenol');
INSERT INTO cv_variablename VALUES ('ironFerrous', 'Iron, ferrous', 'Ferrous Iron (Fe+2)', NULL, 'http://vocabulary.odm2.org/variablename/ironFerrous');
INSERT INTO cv_variablename VALUES ('benthos', 'Benthos', 'Benthic species', NULL, 'http://vocabulary.odm2.org/variablename/benthos');
INSERT INTO cv_variablename VALUES ('glutathione_S_TransferaseDeltaCycleThreshold', 'Glutathione S-transferase, delta cycle threshold', 'Delta cycle threshold for glutathione S-transferase (gst). Cycle threshold is the PCR cycle number at which the fluorescent signal of the gene being amplified crosses the set threshold. Delta cycle threshold for gst is the difference between the cycle threshold (Ct) of gst gene expression and the cycle threshold (Ct) for the gene expression of the reference gene (e.g., beta-actin).', NULL, 'http://vocabulary.odm2.org/variablename/glutathione_S_TransferaseDeltaCycleThreshold');
INSERT INTO cv_variablename VALUES ('solidsFixedSuspended', 'Solids, fixed suspended', 'Fixed Suspended Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsFixedSuspended');
INSERT INTO cv_variablename VALUES ('polycyclicAromaticHydrocarbonParent', 'Polycyclic aromatic hydrocarbon, parent', 'Unsubstituted (i.e., non-alkylated) polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/polycyclicAromaticHydrocarbonParent');
INSERT INTO cv_variablename VALUES ('n_Alkane_C23', 'n-alkane, C23', 'C23 alkane, normal (i.e. straight-chain) isomer, common name: n-Tricosane, formula : C23H48', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C23');
INSERT INTO cv_variablename VALUES ('titanium', 'Titanium', 'Titanium (Ti)', NULL, 'http://vocabulary.odm2.org/variablename/titanium');
INSERT INTO cv_variablename VALUES ('N_Nitrosodiphenylamine', 'N-Nitrosodiphenylamine', 'N-Nitrosodiphenylamine (C12H10N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosodiphenylamine');
INSERT INTO cv_variablename VALUES ('phosphorodithioicAcid', 'Phosphorodithioic acid', 'Phosphorodithioic acid (C10N12N3O3PS2)', NULL, 'http://vocabulary.odm2.org/variablename/phosphorodithioicAcid');
INSERT INTO cv_variablename VALUES ('vaporPressure', 'Vapor pressure', 'The pressure of a vapor in equilibrium with its non-vapor phases', NULL, 'http://vocabulary.odm2.org/variablename/vaporPressure');
INSERT INTO cv_variablename VALUES ('malathion', 'Malathion', 'Butanedioic acid, [(dimethoxyphosphinothioyl)thio]-, diethyl ester (C10H19O6PS2)', NULL, 'http://vocabulary.odm2.org/variablename/malathion');
INSERT INTO cv_variablename VALUES ('carbonDioxideTransducerSignal', 'Carbon dioxide, transducer signal', 'Carbon dioxide (CO2), raw data from sensor', NULL, 'http://vocabulary.odm2.org/variablename/carbonDioxideTransducerSignal');
INSERT INTO cv_variablename VALUES ('carbonTotalSolidPhase', 'Carbon, total solid phase', 'Total solid phase carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonTotalSolidPhase');
INSERT INTO cv_variablename VALUES ('primaryProductivity', 'Primary productivity', 'Primary Productivity', NULL, 'http://vocabulary.odm2.org/variablename/primaryProductivity');
INSERT INTO cv_variablename VALUES ('aroclor_1242', 'Aroclor-1242', 'Aroclor-1242 (C12H6Cl4), a PCB mixture', NULL, 'http://vocabulary.odm2.org/variablename/aroclor_1242');
INSERT INTO cv_variablename VALUES ('1_2_Dichloropropane', '1,2-Dichloropropane', '1,2-Dichloropropane (C3H6Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dichloropropane');
INSERT INTO cv_variablename VALUES ('magnesium', 'Magnesium', 'Magnesium is a chemical element with symbol Mg and atomic number 12. It is a shiny gray solid which bears a close physical resemblance to the other five elements in the second column (Group 2, or alkaline earth metals) of the periodic table: they each have the same electron configuration in their outer electron shell producing a similar crystal structure.', NULL, 'http://vocabulary.odm2.org/variablename/magnesium');
INSERT INTO cv_variablename VALUES ('superoxideDismutaseDeltaCycleThreshold', 'Superoxide dismutase, delta cycle threshold', 'Delta cycle threshold for superoxide dismutase (sod). Cycle threshold is the PCR cycle number at which the fluorescent signal of the gene being amplified crosses the set threshold. Delta cycle threshold for sod is the difference between the cycle threshold (Ct) of sod gene expression and the cycle threshold (Ct) for the gene expression of the reference gene (e.g., beta-actin).', NULL, 'http://vocabulary.odm2.org/variablename/superoxideDismutaseDeltaCycleThreshold');
INSERT INTO cv_variablename VALUES ('n_Alkane_C17', 'n-alkane, C17', 'C17 alkane, normal (i.e. straight-chain) isomer, common name: n-Heptadecane, formula : C17H36', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C17');
INSERT INTO cv_variablename VALUES ('phytoplankton', 'Phytoplankton', 'Measurement of phytoplankton with no differentiation between species', NULL, 'http://vocabulary.odm2.org/variablename/phytoplankton');
INSERT INTO cv_variablename VALUES ('NDVI', 'NDVI', 'Normalized difference vegetation index', NULL, 'http://vocabulary.odm2.org/variablename/NDVI');
INSERT INTO cv_variablename VALUES ('n_Alkane_C32', 'n-alkane, C32', 'C32 alkane, normal (i.e. straight-chain) isomer, common name: n-Dotriacontane, formula : C32H66, Synonym: dicetyl', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C32');
INSERT INTO cv_variablename VALUES ('disulfoton', 'Disulfoton', 'Disulfoton (C8H19O2PS3)', NULL, 'http://vocabulary.odm2.org/variablename/disulfoton');
INSERT INTO cv_variablename VALUES ('ethylTert_ButylEther', 'Ethyl tert-Butyl Ether', 'Ethyl tert-Butyl Ether (C6H14O)', NULL, 'http://vocabulary.odm2.org/variablename/ethylTert_ButylEther');
INSERT INTO cv_variablename VALUES ('d_Limonene', 'd-Limonene', 'd-Limonene (C10H16)', NULL, 'http://vocabulary.odm2.org/variablename/d_Limonene');
INSERT INTO cv_variablename VALUES ('electricEnergy', 'Electric Energy', 'Electric Energy', NULL, 'http://vocabulary.odm2.org/variablename/electricEnergy');
INSERT INTO cv_variablename VALUES ('THSWIndex', 'THSW Index', 'The THSW Index uses temperature, humidity, solar radiation, and wind speed to calculate an apparent temperature.', NULL, 'http://vocabulary.odm2.org/variablename/THSWIndex');
INSERT INTO cv_variablename VALUES ('diallate_CisOrTrans', 'Diallate (cis or trans)', 'Diallate (cis or trans) (C10H17Cl2NOS)', NULL, 'http://vocabulary.odm2.org/variablename/diallate_CisOrTrans');
INSERT INTO cv_variablename VALUES ('mercuryTotal', 'Mercury, total', 'Total Mercury (Hg). For chemical terms, total represents an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/mercuryTotal');
INSERT INTO cv_variablename VALUES ('tertAmylMethylEther', 'Tert-Amyl Methyl Ether', 'Tert-Amyl Methyl Ether (C6H14O)', NULL, 'http://vocabulary.odm2.org/variablename/tertAmylMethylEther');
INSERT INTO cv_variablename VALUES ('bariumDistributionCoefficient', 'Barium, distribution coefficient', 'Ratio of concentrations of barium in two phases in equilibrium with each other. Phases must be specified', NULL, 'http://vocabulary.odm2.org/variablename/bariumDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('biphenyl', 'Biphenyl', 'Biphenyl ((C6H5)2), a polycyclic aromatic hydrocarbon (PAH), also known as diphenyl or phenylbenzene or 1,1''-biphenyl or lemonene', NULL, 'http://vocabulary.odm2.org/variablename/biphenyl');
INSERT INTO cv_variablename VALUES ('uranium', 'Uranium', 'Uranium (U)', NULL, 'http://vocabulary.odm2.org/variablename/uranium');
INSERT INTO cv_variablename VALUES ('delta_13COfC2H6', 'delta-13C of C2H6', 'Isotope 13C of ethane', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfC2H6');
INSERT INTO cv_variablename VALUES ('endrinAldehyde', 'Endrin aldehyde', 'Endrin aldehyde (C12H8Cl6O)', NULL, 'http://vocabulary.odm2.org/variablename/endrinAldehyde');
INSERT INTO cv_variablename VALUES ('relativeHumidity', 'Relative humidity', 'Relative humidity', NULL, 'http://vocabulary.odm2.org/variablename/relativeHumidity');
INSERT INTO cv_variablename VALUES ('DNADamageOliveDailMoment', 'DNA damage, olive tail moment', 'In a single cell gel electrophoresis assay (comet assay), olive tail moment is the product of the percentage of DNA in the tail and the distance between the intesity centroids of the head and tail along the x-axis (Olive, et al., 1990)', NULL, 'http://vocabulary.odm2.org/variablename/DNADamageOliveDailMoment');
INSERT INTO cv_variablename VALUES ('1_Methyldibenzothiophene', '1-Methyldibenzothiophene', '1-Methyldibenzothiophene (C13H10S)', NULL, 'http://vocabulary.odm2.org/variablename/1_Methyldibenzothiophene');
INSERT INTO cv_variablename VALUES ('hardnessCalcium', 'Hardness, Calcium', 'Hardness of calcium', NULL, 'http://vocabulary.odm2.org/variablename/hardnessCalcium');
INSERT INTO cv_variablename VALUES ('solidsVolatileDissolved', 'Solids, volatile dissolved', 'Volatile Dissolved Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsVolatileDissolved');
INSERT INTO cv_variablename VALUES ('solidsVolatileSuspended', 'Solids, volatile suspended', 'Volatile Suspended Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsVolatileSuspended');
INSERT INTO cv_variablename VALUES ('retene', 'Retene', 'Retene (C18H18), a polycyclic aromatic hydrocarbon (PAH), also known as methyl isopropyl phenanthrene or 1-methyl-7-isopropyl phenanthrene', NULL, 'http://vocabulary.odm2.org/variablename/retene');
INSERT INTO cv_variablename VALUES ('phosphorusPolyphosphate', 'Phosphorus, polyphosphate', 'Polyphosphate Phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusPolyphosphate');
INSERT INTO cv_variablename VALUES ('sigma_t', 'Sigma-t', 'Density of seawater calculated with in situ salinity and temperature, but pressure equal to zero, rather than the in situ pressure, and 1000 kg/m^3 is subtracted. Defined as (S,T)-1000 kg m-3, where (S,T) is the density of a sample of seawater at temperature T and salinity S, measured in kg m-3, at standard atmospheric pressure.', NULL, 'http://vocabulary.odm2.org/variablename/sigma_t');
INSERT INTO cv_variablename VALUES ('parathion_Ethyl', 'Parathion-ethyl', 'Parathion-ethyl (C10H14NO5PS)', NULL, 'http://vocabulary.odm2.org/variablename/parathion_Ethyl');
INSERT INTO cv_variablename VALUES ('radium_228', 'Radium-228', 'An isotope of radium in the thorium-232 decay series', NULL, 'http://vocabulary.odm2.org/variablename/radium_228');
INSERT INTO cv_variablename VALUES ('sodiumTotal', 'Sodium, total', 'Total Sodium (Na)', NULL, 'http://vocabulary.odm2.org/variablename/sodiumTotal');
INSERT INTO cv_variablename VALUES ('ethoxyresorufin_O_DeethylaseActivity', 'Ethoxyresorufin O-deethylase, activity', 'Ethoxyresorufin O-deethylase (EROD) activity', NULL, 'http://vocabulary.odm2.org/variablename/ethoxyresorufin_O_DeethylaseActivity');
INSERT INTO cv_variablename VALUES ('n_Alkane_C26', 'n-alkane, C26', 'C26 alkane, normal (i.e. straight-chain) isomer, common name: n-Hexacosane, formula : C26H54, synonyms: cerane, hexeikosane', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C26');
INSERT INTO cv_variablename VALUES ('aluminumDissolved', 'Aluminum, dissolved', 'Dissolved Aluminum (Al)', NULL, 'http://vocabulary.odm2.org/variablename/aluminumDissolved');
INSERT INTO cv_variablename VALUES ('groundHeatFlux', 'Ground heat flux', 'Ground heat flux', NULL, 'http://vocabulary.odm2.org/variablename/groundHeatFlux');
INSERT INTO cv_variablename VALUES ('alkalinityTotal', 'Alkalinity, total', 'Total Alkalinity', NULL, 'http://vocabulary.odm2.org/variablename/alkalinityTotal');
INSERT INTO cv_variablename VALUES ('methylfluoranthene', 'Methylfluoranthene', 'Methylfluoranthene (C17H12)', NULL, 'http://vocabulary.odm2.org/variablename/methylfluoranthene');
INSERT INTO cv_variablename VALUES ('n_Alkane_C25', 'n-alkane, C25', 'C25 alkane, normal (i.e. straight-chain) isomer, common name: n-Pentacosane, formula : C25H52', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C25');
INSERT INTO cv_variablename VALUES ('leadParticulate', 'Lead, particulate', 'Particulate lead (Pb) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/leadParticulate');
INSERT INTO cv_variablename VALUES ('carbonToNitrogenMassRatio', 'Carbon to nitrogen mass ratio', 'Carbon to nitrogen (C:N) mass ratio', NULL, 'http://vocabulary.odm2.org/variablename/carbonToNitrogenMassRatio');
INSERT INTO cv_variablename VALUES ('respirationNet', 'Respiration, net', 'Net respiration', NULL, 'http://vocabulary.odm2.org/variablename/respirationNet');
INSERT INTO cv_variablename VALUES ('fluoranthene', 'Fluoranthene', 'Fluoranthene (C16H10), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/fluoranthene');
INSERT INTO cv_variablename VALUES ('uraniumDissolved', 'Uranium, dissolved', 'Dissolved Uranium. For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/uraniumDissolved');
INSERT INTO cv_variablename VALUES ('biogenicSilica', 'Biogenic silica', 'Hydrated silica (SiO2 nH20)', NULL, 'http://vocabulary.odm2.org/variablename/biogenicSilica');
INSERT INTO cv_variablename VALUES ('phosphorusOrthophosphateTotal', 'Phosphorus, orthophosphate total', 'Total orthophosphate phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusOrthophosphateTotal');
INSERT INTO cv_variablename VALUES ('dataShuttleDetached', 'Data shuttle detached', 'A categorical variable marking the detatchment of a coupler or data shuttle to a logger. This is used for quality control.', NULL, 'http://vocabulary.odm2.org/variablename/dataShuttleDetached');
INSERT INTO cv_variablename VALUES ('hardnessCarbonate', 'Hardness, carbonate', 'Carbonate hardness also known as temporary hardness', NULL, 'http://vocabulary.odm2.org/variablename/hardnessCarbonate');
INSERT INTO cv_variablename VALUES ('nitrogenNitrite_NO2', 'Nitrogen, nitrite (NO2)', 'Nitrite (NO2) Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenNitrite_NO2');
INSERT INTO cv_variablename VALUES ('radiationNet', 'Radiation, net', 'Net Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationNet');
INSERT INTO cv_variablename VALUES ('magnesiumTotal', 'Magnesium, total', 'Total Magnesium (Mg)', NULL, 'http://vocabulary.odm2.org/variablename/magnesiumTotal');
INSERT INTO cv_variablename VALUES ('chromium_VI_Dissolved', 'Chromium (VI), dissolved', 'Dissolved Hexavalent Chromium', NULL, 'http://vocabulary.odm2.org/variablename/chromium_VI_Dissolved');
INSERT INTO cv_variablename VALUES ('oxygenDissolvedPercentOfSaturation', 'Oxygen, dissolved percent of saturation', 'Dissolved oxygen, percent saturation', NULL, 'http://vocabulary.odm2.org/variablename/oxygenDissolvedPercentOfSaturation');
INSERT INTO cv_variablename VALUES ('borrichiaFrutescensCoverage', 'Borrichia frutescens Coverage', 'Areal coverage of the plant Borrichia frutescens', NULL, 'http://vocabulary.odm2.org/variablename/borrichiaFrutescensCoverage');
INSERT INTO cv_variablename VALUES ('waterUseRecreation', 'Water Use, Recreation', 'Recreational water use, for example golf courses.', NULL, 'http://vocabulary.odm2.org/variablename/waterUseRecreation');
INSERT INTO cv_variablename VALUES ('n_Alkane_C27', 'n-alkane, C27', 'C27 alkane, normal (i.e. straight-chain) isomer, common name: n-Heptacosane, formula : C27H56', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C27');
INSERT INTO cv_variablename VALUES ('arsenicDistributionCoefficient', 'Arsenic, distribution coefficient', 'Ratio of concentrations of arsenic in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/arsenicDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('netHeatFlux', 'Net heat flux', 'Outgoing rate of heat energy transfer minus the incoming rate of heat energy transfer through a given area', NULL, 'http://vocabulary.odm2.org/variablename/netHeatFlux');
INSERT INTO cv_variablename VALUES ('2_3_Dimethylnaphthalene', '2,3-Dimethylnaphthalene', '2,3-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_3_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('temperature', 'Temperature', 'Temperature', NULL, 'http://vocabulary.odm2.org/variablename/temperature');
INSERT INTO cv_variablename VALUES ('hosphorusPhosphateFlux', 'Phosphorus, phosphate flux', 'Phosphate (PO4) flux', NULL, 'http://vocabulary.odm2.org/variablename/hosphorusPhosphateFlux');
INSERT INTO cv_variablename VALUES ('taxaCount', 'Taxa count', 'Count of unique taxa. A taxon (plural: taxa) is a group of one (or more) populations of organism(s), which is judged to be a unit.', NULL, 'http://vocabulary.odm2.org/variablename/taxaCount');
INSERT INTO cv_variablename VALUES ('1_Methylphenanthrene', '1-Methylphenanthrene', '1-Methylphenanthrene (C15H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_Methylphenanthrene');
INSERT INTO cv_variablename VALUES ('shannonEvennessIndex', 'Shannon evenness index', 'A dimensionless diversity index, calculated as a ratio of the Shannon diversity index over its maximum. Also known as the Shannon Weaver evenness index', NULL, 'http://vocabulary.odm2.org/variablename/shannonEvennessIndex');
INSERT INTO cv_variablename VALUES ('waterUsePublicSupply', 'Water Use, Public Supply', 'Water supplied by a public utility', NULL, 'http://vocabulary.odm2.org/variablename/waterUsePublicSupply');
INSERT INTO cv_variablename VALUES ('radiationNetPAR', 'Radiation, net PAR', 'Net Photosynthetically-Active Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationNetPAR');
INSERT INTO cv_variablename VALUES ('radiationOutgoingPAR', 'Radiation, outgoing PAR', 'Outgoing Photosynthetically-Active Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationOutgoingPAR');
INSERT INTO cv_variablename VALUES ('bulkDensity', 'Bulk density', 'The mass of many particles of the material divided by the total volume they occupy. The total volume includes particle volume, inter-particle void volume and internal pore volume.', NULL, 'http://vocabulary.odm2.org/variablename/bulkDensity');
INSERT INTO cv_variablename VALUES ('manganese', 'Manganese', 'Manganese is a chemical element with symbol Mn and atomic number 25. It is not found as a free element in nature; it is often found in combination with iron, and in many minerals. Manganese is a metal with important industrial metal alloy uses, particularly in stainless steels.', NULL, 'http://vocabulary.odm2.org/variablename/manganese');
INSERT INTO cv_variablename VALUES ('4_Nitrophenol', '4-Nitrophenol', '4-Nitrophenol (C6H5NO3)', NULL, 'http://vocabulary.odm2.org/variablename/4_Nitrophenol');
INSERT INTO cv_variablename VALUES ('transientSpeciesCoverage', 'Transient species coverage', 'Areal coverage of transient species', NULL, 'http://vocabulary.odm2.org/variablename/transientSpeciesCoverage');
INSERT INTO cv_variablename VALUES ('silica', 'Silica', 'Silica (SiO2)', NULL, 'http://vocabulary.odm2.org/variablename/silica');
INSERT INTO cv_variablename VALUES ('oxygenDissolved', 'Oxygen, dissolved', 'Dissolved oxygen', NULL, 'http://vocabulary.odm2.org/variablename/oxygenDissolved');
INSERT INTO cv_variablename VALUES ('acidityCO2Acidity', 'Acidity, CO2 acidity', 'CO2 acidity', NULL, 'http://vocabulary.odm2.org/variablename/acidityCO2Acidity');
INSERT INTO cv_variablename VALUES ('solidsTotal', 'Solids, total', 'Total Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsTotal');
INSERT INTO cv_variablename VALUES ('chlorobenzene', 'Chlorobenzene', 'Chlorobenzene (C6H5Cl)', NULL, 'http://vocabulary.odm2.org/variablename/chlorobenzene');
INSERT INTO cv_variablename VALUES ('aluminumParticulate', 'Aluminum, particulate', 'Particulate aluminum in suspension', NULL, 'http://vocabulary.odm2.org/variablename/aluminumParticulate');
INSERT INTO cv_variablename VALUES ('fluorine', 'Fluorine', 'Fluorine (F2)', NULL, 'http://vocabulary.odm2.org/variablename/fluorine');
INSERT INTO cv_variablename VALUES ('2_3_4_6_Tetrachlorophenol', '2,3,4,6-Tetrachlorophenol', '2,3,4,6-Tetrachlorophenol (C6H2Cl4O)', NULL, 'http://vocabulary.odm2.org/variablename/2_3_4_6_Tetrachlorophenol');
INSERT INTO cv_variablename VALUES ('ethyleneDissolved', 'Ethylene, dissolved', 'Dissolved ethylene', NULL, 'http://vocabulary.odm2.org/variablename/ethyleneDissolved');
INSERT INTO cv_variablename VALUES ('albedo', 'Albedo', 'The ratio of reflected to incident light.', NULL, 'http://vocabulary.odm2.org/variablename/albedo');
INSERT INTO cv_variablename VALUES ('evapotranspirationPotential', 'Evapotranspiration, potential', 'The amount of water that could be evaporated and transpired if there was sufficient water available.', NULL, 'http://vocabulary.odm2.org/variablename/evapotranspirationPotential');
INSERT INTO cv_variablename VALUES ('tertiaryButylAlcohol', 'Tertiary Butyl Alcohol', 'Tertiary Butyl Alcohol (C4H10O)', NULL, 'http://vocabulary.odm2.org/variablename/tertiaryButylAlcohol');
INSERT INTO cv_variablename VALUES ('cobalt_60', 'Cobalt-60', 'A synthetic radioactive isotope of cobalt with a half-life of 5.27 years.', NULL, 'http://vocabulary.odm2.org/variablename/cobalt_60');
INSERT INTO cv_variablename VALUES ('N_Nitrosomethylethylamine', 'N-Nitrosomethylethylamine', 'N-Nitrosomethylethylamine (C3H8N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosomethylethylamine');
INSERT INTO cv_variablename VALUES ('nickelDissolved', 'Nickel, dissolved', 'Dissolved Nickel (Ni)', NULL, 'http://vocabulary.odm2.org/variablename/nickelDissolved');
INSERT INTO cv_variablename VALUES ('adamantane', 'Adamantane', 'Adamantane (C10H16)', NULL, 'http://vocabulary.odm2.org/variablename/adamantane');
INSERT INTO cv_variablename VALUES ('hardnessNonCarbonate', 'Hardness, non-carbonate', 'Non-carbonate hardness', NULL, 'http://vocabulary.odm2.org/variablename/hardnessNonCarbonate');
INSERT INTO cv_variablename VALUES ('2_4_Dimethylphenol', '2,4-Dimethylphenol', '2,4-Dimethylphenol (C8H10O)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_Dimethylphenol');
INSERT INTO cv_variablename VALUES ('alphaNAcetylglucosaminidase', 'Alpha-N-Acetylglucosaminidase', 'An enzyme with system name alpha-N-acetyl-D-glucosaminide N-acetylglucosaminohydrolase.[1][2][3][4] This enzyme catalyses the following chemical reaction: Hydrolysis of terminal non-reducing N-acetyl-D-glucosamine residues in N-acetyl-alpha-D-glucosaminides.', 'Chemistry', 'http://vocabulary.odm2.org/variablename/alphaNAcetylglucosaminidase');
INSERT INTO cv_variablename VALUES ('acidityHot', 'Acidity, hot', 'Hot Acidity', NULL, 'http://vocabulary.odm2.org/variablename/acidityHot');
INSERT INTO cv_variablename VALUES ('4_4_DDT', '4,4-DDT', 'Dichlorodiphenyltrichloroethane (C14H9Cl5)', NULL, 'http://vocabulary.odm2.org/variablename/4_4_DDT');
INSERT INTO cv_variablename VALUES ('fishDetections', 'Fish detections', 'The number of fish identified by the detection equipment', NULL, 'http://vocabulary.odm2.org/variablename/fishDetections');
INSERT INTO cv_variablename VALUES ('ironTotal', 'Iron, total', 'Total Iron (Fe)', NULL, 'http://vocabulary.odm2.org/variablename/ironTotal');
INSERT INTO cv_variablename VALUES ('limoniumNashiiCoverage', 'Limonium nashii Coverage', 'Areal coverage of the plant Limonium nashii', NULL, 'http://vocabulary.odm2.org/variablename/limoniumNashiiCoverage');
INSERT INTO cv_variablename VALUES ('velocity', 'Velocity', 'The velocity of a substance, fluid or object', NULL, 'http://vocabulary.odm2.org/variablename/velocity');
INSERT INTO cv_variablename VALUES ('endrin', 'Endrin', 'Endrin (C12H8Cl6O)', NULL, 'http://vocabulary.odm2.org/variablename/endrin');
INSERT INTO cv_variablename VALUES ('isobutyricAcid', 'Isobutyric acid', 'Isobutyric acid (C4H8O2)', NULL, 'http://vocabulary.odm2.org/variablename/isobutyricAcid');
INSERT INTO cv_variablename VALUES ('benzo_g_h_i_perylene', 'Benzo(g,h,i)perylene', 'Benzo(g,h,i)perylene (C22H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_g_h_i_perylene');
INSERT INTO cv_variablename VALUES ('peridinin', 'Peridinin', 'The phytoplankton pigment Peridinin', NULL, 'http://vocabulary.odm2.org/variablename/peridinin');
INSERT INTO cv_variablename VALUES ('1_1_Dichloroethane', '1,1-Dichloroethane', '1,1-Dichloroethane (C2H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_1_Dichloroethane');
INSERT INTO cv_variablename VALUES ('3_3_Dichlorobenzidine', '3,3-Dichlorobenzidine', '3,3-Dichlorobenzidine (C12H10Cl2N2)', NULL, 'http://vocabulary.odm2.org/variablename/3_3_Dichlorobenzidine');
INSERT INTO cv_variablename VALUES ('butane', 'Butane', 'Butane', NULL, 'http://vocabulary.odm2.org/variablename/butane');
INSERT INTO cv_variablename VALUES ('waterVaporDensity', 'Water vapor density', 'Water vapor density', NULL, 'http://vocabulary.odm2.org/variablename/waterVaporDensity');
INSERT INTO cv_variablename VALUES ('thorium', 'Thorium', 'Thorium (Th)', NULL, 'http://vocabulary.odm2.org/variablename/thorium');
INSERT INTO cv_variablename VALUES ('di_n_OctylPhthalate', 'Di-n-octyl phthalate', 'Di-n-octyl phthalate (C24H38O4)', NULL, 'http://vocabulary.odm2.org/variablename/di_n_OctylPhthalate');
INSERT INTO cv_variablename VALUES ('wellFlowRate', 'Well flow rate', 'Flow rate from well while pumping', NULL, 'http://vocabulary.odm2.org/variablename/wellFlowRate');
INSERT INTO cv_variablename VALUES ('BOD4Carbonaceous', 'BOD4, carbonaceous', '4-day Carbonaceous Biological Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD4Carbonaceous');
INSERT INTO cv_variablename VALUES ('cryptophytes', 'Cryptophytes', 'The chlorophyll a concentration contributed by cryptophytes', NULL, 'http://vocabulary.odm2.org/variablename/cryptophytes');
INSERT INTO cv_variablename VALUES ('1_2_Diphenylhydrazine', '1,2-Diphenylhydrazine', '1,2-Diphenylhydrazine (C12H12N2)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Diphenylhydrazine');
INSERT INTO cv_variablename VALUES ('methyleneBlueActiveSubstances', 'Methylene blue active substances', 'Methylene Blue Active Substances (MBAS)', NULL, 'http://vocabulary.odm2.org/variablename/methyleneBlueActiveSubstances');
INSERT INTO cv_variablename VALUES ('nickelParticulate', 'Nickel, particulate', 'Particulate nickel (Ni) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/nickelParticulate');
INSERT INTO cv_variablename VALUES ('windGustSpeed', 'Wind gust speed', 'Speed of gusts of wind', NULL, 'http://vocabulary.odm2.org/variablename/windGustSpeed');
INSERT INTO cv_variablename VALUES ('latentHeatFlux', 'Latent heat flux', 'Latent Heat Flux', NULL, 'http://vocabulary.odm2.org/variablename/latentHeatFlux');
INSERT INTO cv_variablename VALUES ('acenaphthene', 'Acenaphthene', 'Acenaphthene (C12H10)', NULL, 'http://vocabulary.odm2.org/variablename/acenaphthene');
INSERT INTO cv_variablename VALUES ('windRun', 'Wind Run', 'The length of flow of air past a point over a time interval. Windspeed times the interval of time.', NULL, 'http://vocabulary.odm2.org/variablename/windRun');
INSERT INTO cv_variablename VALUES ('acidPhosphatase', 'Acid phosphatase', 'Phosphatase enzymes are used by soil microorganisms to access organically bound phosphate nutrients. An assay on the rates of activity of these enzymes may be used to ascertain biological demand for phosphates in the soil. Some plant roots, especially cluster roots, exude carboxylates that perform acid phosphatase activity, helping to mobilise phosphorus in nutrient-deficient soils.', 'Chemistry', 'http://vocabulary.odm2.org/variablename/acidPhosphatase');
INSERT INTO cv_variablename VALUES ('cellobiohydrolase', 'Cellobiohydrolase', 'Exocellulases or cellobiohydrolases cleave two to four units from the ends of the exposed chains produced by endocellulase, resulting in tetrasaccharides or disaccharides, such as cellobiose. Exocellulases are further classified into type I, that work processively from the reducing end of the cellulose chain, and type II, that work processively from the nonreducing end.', 'Chemistry', 'http://vocabulary.odm2.org/variablename/cellobiohydrolase');
INSERT INTO cv_variablename VALUES ('thalliumDistributionCoefficient', 'Thallium, distribution coefficient', 'Ratio of concentrations of thallium in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/thalliumDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('BOD1', 'BOD1', '1-day Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD1');
INSERT INTO cv_variablename VALUES ('loggerStopped', 'Logger stopped', 'A categorical variable indicating that a logger was told to stop recording data. This is used for quality control.', NULL, 'http://vocabulary.odm2.org/variablename/loggerStopped');
INSERT INTO cv_variablename VALUES ('copperTotal', 'Copper, total', 'Total copper (Cu). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/copperTotal');
INSERT INTO cv_variablename VALUES ('radiationIncomingLongwave', 'Radiation, incoming longwave', 'Incoming Longwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncomingLongwave');
INSERT INTO cv_variablename VALUES ('Iron', 'Iron', 'Iron is a chemical element with symbol Fe (from Latin: ferrum) and atomic number 26. It is a metal in the first transition series.', NULL, 'http://vocabulary.odm2.org/variablename/Iron');
INSERT INTO cv_variablename VALUES ('sulfurDissolved', 'Sulfur, dissolved', 'Dissolved Sulfur (S)', NULL, 'http://vocabulary.odm2.org/variablename/sulfurDissolved');
INSERT INTO cv_variablename VALUES ('chlorophyll_a_b_c', 'Chlorophyll (a+b+c)', 'Chlorophyll (a+b+c)', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_a_b_c');
INSERT INTO cv_variablename VALUES ('latitude', 'Latitude', 'Latitude as a variable measurement or observation (Spatial reference to be designated in methods).  This is distinct from the latitude of a site which is a site attribute.', NULL, 'http://vocabulary.odm2.org/variablename/latitude');
INSERT INTO cv_variablename VALUES ('nitrogenGas', 'Nitrogen, gas', 'Gaseous Nitrogen (N2)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenGas');
INSERT INTO cv_variablename VALUES ('manganeseTotal', 'Manganese, total', 'Total manganese (Mn). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/manganeseTotal');
INSERT INTO cv_variablename VALUES ('4_Chloro_3_Methylphenol', '4-Chloro-3-methylphenol', '4-Chloro-3-methylphenol (C7H7ClO)', NULL, 'http://vocabulary.odm2.org/variablename/4_Chloro_3_Methylphenol');
INSERT INTO cv_variablename VALUES ('sulfurPyritic', 'Sulfur, pyritic', 'Pyritic Sulfur', NULL, 'http://vocabulary.odm2.org/variablename/sulfurPyritic');
INSERT INTO cv_variablename VALUES ('phenol', 'Phenol', 'Phenol (C6H5OH)', NULL, 'http://vocabulary.odm2.org/variablename/phenol');
INSERT INTO cv_variablename VALUES ('2_Methylphenol', '2-Methylphenol', '2-Methylphenol (C7H8O)', NULL, 'http://vocabulary.odm2.org/variablename/2_Methylphenol');
INSERT INTO cv_variablename VALUES ('oilAndGrease', 'Oil and grease', 'Oil and grease', NULL, 'http://vocabulary.odm2.org/variablename/oilAndGrease');
INSERT INTO cv_variablename VALUES ('2_4_5_Trichlorophenol', '2,4,5-Trichlorophenol', '2,4,5-Trichlorophenol (C6H3Cl3O)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_5_Trichlorophenol');
INSERT INTO cv_variablename VALUES ('Silt', 'Silt', 'USDA particle size distribution category. 0.002 to 0.5 mm diameter fine earth particles. ', NULL, 'http://vocabulary.odm2.org/variablename/Silt');
INSERT INTO cv_variablename VALUES ('SUVA254', 'SUVA254', 'Specific ultraviolet absorbance at 254 nm. Determined by absorbance normalized to DOC concentration.', NULL, 'http://vocabulary.odm2.org/variablename/SUVA254');
INSERT INTO cv_variablename VALUES ('bariumDissolved', 'Barium, dissolved', 'Dissolved Barium (Ba)', NULL, 'http://vocabulary.odm2.org/variablename/bariumDissolved');
INSERT INTO cv_variablename VALUES ('bifenthrin', 'Bifenthrin', 'Bifenthrin (C23H22ClF3O2)', NULL, 'http://vocabulary.odm2.org/variablename/bifenthrin');
INSERT INTO cv_variablename VALUES ('seleniumDissolved', 'Selenium, dissolved', 'Dissolved selenium (Se). For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/seleniumDissolved');
INSERT INTO cv_variablename VALUES ('ozone', 'Ozone', 'Ozone (O3)', NULL, 'http://vocabulary.odm2.org/variablename/ozone');
INSERT INTO cv_variablename VALUES ('diisopropylEther', 'Diisopropyl Ether', 'Diisopropyl Ether (C6H14O)', NULL, 'http://vocabulary.odm2.org/variablename/diisopropylEther');
INSERT INTO cv_variablename VALUES ('carbonTotalOrganic', 'Carbon, total organic', 'Total (Dissolved+Particulate) Organic Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonTotalOrganic');
INSERT INTO cv_variablename VALUES ('bromomethane_MethylBromide', 'Bromomethane (Methyl bromide)', 'Bromomethane (Methyl bromide) (CH3Br)', NULL, 'http://vocabulary.odm2.org/variablename/bromomethane_MethylBromide');
INSERT INTO cv_variablename VALUES ('trans_1_2_Dichloroethene', 'trans-1,2-Dichloroethene', 'trans-1,2-Dichloroethene (C2H2Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/trans_1_2_Dichloroethene');
INSERT INTO cv_variablename VALUES ('sunshineDuration', 'Sunshine duration', 'Sunshine duration', NULL, 'http://vocabulary.odm2.org/variablename/sunshineDuration');
INSERT INTO cv_variablename VALUES ('endosulfan_II_Beta', 'Endosulfan II (beta)', 'Endosulfan II (beta) (C9H6Cl6O3S)', NULL, 'http://vocabulary.odm2.org/variablename/endosulfan_II_Beta');
INSERT INTO cv_variablename VALUES ('toluene', 'Toluene', 'Toluene (C6H5CH3)', NULL, 'http://vocabulary.odm2.org/variablename/toluene');
INSERT INTO cv_variablename VALUES ('propanoicAcid', 'Propanoic acid', 'Propanoic acid (C3H6O2)', NULL, 'http://vocabulary.odm2.org/variablename/propanoicAcid');
INSERT INTO cv_variablename VALUES ('thorium_228', 'Thorium-228', 'An isotope of thorium in the thorium-232 decay series', NULL, 'http://vocabulary.odm2.org/variablename/thorium_228');
INSERT INTO cv_variablename VALUES ('dibenz_a_h_anthracene', 'Dibenz(a,h)anthracene', 'Dibenz(a,h)anthracene (C22H14), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/dibenz_a_h_anthracene');
INSERT INTO cv_variablename VALUES ('1_Chloronaphthalene', '1-Chloronaphthalene', '1-Chloronaphthalene (C10H7Cl)', NULL, 'http://vocabulary.odm2.org/variablename/1_Chloronaphthalene');
INSERT INTO cv_variablename VALUES ('nitrogenOrganic', 'Nitrogen, organic', 'Organic Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenOrganic');
INSERT INTO cv_variablename VALUES ('hydrogenDissolved', 'Hydrogen, dissolved', 'Dissolved Hydrogen', NULL, 'http://vocabulary.odm2.org/variablename/hydrogenDissolved');
INSERT INTO cv_variablename VALUES ('BOD7Carbonaceous', 'BOD7, carbonaceous', '7-day Carbonaceous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD7Carbonaceous');
INSERT INTO cv_variablename VALUES ('watchdogErrorCount', 'Watchdog error count', 'A counter which counts the number of total datalogger watchdog errors', NULL, 'http://vocabulary.odm2.org/variablename/watchdogErrorCount');
INSERT INTO cv_variablename VALUES ('ethyleneGlycol', 'Ethylene glycol', 'Ethlene Glycol (C2H4(OH)2)', NULL, 'http://vocabulary.odm2.org/variablename/ethyleneGlycol');
INSERT INTO cv_variablename VALUES ('4_Methylchrysene', '4-Methylchrysene', '4-Methylchrysene (C19H14), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/4_Methylchrysene');
INSERT INTO cv_variablename VALUES ('delta_13COfC3H8', 'delta-13C of C3H8', 'Isotope 13C of propane', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfC3H8');
INSERT INTO cv_variablename VALUES ('benzoicAcid', 'Benzoic acid', 'Benzoic acid (C7H6O2)', NULL, 'http://vocabulary.odm2.org/variablename/benzoicAcid');
INSERT INTO cv_variablename VALUES ('4_4_Methylenebis_N_N_Dimethylaniline', '4,4-Methylenebis(N,N-dimethylaniline)', '4,4''-Methylenebis(N,N-dimethylaniline) (C17H22N2)', NULL, 'http://vocabulary.odm2.org/variablename/4_4_Methylenebis_N_N_Dimethylaniline');
INSERT INTO cv_variablename VALUES ('silicon', 'Silicon', 'Silicon (Si)', NULL, 'http://vocabulary.odm2.org/variablename/silicon');
INSERT INTO cv_variablename VALUES ('Sand', 'Sand', 'USDA particle size distribution category. 0.5 to 2 mm diameter fine earth particles. ', NULL, 'http://vocabulary.odm2.org/variablename/Sand');
INSERT INTO cv_variablename VALUES ('1_4_5_Trimethylnaphthalene', '1,4,5-Trimethylnaphthalene', '1,4,5-Trimethylnaphthalene (C10H5(CH3)3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_5_Trimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('2_4_Dinitrotoluene', '2,4-Dinitrotoluene', '2,4-Dinitrotoluene (C7H6N2O4)', NULL, 'http://vocabulary.odm2.org/variablename/2_4_Dinitrotoluene');
INSERT INTO cv_variablename VALUES ('absorbance', 'Absorbance', 'The amount of radiation absorbed by a material', NULL, 'http://vocabulary.odm2.org/variablename/absorbance');
INSERT INTO cv_variablename VALUES ('leadDissolved', 'Lead, dissolved', 'Dissolved Lead (Pb). For chemical terms, dissolved indicates a filtered sample', NULL, 'http://vocabulary.odm2.org/variablename/leadDissolved');
INSERT INTO cv_variablename VALUES ('bromideDissolved', 'Bromide, dissolved', 'Dissolved Bromide (Br-)', NULL, 'http://vocabulary.odm2.org/variablename/bromideDissolved');
INSERT INTO cv_variablename VALUES ('chlorophyllFluorescence', 'Chlorophyll fluorescence', 'Chlorophyll Fluorescence', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyllFluorescence');
INSERT INTO cv_variablename VALUES ('siliconDissolved', 'Silicon, dissolved', 'Dissolved Silicon (Si)', NULL, 'http://vocabulary.odm2.org/variablename/siliconDissolved');
INSERT INTO cv_variablename VALUES ('respirationEcosystem', 'Respiration, ecosystem', 'Gross carbon dioxide production by all organisms in an ecosystem. Ecosystem respiration is the sum of all respiration occurring by the living organisms in a specific ecosystem.', NULL, 'http://vocabulary.odm2.org/variablename/respirationEcosystem');
INSERT INTO cv_variablename VALUES ('radiationIncomingUV_B', 'Radiation, incoming UV-B', 'Incoming Ultraviolet B Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncomingUV_B');
INSERT INTO cv_variablename VALUES ('wellheadPressure', 'Wellhead pressure', 'The pressure exerted by the fluid at the wellhead or casinghead after the well has been shut off for a period of time, typically 24 hours', NULL, 'http://vocabulary.odm2.org/variablename/wellheadPressure');
INSERT INTO cv_variablename VALUES ('ethyne', 'Ethyne', 'Ethyne (C2H2)', NULL, 'http://vocabulary.odm2.org/variablename/ethyne');
INSERT INTO cv_variablename VALUES ('1_4_Dinitrobenzene', '1,4-Dinitrobenzene', '1,4-Dinitrobenzene (C6H4N2O4)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_Dinitrobenzene');
INSERT INTO cv_variablename VALUES ('chlorine', 'Chlorine', 'Chlorine (Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/chlorine');
INSERT INTO cv_variablename VALUES ('slope', 'Slope', 'Ratio between two variables in a linear relationship.', NULL, 'http://vocabulary.odm2.org/variablename/slope');
INSERT INTO cv_variablename VALUES ('1_4_Dimethylnaphthalene', '1,4-Dimethylnaphthalene', '1,4-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('windDirection', 'Wind direction', 'Wind direction', NULL, 'http://vocabulary.odm2.org/variablename/windDirection');
INSERT INTO cv_variablename VALUES ('vanadiumTotal', 'Vanadium, total', 'Total vanadium (V). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/vanadiumTotal');
INSERT INTO cv_variablename VALUES ('sulfateTotal', 'Sulfate, total', 'Total Sulfate (SO4)', NULL, 'http://vocabulary.odm2.org/variablename/sulfateTotal');
INSERT INTO cv_variablename VALUES ('hexachlorobenzene', 'Hexachlorobenzene', 'Hexachlorobenzene (C6Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/hexachlorobenzene');
INSERT INTO cv_variablename VALUES ('secchiDepth', 'Secchi depth', 'Secchi depth', NULL, 'http://vocabulary.odm2.org/variablename/secchiDepth');
INSERT INTO cv_variablename VALUES ('vaporPressureDeficit', 'Vapor pressure deficit', 'The difference between the actual water vapor pressure and the saturation of water vapor pressure at a particular temperature.', NULL, 'http://vocabulary.odm2.org/variablename/vaporPressureDeficit');
INSERT INTO cv_variablename VALUES ('uranium_238', 'Uranium-238', 'Uranium''s most common isotope', NULL, 'http://vocabulary.odm2.org/variablename/uranium_238');
INSERT INTO cv_variablename VALUES ('cis_1_3_Dichloropropene', 'cis-1,3-Dichloropropene', 'cis-1,3-Dichloropropene (C3H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/cis_1_3_Dichloropropene');
INSERT INTO cv_variablename VALUES ('cobaltTotal', 'Cobalt, total', 'Total Cobalt (Co)', NULL, 'http://vocabulary.odm2.org/variablename/cobaltTotal');
INSERT INTO cv_variablename VALUES ('2_6_Dichlorophenol', '2,6-Dichlorophenol', '2,6-Dichlorophenol (C6H4Cl2O)', NULL, 'http://vocabulary.odm2.org/variablename/2_6_Dichlorophenol');
INSERT INTO cv_variablename VALUES ('waterDepth', 'Water depth', 'Water depth is the distance between the water surface and the bottom of the water body at a specific location specified by the site location and offset.', NULL, 'http://vocabulary.odm2.org/variablename/waterDepth');
INSERT INTO cv_variablename VALUES ('titaniumDissolved', 'Titanium, dissolved', 'Dissolved Titanium', NULL, 'http://vocabulary.odm2.org/variablename/titaniumDissolved');
INSERT INTO cv_variablename VALUES ('trichloroethene', 'Trichloroethene', 'Trichloroethene (C2HCl3)', NULL, 'http://vocabulary.odm2.org/variablename/trichloroethene');
INSERT INTO cv_variablename VALUES ('nitrogenNH3_NH4', 'Nitrogen, NH3 + NH4', 'Total (free+ionized) Ammonia', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenNH3_NH4');
INSERT INTO cv_variablename VALUES ('antimonyDissolved', 'Antimony, dissolved', 'Dissolved antimony (Sb)."Dissolved" indicates measurement was on a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/antimonyDissolved');
INSERT INTO cv_variablename VALUES ('N_Nitrosodimethylamine', 'N-Nitrosodimethylamine', 'N-Nitrosodimethylamine (C2H6N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosodimethylamine');
INSERT INTO cv_variablename VALUES ('carbon_13StableIsotopeRatioDelta', 'Carbon-13, stable isotope ratio delta', 'Difference in the 13C:12C ratio between the sample and standard (del C 13)', NULL, 'http://vocabulary.odm2.org/variablename/carbon_13StableIsotopeRatioDelta');
INSERT INTO cv_variablename VALUES ('sodiumDissolved', 'Sodium, dissolved', 'Dissolved Sodium (Na)', NULL, 'http://vocabulary.odm2.org/variablename/sodiumDissolved');
INSERT INTO cv_variablename VALUES ('chlorophyll_c1_And_c2', 'Chlorophyll c1 and c2', 'Chlorophyll c1 and c2', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_c1_And_c2');
INSERT INTO cv_variablename VALUES ('delta_DOfCH4', 'delta-D of CH4', 'hydrogen isotopes of methane', NULL, 'http://vocabulary.odm2.org/variablename/delta_DOfCH4');
INSERT INTO cv_variablename VALUES ('chlorideDissolved', 'Chloride, dissolved', 'Dissolved Chloride (Cl-)', NULL, 'http://vocabulary.odm2.org/variablename/chlorideDissolved');
INSERT INTO cv_variablename VALUES ('TSI', 'TSI', 'Carlson Trophic State Index is a measurement of eutrophication based on Secchi depth', NULL, 'http://vocabulary.odm2.org/variablename/TSI');
INSERT INTO cv_variablename VALUES ('carbonSuspendedTotal', 'Carbon, suspended total', 'Suspended Total (Organic+Inorganic) Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonSuspendedTotal');
INSERT INTO cv_variablename VALUES ('microsomalProtein', 'Microsomal protein', 'The total protein concentration within the microsomal fraction of cells. Microsomes refer to vesicle-like artifacts reformed from pieces of endoplasmic reticulum when eukaryotic cells are broken up in a laboratory.', NULL, 'http://vocabulary.odm2.org/variablename/microsomalProtein');
INSERT INTO cv_variablename VALUES ('pronamide', 'Pronamide', 'Pronamide (C12H11Cl2NO)', NULL, 'http://vocabulary.odm2.org/variablename/pronamide');
INSERT INTO cv_variablename VALUES ('grossBetaRadionuclides', 'Gross beta radionuclides', 'Gross Beta Radionuclides', NULL, 'http://vocabulary.odm2.org/variablename/grossBetaRadionuclides');
INSERT INTO cv_variablename VALUES ('DNADamagePercentTailDNA', 'DNA damage, percent tail DNA', 'In a single cell gel electrophoresis assay (comet assay), percent tail DNA is the ratio of fluorescent intensity of the tail over the total fluorescent intensity of the head (nuclear core) and tail multiplied by 100.', NULL, 'http://vocabulary.odm2.org/variablename/DNADamagePercentTailDNA');
INSERT INTO cv_variablename VALUES ('carbonParticulateOrganic', 'Carbon, particulate organic', 'Particulate organic carbon in suspension', NULL, 'http://vocabulary.odm2.org/variablename/carbonParticulateOrganic');
INSERT INTO cv_variablename VALUES ('pH', 'pH', 'pH is the measure of the acidity or alkalinity of a solution. pH is formally a measure of the activity of dissolved hydrogen ions (H+). Solutions in which the concentration of H+ exceeds that of OH- have a pH value lower than 7.0 and are known as acids.', NULL, 'http://vocabulary.odm2.org/variablename/pH');
INSERT INTO cv_variablename VALUES ('solidsRixedDissolved', 'Solids, fixed dissolved', 'Fixed Dissolved Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsRixedDissolved');
INSERT INTO cv_variablename VALUES ('sodiumPlusPotassium', 'Sodium plus potassium', 'Sodium plus potassium', NULL, 'http://vocabulary.odm2.org/variablename/sodiumPlusPotassium');
INSERT INTO cv_variablename VALUES ('coloredDissolvedOrganicMatter', 'Colored dissolved organic matter', 'The concentration of colored dissolved organic matter (humic substances)', NULL, 'http://vocabulary.odm2.org/variablename/coloredDissolvedOrganicMatter');
INSERT INTO cv_variablename VALUES ('arsenicDissolved', 'Arsenic, dissolved', 'Dissolved Arsenic. For chemical terms, dissolved represents a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/arsenicDissolved');
INSERT INTO cv_variablename VALUES ('chloroethene', 'Chloroethene', 'Chloroethene (C2H3Cl)', NULL, 'http://vocabulary.odm2.org/variablename/chloroethene');
INSERT INTO cv_variablename VALUES ('magnesiumDissolved', 'Magnesium, dissolved', 'Dissolved Magnesium (Mg)', NULL, 'http://vocabulary.odm2.org/variablename/magnesiumDissolved');
INSERT INTO cv_variablename VALUES ('phosphorusInorganic', 'Phosphorus, inorganic', 'Inorganic Phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusInorganic');
INSERT INTO cv_variablename VALUES ('pyridine', 'Pyridine', 'Pyridine (C5H5N)', NULL, 'http://vocabulary.odm2.org/variablename/pyridine');
INSERT INTO cv_variablename VALUES ('TDRWaveformRelativeLength', 'TDR waveform relative length', 'Time domain reflextometry, apparent length divided by probe length. Square root of dielectric', NULL, 'http://vocabulary.odm2.org/variablename/TDRWaveformRelativeLength');
INSERT INTO cv_variablename VALUES ('n_Alkane_C24', 'n-alkane, C24', 'C24 alkane, normal (i.e. straight-chain) isomer, common name: n-Tetracosane, formula : C24H50', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C24');
INSERT INTO cv_variablename VALUES ('nitrogenDissolvedKjeldahl', 'Nitrogen, dissolved Kjeldahl', 'Dissolved Kjeldahl (organic nitrogen + ammonia (NH3) + ammonium (NH4))nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedKjeldahl');
INSERT INTO cv_variablename VALUES ('methylTert_ButylEther_MTBE', 'Methyl tert-butyl ether (MTBE)', 'Methyl tert-butyl ether (MTBE) (C5H12O)', NULL, 'http://vocabulary.odm2.org/variablename/methylTert_ButylEther_MTBE');
INSERT INTO cv_variablename VALUES ('1_4_6_Trimethylnaphthalene', '1,4,6-Trimethylnaphthalene', '1,4,6-Trimethylnaphthalene (C10H5(CH3)3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_6_Trimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('BODu', 'BODu', 'Ultimate Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BODu');
INSERT INTO cv_variablename VALUES ('benzo_e_pyrene', 'Benzo(e)pyrene', 'Benzo(e)pyrene (C20H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_e_pyrene');
INSERT INTO cv_variablename VALUES ('oxygen_18', 'Oxygen-18', '18 O, Delta O', NULL, 'http://vocabulary.odm2.org/variablename/oxygen_18');
INSERT INTO cv_variablename VALUES ('e_coli', 'E-coli', 'Escherichia coli', NULL, 'http://vocabulary.odm2.org/variablename/e_coli');
INSERT INTO cv_variablename VALUES ('urea', 'Urea', 'Urea ((NH2)2CO)', NULL, 'http://vocabulary.odm2.org/variablename/urea');
INSERT INTO cv_variablename VALUES ('berylliumDissolved', 'Beryllium, dissolved', 'Dissolved Beryllium (Be) . For chemical terms, "dissolved"indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/berylliumDissolved');
INSERT INTO cv_variablename VALUES ('temperatureTransducerSignal', 'Temperature, transducer signal', 'Temperature, raw data from sensor', NULL, 'http://vocabulary.odm2.org/variablename/temperatureTransducerSignal');
INSERT INTO cv_variablename VALUES ('cadmiumDistributionCoefficient', 'Cadmium, distribution coefficient', 'Ratio of concentrations of cadmium in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/cadmiumDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('carbon_14', 'Carbon-14', 'A radioactive isotope of carbon which undergoes beta decay', NULL, 'http://vocabulary.odm2.org/variablename/carbon_14');
INSERT INTO cv_variablename VALUES ('manganeseDissolved', 'Manganese, dissolved', 'Dissolved Manganese (Mn)', NULL, 'http://vocabulary.odm2.org/variablename/manganeseDissolved');
INSERT INTO cv_variablename VALUES ('batteryTemperature', 'Battery temperature', 'The battery temperature of a datalogger or sensing system', NULL, 'http://vocabulary.odm2.org/variablename/batteryTemperature');
INSERT INTO cv_variablename VALUES ('chromium_VI', 'Chromium (VI)', 'Hexavalent Chromium', NULL, 'http://vocabulary.odm2.org/variablename/chromium_VI');
INSERT INTO cv_variablename VALUES ('solidsTotalSuspended', 'Solids, total suspended', 'Total Suspended Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsTotalSuspended');
INSERT INTO cv_variablename VALUES ('enterococci', 'Enterococci', 'Enterococcal bacteria', NULL, 'http://vocabulary.odm2.org/variablename/enterococci');
INSERT INTO cv_variablename VALUES ('n_Alkane_C22', 'n-alkane, C22', 'C22 alkane, normal (i.e. straight-chain) isomer, common name: n-Docosane, formula : C22H46', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C22');
INSERT INTO cv_variablename VALUES ('NAlbuminoid', 'N, albuminoid', 'Albuminoid Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/NAlbuminoid');
INSERT INTO cv_variablename VALUES ('2_2_DichlorovinylDimethylPhosphate', '2,2-dichlorovinyl dimethyl phosphate', '2,2-dichlorovinyl dimethyl phosphate (C4H7Cl2O4P)', NULL, 'http://vocabulary.odm2.org/variablename/2_2_DichlorovinylDimethylPhosphate');
INSERT INTO cv_variablename VALUES ('pyrene', 'Pyrene', 'Pyrene (C16H10), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/pyrene');
INSERT INTO cv_variablename VALUES ('sulfideTotal', 'Sulfide, total', 'Total sulfide', NULL, 'http://vocabulary.odm2.org/variablename/sulfideTotal');
INSERT INTO cv_variablename VALUES ('salicorniaBigeloviiCoverage', 'Salicornia bigelovii coverage', 'Areal coverage of the plant Salicornia bigelovii', NULL, 'http://vocabulary.odm2.org/variablename/salicorniaBigeloviiCoverage');
INSERT INTO cv_variablename VALUES ('canthaxanthin', 'Canthaxanthin', 'The phytoplankton pigment Canthaxanthin', NULL, 'http://vocabulary.odm2.org/variablename/canthaxanthin');
INSERT INTO cv_variablename VALUES ('polycyclicAromaticHydrocarbonAlkyl', 'Polycyclic aromatic hydrocarbon, alkyl', 'Polycyclic aromatic hydrocarbon (PAH) having at least one alkyl sidechain (methyl, ethyl or other alkyl group) attached to the aromatic ring structure', NULL, 'http://vocabulary.odm2.org/variablename/polycyclicAromaticHydrocarbonAlkyl');
INSERT INTO cv_variablename VALUES ('1_3_Dichlorobenzene', '1,3-Dichlorobenzene', '1,3-Dichlorobenzene (C6H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_3_Dichlorobenzene');
INSERT INTO cv_variablename VALUES ('radium_226', 'Radium-226', 'An isotope of radium in the uranium-238 decay series', NULL, 'http://vocabulary.odm2.org/variablename/radium_226');
INSERT INTO cv_variablename VALUES ('BODuCarbonaceous', 'BODu, carbonaceous', 'Carbonaceous Ultimate Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BODuCarbonaceous');
INSERT INTO cv_variablename VALUES ('windSpeed', 'Wind speed', 'Wind speed', NULL, 'http://vocabulary.odm2.org/variablename/windSpeed');
INSERT INTO cv_variablename VALUES ('fluoride', 'Fluoride', 'Fluoride (F-)', NULL, 'http://vocabulary.odm2.org/variablename/fluoride');
INSERT INTO cv_variablename VALUES ('1_4_5_8_Tetramethylnaphthalene', '1,4,5,8-Tetramethylnaphthalene', '1,4,5,8-Tetramethylnaphthalene (C14H16), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_4_5_8_Tetramethylnaphthalene');
INSERT INTO cv_variablename VALUES ('longitude', 'Longitude', 'Longitude as a variable measurement or observation (Spatial reference to be designated in methods). This is distinct from the longitude of a site which is a site attribute.', NULL, 'http://vocabulary.odm2.org/variablename/longitude');
INSERT INTO cv_variablename VALUES ('radiationOutgoingLongwave', 'Radiation, outgoing longwave', 'Outgoing Longwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationOutgoingLongwave');
INSERT INTO cv_variablename VALUES ('tetracene', 'Tetracene', 'Tetracene (C18H12), a polycyclic aromatic hydrocarbon (PAH), also known as naphthacene or benz[b]anthracene', NULL, 'http://vocabulary.odm2.org/variablename/tetracene');
INSERT INTO cv_variablename VALUES ('heliumDissolved', 'Helium, dissolved', 'Dissolved Helium (He)', NULL, 'http://vocabulary.odm2.org/variablename/heliumDissolved');
INSERT INTO cv_variablename VALUES ('bariumParticulate', 'Barium, particulate', 'Particulate barium (Ba) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/bariumParticulate');
INSERT INTO cv_variablename VALUES ('1_3_Dinitrobenzene', '1,3-Dinitrobenzene', '1,3-Dinitrobenzene (C6H4N2O4)', NULL, 'http://vocabulary.odm2.org/variablename/1_3_Dinitrobenzene');
INSERT INTO cv_variablename VALUES ('aluminum', 'Aluminum', 'Aluminium (in Commonwealth English) or Aluminum (in American English) is a chemical element in the boron group with symbol Al and atomic number 13. It is a silvery-white, soft, nonmagnetic, ductile metal.', NULL, 'http://vocabulary.odm2.org/variablename/aluminum');
INSERT INTO cv_variablename VALUES ('thoriumDissolved', 'Thorium, dissolved', 'Dissolved thorium. For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/thoriumDissolved');
INSERT INTO cv_variablename VALUES ('electricCurrent', 'Electric Current', 'A flow of electric charge', NULL, 'http://vocabulary.odm2.org/variablename/electricCurrent');
INSERT INTO cv_variablename VALUES ('1_2_Dimethylnaphthalene', '1,2-Dimethylnaphthalene', '1,2-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('tideStage', 'Tide stage', 'Tidal stage', NULL, 'http://vocabulary.odm2.org/variablename/tideStage');
INSERT INTO cv_variablename VALUES ('methane', 'Methane', 'Methane (CH4)', NULL, 'http://vocabulary.odm2.org/variablename/methane');
INSERT INTO cv_variablename VALUES ('bariumTotal', 'Barium, total', 'Total Barium (Ba). For chemical terms, "total" indicates an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/bariumTotal');
INSERT INTO cv_variablename VALUES ('methylpyrene', 'Methylpyrene', 'Methylpyrene (C17H12)', NULL, 'http://vocabulary.odm2.org/variablename/methylpyrene');
INSERT INTO cv_variablename VALUES ('polycyclicAromaticHydrocarbonTotal', 'Polycyclic aromatic hydrocarbon, total', 'total polycyclic aromatic hydrocarbon (PAH), also known as poly-aromatic hydrocarbons or polynuclear aromatic hydrocarbons', NULL, 'http://vocabulary.odm2.org/variablename/polycyclicAromaticHydrocarbonTotal');
INSERT INTO cv_variablename VALUES ('containerNumber', 'Container number', 'The identifying number for a water sampler container.', NULL, 'http://vocabulary.odm2.org/variablename/containerNumber');
INSERT INTO cv_variablename VALUES ('pentane', 'Pentane', 'Pentane', NULL, 'http://vocabulary.odm2.org/variablename/pentane');
INSERT INTO cv_variablename VALUES ('3_6_Dimethylphenanthrene', '3,6-Dimethylphenanthrene', '3,6-Dimethylphenanthrene (C16H14), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/3_6_Dimethylphenanthrene');
INSERT INTO cv_variablename VALUES ('chlorophyll_c', 'Chlorophyll c', 'Chlorophyll c', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_c');
INSERT INTO cv_variablename VALUES ('sedimentPassingSieve', 'Sediment, passing sieve', 'The amount of sediment passing a sieve in a gradation test', NULL, 'http://vocabulary.odm2.org/variablename/sedimentPassingSieve');
INSERT INTO cv_variablename VALUES ('silicate', 'Silicate', 'Silicate. Chemical compound containing silicon, oxygen, and one or more metals, e.g., aluminum, barium, beryllium, calcium, iron, magnesium, manganese, potassium, sodium, or zirconium.', NULL, 'http://vocabulary.odm2.org/variablename/silicate');
INSERT INTO cv_variablename VALUES ('nitrogenTotalKjeldahl', 'Nitrogen, total kjeldahl', 'Total Kjeldahl Nitrogen (Ammonia+Organic)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenTotalKjeldahl');
INSERT INTO cv_variablename VALUES ('nitrogenNitrate_NO3', 'Nitrogen, nitrate (NO3)', 'Nitrate (NO3) Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenNitrate_NO3');
INSERT INTO cv_variablename VALUES ('silverTotal', 'Silver, total', 'Total Silver (Ag). For chemical terms, total represents an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/silverTotal');
INSERT INTO cv_variablename VALUES ('1_6_7_Trimethylnaphthalene', '1,6,7-Trimethylnaphthalene', '1,6,7-Trimethylnaphthalene (C10H5(CH3)3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_6_7_Trimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('cesium_137', 'Cesium-137', 'A radioactive isotope of cesium which is formed as a fission product by nuclear fission of uranium or plutonium.', NULL, 'http://vocabulary.odm2.org/variablename/cesium_137');
INSERT INTO cv_variablename VALUES ('biomass', 'Biomass', 'Mass of living biological organisms in a given area or ecosystem at a given time. If this generic term is used, the publisher should specify/qualify the species, class, etc. being measured in the method, qualifier, or other appropriate field.', NULL, 'http://vocabulary.odm2.org/variablename/biomass');
INSERT INTO cv_variablename VALUES ('benzo_b_fluoranthene', 'Benzo(b)fluoranthene', 'Benzo(b)fluoranthene (C20H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_b_fluoranthene');
INSERT INTO cv_variablename VALUES ('zeaxanthin', 'Zeaxanthin', 'The phytoplankton pigment Zeaxanthin', NULL, 'http://vocabulary.odm2.org/variablename/zeaxanthin');
INSERT INTO cv_variablename VALUES ('nitrogenTotal', 'Nitrogen, total', 'Total Nitrogen (NO3+NO2+NH4+NH3+Organic)', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenTotal');
INSERT INTO cv_variablename VALUES ('zincTotal', 'Zinc, total', 'Total zinc (Zn)."Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/zincTotal');
INSERT INTO cv_variablename VALUES ('bromoform', 'Bromoform', 'Bromoform (CHBr3), a haloform', NULL, 'http://vocabulary.odm2.org/variablename/bromoform');
INSERT INTO cv_variablename VALUES ('wrackCoverage', 'Wrack coverage', 'Areal coverage of dead vegetation', NULL, 'http://vocabulary.odm2.org/variablename/wrackCoverage');
INSERT INTO cv_variablename VALUES ('carbonTotalInorganic', 'Carbon, total inorganic', 'Total (Dissolved+Particulate) Inorganic Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonTotalInorganic');
INSERT INTO cv_variablename VALUES ('1_2_4_Trichlorobenzene', '1,2,4-Trichlorobenzene', '1,2,4-Trichlorobenzene (C6H3Cl3)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_4_Trichlorobenzene');
INSERT INTO cv_variablename VALUES ('alkalinityBicarbonate', 'Alkalinity, bicarbonate', 'Bicarbonate Alkalinity', NULL, 'http://vocabulary.odm2.org/variablename/alkalinityBicarbonate');
INSERT INTO cv_variablename VALUES ('n_Alkane_C31', 'n-alkane, C31', 'C31 alkane,normal (i.e. straight-chain) isomer, common name: n-Hentriacontane, formula : C31H64, Synonym: untriacontane', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C31');
INSERT INTO cv_variablename VALUES ('calciumDissolved', 'Calcium, dissolved', 'Dissolved Calcium (Ca)', NULL, 'http://vocabulary.odm2.org/variablename/calciumDissolved');
INSERT INTO cv_variablename VALUES ('fluorideDissolved', 'Fluoride, dissolved', 'Dissolved Fluoride (F-)', NULL, 'http://vocabulary.odm2.org/variablename/fluorideDissolved');
INSERT INTO cv_variablename VALUES ('dibenzothiophene', 'Dibenzothiophene', 'Dibenzothiophene (C12H8S), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/dibenzothiophene');
INSERT INTO cv_variablename VALUES ('zirconium_95', 'Zirconium-95', 'A radioactive isotope of zirconium with a half-life of 63 days', NULL, 'http://vocabulary.odm2.org/variablename/zirconium_95');
INSERT INTO cv_variablename VALUES ('tritium_3H_DeltaTOfH2O', 'Tritium (3H), Delta T of H2O', 'Isotope 3H of water', NULL, 'http://vocabulary.odm2.org/variablename/tritium_3H_DeltaTOfH2O');
INSERT INTO cv_variablename VALUES ('arsenicTotal', 'Arsenic, total', 'Total arsenic (As). Total indicates was measured on a whole water sample.', NULL, 'http://vocabulary.odm2.org/variablename/arsenicTotal');
INSERT INTO cv_variablename VALUES ('alkalinityCarbonate', 'Alkalinity, carbonate', 'Carbonate Alkalinity', NULL, 'http://vocabulary.odm2.org/variablename/alkalinityCarbonate');
INSERT INTO cv_variablename VALUES ('2_Methylphenanthrene', '2-Methylphenanthrene', '2-Methylphenanthrene (C15H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_Methylphenanthrene');
INSERT INTO cv_variablename VALUES ('cadmiumTotal', 'Cadmium, total', 'Total Cadmium (Cd). For chemical terms, "total" indciates an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/cadmiumTotal');
INSERT INTO cv_variablename VALUES ('carbaryl', 'Carbaryl', 'Carbaryl (C12H11NO2)', NULL, 'http://vocabulary.odm2.org/variablename/carbaryl');
INSERT INTO cv_variablename VALUES ('momentumFlux', 'Momentum flux', 'Momentum flux', NULL, 'http://vocabulary.odm2.org/variablename/momentumFlux');
INSERT INTO cv_variablename VALUES ('petroleumHydrocarbonTotal', 'Petroleum hydrocarbon, total', 'Total petroleum hydrocarbon', NULL, 'http://vocabulary.odm2.org/variablename/petroleumHydrocarbonTotal');
INSERT INTO cv_variablename VALUES ('carbonDisulfide', 'Carbon disulfide', 'Carbon disulfide (CS2)', NULL, 'http://vocabulary.odm2.org/variablename/carbonDisulfide');
INSERT INTO cv_variablename VALUES ('benzylAlcohol', 'Benzyl alcohol', 'Benzyl alcohol (C7H8O)', NULL, 'http://vocabulary.odm2.org/variablename/benzylAlcohol');
INSERT INTO cv_variablename VALUES ('chromiumTotal', 'Chromium, total', 'Total chromium (Cr). Total indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/chromiumTotal');
INSERT INTO cv_variablename VALUES ('carbonate', 'Carbonate', 'Carbonate ion (CO3-2) concentration', NULL, 'http://vocabulary.odm2.org/variablename/carbonate');
INSERT INTO cv_variablename VALUES ('potassiumTotal', 'Potassium, total', 'Total Potassium (K)', NULL, 'http://vocabulary.odm2.org/variablename/potassiumTotal');
INSERT INTO cv_variablename VALUES ('pentachlorobenzene', 'Pentachlorobenzene', 'Pentachlorobenzene (C6HCl5)', NULL, 'http://vocabulary.odm2.org/variablename/pentachlorobenzene');
INSERT INTO cv_variablename VALUES ('propaneDissolved', 'Propane, dissolved', 'Dissolved Propane (C3H8)', NULL, 'http://vocabulary.odm2.org/variablename/propaneDissolved');
INSERT INTO cv_variablename VALUES ('streamflow', 'Streamflow', 'The volume of water flowing past a fixed point.  Equivalent to discharge', NULL, 'http://vocabulary.odm2.org/variablename/streamflow');
INSERT INTO cv_variablename VALUES ('chloromethane', 'Chloromethane', 'Chloromethane (CH3Cl)', NULL, 'http://vocabulary.odm2.org/variablename/chloromethane');
INSERT INTO cv_variablename VALUES ('nitrogenDissolvedNitrate_NO3', 'Nitrogen, dissolved nitrate (NO3)', 'Dissolved nitrate (NO3) nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedNitrate_NO3');
INSERT INTO cv_variablename VALUES ('timeStamp', 'Time Stamp', 'The time at which a sensor produces output', NULL, 'http://vocabulary.odm2.org/variablename/timeStamp');
INSERT INTO cv_variablename VALUES ('solidsTotalVolatile', 'Solids, total volatile', 'Total Volatile Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsTotalVolatile');
INSERT INTO cv_variablename VALUES ('chlorophyll_a_UncorrectedForPheophytin', 'Chlorophyll a, uncorrected for pheophytin', 'Chlorophyll a uncorrected for pheophytin', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_a_UncorrectedForPheophytin');
INSERT INTO cv_variablename VALUES ('methyleneChloride_Dichloromethane', 'Methylene chloride (Dichloromethane)', 'Methylene chloride (Dichloromethane) (CH2Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/methyleneChloride_Dichloromethane');
INSERT INTO cv_variablename VALUES ('xylenesTotal', 'Xylenes, total', 'Total xylenes: C6H4(CH3)2', NULL, 'http://vocabulary.odm2.org/variablename/xylenesTotal');
INSERT INTO cv_variablename VALUES ('gageHeight', 'Gage height', 'Water level with regard to an arbitrary gage datum (also see Water depth for comparison)', NULL, 'http://vocabulary.odm2.org/variablename/gageHeight');
INSERT INTO cv_variablename VALUES ('offset', 'Offset', 'Constant to be added as an offset to a variable of interest.', NULL, 'http://vocabulary.odm2.org/variablename/offset');
INSERT INTO cv_variablename VALUES ('radiationIncomingShortwave', 'Radiation, incoming shortwave', 'Incoming Shortwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationIncomingShortwave');
INSERT INTO cv_variablename VALUES ('oxygen_18_StableIsotopeRatioDelta', 'Oxygen-18, stable isotope ratio delta', 'Difference in the 18O:16O ratio between the sample and standard', NULL, 'http://vocabulary.odm2.org/variablename/oxygen_18_StableIsotopeRatioDelta');
INSERT INTO cv_variablename VALUES ('xylosidase', 'Xylosidase', 'An enzyme with system name 4-beta-D-xylan xylohydrolase.[1][2] This enzyme catalyses the following chemical reaction: Hydrolysis of (1->4)-beta-D-xylans, to remove successive D-xylose residues from the non-reducing termini.', 'Chemistry', 'http://vocabulary.odm2.org/variablename/xylosidase');
INSERT INTO cv_variablename VALUES ('carbazole', 'Carbazole', 'Carbazole (C12H9N)', NULL, 'http://vocabulary.odm2.org/variablename/carbazole');
INSERT INTO cv_variablename VALUES ('chrysene', 'Chrysene', 'Chrysene (C18H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/chrysene');
INSERT INTO cv_variablename VALUES ('phosphorusDissolvedOrganic', 'Phosphorus, dissolved organic', 'Dissolved organic phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusDissolvedOrganic');
INSERT INTO cv_variablename VALUES ('2_Methyldibenzothiophene', '2-Methyldibenzothiophene', '2-Methyldibenzothiophene (C13H10S), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_Methyldibenzothiophene');
INSERT INTO cv_variablename VALUES ('arsenicParticulate', 'Arsenic, particulate', 'Particulate arsenic (As) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/arsenicParticulate');
INSERT INTO cv_variablename VALUES ('carbonTetrachloride', 'Carbon tetrachloride', 'Carbon tetrachloride (CCl4)', NULL, 'http://vocabulary.odm2.org/variablename/carbonTetrachloride');
INSERT INTO cv_variablename VALUES ('benz_a_anthracene', 'Benz(a)anthracene', 'Benz(a)anthracene (C18H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benz_a_anthracene');
INSERT INTO cv_variablename VALUES ('chloride', 'Chloride', 'Chloride (Cl-)', NULL, 'http://vocabulary.odm2.org/variablename/chloride');
INSERT INTO cv_variablename VALUES ('cis_1_2_Dichloroethene', 'cis-1,2-Dichloroethene', 'cis-1,2-Dichloroethene (C2H2Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/cis_1_2_Dichloroethene');
INSERT INTO cv_variablename VALUES ('glutaraldehyde', 'Glutaraldehyde', 'Glutaraldehyde (C5H8O2)', NULL, 'http://vocabulary.odm2.org/variablename/glutaraldehyde');
INSERT INTO cv_variablename VALUES ('alkalinityCarbonatePlusBicarbonate', 'Alkalinity, carbonate plus bicarbonate', 'Alkalinity, carbonate plus bicarbonate', NULL, 'http://vocabulary.odm2.org/variablename/alkalinityCarbonatePlusBicarbonate');
INSERT INTO cv_variablename VALUES ('benzo_a_pyrene', 'Benzo(a)pyrene', 'Benzo(a)pyrene (C20H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_a_pyrene');
INSERT INTO cv_variablename VALUES ('19_Hexanoyloxyfucoxanthin', '19-Hexanoyloxyfucoxanthin', 'The phytoplankton pigment 19-Hexanoyloxyfucoxanthin', NULL, 'http://vocabulary.odm2.org/variablename/19_Hexanoyloxyfucoxanthin');
INSERT INTO cv_variablename VALUES ('ureaFlux', 'Urea flux', 'Urea ((NH2)2CO) flux', NULL, 'http://vocabulary.odm2.org/variablename/ureaFlux');
INSERT INTO cv_variablename VALUES ('phosphorusTotalDissolved', 'Phosphorus, total dissolved', 'Total dissolved phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusTotalDissolved');
INSERT INTO cv_variablename VALUES ('glutathione_S_TransferaseActivity', 'Glutathione S-transferase, activity', 'Glutathione S-transferase (GST) activity', NULL, 'http://vocabulary.odm2.org/variablename/glutathione_S_TransferaseActivity');
INSERT INTO cv_variablename VALUES ('isobutane', 'Isobutane', 'Isobutane', NULL, 'http://vocabulary.odm2.org/variablename/isobutane');
INSERT INTO cv_variablename VALUES ('windGustDirection', 'Wind gust direction', 'Direction of gusts of wind', NULL, 'http://vocabulary.odm2.org/variablename/windGustDirection');
INSERT INTO cv_variablename VALUES ('nitrogenDissolvedNitrite_NO2', 'Nitrogen, dissolved nitrite (NO2)', 'Dissolved nitrite (NO2) nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedNitrite_NO2');
INSERT INTO cv_variablename VALUES ('temperatureDatalogger', 'Temperature, datalogger', 'Temperature, raw data from datalogger', NULL, 'http://vocabulary.odm2.org/variablename/temperatureDatalogger');
INSERT INTO cv_variablename VALUES ('2_Butanone_MEK', '2-Butanone (MEK)', '2-Butanone (MEK) (C4H8O)', NULL, 'http://vocabulary.odm2.org/variablename/2_Butanone_MEK');
INSERT INTO cv_variablename VALUES ('bis_2_ChloroisopropylEther', 'bis-2-chloroisopropyl ether', 'bis-2-chloroisopropyl ether (C6H12Cl2O)', NULL, 'http://vocabulary.odm2.org/variablename/bis_2_ChloroisopropylEther');
INSERT INTO cv_variablename VALUES ('aluminumTotal', 'Aluminum, total', 'Aluminum (Al). Total indicates was measured on a whole water sample.', NULL, 'http://vocabulary.odm2.org/variablename/aluminumTotal');
INSERT INTO cv_variablename VALUES ('phosphorusTotal', 'Phosphorus, total', 'Total Phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusTotal');
INSERT INTO cv_variablename VALUES ('hexane', 'Hexane', 'Hexane', NULL, 'http://vocabulary.odm2.org/variablename/hexane');
INSERT INTO cv_variablename VALUES ('BOD5', 'BOD5', '5-day Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD5');
INSERT INTO cv_variablename VALUES ('acetone', 'Acetone', 'Acetone (C3H6O)', NULL, 'http://vocabulary.odm2.org/variablename/acetone');
INSERT INTO cv_variablename VALUES ('propane', 'Propane', 'Propane', NULL, 'http://vocabulary.odm2.org/variablename/propane');
INSERT INTO cv_variablename VALUES ('phosphorusPhosphate_PO4', 'Phosphorus, phosphate (PO4)', 'Phosphate phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusPhosphate_PO4');
INSERT INTO cv_variablename VALUES ('hostConnected', 'Host connected', 'A categorical variable marking the attachment of a host computer to a logger. This is used for quality control.', NULL, 'http://vocabulary.odm2.org/variablename/hostConnected');
INSERT INTO cv_variablename VALUES ('sequenceNumber', 'Sequence number', 'A counter of events in a sequence', NULL, 'http://vocabulary.odm2.org/variablename/sequenceNumber');
INSERT INTO cv_variablename VALUES ('snowDepth', 'Snow depth', 'Snow depth', NULL, 'http://vocabulary.odm2.org/variablename/snowDepth');
INSERT INTO cv_variablename VALUES ('evapotranspiration', 'Evapotranspiration', 'Evapotranspiration', NULL, 'http://vocabulary.odm2.org/variablename/evapotranspiration');
INSERT INTO cv_variablename VALUES ('pheophytin', 'Pheophytin', 'Pheophytin (Chlorophyll which has lost the central Mg ion) is a degradation product of Chlorophyll', NULL, 'http://vocabulary.odm2.org/variablename/pheophytin');
INSERT INTO cv_variablename VALUES ('thalliumDissolved', 'Thallium, dissolved', 'Dissolved thallium (Tl). "dissolved" indicates measurement was made on a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/thalliumDissolved');
INSERT INTO cv_variablename VALUES ('chlorobenzilate', 'Chlorobenzilate', 'Chlorobenzilate (C16H14Cl2O3)', NULL, 'http://vocabulary.odm2.org/variablename/chlorobenzilate');
INSERT INTO cv_variablename VALUES ('n_Alkane_C16', 'n-alkane, C16', 'C16 alkane, normal (i.e. straight-chain) isomer, common name: n-Hexadecane, formula: C16H34. Synonym: cetane', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C16');
INSERT INTO cv_variablename VALUES ('frictionVelocity', 'Friction velocity', 'Friction velocity', NULL, 'http://vocabulary.odm2.org/variablename/frictionVelocity');
INSERT INTO cv_variablename VALUES ('2_Nitrophenol', '2-Nitrophenol', '2-Nitrophenol (C6H5NO3)', NULL, 'http://vocabulary.odm2.org/variablename/2_Nitrophenol');
INSERT INTO cv_variablename VALUES ('potassiumDissolved', 'Potassium, dissolved', 'Dissolved Potassium (K)', NULL, 'http://vocabulary.odm2.org/variablename/potassiumDissolved');
INSERT INTO cv_variablename VALUES ('4_6_Dinitro_2_Methylphenol', '4,6-Dinitro-2-methylphenol', '4,6-Dinitro-2-methylphenol (C7H6N2O5)', NULL, 'http://vocabulary.odm2.org/variablename/4_6_Dinitro_2_Methylphenol');
INSERT INTO cv_variablename VALUES ('chromiumDissolved', 'Chromium, dissolved', 'Dissolved Chromium', NULL, 'http://vocabulary.odm2.org/variablename/chromiumDissolved');
INSERT INTO cv_variablename VALUES ('aldrin', 'Aldrin', 'Aldrin (C12H8Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/aldrin');
INSERT INTO cv_variablename VALUES ('sodiumAdsorptionRatio', 'Sodium adsorption ratio', 'Sodium adsorption ratio', NULL, 'http://vocabulary.odm2.org/variablename/sodiumAdsorptionRatio');
INSERT INTO cv_variablename VALUES ('deuterium', 'Deuterium', 'Deuterium (2H), Delta D', NULL, 'http://vocabulary.odm2.org/variablename/deuterium');
INSERT INTO cv_variablename VALUES ('radiationTotalShortwave', 'Radiation, total shortwave', 'Total Shortwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationTotalShortwave');
INSERT INTO cv_variablename VALUES ('position', 'Position', 'Position of an element that interacts with water such as reservoir gates', NULL, 'http://vocabulary.odm2.org/variablename/position');
INSERT INTO cv_variablename VALUES ('timeElapsed', 'Time, elapsed', 'Time elapsed since an event occurred', NULL, 'http://vocabulary.odm2.org/variablename/timeElapsed');
INSERT INTO cv_variablename VALUES ('mercuryDissolved', 'Mercury, dissolved', 'Dissolved Mercury (Hg). For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/mercuryDissolved');
INSERT INTO cv_variablename VALUES ('cytosolicProtein', 'Cytosolic protein', 'The total protein concentration within the cytosolic fraction of cells. The cytosol refers to the intracellular fluid or cytoplasmic matrix of a eukaryotic cell.', NULL, 'http://vocabulary.odm2.org/variablename/cytosolicProtein');
INSERT INTO cv_variablename VALUES ('hexachlorocyclopentadiene', 'Hexachlorocyclopentadiene', 'Hexachlorocyclopentadiene (C5Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/hexachlorocyclopentadiene');
INSERT INTO cv_variablename VALUES ('delta_13COfCH4', 'delta-13C of CH4', 'Isotope 13C of methane', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfCH4');
INSERT INTO cv_variablename VALUES ('area', 'Area', 'Area of a measurement location', NULL, 'http://vocabulary.odm2.org/variablename/area');
INSERT INTO cv_variablename VALUES ('BOD20Nitrogenous', 'BOD20, nitrogenous', '20-day Nitrogenous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD20Nitrogenous');
INSERT INTO cv_variablename VALUES ('ironParticulate', 'Iron, particulate', 'Particulate iron (Fe) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/ironParticulate');
INSERT INTO cv_variablename VALUES ('n_Alkane_C33', 'n-alkane, C33', 'C33 alkane, (i.e. straight-chain) isomer, common name: n-Tritriacontane, formula : C33H68', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C33');
INSERT INTO cv_variablename VALUES ('carbonDioxideFlux', 'Carbon dioxide flux', 'Carbon dioxide (CO2) flux', NULL, 'http://vocabulary.odm2.org/variablename/carbonDioxideFlux');
INSERT INTO cv_variablename VALUES ('odor', 'Odor', 'Odor', NULL, 'http://vocabulary.odm2.org/variablename/odor');
INSERT INTO cv_variablename VALUES ('boronTotal', 'Boron, total', 'Total Boron (B)', NULL, 'http://vocabulary.odm2.org/variablename/boronTotal');
INSERT INTO cv_variablename VALUES ('silicicAcidFlux', 'Silicic acid flux', 'Silicate acid (H4SiO4) flux', NULL, 'http://vocabulary.odm2.org/variablename/silicicAcidFlux');
INSERT INTO cv_variablename VALUES ('phosphorusOrthophosphateDissolved', 'Phosphorus, orthophosphate dissolved', 'Dissolved orthophosphate phosphorus', NULL, 'http://vocabulary.odm2.org/variablename/phosphorusOrthophosphateDissolved');
INSERT INTO cv_variablename VALUES ('nickelTotal', 'Nickel, total', 'Total Nickel (Ni). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/nickelTotal');
INSERT INTO cv_variablename VALUES ('bis_2_Ethylhexyl_Phthalate', 'Bis-(2-ethylhexyl) phthalate', 'Bis-(2-ethylhexyl) phthalate (C6H4(C8H17COO)2)', NULL, 'http://vocabulary.odm2.org/variablename/bis_2_Ethylhexyl_Phthalate');
INSERT INTO cv_variablename VALUES ('propyleneGlycol', 'Propylene glycol', 'Propylene glycol (C3H8O2)', NULL, 'http://vocabulary.odm2.org/variablename/propyleneGlycol');
INSERT INTO cv_variablename VALUES ('hexachlorobutadiene', 'Hexachlorobutadiene', 'Hexachlorobutadiene (C4Cl6)', NULL, 'http://vocabulary.odm2.org/variablename/hexachlorobutadiene');
INSERT INTO cv_variablename VALUES ('orientation', 'Orientation', 'Azimuth orientation of sensor platform', NULL, 'http://vocabulary.odm2.org/variablename/orientation');
INSERT INTO cv_variablename VALUES ('dimethylPhthalate', 'Dimethyl Phthalate', 'Dimethyl Phthalate (C10H10O4)', NULL, 'http://vocabulary.odm2.org/variablename/dimethylPhthalate');
INSERT INTO cv_variablename VALUES ('aniline', 'Aniline', 'Aniline (C6H7N)', NULL, 'http://vocabulary.odm2.org/variablename/aniline');
INSERT INTO cv_variablename VALUES ('lyciumCarolinianumCoverage', 'Lycium carolinianum Coverage', 'Areal coverage of the plant Lycium carolinianum', NULL, 'http://vocabulary.odm2.org/variablename/lyciumCarolinianumCoverage');
INSERT INTO cv_variablename VALUES ('2_3_6_Trimethylnaphthalene', '2,3,6-Trimethylnaphthalene', '2,3,6-Trimethylnaphthalene (C10H5(CH3)3), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_3_6_Trimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('dinoflagellates', 'Dinoflagellates', 'The chlorophyll a concentration contributed by Dinoflagellates', NULL, 'http://vocabulary.odm2.org/variablename/dinoflagellates');
INSERT INTO cv_variablename VALUES ('endOfFile', 'End of file', 'A categorical variable marking the end of a data file. This is used for quality control.', NULL, 'http://vocabulary.odm2.org/variablename/endOfFile');
INSERT INTO cv_variablename VALUES ('vanadiumDissolved', 'Vanadium, dissolved', 'Dissolved vanadium (V). "Dissolved" indicates the measurement was made on a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/vanadiumDissolved');
INSERT INTO cv_variablename VALUES ('o_Xylene', 'o-Xylene', 'o-Xylene (C8H10)', NULL, 'http://vocabulary.odm2.org/variablename/o_Xylene');
INSERT INTO cv_variablename VALUES ('butylbenzylphthalate', 'Butylbenzylphthalate', 'Butylbenzylphthalate (C19H20O4)', NULL, 'http://vocabulary.odm2.org/variablename/butylbenzylphthalate');
INSERT INTO cv_variablename VALUES ('dibromochloromethane', 'Dibromochloromethane', 'Dibromochloromethane (CHBr2Cl)', NULL, 'http://vocabulary.odm2.org/variablename/dibromochloromethane');
INSERT INTO cv_variablename VALUES ('alloxanthin', 'Alloxanthin', 'The phytoplankton pigment Alloxanthin', NULL, 'http://vocabulary.odm2.org/variablename/alloxanthin');
INSERT INTO cv_variablename VALUES ('1_1_Dichloroethene', '1,1-Dichloroethene', '1,1-Dichloroethene (C2H2Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_1_Dichloroethene');
INSERT INTO cv_variablename VALUES ('1_3_Dimethylnaphthalene', '1,3-Dimethylnaphthalene', '1,3-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_3_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('grossAlphaRadionuclides', 'Gross alpha radionuclides', 'Gross Alpha Radionuclides', NULL, 'http://vocabulary.odm2.org/variablename/grossAlphaRadionuclides');
INSERT INTO cv_variablename VALUES ('primaryProductivityGross', 'Primary productivity, gross', 'Rate at which an ecosystem accumulates energy by fixation of sunlight, including that consumed by the ecosystem.', NULL, 'http://vocabulary.odm2.org/variablename/primaryProductivityGross');
INSERT INTO cv_variablename VALUES ('thalliumParticulate', 'Thallium, particulate', 'Particulate thallium (Tl) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/thalliumParticulate');
INSERT INTO cv_variablename VALUES ('tetrachloroethene', 'Tetrachloroethene', 'Tetrachloroethene (C2Cl4)', NULL, 'http://vocabulary.odm2.org/variablename/tetrachloroethene');
INSERT INTO cv_variablename VALUES ('percentFullScale', 'Percent full scale', 'The percent of full scale for an instrument', NULL, 'http://vocabulary.odm2.org/variablename/percentFullScale');
INSERT INTO cv_variablename VALUES ('dataShuttleAttached', 'Data shuttle attached', 'A categorical variable marking the attachment of a coupler or data shuttle to a logger. This is used for quality control.', NULL, 'http://vocabulary.odm2.org/variablename/dataShuttleAttached');
INSERT INTO cv_variablename VALUES ('thorium_230', 'Thorium-230', 'An isotope of thorium in the thorium-232 decay series', NULL, 'http://vocabulary.odm2.org/variablename/thorium_230');
INSERT INTO cv_variablename VALUES ('carbonTotal', 'Carbon, total', 'Total (Dissolved+Particulate) Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonTotal');
INSERT INTO cv_variablename VALUES ('triethyleneGlycol', 'Triethylene glycol', 'Triethylene glycol (C6H14O4)', NULL, 'http://vocabulary.odm2.org/variablename/triethyleneGlycol');
INSERT INTO cv_variablename VALUES ('aroclor_1254', 'Aroclor-1254', 'Aroclor-1254 (C12H5Cl5), a PCB mixture', NULL, 'http://vocabulary.odm2.org/variablename/aroclor_1254');
INSERT INTO cv_variablename VALUES ('tetraethyleneGlycol', 'Tetraethylene glycol', 'Tetraethylene glycol (C8H18O5)', NULL, 'http://vocabulary.odm2.org/variablename/tetraethyleneGlycol');
INSERT INTO cv_variablename VALUES ('ruthenium_106', 'Ruthenium-106', 'The most stable isotope of ruthenium with a half life of 373.59 days.', NULL, 'http://vocabulary.odm2.org/variablename/ruthenium_106');
INSERT INTO cv_variablename VALUES ('calciumTotal', 'Calcium, total', 'Total Calcium (Ca)', NULL, 'http://vocabulary.odm2.org/variablename/calciumTotal');
INSERT INTO cv_variablename VALUES ('ivaFrutescenscoverage', 'Iva frutescens coverage', 'Areal coverage of the plant Iva frutescens', NULL, 'http://vocabulary.odm2.org/variablename/ivaFrutescenscoverage');
INSERT INTO cv_variablename VALUES ('bicarbonate', 'Bicarbonate', 'Bicarbonate (HCO3-)', NULL, 'http://vocabulary.odm2.org/variablename/bicarbonate');
INSERT INTO cv_variablename VALUES ('1_2_4_5_Tetrachlorobenzene', '1,2,4,5-tetrachlorobenzene', '1,2,4,5-tetrachlorobenzene (C6H2Cl4)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_4_5_Tetrachlorobenzene');
INSERT INTO cv_variablename VALUES ('oxygenDissolvedTransducerSignal', 'Oxygen, dissolved, transducer signal', 'Dissolved oxygen, raw data from sensor', NULL, 'http://vocabulary.odm2.org/variablename/oxygenDissolvedTransducerSignal');
INSERT INTO cv_variablename VALUES ('dieldrin', 'Dieldrin', 'Dieldrin (C12H8Cl6O)', NULL, 'http://vocabulary.odm2.org/variablename/dieldrin');
INSERT INTO cv_variablename VALUES ('chlorineDissolved', 'Chlorine, dissolved', 'Dissolved Chlorine (Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/chlorineDissolved');
INSERT INTO cv_variablename VALUES ('parameter', 'Parameter', 'Parameter related to a hydrologic process. An example usage would be for a starge-discharge relation parameter.', NULL, 'http://vocabulary.odm2.org/variablename/parameter');
INSERT INTO cv_variablename VALUES ('permittivity', 'Permittivity', 'Permittivity is a physical quantity that describes how an electric field affects, and is affected by a dielectric medium, and is determined by the ability of a material to polarize in response to the field, and thereby reduce the total electric field inside the material. Thus, permittivity relates to a material''s ability to transmit (or "permit") an electric field.', NULL, 'http://vocabulary.odm2.org/variablename/permittivity');
INSERT INTO cv_variablename VALUES ('recorderCode', 'Recorder code', 'A code used to identifier a data recorder.', NULL, 'http://vocabulary.odm2.org/variablename/recorderCode');
INSERT INTO cv_variablename VALUES ('1_2_Dinitrobenzene', '1,2-Dinitrobenzene', '1,2-Dinitrobenzene (C6H4N2O4)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dinitrobenzene');
INSERT INTO cv_variablename VALUES ('lithiumTotal', 'Lithium, total', 'Total Lithium (Li). For chemical terms, total indicates an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/lithiumTotal');
INSERT INTO cv_variablename VALUES ('isopropylAlcohol', 'Isopropyl alcohol', 'Isopropyl alcohol (C3H8O)', NULL, 'http://vocabulary.odm2.org/variablename/isopropylAlcohol');
INSERT INTO cv_variablename VALUES ('benzo_k_fluoranthene', 'Benzo(k)fluoranthene', 'Benzo(k)fluoranthene (C20H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_k_fluoranthene');
INSERT INTO cv_variablename VALUES ('THWIndex', 'THW Index', 'The THW Index uses temperature, humidity, and wind speed to calculate an apparent temperature.', NULL, 'http://vocabulary.odm2.org/variablename/THWIndex');
INSERT INTO cv_variablename VALUES ('density', 'Density', 'Density', NULL, 'http://vocabulary.odm2.org/variablename/density');
INSERT INTO cv_variablename VALUES ('instrumentStatusCode', 'Instrument status code', 'Code value recorded by instrument indicating some information regarding the status of the instrument', NULL, 'http://vocabulary.odm2.org/variablename/instrumentStatusCode');
INSERT INTO cv_variablename VALUES ('nitrogenDissolvedNitrite_NO2_Nitrate_NO3', 'Nitrogen, dissolved nitrite (NO2) + nitrate (NO3)', 'Dissolved nitrite (NO2) + nitrate (NO3) nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolvedNitrite_NO2_Nitrate_NO3');
INSERT INTO cv_variablename VALUES ('2_Butoxyethanol', '2-Butoxyethanol', '2-Butoxyethanol (CH3(CH2)2CH2OCH2OH)', NULL, 'http://vocabulary.odm2.org/variablename/2_Butoxyethanol');
INSERT INTO cv_variablename VALUES ('n_Alkane_C20', 'n-alkane, C20', 'C20 alkane, normal (i.e. straight-chain) isomer, common name: n-Icosane, formula : C20H42. Synonyms: didecyl, eicosane.', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C20');
INSERT INTO cv_variablename VALUES ('naphthalene', 'Naphthalene', 'Naphthalene (C10H8)', NULL, 'http://vocabulary.odm2.org/variablename/naphthalene');
INSERT INTO cv_variablename VALUES ('1_2_Dibromo_3_Chloropropane', '1,2-Dibromo-3-chloropropane', '1,2-Dibromo-3-chloropropane (C3H5Br2Cl)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dibromo_3_Chloropropane');
INSERT INTO cv_variablename VALUES ('diethylPhthalate', 'Diethyl phthalate', 'Diethyl phthalate (C12H14O4)', NULL, 'http://vocabulary.odm2.org/variablename/diethylPhthalate');
INSERT INTO cv_variablename VALUES ('radiationNetShortwave', 'Radiation, net shortwave', 'Net Shortwave radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationNetShortwave');
INSERT INTO cv_variablename VALUES ('1_2_Dichlorobenzene', '1,2-Dichlorobenzene', '1,2-Dichlorobenzene (C6H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/1_2_Dichlorobenzene');
INSERT INTO cv_variablename VALUES ('ethaneDissolved', 'Ethane, dissolved', 'Dissolved Ethane (C2H6)', NULL, 'http://vocabulary.odm2.org/variablename/ethaneDissolved');
INSERT INTO cv_variablename VALUES ('benzene', 'Benzene', 'Benzene (C6H6)', NULL, 'http://vocabulary.odm2.org/variablename/benzene');
INSERT INTO cv_variablename VALUES ('mevinphos', 'Mevinphos', 'Mevinphos (C7H13O6P)', NULL, 'http://vocabulary.odm2.org/variablename/mevinphos');
INSERT INTO cv_variablename VALUES ('coliformTotal', 'Coliform, total', 'Total Coliform', NULL, 'http://vocabulary.odm2.org/variablename/coliformTotal');
INSERT INTO cv_variablename VALUES ('seleniumTotal', 'Selenium, total', 'Total Selenium (Se). For chemical terms, total indicates an unfiltered sample', NULL, 'http://vocabulary.odm2.org/variablename/seleniumTotal');
INSERT INTO cv_variablename VALUES ('bulkElectricalConductivity', 'Bulk electrical conductivity', 'Bulk electrical conductivity of a medium measured using a sensor such as time domain reflectometry (TDR), as a raw sensor response in the measurement of a quantity like soil moisture.', NULL, 'http://vocabulary.odm2.org/variablename/bulkElectricalConductivity');
INSERT INTO cv_variablename VALUES ('4_Nitroaniline', '4-Nitroaniline', '4-Nitroaniline (C6H6N2O2)', NULL, 'http://vocabulary.odm2.org/variablename/4_Nitroaniline');
INSERT INTO cv_variablename VALUES ('cytochromeP450Family1SubfamilyAPolypeptide1DeltaCycleThreshold', 'Cytochrome P450, family 1, subfamily A, polypeptide 1, delta cycle threshold', 'Delta cycle threshold for Cytochrome P450, family 1, subfamily A, polypeptide 1 (cyp1a1). Cycle threshold is the PCR cycle number at which the fluorescent signal of the gene being amplified crosses the set threshold. Delta cycle threshold for cyp1a1 is the difference between the cycle threshold (Ct) of cyp1a1 gene expression and the cycle threshold (Ct) for the gene expression of the reference gene (e.g., beta-actin).', NULL, 'http://vocabulary.odm2.org/variablename/cytochromeP450Family1SubfamilyAPolypeptide1DeltaCycleThreshold');
INSERT INTO cv_variablename VALUES ('2_6_Dinitrotoluene', '2,6-Dinitrotoluene', '2,6-Dinitrotoluene (C7H6N2O4)', NULL, 'http://vocabulary.odm2.org/variablename/2_6_Dinitrotoluene');
INSERT INTO cv_variablename VALUES ('nitrobenzene', 'Nitrobenzene', 'Nitrobenzene (C6H5NO2)', NULL, 'http://vocabulary.odm2.org/variablename/nitrobenzene');
INSERT INTO cv_variablename VALUES ('acetate', 'Acetate', 'Acetate', NULL, 'http://vocabulary.odm2.org/variablename/acetate');
INSERT INTO cv_variablename VALUES ('waterFlux', 'Water flux', 'Water Flux', NULL, 'http://vocabulary.odm2.org/variablename/waterFlux');
INSERT INTO cv_variablename VALUES ('nitrogenNitrite_NO2_Nitrate_NO3', 'Nitrogen, nitrite (NO2) + nitrate (NO3)', 'Nitrite (NO2) + Nitrate (NO3) Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenNitrite_NO2_Nitrate_NO3');
INSERT INTO cv_variablename VALUES ('nickelDistributionCoefficient', 'Nickel, distribution coefficient', 'Ratio of concentrations of nickel in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/nickelDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('vanadiumParticulate', 'Vanadium, particulate', 'Particulate vanadium (V) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/vanadiumParticulate');
INSERT INTO cv_variablename VALUES ('1_3_Dimethyladamantane', '1,3-Dimethyladamantane', '1,3-Dimethyladamantane (C12H20).', NULL, 'http://vocabulary.odm2.org/variablename/1_3_Dimethyladamantane');
INSERT INTO cv_variablename VALUES ('sulfurDioxide', 'Sulfur dioxide', 'Sulfur dioxide (SO2)', NULL, 'http://vocabulary.odm2.org/variablename/sulfurDioxide');
INSERT INTO cv_variablename VALUES ('heptachlorEpoxide', 'Heptachlor epoxide', 'Heptachlor epoxide (C10H5Cl7O)', NULL, 'http://vocabulary.odm2.org/variablename/heptachlorEpoxide');
INSERT INTO cv_variablename VALUES ('1_8_Dimethylnaphthalene', '1,8-Dimethylnaphthalene', '1,8-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_8_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('hydrogen_2_StableIsotopeRatioDelta', 'Hydrogen-2, stable isotope ratio delta', 'Difference in the 2H:1H ratio between the sample and standard', NULL, 'http://vocabulary.odm2.org/variablename/hydrogen_2_StableIsotopeRatioDelta');
INSERT INTO cv_variablename VALUES ('endosulfanSulfate', 'Endosulfan Sulfate', 'Endosulfan Sulfate (C9H6Cl6O4S)', NULL, 'http://vocabulary.odm2.org/variablename/endosulfanSulfate');
INSERT INTO cv_variablename VALUES ('heightAboveSeaFloor', 'height, above sea floor', 'Vertical distance from the sea floor to a point.', NULL, 'http://vocabulary.odm2.org/variablename/heightAboveSeaFloor');
INSERT INTO cv_variablename VALUES ('carbonDissolvedTotal', 'Carbon, dissolved total', 'Dissolved Total (Organic+Inorganic) Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonDissolvedTotal');
INSERT INTO cv_variablename VALUES ('4_Chloroaniline', '4-Chloroaniline', '4-Chloroaniline (C6H6ClN)', NULL, 'http://vocabulary.odm2.org/variablename/4_Chloroaniline');
INSERT INTO cv_variablename VALUES ('endosulfan_I_Alpha', 'Endosulfan I (alpha)', 'Endosulfan I (alpha) (C9H6Cl6O3S)', NULL, 'http://vocabulary.odm2.org/variablename/endosulfan_I_Alpha');
INSERT INTO cv_variablename VALUES ('snowWaterEquivalent', 'Snow water equivalent', 'The depth of water if a snow cover is completely melted, expressed in units of depth, on a corresponding horizontal surface area.', NULL, 'http://vocabulary.odm2.org/variablename/snowWaterEquivalent');
INSERT INTO cv_variablename VALUES ('formicAcid', 'Formic acid', 'Formic acid (CH2O2)', NULL, 'http://vocabulary.odm2.org/variablename/formicAcid');
INSERT INTO cv_variablename VALUES ('signalToNoiseRatio', 'Signal-to-noise ratio', 'Signal-to-noise ratio (often abbreviated SNR or S/N) is defined as the ratio of a signal power to the noise power corrupting the signal. The higher the ratio, the less obtrusive the background noise is.', NULL, 'http://vocabulary.odm2.org/variablename/signalToNoiseRatio');
INSERT INTO cv_variablename VALUES ('fluorene', 'Fluorene', 'Fluorene (C13H10), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/fluorene');
INSERT INTO cv_variablename VALUES ('zincDissolved', 'Zinc, dissolved', 'Dissolved Zinc (Zn)', NULL, 'http://vocabulary.odm2.org/variablename/zincDissolved');
INSERT INTO cv_variablename VALUES ('blue_GreenAlgae_Cyanobacteria_Phycocyanin', 'Blue-green algae (cyanobacteria), phycocyanin', 'Blue-green algae (cyanobacteria) with phycocyanin pigments', NULL, 'http://vocabulary.odm2.org/variablename/blue_GreenAlgae_Cyanobacteria_Phycocyanin');
INSERT INTO cv_variablename VALUES ('BOD20Carbonaceous', 'BOD20, carbonaceous', '20-day Carbonaceous Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD20Carbonaceous');
INSERT INTO cv_variablename VALUES ('temperatureDewPoint', 'Temperature, dew point', 'Dew point temperature', NULL, 'http://vocabulary.odm2.org/variablename/temperatureDewPoint');
INSERT INTO cv_variablename VALUES ('aceticAcid', 'Acetic Acid', 'Acetic Acid (C2H4O2)', NULL, 'http://vocabulary.odm2.org/variablename/aceticAcid');
INSERT INTO cv_variablename VALUES ('delta_13COfCO2', 'delta-13C of CO2', 'Isotope 13C of carbon dioxide', NULL, 'http://vocabulary.odm2.org/variablename/delta_13COfCO2');
INSERT INTO cv_variablename VALUES ('dimethylphenanthrene', 'Dimethylphenanthrene', 'Dimethylphenanthrene (C16H14)', NULL, 'http://vocabulary.odm2.org/variablename/dimethylphenanthrene');
INSERT INTO cv_variablename VALUES ('1_1_2_2_Tetrachloroethane', '1,1,2,2-Tetrachloroethane', '1,1,2,2-Tetrachloroethane (C2H2Cl4)', NULL, 'http://vocabulary.odm2.org/variablename/1_1_2_2_Tetrachloroethane');
INSERT INTO cv_variablename VALUES ('suaedaMaritimaCoverage', 'Suaeda maritima coverage', 'Areal coverage of the plant Suaeda maritima', NULL, 'http://vocabulary.odm2.org/variablename/suaedaMaritimaCoverage');
INSERT INTO cv_variablename VALUES ('counter', 'Counter', 'The total number of events within the measurement period', NULL, 'http://vocabulary.odm2.org/variablename/counter');
INSERT INTO cv_variablename VALUES ('acidityExchange', 'Acidity, exchange', 'The total amount of the Cation Exchange Capacity (CEC) of a soil that is due to H+ and Al3+ ions. It is a proportion of the total acidity and it is dependent on the type of soil and the percentage of the CEC that is composed of exchangeable bases (Ca2+, Mg2+, K+).', NULL, 'http://vocabulary.odm2.org/variablename/acidityExchange');
INSERT INTO cv_variablename VALUES ('waveHeight', 'Wave height', 'The height of a surface wave, measured as the difference in elevation between the wave crest and an adjacent trough.', NULL, 'http://vocabulary.odm2.org/variablename/waveHeight');
INSERT INTO cv_variablename VALUES ('cesiumTotal', 'Cesium, total', 'Total Cesium (Cs)', NULL, 'http://vocabulary.odm2.org/variablename/cesiumTotal');
INSERT INTO cv_variablename VALUES ('chloroform', 'Chloroform', 'Chloroform (CHCl3), a haloform', NULL, 'http://vocabulary.odm2.org/variablename/chloroform');
INSERT INTO cv_variablename VALUES ('hydrogen', 'Hydrogen', 'Hydrogen', NULL, 'http://vocabulary.odm2.org/variablename/hydrogen');
INSERT INTO cv_variablename VALUES ('terpineol', 'Terpineol', 'Terpineol (C10H18O)', NULL, 'http://vocabulary.odm2.org/variablename/terpineol');
INSERT INTO cv_variablename VALUES ('specificConductance', 'Specific conductance', 'Specific conductance', NULL, 'http://vocabulary.odm2.org/variablename/specificConductance');
INSERT INTO cv_variablename VALUES ('acidityTotalAcidity', 'Acidity, total acidity', 'Total acidity', NULL, 'http://vocabulary.odm2.org/variablename/acidityTotalAcidity');
INSERT INTO cv_variablename VALUES ('nitrogenDissolved_Free_Ionized_Ammonia_NH3_NH4', 'Nitrogen, dissolved (free+ionized) Ammonia (NH3) + (NH4)', 'Dissolved (free+ionized) Ammonia', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenDissolved_Free_Ionized_Ammonia_NH3_NH4');
INSERT INTO cv_variablename VALUES ('radiationOutgoingShortwave', 'Radiation, outgoing shortwave', 'Outgoing Shortwave Radiation', NULL, 'http://vocabulary.odm2.org/variablename/radiationOutgoingShortwave');
INSERT INTO cv_variablename VALUES ('perylene', 'Perylene', 'Perylene (C20H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/perylene');
INSERT INTO cv_variablename VALUES ('molbydenumDissolved', 'Molbydenum, dissolved', 'Dissolved Molbydenum (Mo). For chemical terms, dissolved indicates a filtered sample.', NULL, 'http://vocabulary.odm2.org/variablename/molbydenumDissolved');
INSERT INTO cv_variablename VALUES ('1_6_Dimethylnaphthalene', '1,6-Dimethylnaphthalene', '1,6-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_6_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('ethane', 'Ethane', 'Ethane', NULL, 'http://vocabulary.odm2.org/variablename/ethane');
INSERT INTO cv_variablename VALUES ('salinity', 'Salinity', 'Salinity', NULL, 'http://vocabulary.odm2.org/variablename/salinity');
INSERT INTO cv_variablename VALUES ('carbonSuspendedOrganic', 'Carbon, suspended organic', 'DEPRECATED -- The use of this term is discouraged in favor of the use of the synonymous term "Carbon, particulate organic".', NULL, 'http://vocabulary.odm2.org/variablename/carbonSuspendedOrganic');
INSERT INTO cv_variablename VALUES ('cesiumDissolved', 'Cesium, dissolved', 'Dissolved Cesium (Cs)', NULL, 'http://vocabulary.odm2.org/variablename/cesiumDissolved');
INSERT INTO cv_variablename VALUES ('carbonToNitrogenMolarRatio', 'Carbon to nitrogen molar ratio', 'Carbon to nitrogen (C:N) molar ratio', NULL, 'http://vocabulary.odm2.org/variablename/carbonToNitrogenMolarRatio');
INSERT INTO cv_variablename VALUES ('1_Methylfluorene', '1-Methylfluorene', '1-Methylfluorene (C14H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/1_Methylfluorene');
INSERT INTO cv_variablename VALUES ('ironDissolved', 'Iron, dissolved', 'Dissolved Iron (Fe)', NULL, 'http://vocabulary.odm2.org/variablename/ironDissolved');
INSERT INTO cv_variablename VALUES ('benzo_b_fluorene', 'Benzo(b)fluorene', 'Benzo(b)fluorene (C17H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/benzo_b_fluorene');
INSERT INTO cv_variablename VALUES ('n_Alkane_C21', 'n-alkane, C21', 'C21 alkane, normal (i.e. straight-chain) isomer, common name: n-Henicosane, formula : C21H44.', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C21');
INSERT INTO cv_variablename VALUES ('isopropylbenzene', 'Isopropylbenzene', 'Isopropylbenzene (C9H12)', NULL, 'http://vocabulary.odm2.org/variablename/isopropylbenzene');
INSERT INTO cv_variablename VALUES ('cobaltDissolved', 'Cobalt, dissolved', 'Dissolved Cobalt (Co)', NULL, 'http://vocabulary.odm2.org/variablename/cobaltDissolved');
INSERT INTO cv_variablename VALUES ('zincParticulate', 'Zinc, particulate', 'Particulate zinc (Zn) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/zincParticulate');
INSERT INTO cv_variablename VALUES ('di_n_Butylphthalate', 'Di-n-butylphthalate', 'Di-n-butylphthalate (C16H22O4)', NULL, 'http://vocabulary.odm2.org/variablename/di_n_Butylphthalate');
INSERT INTO cv_variablename VALUES ('asteridaeCoverage', 'Asteridae coverage', 'Areal coverage of the plant Asteridae', NULL, 'http://vocabulary.odm2.org/variablename/asteridaeCoverage');
INSERT INTO cv_variablename VALUES ('carbonDioxideStorageFlux', 'Carbon dioxide storage flux', 'Carbon dioxide (CO2) storage flux', NULL, 'http://vocabulary.odm2.org/variablename/carbonDioxideStorageFlux');
INSERT INTO cv_variablename VALUES ('diethyleneGlycol', 'Diethylene glycol', 'Diethylene glycol (C4H10O3)', NULL, 'http://vocabulary.odm2.org/variablename/diethyleneGlycol');
INSERT INTO cv_variablename VALUES ('alkalinityHydroxide', 'Alkalinity, hydroxide', 'Hydroxide Alkalinity', NULL, 'http://vocabulary.odm2.org/variablename/alkalinityHydroxide');
INSERT INTO cv_variablename VALUES ('bromodichloromethane', 'Bromodichloromethane', 'Bromodichloromethane (CHBrCl2)', NULL, 'http://vocabulary.odm2.org/variablename/bromodichloromethane');
INSERT INTO cv_variablename VALUES ('chloroethane', 'Chloroethane', 'Chloroethane (C2H5Cl)', NULL, 'http://vocabulary.odm2.org/variablename/chloroethane');
INSERT INTO cv_variablename VALUES ('solidsTotalDissolved', 'Solids, total dissolved', 'Total Dissolved Solids', NULL, 'http://vocabulary.odm2.org/variablename/solidsTotalDissolved');
INSERT INTO cv_variablename VALUES ('uranium_235', 'Uranium-235', 'An isotope of uranium that can sustain fission chain reaction', NULL, 'http://vocabulary.odm2.org/variablename/uranium_235');
INSERT INTO cv_variablename VALUES ('batteryVoltage', 'Battery voltage', 'The battery voltage of a datalogger or sensing system, often recorded as an indicator of data reliability', NULL, 'http://vocabulary.odm2.org/variablename/batteryVoltage');
INSERT INTO cv_variablename VALUES ('osmoticPressure', 'Osmotic pressure', 'Osmotic pressure', NULL, 'http://vocabulary.odm2.org/variablename/osmoticPressure');
INSERT INTO cv_variablename VALUES ('4_Methylphenol', '4-Methylphenol', '4-Methylphenol (C7H8O)', NULL, 'http://vocabulary.odm2.org/variablename/4_Methylphenol');
INSERT INTO cv_variablename VALUES ('2_Methylanthracene', '2-Methylanthracene', '2-Methylanthracene (C15H12), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_Methylanthracene');
INSERT INTO cv_variablename VALUES ('chromiumParticulate', 'Chromium, particulate', 'Particulate chromium (Cr) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/chromiumParticulate');
INSERT INTO cv_variablename VALUES ('copperDissolved', 'Copper, dissolved', 'Dissolved Copper (Cu)', NULL, 'http://vocabulary.odm2.org/variablename/copperDissolved');
INSERT INTO cv_variablename VALUES ('noVegetationCoverage', 'No vegetation coverage', 'Areal coverage of no vegetation', NULL, 'http://vocabulary.odm2.org/variablename/noVegetationCoverage');
INSERT INTO cv_variablename VALUES ('seleniumDistributionCoefficient', 'Selenium, distribution coefficient', 'Ratio of concentrations of selenium in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/seleniumDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('COD', 'COD', 'Chemical oxygen demand', NULL, 'http://vocabulary.odm2.org/variablename/COD');
INSERT INTO cv_variablename VALUES ('imaginaryDielectricConstant', 'Imaginary dielectric constant', 'Soil reponse of a reflected standing electromagnetic wave of a particular frequency which is related to the dissipation (or loss) of energy within the medium. This is the imaginary portion of the complex dielectric constant.', NULL, 'http://vocabulary.odm2.org/variablename/imaginaryDielectricConstant');
INSERT INTO cv_variablename VALUES ('4_Methyldibenzothiophene', '4-Methyldibenzothiophene', '4-Methyldibenzothiophene (C13H10S), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/4_Methyldibenzothiophene');
INSERT INTO cv_variablename VALUES ('trans_1_3_Dichloropropene', 'trans-1,3-Dichloropropene', 'trans-1,3-Dichloropropene (C3H4Cl2)', NULL, 'http://vocabulary.odm2.org/variablename/trans_1_3_Dichloropropene');
INSERT INTO cv_variablename VALUES ('volume', 'Volume', 'Volume. To quantify discharge or hydrograph volume or some other volume measurement.', NULL, 'http://vocabulary.odm2.org/variablename/volume');
INSERT INTO cv_variablename VALUES ('BODuNitrogenous', 'BODu, nitrogenous', 'Nitrogenous Ultimate Biochemical Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BODuNitrogenous');
INSERT INTO cv_variablename VALUES ('boreholeLogMaterialClassification', 'Borehole log material classification', 'Classification of material encountered by a driller at various depths during the drilling of a well and recorded in the borehole log.', NULL, 'http://vocabulary.odm2.org/variablename/boreholeLogMaterialClassification');
INSERT INTO cv_variablename VALUES ('distichlisSpicataCoverage', 'Distichlis spicata Coverage', 'Areal coverage of the plant Distichlis spicata', NULL, 'http://vocabulary.odm2.org/variablename/distichlisSpicataCoverage');
INSERT INTO cv_variablename VALUES ('bromideTotal', 'Bromide, total', 'Total Bromide (Br-)', NULL, 'http://vocabulary.odm2.org/variablename/bromideTotal');
INSERT INTO cv_variablename VALUES ('n_Alkane_C18', 'n-alkane, C18', 'C18 alkane, normal (i.e. straight-chain) isomer, common name: n-Octadecane, formula : C18H38', NULL, 'http://vocabulary.odm2.org/variablename/n_Alkane_C18');
INSERT INTO cv_variablename VALUES ('radiationTotalOutgoing', 'Radiation, total outgoing', 'Total amount of outgoing radiation from all frequencies', NULL, 'http://vocabulary.odm2.org/variablename/radiationTotalOutgoing');
INSERT INTO cv_variablename VALUES ('biomassPhytoplankton', 'Biomass, phytoplankton', 'Total mass of phytoplankton, per unit area or volume', NULL, 'http://vocabulary.odm2.org/variablename/biomassPhytoplankton');
INSERT INTO cv_variablename VALUES ('waterColumnEquivalentHeightAbsolute', 'Water column equivalent height, absolute', 'The absolute pressure (combined water + barometric) on a sensor expressed as the height of an equivalent column of water.', NULL, 'http://vocabulary.odm2.org/variablename/waterColumnEquivalentHeightAbsolute');
INSERT INTO cv_variablename VALUES ('sedimentSuspended', 'Sediment, suspended', 'Suspended Sediment', NULL, 'http://vocabulary.odm2.org/variablename/sedimentSuspended');
INSERT INTO cv_variablename VALUES ('2_Hexanone', '2-Hexanone', '2-Hexanone (C6H12O)', NULL, 'http://vocabulary.odm2.org/variablename/2_Hexanone');
INSERT INTO cv_variablename VALUES ('BOD6Carbonaceous', 'BOD6, carbonaceous', '6-day Carbonaceous Biological Oxygen Demand', NULL, 'http://vocabulary.odm2.org/variablename/BOD6Carbonaceous');
INSERT INTO cv_variablename VALUES ('thalliumTotal', 'Thallium, total', 'Total thallium (Tl). "Total" indicates was measured on a whole water (unfiltered) sample.', NULL, 'http://vocabulary.odm2.org/variablename/thalliumTotal');
INSERT INTO cv_variablename VALUES ('ironSulfide', 'Iron sulfide', 'Iron sulfide (FeS2)', NULL, 'http://vocabulary.odm2.org/variablename/ironSulfide');
INSERT INTO cv_variablename VALUES ('N_Nitrosodi_n_Butylamine', 'N-Nitrosodi-n-butylamine', 'N-Nitrosodi-n-butylamine (C8H18N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosodi_n_Butylamine');
INSERT INTO cv_variablename VALUES ('silicicAcid', 'Silicic acid', 'Hydrated silica disolved in water', NULL, 'http://vocabulary.odm2.org/variablename/silicicAcid');
INSERT INTO cv_variablename VALUES ('nitrogenTotalDissolved', 'Nitrogen, total dissolved', 'Total dissolved nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenTotalDissolved');
INSERT INTO cv_variablename VALUES ('spartinaSpartineaCoverage', 'Spartina spartinea coverage', 'Areal coverage of the plant Spartina spartinea', NULL, 'http://vocabulary.odm2.org/variablename/spartinaSpartineaCoverage');
INSERT INTO cv_variablename VALUES ('trifluralin', 'Trifluralin', 'Trifluralin (C13H16F3N3O4)', NULL, 'http://vocabulary.odm2.org/variablename/trifluralin');
INSERT INTO cv_variablename VALUES ('thorium_232', 'Thorium-232', 'A radioactive isotope of thorium which undergoes alpha decay', NULL, 'http://vocabulary.odm2.org/variablename/thorium_232');
INSERT INTO cv_variablename VALUES ('4_ChlorophenylphenylEther', '4-Chlorophenylphenyl ether', '4-Chlorophenylphenyl ether (C12H9ClO)', NULL, 'http://vocabulary.odm2.org/variablename/4_ChlorophenylphenylEther');
INSERT INTO cv_variablename VALUES ('4_4_Methylenebis_2_Chloroaniline', '4,4-Methylenebis(2-chloroaniline)', '4,4''-Methylenebis(2-chloroaniline) (C13H12Cl2N2)', NULL, 'http://vocabulary.odm2.org/variablename/4_4_Methylenebis_2_Chloroaniline');
INSERT INTO cv_variablename VALUES ('1_1_1_Trichloroethane', '1,1,1-Trichloroethane', '1,1,1-Trichloroethane (C2H3Cl3)', NULL, 'http://vocabulary.odm2.org/variablename/1_1_1_Trichloroethane');
INSERT INTO cv_variablename VALUES ('chlorophyll_b', 'Chlorophyll b', 'Chlorophyll b', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_b');
INSERT INTO cv_variablename VALUES ('methylfluorene', 'Methylfluorene', 'Methylfluorene (C14H12)', NULL, 'http://vocabulary.odm2.org/variablename/methylfluorene');
INSERT INTO cv_variablename VALUES ('4_4_DDD', '4,4-DDD', 'Dichlorodiphenyldichloroethane (C14H10Cl4)', NULL, 'http://vocabulary.odm2.org/variablename/4_4_DDD');
INSERT INTO cv_variablename VALUES ('antimonyParticulate', 'Antimony, particulate', 'Particulate antimony (Sb) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/antimonyParticulate');
INSERT INTO cv_variablename VALUES ('2_Chlorophenol', '2-Chlorophenol', '2-Chlorophenol (C6H5ClO)', NULL, 'http://vocabulary.odm2.org/variablename/2_Chlorophenol');
INSERT INTO cv_variablename VALUES ('carbonSuspendedInorganic', 'Carbon, suspended inorganic', 'Suspended Inorganic Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonSuspendedInorganic');
INSERT INTO cv_variablename VALUES ('nitrogenInorganic', 'Nitrogen, inorganic', 'Total Inorganic Nitrogen', NULL, 'http://vocabulary.odm2.org/variablename/nitrogenInorganic');
INSERT INTO cv_variablename VALUES ('acenaphthylene', 'Acenaphthylene', 'Acenaphthylene (C12H8), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/acenaphthylene');
INSERT INTO cv_variablename VALUES ('bromine', 'Bromine', 'Bromine (Br2)', NULL, 'http://vocabulary.odm2.org/variablename/bromine');
INSERT INTO cv_variablename VALUES ('chlorophyll_a_Allomer', 'Chlorophyll a allomer', 'The phytoplankton pigment Chlorophyll a allomer', NULL, 'http://vocabulary.odm2.org/variablename/chlorophyll_a_Allomer');
INSERT INTO cv_variablename VALUES ('N_Nitrosodiethylamine', 'N-Nitrosodiethylamine', 'N-Nitrosodiethylamine (C4H10N2O)', NULL, 'http://vocabulary.odm2.org/variablename/N_Nitrosodiethylamine');
INSERT INTO cv_variablename VALUES ('9_cis_Neoxanthin', '9 cis-Neoxanthin', 'The phytoplankton pigment  9 cis-Neoxanthin', NULL, 'http://vocabulary.odm2.org/variablename/9_cis_Neoxanthin');
INSERT INTO cv_variablename VALUES ('zincDistributionCoefficient', 'Zinc, distribution coefficient', 'Ratio of concentrations of zinc in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/zincDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('acetophenone', 'Acetophenone', 'Acetophenone (C6H5C(O)CH3)', NULL, 'http://vocabulary.odm2.org/variablename/acetophenone');
INSERT INTO cv_variablename VALUES ('temperatureChange', 'Temperature change', 'temperature change', NULL, 'http://vocabulary.odm2.org/variablename/temperatureChange');
INSERT INTO cv_variablename VALUES ('carbonDissolvedInorganic', 'Carbon, dissolved inorganic', 'Dissolved Inorganic Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonDissolvedInorganic');
INSERT INTO cv_variablename VALUES ('waterUseCommercialIndustrialPower', 'Water Use, Commercial + Industrial + Power', 'Water pumped by commercial, industrial users.', NULL, 'http://vocabulary.odm2.org/variablename/waterUseCommercialIndustrialPower');
INSERT INTO cv_variablename VALUES ('n_AlkaneShortChain', 'n-alkane, short-chain', 'short-chain alkanes, normal (i.e. straight chain) isomer (isomer range of alkanes measured should be specified)', NULL, 'http://vocabulary.odm2.org/variablename/n_AlkaneShortChain');
INSERT INTO cv_variablename VALUES ('agencyCode', 'Agency code', 'Code for the agency which analyzed the sample', NULL, 'http://vocabulary.odm2.org/variablename/agencyCode');
INSERT INTO cv_variablename VALUES ('distance', 'Distance', 'Distance measured from a sensor to a target object such as the surface of a water body or snow surface.', NULL, 'http://vocabulary.odm2.org/variablename/distance');
INSERT INTO cv_variablename VALUES ('carbonDissolvedOrganic', 'Carbon, dissolved organic', 'Dissolved Organic Carbon', NULL, 'http://vocabulary.odm2.org/variablename/carbonDissolvedOrganic');
INSERT INTO cv_variablename VALUES ('temperatureInitial', 'Temperature, initial', 'initial temperature before heating', NULL, 'http://vocabulary.odm2.org/variablename/temperatureInitial');
INSERT INTO cv_variablename VALUES ('diadinoxanthin', 'Diadinoxanthin', 'The phytoplankton pigment Diadinoxanthin', NULL, 'http://vocabulary.odm2.org/variablename/diadinoxanthin');
INSERT INTO cv_variablename VALUES ('leadDistributionCoefficient', 'Lead, distribution coefficient', 'Ratio of concentrations of lead in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/leadDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('1_1_2_Trichloroethane', '1,1,2-Trichloroethane', '1,1,2-Trichloroethane (C2H3Cl3)', NULL, 'http://vocabulary.odm2.org/variablename/1_1_2_Trichloroethane');
INSERT INTO cv_variablename VALUES ('leadTotal', 'Lead, total', 'Total Lead (Pb). For chemical terms, total indicates an unfiltered sample.', NULL, 'http://vocabulary.odm2.org/variablename/leadTotal');
INSERT INTO cv_variablename VALUES ('globalRadiation', 'Global Radiation', 'Solar radiation, direct and diffuse, received from a solid angle of 2p steradians on a horizontal surface. Source: World Meteorological Organization, Meteoterm', NULL, 'http://vocabulary.odm2.org/variablename/globalRadiation');
INSERT INTO cv_variablename VALUES ('hydrogenSulfide', 'Hydrogen sulfide', 'Hydrogen sulfide (H2S)', NULL, 'http://vocabulary.odm2.org/variablename/hydrogenSulfide');
INSERT INTO cv_variablename VALUES ('ethylbenzene', 'Ethylbenzene', 'Ethylbenzene (C8H10)', NULL, 'http://vocabulary.odm2.org/variablename/ethylbenzene');
INSERT INTO cv_variablename VALUES ('windChill', 'Wind chill', 'The effect of wind on the temperature felt on human skin.', NULL, 'http://vocabulary.odm2.org/variablename/windChill');
INSERT INTO cv_variablename VALUES ('weatherConditions', 'Weather conditions', 'Weather conditions', NULL, 'http://vocabulary.odm2.org/variablename/weatherConditions');
INSERT INTO cv_variablename VALUES ('seleniumParticulate', 'Selenium, particulate', 'Particulate selenium (Se) in suspension', NULL, 'http://vocabulary.odm2.org/variablename/seleniumParticulate');
INSERT INTO cv_variablename VALUES ('chromium_III', 'Chromium (III)', 'Trivalent Chromium', NULL, 'http://vocabulary.odm2.org/variablename/chromium_III');
INSERT INTO cv_variablename VALUES ('hardnessTotal', 'Hardness, total', 'Total hardness', NULL, 'http://vocabulary.odm2.org/variablename/hardnessTotal');
INSERT INTO cv_variablename VALUES ('n_AlkaneLongChain', 'n-alkane, long-chain', 'long-chain alkanes, normal (i.e. straight chain) isomer (isomer range of alkanes measured should be specified)', NULL, 'http://vocabulary.odm2.org/variablename/n_AlkaneLongChain');
INSERT INTO cv_variablename VALUES ('aroclor_1260', 'Aroclor-1260', 'Aroclor-1260 (C12H3Cl7), a PCB mixture', NULL, 'http://vocabulary.odm2.org/variablename/aroclor_1260');
INSERT INTO cv_variablename VALUES ('2_7_Dimethylnaphthalene', '2,7-Dimethylnaphthalene', '2,7-Dimethylnaphthalene (C10H6(CH3)2), a polycyclic aromatic hydrocarbon (PAH)', NULL, 'http://vocabulary.odm2.org/variablename/2_7_Dimethylnaphthalene');
INSERT INTO cv_variablename VALUES ('baseflow', 'Baseflow', 'The portion of streamflow (discharge) that is supplied by groundwater sources.', NULL, 'http://vocabulary.odm2.org/variablename/baseflow');
INSERT INTO cv_variablename VALUES ('diatoxanthin', 'Diatoxanthin', 'The phytoplankton pigment Diatoxanthin', NULL, 'http://vocabulary.odm2.org/variablename/diatoxanthin');
INSERT INTO cv_variablename VALUES ('chromiumDistributionCoefficient', 'Chromium, distribution coefficient', 'Ratio of concentrations of chromium in two phases in equilibrium with each other. Phases must be specified.', NULL, 'http://vocabulary.odm2.org/variablename/chromiumDistributionCoefficient');
INSERT INTO cv_variablename VALUES ('bis_2_Chloroethyl_Ether', 'bis(2-Chloroethyl)ether', 'bis(2-Chloroethyl)ether (C4H8Cl2O)', NULL, 'http://vocabulary.odm2.org/variablename/bis_2_Chloroethyl_Ether');
INSERT INTO cv_variablename VALUES ('freeSRAM', 'Free SRAM', 'Device Free SRAM', NULL, NULL);


--
-- TOC entry 3386 (class 0 OID 18025)
-- Dependencies: 223
-- Data for Name: cv_variabletype; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO cv_variabletype VALUES ('rareEarthElement', 'Rare earth element', 'Variables associated with rare earth elements', NULL, 'http://vocabulary.odm2.org/variabletype/rareEarthElement');
INSERT INTO cv_variabletype VALUES ('speciationRatio', 'Speciation ratio', 'Variables associated with a speciation ratio', NULL, 'http://vocabulary.odm2.org/variabletype/speciationRatio');
INSERT INTO cv_variabletype VALUES ('Climate', 'Climate', 'Variables associated with the climate, weather, or atmospheric processes', NULL, 'http://vocabulary.odm2.org/variabletype/Climate');
INSERT INTO cv_variabletype VALUES ('uraniumSeries', 'Uranium series', 'Variables associated with uranium series', NULL, 'http://vocabulary.odm2.org/variabletype/uraniumSeries');
INSERT INTO cv_variabletype VALUES ('Biota', 'Biota', 'Variables associated with biological organisms', NULL, 'http://vocabulary.odm2.org/variabletype/Biota');
INSERT INTO cv_variabletype VALUES ('modelData', 'Model data', 'Variables associated with modeled data', NULL, 'http://vocabulary.odm2.org/variabletype/modelData');
INSERT INTO cv_variabletype VALUES ('stableIsotopes', 'Stable isotopes', 'Variables associated with stable isotopes', NULL, 'http://vocabulary.odm2.org/variabletype/stableIsotopes');
INSERT INTO cv_variabletype VALUES ('radiogenicIsotopes', 'Radiogenic isotopes', 'Variables associated with radiogenic isotopes', NULL, 'http://vocabulary.odm2.org/variabletype/radiogenicIsotopes');
INSERT INTO cv_variabletype VALUES ('traceElement', 'Trace element', 'Variables associated with trace elements', NULL, 'http://vocabulary.odm2.org/variabletype/traceElement');
INSERT INTO cv_variabletype VALUES ('Hydrology', 'Hydrology', 'Variables associated with hydrologic variables or processes', NULL, 'http://vocabulary.odm2.org/variabletype/Hydrology');
INSERT INTO cv_variabletype VALUES ('Chemistry', 'Chemistry', 'Variables associated with chemistry, chemical analysis or processes', NULL, 'http://vocabulary.odm2.org/variabletype/Chemistry');
INSERT INTO cv_variabletype VALUES ('majorOxideElement', 'Major oxide or element', 'Variables associated with major oxides or elements', NULL, 'http://vocabulary.odm2.org/variabletype/majorOxideElement');
INSERT INTO cv_variabletype VALUES ('volatile', 'Volatile', 'Variables associated with volatile chemicals', NULL, 'http://vocabulary.odm2.org/variabletype/volatile');
INSERT INTO cv_variabletype VALUES ('ratio', 'Ratio', 'Variables associated with a ratio', NULL, 'http://vocabulary.odm2.org/variabletype/ratio');
INSERT INTO cv_variabletype VALUES ('endMember', 'End-Member', 'Variables associated with end members', NULL, 'http://vocabulary.odm2.org/variabletype/endMember');
INSERT INTO cv_variabletype VALUES ('Instrumentation', 'Instrumentation', 'Variables associated with instrumentation and instrument properties such as battery voltages, data logger temperatures, often useful for diagnosis.', NULL, 'http://vocabulary.odm2.org/variabletype/Instrumentation');
INSERT INTO cv_variabletype VALUES ('rockMode', 'Rock mode', 'Variables associated with a rock mode', NULL, 'http://vocabulary.odm2.org/variabletype/rockMode');
INSERT INTO cv_variabletype VALUES ('Soil', 'Soil', 'Variables associated with soil variables or processes', NULL, 'http://vocabulary.odm2.org/variabletype/Soil');
INSERT INTO cv_variabletype VALUES ('nobleGas', 'Noble gas', 'Variables associated with noble gasses', NULL, 'http://vocabulary.odm2.org/variabletype/nobleGas');
INSERT INTO cv_variabletype VALUES ('Unknown', 'Unknown', 'The VariableType is unknown.', NULL, 'http://vocabulary.odm2.org/variabletype/Unknown');
INSERT INTO cv_variabletype VALUES ('age', 'Age', 'Variables associated with age', NULL, 'http://vocabulary.odm2.org/variabletype/age');
INSERT INTO cv_variabletype VALUES ('Geology', 'Geology', 'Variables associated with geology or geological processes', NULL, 'http://vocabulary.odm2.org/variabletype/Geology');
INSERT INTO cv_variabletype VALUES ('WaterQuality', 'Water quality', 'Variables associated with water quality variables or processes', NULL, 'http://vocabulary.odm2.org/variabletype/WaterQuality');


--
-- TOC entry 3387 (class 0 OID 18031)
-- Dependencies: 224
-- Data for Name: dataloggerfilecolumns; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO dataloggerfilecolumns VALUES (183, 54, 38, 1, 'EnviroDIY_Mayfly_Temp(degC)', '', '', NULL, NULL, NULL, NULL, NULL);
INSERT INTO dataloggerfilecolumns VALUES (184, 55, 39, 1, 'EnviroDIY_Mayfly_Temp(degC)', '', '', NULL, NULL, NULL, NULL, NULL);
INSERT INTO dataloggerfilecolumns VALUES (185, 56, 39, 1, 'EnviroDIY_Mayfly_Temp(degC)', '', '', NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 225
-- Name: dataloggerfilecolumns_dataloggerfilecolumnid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('dataloggerfilecolumns_dataloggerfilecolumnid_seq', 193, true);


--
-- TOC entry 3389 (class 0 OID 18039)
-- Dependencies: 226
-- Data for Name: dataloggerfiles; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO dataloggerfiles VALUES (1, 1, 'sdfasd', '', '');
INSERT INTO dataloggerfiles VALUES (2, 2, 'USU-UWRL', '', '');
INSERT INTO dataloggerfiles VALUES (4, 4, 'desk_sensors', '', '');
INSERT INTO dataloggerfiles VALUES (5, 5, 'GermantownFS', '', '');
INSERT INTO dataloggerfiles VALUES (6, 6, 'LaSalleE', '', '');
INSERT INTO dataloggerfiles VALUES (7, 7, 'LaSalleN', '', '');
INSERT INTO dataloggerfiles VALUES (8, 8, 'ZYU1', '', '');
INSERT INTO dataloggerfiles VALUES (9, 9, 'JRains1', '', '');
INSERT INTO dataloggerfiles VALUES (10, 10, 'JRains2', '', '');
INSERT INTO dataloggerfiles VALUES (11, 11, 'abcdabcd', '', '');
INSERT INTO dataloggerfiles VALUES (12, 12, 'FIRST-DAM', '', '');
INSERT INTO dataloggerfiles VALUES (13, 13, 'asdfs', '', '');
INSERT INTO dataloggerfiles VALUES (14, 14, 'BeaverLow', '', '');
INSERT INTO dataloggerfiles VALUES (16, 16, 'RockeyUp', '', '');
INSERT INTO dataloggerfiles VALUES (17, 17, 'RockyUp', '', '');
INSERT INTO dataloggerfiles VALUES (18, 18, 'Hurricane', '', '');
INSERT INTO dataloggerfiles VALUES (19, 19, 'EDIT_TEST', '', '');
INSERT INTO dataloggerfiles VALUES (20, 20, 'EDIT_TEST', '', '');
INSERT INTO dataloggerfiles VALUES (21, 21, 'EDIT_TEST', '', '');
INSERT INTO dataloggerfiles VALUES (22, 22, 'EDIT_SITE', '', '');
INSERT INTO dataloggerfiles VALUES (23, 23, 'NHMU9S', '', '');
INSERT INTO dataloggerfiles VALUES (24, 24, 'NHMU10S', '', '');
INSERT INTO dataloggerfiles VALUES (25, 25, 'PKCV2S', '', '');
INSERT INTO dataloggerfiles VALUES (26, 26, 'PKCV3S', '', '');
INSERT INTO dataloggerfiles VALUES (27, 27, 'NHPK7S', '', '');
INSERT INTO dataloggerfiles VALUES (28, 28, 'NHPK8S', '', '');
INSERT INTO dataloggerfiles VALUES (29, 29, 'ASITE', '', '');
INSERT INTO dataloggerfiles VALUES (15, 15, 'Ramsey', '', '');
INSERT INTO dataloggerfiles VALUES (31, 31, 'RockyLow', '', '');
INSERT INTO dataloggerfiles VALUES (32, 32, 'Casia', '', '');
INSERT INTO dataloggerfiles VALUES (33, 33, '160065_CrosslandsPond', '', '');
INSERT INTO dataloggerfiles VALUES (34, 34, '160065_4vars', '', '');
INSERT INTO dataloggerfiles VALUES (36, 36, 'TKessler2', '', '');
INSERT INTO dataloggerfiles VALUES (35, 35, '160065_Crosslands', '', '');
INSERT INTO dataloggerfiles VALUES (3, 3, 'USU-LBR-Mendon', '', '');
INSERT INTO dataloggerfiles VALUES (38, 38, 'srgd_home', '', '');
INSERT INTO dataloggerfiles VALUES (39, 39, 'srgd_desk', '', '');
INSERT INTO dataloggerfiles VALUES (40, 40, 'Anthonys_Desk', '', '');
INSERT INTO dataloggerfiles VALUES (41, 41, 'Nicks_Desk', '', '');
INSERT INTO dataloggerfiles VALUES (42, 42, 'Ben_Desk', '', '');
INSERT INTO dataloggerfiles VALUES (43, 43, 'Craig''s_Desk_Test', '', '');
INSERT INTO dataloggerfiles VALUES (44, 44, 'USU-LBR-Mendon', '', '');
INSERT INTO dataloggerfiles VALUES (45, 45, 'desk_sensors', '', '');
INSERT INTO dataloggerfiles VALUES (46, 46, 'GermantownFS', '', '');
INSERT INTO dataloggerfiles VALUES (47, 47, 'LaSalleE', '', '');
INSERT INTO dataloggerfiles VALUES (48, 48, 'LaSalleN', '', '');
INSERT INTO dataloggerfiles VALUES (49, 49, 'ZYU1', '', '');
INSERT INTO dataloggerfiles VALUES (50, 50, 'JRains1', '', '');
INSERT INTO dataloggerfiles VALUES (51, 51, 'JRains2', '', '');
INSERT INTO dataloggerfiles VALUES (52, 52, 'BeaverLow', '', '');
INSERT INTO dataloggerfiles VALUES (53, 53, 'Ramsey', '', '');
INSERT INTO dataloggerfiles VALUES (54, 54, 'RockeyUp', '', '');
INSERT INTO dataloggerfiles VALUES (55, 55, 'RockyUp', '', '');
INSERT INTO dataloggerfiles VALUES (56, 56, 'Hurricane', '', '');
INSERT INTO dataloggerfiles VALUES (57, 57, 'TESTzzz', '', '');
INSERT INTO dataloggerfiles VALUES (58, 58, 'NHMU9S', '', '');
INSERT INTO dataloggerfiles VALUES (59, 59, 'NHMU10S', '', '');
INSERT INTO dataloggerfiles VALUES (60, 60, 'PKCV2S', '', '');
INSERT INTO dataloggerfiles VALUES (61, 61, 'PKCV3S', '', '');
INSERT INTO dataloggerfiles VALUES (62, 62, 'NHPK7S', '', '');
INSERT INTO dataloggerfiles VALUES (63, 63, 'NHPK8S', '', '');
INSERT INTO dataloggerfiles VALUES (64, 64, 'RockyLow', '', '');
INSERT INTO dataloggerfiles VALUES (65, 65, 'Casia', '', '');
INSERT INTO dataloggerfiles VALUES (66, 66, '160065_CrosslandsPond', '', '');
INSERT INTO dataloggerfiles VALUES (67, 67, '160065_4vars', '', '');
INSERT INTO dataloggerfiles VALUES (68, 68, '160065_Crosslands', '', '');
INSERT INTO dataloggerfiles VALUES (69, 69, 'TKessler2', '', '');


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 227
-- Name: dataloggerfiles_dataloggerfileid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('dataloggerfiles_dataloggerfileid_seq', 69, true);


--
-- TOC entry 3391 (class 0 OID 18047)
-- Dependencies: 228
-- Data for Name: dataloggerprogramfiles; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO dataloggerprogramfiles VALUES (1, 42, 'sdfasd data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (2, 46, 'USU-UWRL data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (4, 45, 'desk_sensors data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (5, 54, 'GermantownFS data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (6, 55, 'LaSalleE data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (7, 55, 'LaSalleN data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (8, 56, 'ZYU1 data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (9, 57, 'JRains1 data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (10, 57, 'JRains2 data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (11, 40, 'abcdabcd data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (12, 42, 'FIRST-DAM data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (13, 42, 'asdfs data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (14, 58, 'BeaverLow data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (16, 58, 'RockeyUp data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (17, 58, 'RockyUp data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (18, 58, 'Hurricane data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (19, 42, 'EDIT_TEST data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (20, 42, 'EDIT_TEST data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (21, 42, 'EDIT_TEST data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (22, 42, 'EDIT_SITE data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (23, 59, 'NHMU9S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (24, 59, 'NHMU10S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (25, 60, 'PKCV2S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (26, 60, 'PKCV3S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (27, 61, 'NHPK7S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (28, 61, 'NHPK8S data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (29, 42, 'ASITE data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (15, 58, 'Ramsey data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (31, 58, 'RockyLow data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (32, 58, 'Casia data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (33, 39, '160065_CrosslandsPond data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (34, 39, '160065_4vars data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (36, 54, 'TKessler2 data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (35, 64, '160065_Crosslands data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (3, 46, 'USU-LBR-Mendon data collection', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (38, 45, 'srgd_home', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (39, 45, 'srgd_desk', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (40, 39, 'Anthonys_Desk', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (41, 48, 'Nicks_Desk', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (42, 49, 'Ben_Desk', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (43, 50, 'Craig''s_Desk_Test', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (44, 46, 'USU-LBR-Mendon', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (45, 45, 'desk_sensors', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (46, 54, 'GermantownFS', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (47, 55, 'LaSalleE', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (48, 55, 'LaSalleN', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (49, 56, 'ZYU1', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (50, 57, 'JRains1', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (51, 57, 'JRains2', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (52, 58, 'BeaverLow', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (53, 58, 'Ramsey', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (54, 58, 'RockeyUp', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (55, 58, 'RockyUp', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (56, 58, 'Hurricane', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (57, 42, 'TESTzzz', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (58, 59, 'NHMU9S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (59, 59, 'NHMU10S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (60, 60, 'PKCV2S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (61, 60, 'PKCV3S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (62, 61, 'NHPK7S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (63, 61, 'NHPK8S', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (64, 58, 'RockyLow', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (65, 58, 'Casia', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (66, 39, '160065_CrosslandsPond', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (67, 39, '160065_4vars', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (68, 64, '160065_Crosslands', '', '', '');
INSERT INTO dataloggerprogramfiles VALUES (69, 54, 'TKessler2', '', '', '');


--
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 229
-- Name: dataloggerprogramfiles_programid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('dataloggerprogramfiles_programid_seq', 69, true);


--
-- TOC entry 3393 (class 0 OID 18055)
-- Dependencies: 230
-- Data for Name: dataquality; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3394 (class 0 OID 18061)
-- Dependencies: 231
-- Data for Name: datasetcitations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 232
-- Name: datasetcitations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('datasetcitations_bridgeid_seq', 1, false);


--
-- TOC entry 3396 (class 0 OID 18066)
-- Dependencies: 233
-- Data for Name: datasets; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 234
-- Name: datasets_datasetid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('datasets_datasetid_seq', 1, false);


--
-- TOC entry 3398 (class 0 OID 18074)
-- Dependencies: 235
-- Data for Name: datasetsresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 236
-- Name: datasetsresults_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('datasetsresults_bridgeid_seq', 1, false);


--
-- TOC entry 3400 (class 0 OID 18079)
-- Dependencies: 237
-- Data for Name: derivationequations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 238
-- Name: derivationequations_derivationequationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('derivationequations_derivationequationid_seq', 1, false);


--
-- TOC entry 3402 (class 0 OID 18084)
-- Dependencies: 239
-- Data for Name: directives; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 240
-- Name: directives_directiveid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('directives_directiveid_seq', 1, false);


--
-- TOC entry 3404 (class 0 OID 18092)
-- Dependencies: 241
-- Data for Name: equipment; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 242
-- Name: equipment_equipmentid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('equipment_equipmentid_seq', 1, false);


--
-- TOC entry 3406 (class 0 OID 18100)
-- Dependencies: 243
-- Data for Name: equipmentannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 244
-- Name: equipmentannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('equipmentannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3408 (class 0 OID 18105)
-- Dependencies: 245
-- Data for Name: equipmentmodels; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO equipmentmodels VALUES (1, 25, 'Mayfly', 'Mayfly Data Logger', NULL, true, NULL, 'http://envirodiy.org/mayfly/');
INSERT INTO equipmentmodels VALUES (2, 26, 'CTD-10', 'CTD-10 Electrical Conductivity Temperature Depth Sensor', NULL, true, NULL, 'http://www.decagon.com/en/hydrology/water-level-temperature-electrical-conductivity/ctd-10-sensor-electrical-conductivity-temperature-depth/');
INSERT INTO equipmentmodels VALUES (3, 26, '5TM', '5TM Soil Moisture Sensor', NULL, true, NULL, 'https://www.decagon.com/en/soils/volumetric-water-content-sensors/5tm-vwc-temp/');
INSERT INTO equipmentmodels VALUES (4, 27, 'OBS-3+', 'OBS-3+ Turbidity Sensor', NULL, true, NULL, 'https://www.campbellsci.com/obs-3plus');
INSERT INTO equipmentmodels VALUES (5, 26, 'ES-2', 'ES-2 Electrical Conductivity Sensor', NULL, true, NULL, 'http://www.decagon.com/en/hydrology/water-level-temperature-electrical-conductivity/es-2-electrical-conductivity-temperature/');
INSERT INTO equipmentmodels VALUES (6, 50, 'MB7386', 'HRXL-MaxSonar®-WRLT', NULL, true, NULL, 'http://www.maxbotix.com/documents/HRXL-MaxSonar-WR_Datasheet.pdf');
INSERT INTO equipmentmodels VALUES (7, 50, 'MB7389', 'HRXL-MaxSonar®-WRMT', NULL, true, NULL, 'http://www.maxbotix.com/documents/HRXL-MaxSonar-WR_Datasheet.pdf');
INSERT INTO equipmentmodels VALUES (8, 51, 'DS18B20', 'DS18B20 Waterproof Digital temperature sensor ', NULL, true, NULL, 'https://www.adafruit.com/products/381');
INSERT INTO equipmentmodels VALUES (9, 51, 'AM2315', 'AM2315 - Encased I2C Temperature/Humidity Sensor', NULL, true, NULL, 'https://www.adafruit.com/products/1293');
INSERT INTO equipmentmodels VALUES (10, 52, 'DHT22', 'DHT22 Digital Humidity Temperature Pro Grove Sensor', NULL, true, NULL, 'http://wiki.seeed.cc/Grove-Temperature_and_Humidity_Sensor_Pro/');
INSERT INTO equipmentmodels VALUES (11, 52, 'DHT11', 'DHT11 Digital Humidity Temperature Grove Sensor', NULL, true, NULL, 'https://www.seeedstudio.com/Grove-Temp%26Humi-Sensor-p-745.html');
INSERT INTO equipmentmodels VALUES (12, 52, 'BME280', 'BME280 Barometer Humidity Temperature Grove Sensor', NULL, true, NULL, 'http://wiki.seeed.cc/Grove-Barometer_Sensor-BME280/');
INSERT INTO equipmentmodels VALUES (13, 53, 'SQ-212', 'SQ-212: Amplified 0-2.5 Volt Sun Calibration Quantum Sensor', NULL, true, NULL, 'http://www.apogeeinstruments.com/sq-212-amplified-0-2-5-volt-sun-calibration-quantum-sensor/');


--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 246
-- Name: equipmentmodels_equipmentmodelid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('equipmentmodels_equipmentmodelid_seq', 14, true);


--
-- TOC entry 3410 (class 0 OID 18113)
-- Dependencies: 247
-- Data for Name: equipmentused; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 248
-- Name: equipmentused_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('equipmentused_bridgeid_seq', 1, false);


--
-- TOC entry 3412 (class 0 OID 18118)
-- Dependencies: 249
-- Data for Name: extensionproperties; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 250
-- Name: extensionproperties_propertyid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('extensionproperties_propertyid_seq', 1, false);


--
-- TOC entry 3414 (class 0 OID 18126)
-- Dependencies: 251
-- Data for Name: externalidentifiersystems; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 252
-- Name: externalidentifiersystems_externalidentifiersystemid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('externalidentifiersystems_externalidentifiersystemid_seq', 1, false);


--
-- TOC entry 3416 (class 0 OID 18134)
-- Dependencies: 253
-- Data for Name: featureactions; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO featureactions VALUES (59, 65, 59);
INSERT INTO featureactions VALUES (60, 65, 60);
INSERT INTO featureactions VALUES (61, 66, 61);
INSERT INTO featureactions VALUES (62, 67, 62);
INSERT INTO featureactions VALUES (63, 67, 63);
INSERT INTO featureactions VALUES (64, 67, 64);
INSERT INTO featureactions VALUES (65, 67, 65);
INSERT INTO featureactions VALUES (66, 70, 66);
INSERT INTO featureactions VALUES (67, 70, 67);
INSERT INTO featureactions VALUES (68, 71, 68);
INSERT INTO featureactions VALUES (69, 72, 69);
INSERT INTO featureactions VALUES (70, 72, 70);


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 254
-- Name: featureactions_featureactionid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('featureactions_featureactionid_seq', 313, true);


--
-- TOC entry 3418 (class 0 OID 18139)
-- Dependencies: 255
-- Data for Name: instrumentoutputvariables; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO instrumentoutputvariables VALUES (1, 1, 10, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (3, 2, 11, 2, NULL, NULL, 366);
INSERT INTO instrumentoutputvariables VALUES (4, 2, 12, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (5, 2, 13, 2, NULL, NULL, 367);
INSERT INTO instrumentoutputvariables VALUES (6, 4, 14, 2, NULL, NULL, 364);
INSERT INTO instrumentoutputvariables VALUES (7, 3, 15, 2, NULL, NULL, 368);
INSERT INTO instrumentoutputvariables VALUES (8, 3, 16, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (10, 1, 10, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (11, 1, 21, 2, NULL, NULL, 369);
INSERT INTO instrumentoutputvariables VALUES (12, 1, 22, 2, NULL, NULL, 370);
INSERT INTO instrumentoutputvariables VALUES (13, 2, 11, 2, NULL, NULL, 373);
INSERT INTO instrumentoutputvariables VALUES (14, 2, 12, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (15, 5, 23, 2, NULL, NULL, 366);
INSERT INTO instrumentoutputvariables VALUES (16, 5, 23, 2, NULL, NULL, 373);
INSERT INTO instrumentoutputvariables VALUES (17, 5, 24, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (18, 5, 24, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (19, 6, 37, 2, NULL, NULL, 367);
INSERT INTO instrumentoutputvariables VALUES (20, 7, 38, 2, NULL, NULL, 367);
INSERT INTO instrumentoutputvariables VALUES (21, 8, 39, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (22, 8, 39, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (23, 9, 40, 2, NULL, NULL, 368);
INSERT INTO instrumentoutputvariables VALUES (24, 9, 41, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (25, 9, 41, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (26, 10, 42, 2, NULL, NULL, 368);
INSERT INTO instrumentoutputvariables VALUES (27, 10, 43, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (28, 10, 43, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (29, 11, 44, 2, NULL, NULL, 368);
INSERT INTO instrumentoutputvariables VALUES (30, 11, 45, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (31, 11, 45, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (32, 13, 46, 2, NULL, NULL, 371);
INSERT INTO instrumentoutputvariables VALUES (33, 12, 47, 2, NULL, NULL, 368);
INSERT INTO instrumentoutputvariables VALUES (34, 12, 48, 2, NULL, NULL, 362);
INSERT INTO instrumentoutputvariables VALUES (35, 12, 48, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (36, 3, 16, 2, NULL, NULL, 372);
INSERT INTO instrumentoutputvariables VALUES (37, 3, 50, 2, NULL, NULL, 375);


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 256
-- Name: instrumentoutputvariables_instrumentoutputvariableid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('instrumentoutputvariables_instrumentoutputvariableid_seq', 38, true);


--
-- TOC entry 3420 (class 0 OID 18147)
-- Dependencies: 257
-- Data for Name: maintenanceactions; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3421 (class 0 OID 18153)
-- Dependencies: 258
-- Data for Name: measurementresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3422 (class 0 OID 18159)
-- Dependencies: 259
-- Data for Name: measurementresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 260
-- Name: measurementresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('measurementresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3424 (class 0 OID 18164)
-- Dependencies: 261
-- Data for Name: measurementresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 262
-- Name: measurementresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('measurementresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3426 (class 0 OID 18169)
-- Dependencies: 263
-- Data for Name: methodannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 264
-- Name: methodannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('methodannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3428 (class 0 OID 18174)
-- Dependencies: 265
-- Data for Name: methodcitations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 266
-- Name: methodcitations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('methodcitations_bridgeid_seq', 1, false);


--
-- TOC entry 3430 (class 0 OID 18179)
-- Dependencies: 267
-- Data for Name: methodextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 268
-- Name: methodextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('methodextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3432 (class 0 OID 18184)
-- Dependencies: 269
-- Data for Name: methodexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 270
-- Name: methodexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('methodexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3434 (class 0 OID 18192)
-- Dependencies: 271
-- Data for Name: methods; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO methods VALUES (2, 'Instrument deployment', 'Sensor', 'Environment time series values recorded using an in situ sensor.', NULL, NULL, NULL);


--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 272
-- Name: methods_methodid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('methods_methodid_seq', 3, true);


--
-- TOC entry 3436 (class 0 OID 18200)
-- Dependencies: 273
-- Data for Name: modelaffiliations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 274
-- Name: modelaffiliations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('modelaffiliations_bridgeid_seq', 1, false);


--
-- TOC entry 3438 (class 0 OID 18208)
-- Dependencies: 275
-- Data for Name: models; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 276
-- Name: models_modelid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('models_modelid_seq', 1, false);


--
-- TOC entry 3440 (class 0 OID 18216)
-- Dependencies: 277
-- Data for Name: organizations; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO organizations VALUES (25, 'Manufacturer', 'EnviroDIY', 'EnviroDIY', '', NULL, NULL);
INSERT INTO organizations VALUES (26, 'Manufacturer', 'Decagon', 'Decagon Devices', NULL, NULL, NULL);
INSERT INTO organizations VALUES (27, 'Manufacturer', 'Campbell', 'Campbell Scientific', NULL, NULL, NULL);
INSERT INTO organizations VALUES (47, 'Company', 'LimnoTech', 'LimnoTech', 'Water Environment | Scientists Engineers', '', NULL);
INSERT INTO organizations VALUES (48, 'Research organization', 'UWRL', 'Utah Water Research Laboratory', '', '', NULL);
INSERT INTO organizations VALUES (49, 'Research institute', 'SWRC', 'Stroud Water Research Center', 'Since 1967, Stroud™ Water Research Center has been focused on one thing — fresh water. We are dedicated to understanding the ecology of streams, rivers, and their watersheds — both pristine and polluted.', '', NULL);
INSERT INTO organizations VALUES (50, 'Manufacturer', 'MaxBotix', 'MaxBotix', NULL, NULL, NULL);
INSERT INTO organizations VALUES (51, 'Manufacturer', 'Adafruit', 'Adafruit', NULL, NULL, NULL);
INSERT INTO organizations VALUES (52, 'Manufacturer', 'Seeed', 'Seeed Studio', NULL, NULL, NULL);
INSERT INTO organizations VALUES (53, 'Manufacturer', 'Apogee', 'Apogee Instruments', NULL, NULL, NULL);
INSERT INTO organizations VALUES (54, 'Consortium', 'SBN', 'Sustainable Business Network of Greater Philadelphia', 'The Sustainable Business Network is a community of local businesses and individuals committed to building a just, thriving, and sustainable economy in the Greater Philadelphia region.', '', NULL);
INSERT INTO organizations VALUES (55, 'Association', 'TNC', 'The Nature Conservancy', 'The Nature Conservancy is the leading conservation organization working around the world to protect ecologically important lands and waters for nature and people.', '', NULL);
INSERT INTO organizations VALUES (56, 'Association', 'MWA', 'Musconetcong Watershed Association', 'The Musconetcong Watershed Association (MWA) is an independent, non-profit organization dedicated to protecting and improving the quality of the Musconetcong River and its Watershed, including its natural and cultural resources.', '', NULL);
INSERT INTO organizations VALUES (57, 'University', 'ESU', 'East Stroudsburg University', 'ESU is a comprehensive university in northeastern Pennsylvania offering 55 undergraduate and 22 graduate degrees and is one of the 14 institutions in the Pennsylvania State System of Higher Education.', '', NULL);
INSERT INTO organizations VALUES (59, 'University', 'UofU', 'University of Utah', '', '', NULL);


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 278
-- Name: organizations_organizationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('organizations_organizationid_seq', 59, true);


--
-- TOC entry 3442 (class 0 OID 18224)
-- Dependencies: 279
-- Data for Name: people; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO people VALUES (41, 'Mauriel', '', 'Ramirez');
INSERT INTO people VALUES (42, 'Juan', '', 'Caraballo');
INSERT INTO people VALUES (43, 'Anthony', '', 'Aufdenkampe');
INSERT INTO people VALUES (44, 'Mario', '', 'Matos');
INSERT INTO people VALUES (45, 'Mikaila', '', 'Young');
INSERT INTO people VALUES (46, 'Shannon', '', 'Hicks');
INSERT INTO people VALUES (47, 'Sara', '', 'Damiano');
INSERT INTO people VALUES (48, 'Jeff', '', 'Horsburgh');
INSERT INTO people VALUES (49, 'David', '', 'Arscott');
INSERT INTO people VALUES (50, 'Nick', '', 'Grewe');
INSERT INTO people VALUES (51, 'Benjamin', '', 'Crary');
INSERT INTO people VALUES (52, 'Craig', '', 'Taylor');
INSERT INTO people VALUES (53, 'Beth', '', 'Fisher');
INSERT INTO people VALUES (54, 'Miguel', '', 'Leon');
INSERT INTO people VALUES (55, 'Sara', '', 'Damiano');
INSERT INTO people VALUES (56, 'Toby', '', 'Kessler');
INSERT INTO people VALUES (57, 'Dennis', '', 'Shelly');
INSERT INTO people VALUES (58, 'Ziwen', '', 'Yu');
INSERT INTO people VALUES (59, 'John', '', 'Rains');
INSERT INTO people VALUES (1, 'Kenneth', '', 'FryarLudwig');
INSERT INTO people VALUES (60, 'Kim', '', 'Hachadoorian');
INSERT INTO people VALUES (61, 'Nancy', '', 'Lawler');
INSERT INTO people VALUES (62, 'Paul', '', 'Wilson');
INSERT INTO people VALUES (63, 'Michelle', '', 'DiBlasio');
INSERT INTO people VALUES (65, 'Dave', '', 'Eiriksson');
INSERT INTO people VALUES (66, 'LimnoTech', '', 'CRO');
INSERT INTO people VALUES (67, 'Kenneth', '', 'Fryar-Ludwig');


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 280
-- Name: people_personid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('people_personid_seq', 67, true);


--
-- TOC entry 3444 (class 0 OID 18232)
-- Dependencies: 281
-- Data for Name: personexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 282
-- Name: personexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('personexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3446 (class 0 OID 18240)
-- Dependencies: 283
-- Data for Name: pointcoverageresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3447 (class 0 OID 18243)
-- Dependencies: 284
-- Data for Name: pointcoverageresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 285
-- Name: pointcoverageresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('pointcoverageresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3449 (class 0 OID 18248)
-- Dependencies: 286
-- Data for Name: pointcoverageresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 287
-- Name: pointcoverageresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('pointcoverageresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3451 (class 0 OID 18256)
-- Dependencies: 288
-- Data for Name: processinglevels; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO processinglevels VALUES (1, 'Raw', 'Raw Data', NULL);


--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 289
-- Name: processinglevels_processinglevelid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('processinglevels_processinglevelid_seq', 2, true);


--
-- TOC entry 3453 (class 0 OID 18264)
-- Dependencies: 290
-- Data for Name: profileresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3454 (class 0 OID 18267)
-- Dependencies: 291
-- Data for Name: profileresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 292
-- Name: profileresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('profileresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3456 (class 0 OID 18272)
-- Dependencies: 293
-- Data for Name: profileresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 294
-- Name: profileresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('profileresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3458 (class 0 OID 18280)
-- Dependencies: 295
-- Data for Name: referencematerialexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 296
-- Name: referencematerialexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('referencematerialexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3460 (class 0 OID 18288)
-- Dependencies: 297
-- Data for Name: referencematerials; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 298
-- Name: referencematerials_referencematerialid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('referencematerials_referencematerialid_seq', 1, false);


--
-- TOC entry 3462 (class 0 OID 18296)
-- Dependencies: 299
-- Data for Name: referencematerialvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 300
-- Name: referencematerialvalues_referencematerialvalueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('referencematerialvalues_referencematerialvalueid_seq', 1, false);


--
-- TOC entry 3464 (class 0 OID 18301)
-- Dependencies: 301
-- Data for Name: relatedactions; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 302
-- Name: relatedactions_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedactions_relationid_seq', 1, false);


--
-- TOC entry 3466 (class 0 OID 18306)
-- Dependencies: 303
-- Data for Name: relatedannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 304
-- Name: relatedannotations_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedannotations_relationid_seq', 1, false);


--
-- TOC entry 3468 (class 0 OID 18311)
-- Dependencies: 305
-- Data for Name: relatedcitations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 306
-- Name: relatedcitations_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedcitations_relationid_seq', 1, false);


--
-- TOC entry 3470 (class 0 OID 18316)
-- Dependencies: 307
-- Data for Name: relateddatasets; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 308
-- Name: relateddatasets_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relateddatasets_relationid_seq', 1, false);


--
-- TOC entry 3472 (class 0 OID 18321)
-- Dependencies: 309
-- Data for Name: relatedequipment; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 310
-- Name: relatedequipment_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedequipment_relationid_seq', 1, false);


--
-- TOC entry 3474 (class 0 OID 18326)
-- Dependencies: 311
-- Data for Name: relatedfeatures; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 312
-- Name: relatedfeatures_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedfeatures_relationid_seq', 1, false);


--
-- TOC entry 3476 (class 0 OID 18331)
-- Dependencies: 313
-- Data for Name: relatedmodels; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 314
-- Name: relatedmodels_relatedid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedmodels_relatedid_seq', 1, false);


--
-- TOC entry 3478 (class 0 OID 18336)
-- Dependencies: 315
-- Data for Name: relatedresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 316
-- Name: relatedresults_relationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('relatedresults_relationid_seq', 1, false);


--
-- TOC entry 3480 (class 0 OID 18341)
-- Dependencies: 317
-- Data for Name: resultannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 318
-- Name: resultannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('resultannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3482 (class 0 OID 18346)
-- Dependencies: 319
-- Data for Name: resultderivationequations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3483 (class 0 OID 18349)
-- Dependencies: 320
-- Data for Name: resultextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 321
-- Name: resultextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('resultextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3485 (class 0 OID 18354)
-- Dependencies: 322
-- Data for Name: resultnormalizationvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3486 (class 0 OID 18357)
-- Dependencies: 323
-- Data for Name: results; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO results VALUES (45, 'a6f114f1-5416-4606-ae10-23be32dbc202', 59, 'Time series coverage', 10, 362, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Liquid aqueous', 0);
INSERT INTO results VALUES (46, '5396fdf3-ceb3-46b6-aaf9-454a37278bb4', 60, 'Time series coverage', 12, 362, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Air', 0);
INSERT INTO results VALUES (47, 'd20b0be1-753a-414c-950a-29f4bb1959ef', 61, 'Time series coverage', 16, 362, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Liquid aqueous', 0);
INSERT INTO results VALUES (48, '7cf27639-a6c7-4a6a-84c3-6689a60fa683', 62, 'Time series coverage', 10, 362, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Air', 0);
INSERT INTO results VALUES (49, 'e1555cfc-6d04-477e-a018-97fe3e1f1885', 63, 'Time series coverage', 13, 367, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Liquid aqueous', 0);
INSERT INTO results VALUES (50, '6cbfafa0-617e-4762-9220-7c4274aa783f', 64, 'Time series coverage', 12, 362, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Liquid aqueous', 0);
INSERT INTO results VALUES (51, 'b87cb6ce-2667-411b-a24f-a68383a83359', 65, 'Time series coverage', 11, 366, NULL, 1, NULL, NULL, NULL, NULL, 'Ongoing', 'Liquid aqueous', 0);
INSERT INTO results VALUES (52, 'f8fbf90e-f59d-4736-af66-91fbee455433', 66, 'Time series coverage', 10, 362, NULL, 1, '2017-01-26 19:29:00', -7, NULL, NULL, 'Ongoing', 'Air', 1);
INSERT INTO results VALUES (53, '52e6d5ce-eca1-4545-9b01-607a487cbfc0', 67, 'Time series coverage', 14, 364, NULL, 1, '2017-01-26 19:29:00', -7, NULL, NULL, 'Ongoing', 'Liquid aqueous', 1);
INSERT INTO results VALUES (54, 'a76b27aa-489b-435a-bd49-d4c81968eaca', 68, 'Time series coverage', 10, 362, NULL, 1, '2017-02-07 02:21:00', -7, NULL, NULL, 'Ongoing', 'Air', 140);
INSERT INTO results VALUES (55, 'fec11d32-0658-4ef0-8a27-bdffa2104e31', 69, 'Time series coverage', 10, 362, NULL, 1, '2017-02-20 04:57:00', -5, NULL, NULL, 'Ongoing', 'Air', 432);
INSERT INTO results VALUES (56, 'a7329b1b-b002-4fa8-afba-ae83b82ab8e9', 70, 'Time series coverage', 10, 362, NULL, 1, '2017-02-20 04:57:00', -5, NULL, NULL, 'Ongoing', 'Air', 432);


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 324
-- Name: results_resultid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('results_resultid_seq', 299, true);


--
-- TOC entry 3488 (class 0 OID 18365)
-- Dependencies: 325
-- Data for Name: resultsdataquality; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 326
-- Name: resultsdataquality_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('resultsdataquality_bridgeid_seq', 1, false);


--
-- TOC entry 3490 (class 0 OID 18370)
-- Dependencies: 327
-- Data for Name: samplingfeatureannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 328
-- Name: samplingfeatureannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('samplingfeatureannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3492 (class 0 OID 18375)
-- Dependencies: 329
-- Data for Name: samplingfeatureextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 330
-- Name: samplingfeatureextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('samplingfeatureextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3494 (class 0 OID 18380)
-- Dependencies: 331
-- Data for Name: samplingfeatureexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 332
-- Name: samplingfeatureexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('samplingfeatureexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3496 (class 0 OID 18388)
-- Dependencies: 333
-- Data for Name: samplingfeatures; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO samplingfeatures VALUES (65, 'bc2170f1-d931-41be-9172-16a53011286e', 'Site', 'HOME', 'Juans House', '', NULL, NULL, NULL, 47, 'MSL');
INSERT INTO samplingfeatures VALUES (66, 'f1bb5243-bba0-4542-8f38-a9b763d3709a', 'Site', 'Test', 'Testing', '', NULL, NULL, NULL, 862, 'MSL');
INSERT INTO samplingfeatures VALUES (67, 'c07ea02f-0734-45a5-9f38-063bda8e6e92', 'Site', 'SDH_test1', 'Mayfly test stuff #1', '', NULL, NULL, NULL, 107, 'MSL');
INSERT INTO samplingfeatures VALUES (70, 'f319af6a-3091-4070-b3ad-a606a7fdbed4', 'Site', 'JHDR', 'Juan''s House in the DR', '', NULL, NULL, NULL, 40, 'MSL');
INSERT INTO samplingfeatures VALUES (71, '1aa8f9f7-e5b5-4942-8b2d-a8b44fd93efb', 'Site', 'srgd_home', 'Sara''s House', '', NULL, NULL, NULL, 168, 'MSL');
INSERT INTO samplingfeatures VALUES (72, '39bf098f-d11d-4ea6-9be3-6a073969b019', 'Site', 'srgd_desk', 'Sara''s Desk at Stroud', '', NULL, NULL, NULL, 105, 'MSL');
INSERT INTO samplingfeatures VALUES (73, '63afe80f-a041-44d6-9df7-52775e973802', 'Site', 'srgd_mass_test', 'test', '', NULL, NULL, NULL, 167, 'MSL');
INSERT INTO samplingfeatures VALUES (74, 'b5125363-1f8a-41f6-b72a-5f925f99c977', 'Site', 'Anthonys_Desk', 'Anthony''s Desk at LimnoTech in Oakdale MN', '', NULL, NULL, NULL, 313, 'MSL');
INSERT INTO samplingfeatures VALUES (75, '5a2a80c6-e4b4-4647-b51a-0034c9c938de', 'Site', 'Nicks_Desk', 'Nick''s Desk at LimnoTech', '', NULL, NULL, NULL, 313, 'MSL');
INSERT INTO samplingfeatures VALUES (76, 'de6e700a-6e95-4744-9c4e-a11d6e959d9d', 'Site', 'Ben_Desk', 'Ben''s desk', '', NULL, NULL, NULL, 314, 'MSL');
INSERT INTO samplingfeatures VALUES (77, 'f92c259a-7627-414e-850d-82e6ea76584d', 'Site', 'Craig''s_Desk_Test', 'Craig''s Desk at LimnoTech', '', NULL, NULL, NULL, 317, 'NAVD88');
INSERT INTO samplingfeatures VALUES (78, 'bce79280-ea09-49a2-8add-c53522b1ea9b', 'Site', 'sdfasd', 'fasdfasdf', '', NULL, NULL, NULL, 1863, 'MSL');
INSERT INTO samplingfeatures VALUES (79, '38f842a1-bd5c-49ac-ab67-243a7e2310e8', 'Site', 'USU-UWRL', 'Utah Water Research Laboratory', '', NULL, NULL, NULL, 1424, 'MSL');
INSERT INTO samplingfeatures VALUES (81, '80f6daff-df8a-4782-9fcc-be43ea37ee0d', 'Site', 'desk_sensors', 'Sara''s Desk at Stroud', '', NULL, NULL, NULL, 104, 'MSL');
INSERT INTO samplingfeatures VALUES (82, 'ac1b9d1b-cb5b-447a-9c19-0bc048c1fd31', 'Site', 'GermantownFS', 'Germantown Friends School', '', NULL, NULL, NULL, 70, 'MSL');
INSERT INTO samplingfeatures VALUES (83, '1e6fd7a6-1c5e-4132-bf36-12db58d4a1f2', 'Site', 'LaSalleE', 'Eastern Rain Garden at La Salle University', '', NULL, NULL, NULL, 45, 'MSL');
INSERT INTO samplingfeatures VALUES (84, 'a9d407f5-0796-467e-9325-91e3a9b902c5', 'Site', 'LaSalleN', 'Northern Rain Garden at La Salle University', '', NULL, NULL, NULL, 45, 'MSL');
INSERT INTO samplingfeatures VALUES (85, '9ae0ba81-242a-4086-a03c-c78924067029', 'Site', 'ZYU1', 'ZYU1', '', NULL, NULL, NULL, 21, 'MSL');
INSERT INTO samplingfeatures VALUES (86, 'd97618bc-fa62-4560-a15c-34e0a7481c8f', 'Site', 'JRains1', 'JRains1', '', NULL, NULL, NULL, 16, 'MSL');
INSERT INTO samplingfeatures VALUES (87, '7ec52878-96bf-469a-96cf-4feea709cfa8', 'Site', 'JRains2', 'JRains2', '', NULL, NULL, NULL, 14, 'MSL');
INSERT INTO samplingfeatures VALUES (88, 'b3249666-7e94-4575-8010-dccc64ee7bec', 'Site', 'abcdabcd', 'Click on the map', '', NULL, NULL, NULL, 1391, 'MSL');
INSERT INTO samplingfeatures VALUES (89, '88fd0a70-cf7f-458b-abd6-4b499065681a', 'Site', 'FIRST-DAM', 'First Dam', '', NULL, NULL, NULL, 1449, 'MSL');
INSERT INTO samplingfeatures VALUES (90, 'f269dd77-0130-4f28-bd5b-be223f6c7736', 'Site', 'asdfs', 'qwerqwer', '', NULL, NULL, NULL, 2049, 'MSL');
INSERT INTO samplingfeatures VALUES (1, 'acccafeb-3fc5-464d-a12b-a2bfb0b95bce', 'Site', 'T_1_Machine', 'This_Is_A_Test_Site', '', NULL, NULL, NULL, 2010, 'MSL');
INSERT INTO samplingfeatures VALUES (93, '85d2450f-a802-4c4f-8664-be32277d3c08', 'Site', 'Ramsey', 'Ramsey Run', '', NULL, NULL, NULL, 47, 'MSL');
INSERT INTO samplingfeatures VALUES (94, 'fd76cc32-d212-465e-8db5-003e42ce18fe', 'Site', 'RockeyUp', 'Upper Rockey Run', '', NULL, NULL, NULL, 120, 'MSL');
INSERT INTO samplingfeatures VALUES (96, '801ded41-27db-4b41-b6ef-f28cba1d854e', 'Site', 'RockyUp', 'Upper Rocky Run', '', NULL, NULL, NULL, 120, 'MSL');
INSERT INTO samplingfeatures VALUES (97, 'c76fa21c-2897-4acd-9c8a-6b0a9087ea77', 'Site', 'Hurricane', 'Hurricane Run', '', NULL, NULL, NULL, 108, 'MSL');
INSERT INTO samplingfeatures VALUES (98, '834873de-cd10-457c-9f08-f4e33052ce9d', 'Site', 'TESTzzz', 'Edit Testzzzzz', '', NULL, NULL, NULL, 1381, 'MSL');
INSERT INTO samplingfeatures VALUES (100, '3261984e-0cdd-4790-8ebe-b7f6727b776b', 'Site', 'EDIT_SITE', 'Edit Site', '', NULL, NULL, NULL, 1352, 'MSL');
INSERT INTO samplingfeatures VALUES (101, 'd718b3db-698c-4879-94ff-4a9db81872e2', 'Site', 'NHMU9S', 'Musconetcong River at Waterloo Road', '', NULL, NULL, NULL, 245, 'MSL');
INSERT INTO samplingfeatures VALUES (102, '9bbf3f0d-8320-4edf-b646-92eba6700197', 'Site', 'NHMU10S', 'Musconetcong River at Drainway', '', NULL, NULL, NULL, 221, 'MSL');
INSERT INTO samplingfeatures VALUES (103, 'cf15a63f-fae1-4cc5-8afd-54c3c82ae837', 'Site', 'PKCV2S', 'Cherry Creek Downstream', '', NULL, NULL, NULL, 105, 'MSL');
INSERT INTO samplingfeatures VALUES (104, '59884b0e-0632-4696-9087-bfc3bf8ac2b9', 'Site', 'PKCV3S', 'Cherry Creek Upstream', '', NULL, NULL, NULL, 108, 'MSL');
INSERT INTO samplingfeatures VALUES (105, '90c42d9b-d70f-4faf-bfb6-af9578df83f5', 'Site', 'NHPK7S', 'Paulins Kill Upstream', '', NULL, NULL, NULL, 174, 'MSL');
INSERT INTO samplingfeatures VALUES (106, 'f1099607-e03e-44db-8723-a8a6353f8f5b', 'Site', 'NHPK8S', 'Paulins Kill Downstream', '', NULL, NULL, NULL, 172, 'MSL');
INSERT INTO samplingfeatures VALUES (107, '0b67e24d-ce49-42e5-b653-2f0564819371', 'Site', 'ASITE', 'A Site', '', NULL, NULL, NULL, 216, 'MSL');
INSERT INTO samplingfeatures VALUES (92, '262a23e4-a189-4b88-a4a1-638ec2dceff6', 'Site', 'BeaverLow', 'Lower Beaver Creek', '', NULL, NULL, NULL, 59, 'MSL');
INSERT INTO samplingfeatures VALUES (109, '0714ded4-69b0-4470-ae1d-ac2df49714b7', 'Site', 'RockyLow', 'Lower Rocky Run', '', NULL, NULL, NULL, 49, 'MSL');
INSERT INTO samplingfeatures VALUES (110, '27b0e58f-50bd-41da-bd94-16d2069c39e3', 'Site', 'Casia', 'Casia Creek', '', NULL, NULL, NULL, 73, 'MSL');
INSERT INTO samplingfeatures VALUES (111, '5d70fa1f-ecca-4983-9c3a-711fd15ee587', 'Site', '160065_CrosslandsPond', '160065_CrosslandsPond', '', NULL, NULL, NULL, 311, 'MSL');
INSERT INTO samplingfeatures VALUES (112, '20fc5d26-3770-4c1e-9f30-a0d6c56cf2ef', 'Site', '160065_4vars', '160065 Crosslands Pond with 4 variables', '', NULL, NULL, NULL, NULL, 'MSL');
INSERT INTO samplingfeatures VALUES (114, '39ee8d9c-18fd-4c9e-bb05-d35dd6016bdb', 'Site', 'TKessler2', 'TKessler2', '', NULL, NULL, NULL, 75, 'MSL');
INSERT INTO samplingfeatures VALUES (113, '88ec00f8-02a7-4946-8544-fa0b715873dc', 'Site', '160065_Crosslands', '160065 CrosslandsPond - 10 variables', '', NULL, NULL, NULL, NULL, 'MSL');
INSERT INTO samplingfeatures VALUES (80, '5bf2f650-b5bb-4ebb-8128-1c1c7fd622c1', 'Site', 'USU-LBR-Mendon', 'Little Bear River at Mendon Road', '', NULL, NULL, NULL, 1346, 'MSL');


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 334
-- Name: samplingfeatures_samplingfeatureid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('samplingfeatures_samplingfeatureid_seq', 115, true);


--
-- TOC entry 3498 (class 0 OID 18396)
-- Dependencies: 335
-- Data for Name: sectionresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3499 (class 0 OID 18399)
-- Dependencies: 336
-- Data for Name: sectionresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 337
-- Name: sectionresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('sectionresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3501 (class 0 OID 18404)
-- Dependencies: 338
-- Data for Name: sectionresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 339
-- Name: sectionresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('sectionresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3503 (class 0 OID 18412)
-- Dependencies: 340
-- Data for Name: simulations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 341
-- Name: simulations_simulationid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('simulations_simulationid_seq', 1, false);


--
-- TOC entry 3505 (class 0 OID 18420)
-- Dependencies: 342
-- Data for Name: sites; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO sites VALUES (65, 'Stream', 18.4904000000000011, -69.8648000000000025, 2);
INSERT INTO sites VALUES (66, 'Stream', 46.2017000000000024, -103.007999999999996, 2);
INSERT INTO sites VALUES (67, 'Stream', 39.8603000000000023, -75.7843000000000018, 2);
INSERT INTO sites VALUES (70, 'Stream', 18.4972999999999992, -69.8568000000000069, 2);
INSERT INTO sites VALUES (71, 'Unknown', 39.9588999999999999, -75.8301000000000016, 2);
INSERT INTO sites VALUES (72, 'Unknown', 39.859499999999997, -75.7831000000000046, 2);
INSERT INTO sites VALUES (73, 'Stream', 39.9588999999999999, -75.8302000000000049, 2);
INSERT INTO sites VALUES (74, 'Facility', 44.9506999999999977, -92.9561999999999955, 2);
INSERT INTO sites VALUES (75, 'Glacier', 44.950800000000001, -92.9557999999999964, 2);
INSERT INTO sites VALUES (76, 'Unknown', 44.9519999999999982, -92.9515999999999991, 2);
INSERT INTO sites VALUES (77, 'Unknown', 44.954500000000003, -92.9540999999999968, 2);
INSERT INTO sites VALUES (78, 'Stream', 41.6940999999999988, -111.783000000000001, 2);
INSERT INTO sites VALUES (79, 'Facility', 41.7398999999999987, -111.793000000000006, 2);
INSERT INTO sites VALUES (81, 'Unknown', 39.8592000000000013, -75.7831999999999937, 2);
INSERT INTO sites VALUES (82, 'Land', 40.0328000000000017, -75.1706999999999965, 2);
INSERT INTO sites VALUES (83, 'Land', 40.0326999999999984, -75.1530999999999949, 2);
INSERT INTO sites VALUES (84, 'Land', 40.0328999999999979, -75.1529000000000025, 2);
INSERT INTO sites VALUES (85, 'Stream', 39.9542000000000002, -75.1888000000000005, 2);
INSERT INTO sites VALUES (86, 'Land', 39.9549000000000021, -75.1895999999999987, 2);
INSERT INTO sites VALUES (87, 'Land', 39.9540999999999968, -75.1893000000000029, 2);
INSERT INTO sites VALUES (88, 'Stream', 41.7306999999999988, -112.093999999999994, 2);
INSERT INTO sites VALUES (89, 'Stream', 41.741500000000002, -111.793000000000006, 2);
INSERT INTO sites VALUES (90, 'Stream', 41.7535999999999987, -111.772000000000006, 2);
INSERT INTO sites VALUES (1, 'Stream', 34.2129400000000032, -105.921940000000006, 2);
INSERT INTO sites VALUES (94, 'Stream', 39.8168999999999969, -75.5507999999999953, 2);
INSERT INTO sites VALUES (96, 'Stream', 39.8168999999999969, -75.5504999999999995, 2);
INSERT INTO sites VALUES (97, 'Stream', 39.8215000000000003, -75.5548000000000002, 2);
INSERT INTO sites VALUES (98, 'Stream', 41.7351000000000028, -111.834000000000003, 2);
INSERT INTO sites VALUES (100, 'Stream', 41.7165999999999997, -111.882000000000005, 2);
INSERT INTO sites VALUES (101, 'Stream', 40.9024000000000001, -74.7134999999999962, 2);
INSERT INTO sites VALUES (102, 'Stream', 40.9170999999999978, -74.7287000000000035, 2);
INSERT INTO sites VALUES (103, 'Stream', 40.9731999999999985, -75.1694999999999993, 2);
INSERT INTO sites VALUES (104, 'Stream', 40.9684999999999988, -75.1748000000000047, 2);
INSERT INTO sites VALUES (105, 'Stream', 41.0608000000000004, -74.7480999999999938, 2);
INSERT INTO sites VALUES (106, 'Stream', 41.0855000000000032, -74.6995000000000005, 2);
INSERT INTO sites VALUES (107, 'Stream', 53.2890000000000015, -98.0117999999999938, 2);
INSERT INTO sites VALUES (93, 'Stream', 39.8288000000000011, -75.5725000000000051, 2);
INSERT INTO sites VALUES (92, 'Stream', 39.8378000000000014, -75.5728000000000009, 2);
INSERT INTO sites VALUES (109, 'Stream', 39.8120899999999978, -75.5662599999999998, 2);
INSERT INTO sites VALUES (110, 'Stream', 39.8234800000000035, -75.5717400000000055, 2);
INSERT INTO sites VALUES (111, 'Lake, Reservoir, Impoundment', 44.9506080000000026, -92.9550839999999994, 2);
INSERT INTO sites VALUES (112, 'Lake, Reservoir, Impoundment', 44.9506080000000026, -92.9550839999999994, 2);
INSERT INTO sites VALUES (114, 'Stream', 40.032820000000001, -75.1711999999999989, 2);
INSERT INTO sites VALUES (113, 'Lake, Reservoir, Impoundment', 44.9506080000000026, -92.9550839999999994, 2);
INSERT INTO sites VALUES (80, 'Stream', 41.7186999999999983, -111.94623, 2);


--
-- TOC entry 3506 (class 0 OID 18423)
-- Dependencies: 343
-- Data for Name: spatialoffsets; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 344
-- Name: spatialoffsets_spatialoffsetid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('spatialoffsets_spatialoffsetid_seq', 1, false);


--
-- TOC entry 3508 (class 0 OID 18428)
-- Dependencies: 345
-- Data for Name: spatialreferenceexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 346
-- Name: spatialreferenceexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('spatialreferenceexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3510 (class 0 OID 18436)
-- Dependencies: 347
-- Data for Name: spatialreferences; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO spatialreferences VALUES (2, '4236', 'WGS84', 'test', NULL);


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 348
-- Name: spatialreferences_spatialreferenceid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('spatialreferences_spatialreferenceid_seq', 3, true);


--
-- TOC entry 3512 (class 0 OID 18444)
-- Dependencies: 349
-- Data for Name: specimenbatchpostions; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3513 (class 0 OID 18447)
-- Dependencies: 350
-- Data for Name: specimens; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3514 (class 0 OID 18453)
-- Dependencies: 351
-- Data for Name: specimentaxonomicclassifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 352
-- Name: specimentaxonomicclassifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('specimentaxonomicclassifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3516 (class 0 OID 18458)
-- Dependencies: 353
-- Data for Name: spectraresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3517 (class 0 OID 18461)
-- Dependencies: 354
-- Data for Name: spectraresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 355
-- Name: spectraresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('spectraresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3519 (class 0 OID 18466)
-- Dependencies: 356
-- Data for Name: spectraresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 357
-- Name: spectraresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('spectraresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3521 (class 0 OID 18474)
-- Dependencies: 358
-- Data for Name: taxonomicclassifierexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 359
-- Name: taxonomicclassifierexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('taxonomicclassifierexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3523 (class 0 OID 18482)
-- Dependencies: 360
-- Data for Name: taxonomicclassifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 361
-- Name: taxonomicclassifiers_taxonomicclassifierid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('taxonomicclassifiers_taxonomicclassifierid_seq', 1, false);


--
-- TOC entry 3525 (class 0 OID 18490)
-- Dependencies: 362
-- Data for Name: timeseriesresults; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO timeseriesresults VALUES (45, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (46, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (47, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (48, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (49, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (50, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (51, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (52, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (53, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (54, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (55, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');
INSERT INTO timeseriesresults VALUES (56, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Average');


--
-- TOC entry 3526 (class 0 OID 18493)
-- Dependencies: 363
-- Data for Name: timeseriesresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 364
-- Name: timeseriesresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('timeseriesresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3528 (class 0 OID 18498)
-- Dependencies: 365
-- Data for Name: timeseriesresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO timeseriesresultvalues VALUES (381798, 55, 4.16000000000000014, '2017-02-20 03:50:42', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381800, 55, 4.16000000000000014, '2017-02-20 03:51:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381802, 55, 4.16000000000000014, '2017-02-20 03:52:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381804, 55, 4.16000000000000014, '2017-02-20 03:53:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381806, 55, 4.16000000000000014, '2017-02-20 03:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381808, 55, 4.16000000000000014, '2017-02-20 03:55:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381810, 55, 4.16000000000000014, '2017-02-20 03:56:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381812, 55, 4.16000000000000014, '2017-02-20 03:57:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381814, 55, 4.16000000000000014, '2017-02-20 03:58:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381816, 55, 4.16000000000000014, '2017-02-20 03:59:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381818, 55, 4.16000000000000014, '2017-02-20 04:00:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381820, 55, 4.16000000000000014, '2017-02-20 04:00:46', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381822, 55, 4.16000000000000014, '2017-02-20 04:02:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381824, 55, 4.16000000000000014, '2017-02-20 04:03:09', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381826, 55, 4.16000000000000014, '2017-02-20 04:04:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381828, 55, 4.16000000000000014, '2017-02-20 04:05:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381830, 55, 4.16000000000000014, '2017-02-20 04:06:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381832, 55, 4.16000000000000014, '2017-02-20 04:07:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381834, 55, 4.16000000000000014, '2017-02-20 04:08:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381836, 55, 4.16000000000000014, '2017-02-20 04:09:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381838, 55, 4.16000000000000014, '2017-02-20 04:10:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381840, 55, 4.16000000000000014, '2017-02-20 04:11:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381842, 55, 4.16000000000000014, '2017-02-20 04:15:08', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381844, 55, 4.16000000000000014, '2017-02-20 04:16:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381846, 55, 4.16000000000000014, '2017-02-20 04:17:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381848, 55, 4.16000000000000014, '2017-02-20 04:40:17', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381850, 55, 4.16000000000000014, '2017-02-20 04:52:18', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381852, 55, 4.16000000000000014, '2017-02-20 04:53:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381854, 55, 4.16000000000000014, '2017-02-20 04:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381856, 55, 4.16000000000000014, '2017-02-20 04:55:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381858, 55, 4.16000000000000014, '2017-02-20 04:56:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381860, 55, 4.16000000000000014, '2017-02-20 04:57:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381724, 55, 23.25, '2017-02-20 01:52:08', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381722, 55, 23.5, '2017-02-20 01:39:14', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381726, 55, 23.5, '2017-02-20 01:53:11', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381728, 55, 23.75, '2017-02-20 01:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381730, 55, 23.75, '2017-02-20 02:03:28', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381732, 55, 23.75, '2017-02-20 02:03:33', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381734, 55, 23.75, '2017-02-20 02:04:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381736, 55, 24.25, '2017-02-20 02:05:23', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381738, 55, 24.5, '2017-02-20 02:05:29', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381740, 55, 24.75, '2017-02-20 02:06:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381742, 55, 25, '2017-02-20 02:07:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381744, 55, 25.25, '2017-02-20 02:08:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381746, 55, 25.5, '2017-02-20 02:09:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381748, 55, 25.75, '2017-02-20 02:10:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381750, 55, 26, '2017-02-20 02:11:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381752, 55, 26.25, '2017-02-20 02:12:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381754, 55, 26.25, '2017-02-20 02:13:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381756, 55, 26.5, '2017-02-20 02:13:43', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381758, 55, 26.75, '2017-02-20 02:15:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381760, 55, 26.75, '2017-02-20 02:16:29', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381762, 55, 26.75, '2017-02-20 02:18:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381764, 55, 27, '2017-02-20 02:19:39', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381766, 55, 27, '2017-02-20 02:21:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381768, 55, 27, '2017-02-20 02:22:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381770, 55, 27, '2017-02-20 02:23:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381772, 55, 27.25, '2017-02-20 02:24:46', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381774, 55, 27.25, '2017-02-20 02:26:30', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381776, 55, 27.25, '2017-02-20 02:27:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381778, 55, 27.25, '2017-02-20 02:28:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381780, 55, 27.25, '2017-02-20 02:29:20', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381782, 55, 27.25, '2017-02-20 02:30:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381784, 55, 27.25, '2017-02-20 02:31:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381786, 55, 27.25, '2017-02-20 02:32:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381788, 55, 27.25, '2017-02-20 02:33:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381790, 55, 27.25, '2017-02-20 02:34:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381792, 55, 27.25, '2017-02-20 02:35:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381796, 55, 27.25, '2017-02-20 02:37:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381794, 55, 27.5, '2017-02-20 02:36:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381723, 56, 4.13999999999999968, '2017-02-20 01:39:14', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381725, 56, 4.13999999999999968, '2017-02-20 01:52:08', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381727, 56, 4.13999999999999968, '2017-02-20 01:53:11', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381731, 56, 4.15000000000000036, '2017-02-20 02:03:28', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381733, 56, 4.16000000000000014, '2017-02-20 02:03:33', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381735, 56, 4.16000000000000014, '2017-02-20 02:04:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381737, 56, 4.16000000000000014, '2017-02-20 02:05:23', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381739, 56, 4.16000000000000014, '2017-02-20 02:05:29', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381741, 56, 4.16000000000000014, '2017-02-20 02:06:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381743, 56, 4.16000000000000014, '2017-02-20 02:07:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381745, 56, 4.16000000000000014, '2017-02-20 02:08:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381747, 56, 4.16000000000000014, '2017-02-20 02:09:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381749, 56, 4.16000000000000014, '2017-02-20 02:10:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381751, 56, 4.16000000000000014, '2017-02-20 02:11:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381753, 56, 4.16000000000000014, '2017-02-20 02:12:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381755, 56, 4.16000000000000014, '2017-02-20 02:13:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381757, 56, 4.16000000000000014, '2017-02-20 02:13:43', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381759, 56, 4.16000000000000014, '2017-02-20 02:15:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381761, 56, 4.16000000000000014, '2017-02-20 02:16:29', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381763, 56, 4.16000000000000014, '2017-02-20 02:18:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381765, 56, 4.16000000000000014, '2017-02-20 02:19:39', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381767, 56, 4.16000000000000014, '2017-02-20 02:21:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381769, 56, 4.16000000000000014, '2017-02-20 02:22:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381771, 56, 4.16000000000000014, '2017-02-20 02:23:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381773, 56, 4.16000000000000014, '2017-02-20 02:24:46', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381775, 56, 4.16000000000000014, '2017-02-20 02:26:30', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381777, 56, 4.16000000000000014, '2017-02-20 02:27:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381779, 56, 4.16000000000000014, '2017-02-20 02:28:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381781, 56, 4.16000000000000014, '2017-02-20 02:29:20', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381783, 56, 4.16000000000000014, '2017-02-20 02:30:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381785, 56, 4.16000000000000014, '2017-02-20 02:31:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381787, 56, 4.16000000000000014, '2017-02-20 02:32:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381789, 56, 4.16000000000000014, '2017-02-20 02:33:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381791, 56, 4.16000000000000014, '2017-02-20 02:34:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381793, 56, 4.16000000000000014, '2017-02-20 02:35:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381795, 56, 4.16000000000000014, '2017-02-20 02:36:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381797, 56, 4.16000000000000014, '2017-02-20 02:37:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381729, 56, 4.19000000000000039, '2017-02-20 01:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381849, 56, 25.25, '2017-02-20 04:40:17', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381845, 56, 26, '2017-02-20 04:16:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381847, 56, 26, '2017-02-20 04:17:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381843, 56, 26.25, '2017-02-20 04:15:08', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381851, 56, 26.5, '2017-02-20 04:52:18', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381853, 56, 26.75, '2017-02-20 04:53:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381855, 56, 26.75, '2017-02-20 04:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381857, 56, 26.75, '2017-02-20 04:55:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381859, 56, 26.75, '2017-02-20 04:56:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381831, 56, 27, '2017-02-20 04:06:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381833, 56, 27, '2017-02-20 04:07:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381835, 56, 27, '2017-02-20 04:08:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381837, 56, 27, '2017-02-20 04:09:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381841, 56, 27, '2017-02-20 04:11:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381861, 56, 27, '2017-02-20 04:57:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381819, 56, 27.25, '2017-02-20 04:00:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381827, 56, 27.25, '2017-02-20 04:04:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381829, 56, 27.25, '2017-02-20 04:05:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381839, 56, 27.25, '2017-02-20 04:10:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381805, 56, 27.5, '2017-02-20 03:53:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381807, 56, 27.5, '2017-02-20 03:54:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381809, 56, 27.5, '2017-02-20 03:55:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381811, 56, 27.5, '2017-02-20 03:56:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381813, 56, 27.5, '2017-02-20 03:57:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381815, 56, 27.5, '2017-02-20 03:58:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381817, 56, 27.5, '2017-02-20 03:59:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381821, 56, 27.5, '2017-02-20 04:00:46', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381823, 56, 27.5, '2017-02-20 04:02:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381825, 56, 27.5, '2017-02-20 04:03:09', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381799, 56, 27.75, '2017-02-20 03:50:42', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381801, 56, 27.75, '2017-02-20 03:51:00', -5, 'Not censored', 'None', 1, 2);
INSERT INTO timeseriesresultvalues VALUES (381803, 56, 27.75, '2017-02-20 03:52:00', -5, 'Not censored', 'None', 1, 2);


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 366
-- Name: timeseriesresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('timeseriesresultvalues_valueid_seq', 733315, true);


--
-- TOC entry 3530 (class 0 OID 18506)
-- Dependencies: 367
-- Data for Name: trajectoryresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3531 (class 0 OID 18509)
-- Dependencies: 368
-- Data for Name: trajectoryresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 369
-- Name: trajectoryresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('trajectoryresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3533 (class 0 OID 18514)
-- Dependencies: 370
-- Data for Name: trajectoryresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 371
-- Name: trajectoryresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('trajectoryresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3535 (class 0 OID 18522)
-- Dependencies: 372
-- Data for Name: transectresults; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3536 (class 0 OID 18525)
-- Dependencies: 373
-- Data for Name: transectresultvalueannotations; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 374
-- Name: transectresultvalueannotations_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('transectresultvalueannotations_bridgeid_seq', 1, false);


--
-- TOC entry 3538 (class 0 OID 18530)
-- Dependencies: 375
-- Data for Name: transectresultvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 376
-- Name: transectresultvalues_valueid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('transectresultvalues_valueid_seq', 1, false);


--
-- TOC entry 3540 (class 0 OID 18538)
-- Dependencies: 377
-- Data for Name: units; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO units VALUES (371, 'Particle flux', 'µmol/m^2 s', 'Micromole per Square Meter per Second', NULL);
INSERT INTO units VALUES (372, 'Temperature', 'degF', 'Degree Fahrenheit', NULL);
INSERT INTO units VALUES (373, 'Electrical conductivity', 'uS/cm', 'Microsiemen per Centimeter', NULL);
INSERT INTO units VALUES (375, 'Electrical permittivity', 'F/m', 'Farad per Meter', NULL);
INSERT INTO units VALUES (362, 'Temperature', 'degC', 'degree celsius', NULL);
INSERT INTO units VALUES (364, 'Turbidity', 'NTU', 'Nephelometric Turbidity Unit', NULL);
INSERT INTO units VALUES (366, 'Electrical conductivity', 'dS/m', 'Decisiemen per Meter', NULL);
INSERT INTO units VALUES (367, 'Length', 'mm', 'Millimeter', NULL);
INSERT INTO units VALUES (368, 'Concentration volume per volume', '% by vol', 'Percent By Volume', NULL);
INSERT INTO units VALUES (369, 'Electromotive force', 'V', 'Volt', NULL);
INSERT INTO units VALUES (2, 'Time', 'hm', 'hour minute', NULL);
INSERT INTO units VALUES (370, 'Amount of Information', 'bit', 'Bit', NULL);


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 378
-- Name: units_unitsid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('units_unitsid_seq', 376, true);


--
-- TOC entry 3542 (class 0 OID 18546)
-- Dependencies: 379
-- Data for Name: variableextensionpropertyvalues; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 380
-- Name: variableextensionpropertyvalues_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('variableextensionpropertyvalues_bridgeid_seq', 1, false);


--
-- TOC entry 3544 (class 0 OID 18551)
-- Dependencies: 381
-- Data for Name: variableexternalidentifiers; Type: TABLE DATA; Schema: odm2; Owner: -
--



--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 382
-- Name: variableexternalidentifiers_bridgeid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('variableexternalidentifiers_bridgeid_seq', 1, false);


--
-- TOC entry 3546 (class 0 OID 18559)
-- Dependencies: 383
-- Data for Name: variables; Type: TABLE DATA; Schema: odm2; Owner: -
--

INSERT INTO variables VALUES (10, 'Instrumentation', 'EnviroDIY_Mayfly_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (11, 'Water quality', 'Decagon_CTD-10_EC', 'Electrical conductivity', NULL, NULL, -9999);
INSERT INTO variables VALUES (12, 'Water quality', 'Decagon_CTD-10_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (13, 'Hydrology', 'Decagon_CTD-10_Depth', 'Water depth', NULL, NULL, -9999);
INSERT INTO variables VALUES (14, 'Water quality', 'Campbell_OBS-3+_Turb', 'Turbidity', NULL, NULL, -9999);
INSERT INTO variables VALUES (15, 'Soil', 'Decagon_5TM_VWC', 'Volumetric water content', NULL, NULL, -9999);
INSERT INTO variables VALUES (16, 'Soil', 'Decagon_5TM_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (21, 'Instrumentation', 'EnviroDIY_Mayfly_Volt', 'Battery voltage', NULL, NULL, -9999);
INSERT INTO variables VALUES (22, 'Instrumentation', 'EnviroDIY_Mayfly_FreeSRAM', 'Free SRAM', NULL, NULL, -9999);
INSERT INTO variables VALUES (23, 'Water quality', 'Decagon_ES-2_EC', 'Electrical conductivity', NULL, NULL, -9999);
INSERT INTO variables VALUES (24, 'Water quality', 'Decagon_ES-2_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (37, 'Hydrology', 'MaxBotix_MB7386_Distance', 'Distance', NULL, NULL, -9999);
INSERT INTO variables VALUES (38, 'Hydrology', 'MaxBotix_MB7389_Distance', 'Distance', NULL, NULL, -9999);
INSERT INTO variables VALUES (39, 'Water quality', 'Adafruit_DS18B20_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (40, 'Climate', 'Adafruit_AM2315_humidity', 'Relative humidity', NULL, NULL, -9999);
INSERT INTO variables VALUES (41, 'Climate', 'Adafruit_AM2315_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (42, 'Climate', 'Seeed_DHT22_humidity', 'Relative humidity', NULL, NULL, -9999);
INSERT INTO variables VALUES (43, 'Climate', 'Seeed_DHT22_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (44, 'Climate', 'Seeed_DHT11_humidity', 'Relative humidity', NULL, NULL, -9999);
INSERT INTO variables VALUES (45, 'Climate', 'Seeed_DHT11_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (46, 'Climate', 'Apogee_SQ-212_PAR', 'Radiation, incoming PAR', NULL, NULL, -9999);
INSERT INTO variables VALUES (47, 'Climate', 'Seeed_BME280_humidity', 'Relative humidity', NULL, NULL, -9999);
INSERT INTO variables VALUES (48, 'Climate', 'Seeed_BME280_Temp', 'Temperature', NULL, NULL, -9999);
INSERT INTO variables VALUES (50, 'Soil', 'Decagon_5TM_Ea', 'Permittivity', NULL, NULL, -9999);


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 384
-- Name: variables_variableid_seq; Type: SEQUENCE SET; Schema: odm2; Owner: -
--

SELECT pg_catalog.setval('variables_variableid_seq', 51, true);


SET search_path = public, pg_catalog;

--
-- TOC entry 3548 (class 0 OID 18567)
-- Dependencies: 385
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 386
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('django_migrations_id_seq', 1, false);


SET search_path = odm2, pg_catalog;

--
-- TOC entry 2635 (class 2606 OID 18669)
-- Name: actionannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionannotations
    ADD CONSTRAINT actionannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2637 (class 2606 OID 18671)
-- Name: actionby_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionby
    ADD CONSTRAINT actionby_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2639 (class 2606 OID 18673)
-- Name: actiondirectives_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actiondirectives
    ADD CONSTRAINT actiondirectives_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2641 (class 2606 OID 18675)
-- Name: actionextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionextensionpropertyvalues
    ADD CONSTRAINT actionextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2643 (class 2606 OID 18677)
-- Name: actions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actions
    ADD CONSTRAINT actions_pkey PRIMARY KEY (actionid);


--
-- TOC entry 2645 (class 2606 OID 18679)
-- Name: affiliations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY affiliations
    ADD CONSTRAINT affiliations_pkey PRIMARY KEY (affiliationid);


--
-- TOC entry 2647 (class 2606 OID 18681)
-- Name: annotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY annotations
    ADD CONSTRAINT annotations_pkey PRIMARY KEY (annotationid);


--
-- TOC entry 2649 (class 2606 OID 18683)
-- Name: authorlists_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY authorlists
    ADD CONSTRAINT authorlists_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2651 (class 2606 OID 18685)
-- Name: calibrationactions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationactions
    ADD CONSTRAINT calibrationactions_pkey PRIMARY KEY (actionid);


--
-- TOC entry 2653 (class 2606 OID 18687)
-- Name: calibrationreferenceequipment_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationreferenceequipment
    ADD CONSTRAINT calibrationreferenceequipment_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2655 (class 2606 OID 18689)
-- Name: calibrationstandards_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationstandards
    ADD CONSTRAINT calibrationstandards_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2657 (class 2606 OID 18691)
-- Name: categoricalresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresults
    ADD CONSTRAINT categoricalresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2659 (class 2606 OID 18693)
-- Name: categoricalresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalueannotations
    ADD CONSTRAINT categoricalresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2661 (class 2606 OID 18695)
-- Name: categoricalresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalues
    ADD CONSTRAINT categoricalresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2663 (class 2606 OID 18697)
-- Name: categoricalresultvalues_resultid_datavalue_valuedatetime_va_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalues
    ADD CONSTRAINT categoricalresultvalues_resultid_datavalue_valuedatetime_va_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset);


--
-- TOC entry 2665 (class 2606 OID 18699)
-- Name: citationextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationextensionpropertyvalues
    ADD CONSTRAINT citationextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2667 (class 2606 OID 18701)
-- Name: citationexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationexternalidentifiers
    ADD CONSTRAINT citationexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2669 (class 2606 OID 18703)
-- Name: citations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citations
    ADD CONSTRAINT citations_pkey PRIMARY KEY (citationid);


--
-- TOC entry 2671 (class 2606 OID 18705)
-- Name: cv_actiontype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_actiontype
    ADD CONSTRAINT cv_actiontype_pkey PRIMARY KEY (name);


--
-- TOC entry 2673 (class 2606 OID 18707)
-- Name: cv_aggregationstatistic_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_aggregationstatistic
    ADD CONSTRAINT cv_aggregationstatistic_pkey PRIMARY KEY (name);


--
-- TOC entry 2675 (class 2606 OID 18709)
-- Name: cv_annotationtype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_annotationtype
    ADD CONSTRAINT cv_annotationtype_pkey PRIMARY KEY (name);


--
-- TOC entry 2677 (class 2606 OID 18711)
-- Name: cv_censorcode_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_censorcode
    ADD CONSTRAINT cv_censorcode_pkey PRIMARY KEY (name);


--
-- TOC entry 2679 (class 2606 OID 18713)
-- Name: cv_dataqualitytype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_dataqualitytype
    ADD CONSTRAINT cv_dataqualitytype_pkey PRIMARY KEY (name);


--
-- TOC entry 2681 (class 2606 OID 18715)
-- Name: cv_datasettype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_datasettype
    ADD CONSTRAINT cv_datasettype_pkey PRIMARY KEY (name);


--
-- TOC entry 2683 (class 2606 OID 18717)
-- Name: cv_directivetype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_directivetype
    ADD CONSTRAINT cv_directivetype_pkey PRIMARY KEY (name);


--
-- TOC entry 2685 (class 2606 OID 18719)
-- Name: cv_elevationdatum_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_elevationdatum
    ADD CONSTRAINT cv_elevationdatum_pkey PRIMARY KEY (name);


--
-- TOC entry 2687 (class 2606 OID 18721)
-- Name: cv_equipmenttype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_equipmenttype
    ADD CONSTRAINT cv_equipmenttype_pkey PRIMARY KEY (name);


--
-- TOC entry 2689 (class 2606 OID 18723)
-- Name: cv_medium_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_medium
    ADD CONSTRAINT cv_medium_pkey PRIMARY KEY (name);


--
-- TOC entry 2691 (class 2606 OID 18725)
-- Name: cv_methodtype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_methodtype
    ADD CONSTRAINT cv_methodtype_pkey PRIMARY KEY (name);


--
-- TOC entry 2693 (class 2606 OID 18727)
-- Name: cv_organizationtype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_organizationtype
    ADD CONSTRAINT cv_organizationtype_pkey PRIMARY KEY (name);


--
-- TOC entry 2695 (class 2606 OID 18729)
-- Name: cv_propertydatatype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_propertydatatype
    ADD CONSTRAINT cv_propertydatatype_pkey PRIMARY KEY (name);


--
-- TOC entry 2697 (class 2606 OID 18731)
-- Name: cv_qualitycode_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_qualitycode
    ADD CONSTRAINT cv_qualitycode_pkey PRIMARY KEY (name);


--
-- TOC entry 2699 (class 2606 OID 18733)
-- Name: cv_relationshiptype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_relationshiptype
    ADD CONSTRAINT cv_relationshiptype_pkey PRIMARY KEY (name);


--
-- TOC entry 2701 (class 2606 OID 18735)
-- Name: cv_resulttype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_resulttype
    ADD CONSTRAINT cv_resulttype_pkey PRIMARY KEY (name);


--
-- TOC entry 2703 (class 2606 OID 18737)
-- Name: cv_samplingfeaturegeotype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_samplingfeaturegeotype
    ADD CONSTRAINT cv_samplingfeaturegeotype_pkey PRIMARY KEY (name);


--
-- TOC entry 2705 (class 2606 OID 18739)
-- Name: cv_samplingfeaturetype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_samplingfeaturetype
    ADD CONSTRAINT cv_samplingfeaturetype_pkey PRIMARY KEY (name);


--
-- TOC entry 2707 (class 2606 OID 18741)
-- Name: cv_sitetype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_sitetype
    ADD CONSTRAINT cv_sitetype_pkey PRIMARY KEY (name);


--
-- TOC entry 2709 (class 2606 OID 18743)
-- Name: cv_spatialoffsettype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_spatialoffsettype
    ADD CONSTRAINT cv_spatialoffsettype_pkey PRIMARY KEY (name);


--
-- TOC entry 2711 (class 2606 OID 18745)
-- Name: cv_speciation_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_speciation
    ADD CONSTRAINT cv_speciation_pkey PRIMARY KEY (name);


--
-- TOC entry 2713 (class 2606 OID 18747)
-- Name: cv_specimentype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_specimentype
    ADD CONSTRAINT cv_specimentype_pkey PRIMARY KEY (name);


--
-- TOC entry 2715 (class 2606 OID 18749)
-- Name: cv_status_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_status
    ADD CONSTRAINT cv_status_pkey PRIMARY KEY (name);


--
-- TOC entry 2717 (class 2606 OID 18751)
-- Name: cv_taxonomicclassifiertype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_taxonomicclassifiertype
    ADD CONSTRAINT cv_taxonomicclassifiertype_pkey PRIMARY KEY (name);


--
-- TOC entry 2719 (class 2606 OID 18753)
-- Name: cv_unitstype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_unitstype
    ADD CONSTRAINT cv_unitstype_pkey PRIMARY KEY (name);


--
-- TOC entry 2721 (class 2606 OID 18755)
-- Name: cv_variablename_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_variablename
    ADD CONSTRAINT cv_variablename_pkey PRIMARY KEY (name);


--
-- TOC entry 2723 (class 2606 OID 18757)
-- Name: cv_variabletype_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY cv_variabletype
    ADD CONSTRAINT cv_variabletype_pkey PRIMARY KEY (name);


--
-- TOC entry 2725 (class 2606 OID 18759)
-- Name: dataloggerfilecolumns_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT dataloggerfilecolumns_pkey PRIMARY KEY (dataloggerfilecolumnid);


--
-- TOC entry 2727 (class 2606 OID 18761)
-- Name: dataloggerfiles_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfiles
    ADD CONSTRAINT dataloggerfiles_pkey PRIMARY KEY (dataloggerfileid);


--
-- TOC entry 2729 (class 2606 OID 18763)
-- Name: dataloggerprogramfiles_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerprogramfiles
    ADD CONSTRAINT dataloggerprogramfiles_pkey PRIMARY KEY (programid);


--
-- TOC entry 2731 (class 2606 OID 18765)
-- Name: dataquality_dataqualitycode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataquality
    ADD CONSTRAINT dataquality_dataqualitycode_key UNIQUE (dataqualitycode);


--
-- TOC entry 2733 (class 2606 OID 18767)
-- Name: dataquality_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataquality
    ADD CONSTRAINT dataquality_pkey PRIMARY KEY (dataqualityid);


--
-- TOC entry 2735 (class 2606 OID 18769)
-- Name: datasetcitations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetcitations
    ADD CONSTRAINT datasetcitations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2737 (class 2606 OID 18771)
-- Name: datasets_datasetcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_datasetcode_key UNIQUE (datasetcode);


--
-- TOC entry 2739 (class 2606 OID 18773)
-- Name: datasets_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (datasetid);


--
-- TOC entry 2741 (class 2606 OID 18775)
-- Name: datasetsresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetsresults
    ADD CONSTRAINT datasetsresults_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2743 (class 2606 OID 18777)
-- Name: derivationequations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY derivationequations
    ADD CONSTRAINT derivationequations_pkey PRIMARY KEY (derivationequationid);


--
-- TOC entry 2745 (class 2606 OID 18779)
-- Name: directives_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY directives
    ADD CONSTRAINT directives_pkey PRIMARY KEY (directiveid);


--
-- TOC entry 2747 (class 2606 OID 18781)
-- Name: equipment_equipmentcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT equipment_equipmentcode_key UNIQUE (equipmentcode);


--
-- TOC entry 2749 (class 2606 OID 18783)
-- Name: equipment_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT equipment_pkey PRIMARY KEY (equipmentid);


--
-- TOC entry 2751 (class 2606 OID 18785)
-- Name: equipmentannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentannotations
    ADD CONSTRAINT equipmentannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2753 (class 2606 OID 18787)
-- Name: equipmentmodels_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentmodels
    ADD CONSTRAINT equipmentmodels_pkey PRIMARY KEY (equipmentmodelid);


--
-- TOC entry 2755 (class 2606 OID 18789)
-- Name: equipmentused_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentused
    ADD CONSTRAINT equipmentused_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2757 (class 2606 OID 18791)
-- Name: extensionproperties_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY extensionproperties
    ADD CONSTRAINT extensionproperties_pkey PRIMARY KEY (propertyid);


--
-- TOC entry 2759 (class 2606 OID 18793)
-- Name: externalidentifiersystems_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY externalidentifiersystems
    ADD CONSTRAINT externalidentifiersystems_pkey PRIMARY KEY (externalidentifiersystemid);


--
-- TOC entry 2761 (class 2606 OID 18795)
-- Name: featureactions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY featureactions
    ADD CONSTRAINT featureactions_pkey PRIMARY KEY (featureactionid);


--
-- TOC entry 2763 (class 2606 OID 18797)
-- Name: instrumentoutputvariables_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables
    ADD CONSTRAINT instrumentoutputvariables_pkey PRIMARY KEY (instrumentoutputvariableid);


--
-- TOC entry 2765 (class 2606 OID 18799)
-- Name: maintenanceactions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY maintenanceactions
    ADD CONSTRAINT maintenanceactions_pkey PRIMARY KEY (actionid);


--
-- TOC entry 2767 (class 2606 OID 18801)
-- Name: measurementresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT measurementresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2769 (class 2606 OID 18803)
-- Name: measurementresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalueannotations
    ADD CONSTRAINT measurementresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2771 (class 2606 OID 18805)
-- Name: measurementresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalues
    ADD CONSTRAINT measurementresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2773 (class 2606 OID 18807)
-- Name: measurementresultvalues_resultid_datavalue_valuedatetime_va_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalues
    ADD CONSTRAINT measurementresultvalues_resultid_datavalue_valuedatetime_va_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset);


--
-- TOC entry 2775 (class 2606 OID 18809)
-- Name: methodannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodannotations
    ADD CONSTRAINT methodannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2777 (class 2606 OID 18811)
-- Name: methodcitations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodcitations
    ADD CONSTRAINT methodcitations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2779 (class 2606 OID 18813)
-- Name: methodextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodextensionpropertyvalues
    ADD CONSTRAINT methodextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2781 (class 2606 OID 18815)
-- Name: methodexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodexternalidentifiers
    ADD CONSTRAINT methodexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2783 (class 2606 OID 18817)
-- Name: methods_methodcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methods
    ADD CONSTRAINT methods_methodcode_key UNIQUE (methodcode);


--
-- TOC entry 2785 (class 2606 OID 18819)
-- Name: methods_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methods
    ADD CONSTRAINT methods_pkey PRIMARY KEY (methodid);


--
-- TOC entry 2787 (class 2606 OID 18821)
-- Name: modelaffiliations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY modelaffiliations
    ADD CONSTRAINT modelaffiliations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2789 (class 2606 OID 18823)
-- Name: models_modelcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY models
    ADD CONSTRAINT models_modelcode_key UNIQUE (modelcode);


--
-- TOC entry 2791 (class 2606 OID 18825)
-- Name: models_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY models
    ADD CONSTRAINT models_pkey PRIMARY KEY (modelid);


--
-- TOC entry 2793 (class 2606 OID 18827)
-- Name: organizations_organizationcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_organizationcode_key UNIQUE (organizationcode);


--
-- TOC entry 2795 (class 2606 OID 18829)
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (organizationid);


--
-- TOC entry 2797 (class 2606 OID 18831)
-- Name: people_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY people
    ADD CONSTRAINT people_pkey PRIMARY KEY (personid);


--
-- TOC entry 2799 (class 2606 OID 18833)
-- Name: personexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY personexternalidentifiers
    ADD CONSTRAINT personexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2801 (class 2606 OID 18835)
-- Name: pointcoverageresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT pointcoverageresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2803 (class 2606 OID 18837)
-- Name: pointcoverageresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalueannotations
    ADD CONSTRAINT pointcoverageresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2805 (class 2606 OID 18839)
-- Name: pointcoverageresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT pointcoverageresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2807 (class 2606 OID 18841)
-- Name: pointcoverageresultvalues_resultid_datavalue_valuedatetime__key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT pointcoverageresultvalues_resultid_datavalue_valuedatetime__key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, xlocation, xlocationunitsid, ylocation, ylocationunitsid, censorcodecv, qualitycodecv);


--
-- TOC entry 2809 (class 2606 OID 18843)
-- Name: processinglevels_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY processinglevels
    ADD CONSTRAINT processinglevels_pkey PRIMARY KEY (processinglevelid);


--
-- TOC entry 2811 (class 2606 OID 18845)
-- Name: processinglevels_processinglevelcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY processinglevels
    ADD CONSTRAINT processinglevels_processinglevelcode_key UNIQUE (processinglevelcode);


--
-- TOC entry 2813 (class 2606 OID 18847)
-- Name: profileresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT profileresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2815 (class 2606 OID 18849)
-- Name: profileresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalueannotations
    ADD CONSTRAINT profileresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2817 (class 2606 OID 18851)
-- Name: profileresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT profileresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2819 (class 2606 OID 18853)
-- Name: profileresultvalues_resultid_datavalue_valuedatetime_valued_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT profileresultvalues_resultid_datavalue_valuedatetime_valued_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, zlocation, zaggregationinterval, zlocationunitsid, censorcodecv, qualitycodecv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2821 (class 2606 OID 18855)
-- Name: referencematerialexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialexternalidentifiers
    ADD CONSTRAINT referencematerialexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2823 (class 2606 OID 18857)
-- Name: referencematerials_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials
    ADD CONSTRAINT referencematerials_pkey PRIMARY KEY (referencematerialid);


--
-- TOC entry 2825 (class 2606 OID 18859)
-- Name: referencematerials_referencematerialcode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials
    ADD CONSTRAINT referencematerials_referencematerialcode_key UNIQUE (referencematerialcode);


--
-- TOC entry 2827 (class 2606 OID 18861)
-- Name: referencematerialvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues
    ADD CONSTRAINT referencematerialvalues_pkey PRIMARY KEY (referencematerialvalueid);


--
-- TOC entry 2829 (class 2606 OID 18863)
-- Name: relatedactions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedactions
    ADD CONSTRAINT relatedactions_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2831 (class 2606 OID 18865)
-- Name: relatedannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedannotations
    ADD CONSTRAINT relatedannotations_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2833 (class 2606 OID 18867)
-- Name: relatedcitations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedcitations
    ADD CONSTRAINT relatedcitations_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2835 (class 2606 OID 18869)
-- Name: relateddatasets_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relateddatasets
    ADD CONSTRAINT relateddatasets_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2837 (class 2606 OID 18871)
-- Name: relatedequipment_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedequipment
    ADD CONSTRAINT relatedequipment_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2839 (class 2606 OID 18873)
-- Name: relatedfeatures_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures
    ADD CONSTRAINT relatedfeatures_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2841 (class 2606 OID 18875)
-- Name: relatedmodels_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedmodels
    ADD CONSTRAINT relatedmodels_pkey PRIMARY KEY (relatedid);


--
-- TOC entry 2843 (class 2606 OID 18877)
-- Name: relatedresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedresults
    ADD CONSTRAINT relatedresults_pkey PRIMARY KEY (relationid);


--
-- TOC entry 2845 (class 2606 OID 18879)
-- Name: resultannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultannotations
    ADD CONSTRAINT resultannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2847 (class 2606 OID 18881)
-- Name: resultderivationequations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultderivationequations
    ADD CONSTRAINT resultderivationequations_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2849 (class 2606 OID 18883)
-- Name: resultextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultextensionpropertyvalues
    ADD CONSTRAINT resultextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2851 (class 2606 OID 18885)
-- Name: resultnormalizationvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultnormalizationvalues
    ADD CONSTRAINT resultnormalizationvalues_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2853 (class 2606 OID 18887)
-- Name: results_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT results_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2855 (class 2606 OID 18889)
-- Name: resultsdataquality_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultsdataquality
    ADD CONSTRAINT resultsdataquality_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2857 (class 2606 OID 18891)
-- Name: samplingfeatureannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureannotations
    ADD CONSTRAINT samplingfeatureannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2859 (class 2606 OID 18893)
-- Name: samplingfeatureextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureextensionpropertyvalues
    ADD CONSTRAINT samplingfeatureextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2861 (class 2606 OID 18895)
-- Name: samplingfeatureexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureexternalidentifiers
    ADD CONSTRAINT samplingfeatureexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2863 (class 2606 OID 18897)
-- Name: samplingfeatures_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures
    ADD CONSTRAINT samplingfeatures_pkey PRIMARY KEY (samplingfeatureid);


--
-- TOC entry 2865 (class 2606 OID 18899)
-- Name: samplingfeatures_samplingfeaturecode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures
    ADD CONSTRAINT samplingfeatures_samplingfeaturecode_key UNIQUE (samplingfeaturecode);


--
-- TOC entry 2867 (class 2606 OID 18901)
-- Name: sectionresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT sectionresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2869 (class 2606 OID 18903)
-- Name: sectionresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalueannotations
    ADD CONSTRAINT sectionresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2871 (class 2606 OID 18905)
-- Name: sectionresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT sectionresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2873 (class 2606 OID 18907)
-- Name: sectionresultvalues_resultid_datavalue_valuedatetime_valued_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT sectionresultvalues_resultid_datavalue_valuedatetime_valued_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, xlocation, xaggregationinterval, xlocationunitsid, zlocation, zaggregationinterval, zlocationunitsid, censorcodecv, qualitycodecv, aggregationstatisticcv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2875 (class 2606 OID 18909)
-- Name: simulations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY simulations
    ADD CONSTRAINT simulations_pkey PRIMARY KEY (simulationid);


--
-- TOC entry 2877 (class 2606 OID 18911)
-- Name: sites_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (samplingfeatureid);


--
-- TOC entry 2879 (class 2606 OID 18913)
-- Name: spatialoffsets_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets
    ADD CONSTRAINT spatialoffsets_pkey PRIMARY KEY (spatialoffsetid);


--
-- TOC entry 2881 (class 2606 OID 18915)
-- Name: spatialreferenceexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferenceexternalidentifiers
    ADD CONSTRAINT spatialreferenceexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2883 (class 2606 OID 18917)
-- Name: spatialreferences_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferences
    ADD CONSTRAINT spatialreferences_pkey PRIMARY KEY (spatialreferenceid);


--
-- TOC entry 2885 (class 2606 OID 18919)
-- Name: specimenbatchpostions_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimenbatchpostions
    ADD CONSTRAINT specimenbatchpostions_pkey PRIMARY KEY (featureactionid);


--
-- TOC entry 2887 (class 2606 OID 18921)
-- Name: specimens_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimens
    ADD CONSTRAINT specimens_pkey PRIMARY KEY (samplingfeatureid);


--
-- TOC entry 2889 (class 2606 OID 18923)
-- Name: specimentaxonomicclassifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimentaxonomicclassifiers
    ADD CONSTRAINT specimentaxonomicclassifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2891 (class 2606 OID 18925)
-- Name: spectraresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT spectraresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2893 (class 2606 OID 18927)
-- Name: spectraresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalueannotations
    ADD CONSTRAINT spectraresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2895 (class 2606 OID 18929)
-- Name: spectraresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT spectraresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2897 (class 2606 OID 18931)
-- Name: spectraresultvalues_resultid_datavalue_valuedatetime_valued_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT spectraresultvalues_resultid_datavalue_valuedatetime_valued_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, excitationwavelength, emissionwavelength, wavelengthunitsid, censorcodecv, qualitycodecv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2899 (class 2606 OID 18933)
-- Name: taxonomicclassifierexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifierexternalidentifiers
    ADD CONSTRAINT taxonomicclassifierexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2901 (class 2606 OID 18935)
-- Name: taxonomicclassifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifiers
    ADD CONSTRAINT taxonomicclassifiers_pkey PRIMARY KEY (taxonomicclassifierid);


--
-- TOC entry 2903 (class 2606 OID 18937)
-- Name: timeseriesresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT timeseriesresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2905 (class 2606 OID 18939)
-- Name: timeseriesresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalueannotations
    ADD CONSTRAINT timeseriesresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2907 (class 2606 OID 18941)
-- Name: timeseriesresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT timeseriesresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2909 (class 2606 OID 18943)
-- Name: timeseriesresultvalues_resultid_datavalue_valuedatetime_val_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT timeseriesresultvalues_resultid_datavalue_valuedatetime_val_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, censorcodecv, qualitycodecv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2911 (class 2606 OID 18945)
-- Name: trajectoryresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT trajectoryresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2913 (class 2606 OID 18947)
-- Name: trajectoryresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalueannotations
    ADD CONSTRAINT trajectoryresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2915 (class 2606 OID 18949)
-- Name: trajectoryresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT trajectoryresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2917 (class 2606 OID 18951)
-- Name: trajectoryresultvalues_resultid_datavalue_valuedatetime_val_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT trajectoryresultvalues_resultid_datavalue_valuedatetime_val_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, xlocation, xlocationunitsid, ylocation, ylocationunitsid, zlocation, zlocationunitsid, trajectorydistance, trajectorydistanceaggregationinterval, trajectorydistanceunitsid, censorcodecv, qualitycodecv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2919 (class 2606 OID 18953)
-- Name: transectresults_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT transectresults_pkey PRIMARY KEY (resultid);


--
-- TOC entry 2921 (class 2606 OID 18955)
-- Name: transectresultvalueannotations_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalueannotations
    ADD CONSTRAINT transectresultvalueannotations_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2923 (class 2606 OID 18957)
-- Name: transectresultvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT transectresultvalues_pkey PRIMARY KEY (valueid);


--
-- TOC entry 2925 (class 2606 OID 18959)
-- Name: transectresultvalues_resultid_datavalue_valuedatetime_value_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT transectresultvalues_resultid_datavalue_valuedatetime_value_key UNIQUE (resultid, datavalue, valuedatetime, valuedatetimeutcoffset, xlocation, xlocationunitsid, ylocation, ylocationunitsid, transectdistance, transectdistanceaggregationinterval, transectdistanceunitsid, censorcodecv, qualitycodecv, aggregationstatisticcv, timeaggregationinterval, timeaggregationintervalunitsid);


--
-- TOC entry 2927 (class 2606 OID 18961)
-- Name: units_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unitsid);


--
-- TOC entry 2929 (class 2606 OID 18963)
-- Name: variableextensionpropertyvalues_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableextensionpropertyvalues
    ADD CONSTRAINT variableextensionpropertyvalues_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2931 (class 2606 OID 18965)
-- Name: variableexternalidentifiers_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableexternalidentifiers
    ADD CONSTRAINT variableexternalidentifiers_pkey PRIMARY KEY (bridgeid);


--
-- TOC entry 2933 (class 2606 OID 18967)
-- Name: variables_pkey; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT variables_pkey PRIMARY KEY (variableid);


--
-- TOC entry 2935 (class 2606 OID 18969)
-- Name: variables_variablecode_key; Type: CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT variables_variablecode_key UNIQUE (variablecode);


SET search_path = public, pg_catalog;

--
-- TOC entry 2937 (class 2606 OID 18971)
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


SET search_path = odm2, pg_catalog;

--
-- TOC entry 2938 (class 2606 OID 18972)
-- Name: fk_actionannotations_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionannotations
    ADD CONSTRAINT fk_actionannotations_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2939 (class 2606 OID 18977)
-- Name: fk_actionannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionannotations
    ADD CONSTRAINT fk_actionannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 2942 (class 2606 OID 18982)
-- Name: fk_actiondirectives_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actiondirectives
    ADD CONSTRAINT fk_actiondirectives_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2943 (class 2606 OID 18987)
-- Name: fk_actiondirectives_directives; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actiondirectives
    ADD CONSTRAINT fk_actiondirectives_directives FOREIGN KEY (directiveid) REFERENCES directives(directiveid) ON DELETE CASCADE;


--
-- TOC entry 2944 (class 2606 OID 18992)
-- Name: fk_actionextensionpropertyvalues_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionextensionpropertyvalues
    ADD CONSTRAINT fk_actionextensionpropertyvalues_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2945 (class 2606 OID 18997)
-- Name: fk_actionextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionextensionpropertyvalues
    ADD CONSTRAINT fk_actionextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 2940 (class 2606 OID 19002)
-- Name: fk_actionpeople_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionby
    ADD CONSTRAINT fk_actionpeople_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2941 (class 2606 OID 19007)
-- Name: fk_actionpeople_affiliations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actionby
    ADD CONSTRAINT fk_actionpeople_affiliations FOREIGN KEY (affiliationid) REFERENCES affiliations(affiliationid) ON DELETE CASCADE;


--
-- TOC entry 2946 (class 2606 OID 19012)
-- Name: fk_actions_cv_actiontype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actions
    ADD CONSTRAINT fk_actions_cv_actiontype FOREIGN KEY (actiontypecv) REFERENCES cv_actiontype(name) ON DELETE CASCADE;


--
-- TOC entry 2947 (class 2606 OID 19017)
-- Name: fk_actions_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY actions
    ADD CONSTRAINT fk_actions_methods FOREIGN KEY (methodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 2948 (class 2606 OID 19022)
-- Name: fk_affiliations_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY affiliations
    ADD CONSTRAINT fk_affiliations_organizations FOREIGN KEY (organizationid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 2949 (class 2606 OID 19027)
-- Name: fk_affiliations_people; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY affiliations
    ADD CONSTRAINT fk_affiliations_people FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- TOC entry 2950 (class 2606 OID 19032)
-- Name: fk_annotations_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY annotations
    ADD CONSTRAINT fk_annotations_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 2951 (class 2606 OID 19037)
-- Name: fk_annotations_cv_annotationtype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY annotations
    ADD CONSTRAINT fk_annotations_cv_annotationtype FOREIGN KEY (annotationtypecv) REFERENCES cv_annotationtype(name) ON DELETE CASCADE;


--
-- TOC entry 2952 (class 2606 OID 19042)
-- Name: fk_annotations_people; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY annotations
    ADD CONSTRAINT fk_annotations_people FOREIGN KEY (annotatorid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- TOC entry 2953 (class 2606 OID 19047)
-- Name: fk_authorlists_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY authorlists
    ADD CONSTRAINT fk_authorlists_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 2954 (class 2606 OID 19052)
-- Name: fk_authorlists_people; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY authorlists
    ADD CONSTRAINT fk_authorlists_people FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- TOC entry 2955 (class 2606 OID 19057)
-- Name: fk_calibrationactions_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationactions
    ADD CONSTRAINT fk_calibrationactions_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2956 (class 2606 OID 19062)
-- Name: fk_calibrationactions_instrumentoutputvariables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationactions
    ADD CONSTRAINT fk_calibrationactions_instrumentoutputvariables FOREIGN KEY (instrumentoutputvariableid) REFERENCES instrumentoutputvariables(instrumentoutputvariableid) ON DELETE CASCADE;


--
-- TOC entry 2957 (class 2606 OID 19067)
-- Name: fk_calibrationreferenceequipment_calibrationactions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationreferenceequipment
    ADD CONSTRAINT fk_calibrationreferenceequipment_calibrationactions FOREIGN KEY (actionid) REFERENCES calibrationactions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2958 (class 2606 OID 19072)
-- Name: fk_calibrationreferenceequipment_equipment; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationreferenceequipment
    ADD CONSTRAINT fk_calibrationreferenceequipment_equipment FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid) ON DELETE CASCADE;


--
-- TOC entry 2959 (class 2606 OID 19077)
-- Name: fk_calibrationstandards_calibrationactions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationstandards
    ADD CONSTRAINT fk_calibrationstandards_calibrationactions FOREIGN KEY (actionid) REFERENCES calibrationactions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2961 (class 2606 OID 19082)
-- Name: fk_categoricalresults_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresults
    ADD CONSTRAINT fk_categoricalresults_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 2962 (class 2606 OID 19087)
-- Name: fk_categoricalresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresults
    ADD CONSTRAINT fk_categoricalresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 2963 (class 2606 OID 19092)
-- Name: fk_categoricalresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresults
    ADD CONSTRAINT fk_categoricalresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 2964 (class 2606 OID 19097)
-- Name: fk_categoricalresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalueannotations
    ADD CONSTRAINT fk_categoricalresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 2965 (class 2606 OID 19102)
-- Name: fk_categoricalresultvalueannotations_categoricalresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalueannotations
    ADD CONSTRAINT fk_categoricalresultvalueannotations_categoricalresultvalues FOREIGN KEY (valueid) REFERENCES categoricalresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 2966 (class 2606 OID 19107)
-- Name: fk_categoricalresultvalues_categoricalresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY categoricalresultvalues
    ADD CONSTRAINT fk_categoricalresultvalues_categoricalresults FOREIGN KEY (resultid) REFERENCES categoricalresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 2967 (class 2606 OID 19112)
-- Name: fk_citationextensionpropertyvalues_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationextensionpropertyvalues
    ADD CONSTRAINT fk_citationextensionpropertyvalues_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 2968 (class 2606 OID 19117)
-- Name: fk_citationextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationextensionpropertyvalues
    ADD CONSTRAINT fk_citationextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 2969 (class 2606 OID 19122)
-- Name: fk_citationexternalidentifiers_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationexternalidentifiers
    ADD CONSTRAINT fk_citationexternalidentifiers_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 2970 (class 2606 OID 19127)
-- Name: fk_citationexternalidentifiers_externalidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY citationexternalidentifiers
    ADD CONSTRAINT fk_citationexternalidentifiers_externalidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 2971 (class 2606 OID 19132)
-- Name: fk_dataloggerfilecolumns_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 2972 (class 2606 OID 19137)
-- Name: fk_dataloggerfilecolumns_dataloggerfiles; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_dataloggerfiles FOREIGN KEY (dataloggerfileid) REFERENCES dataloggerfiles(dataloggerfileid) ON DELETE CASCADE;


--
-- TOC entry 2973 (class 2606 OID 19142)
-- Name: fk_dataloggerfilecolumns_instrumentoutputvariables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_instrumentoutputvariables FOREIGN KEY (instrumentoutputvariableid) REFERENCES instrumentoutputvariables(instrumentoutputvariableid) ON DELETE CASCADE;


--
-- TOC entry 2974 (class 2606 OID 19147)
-- Name: fk_dataloggerfilecolumns_recordingunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_recordingunits FOREIGN KEY (recordingintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 2975 (class 2606 OID 19152)
-- Name: fk_dataloggerfilecolumns_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 2976 (class 2606 OID 19157)
-- Name: fk_dataloggerfilecolumns_scanunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfilecolumns
    ADD CONSTRAINT fk_dataloggerfilecolumns_scanunits FOREIGN KEY (scanintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 2977 (class 2606 OID 19162)
-- Name: fk_dataloggerfiles_dataloggerprogramfiles; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerfiles
    ADD CONSTRAINT fk_dataloggerfiles_dataloggerprogramfiles FOREIGN KEY (programid) REFERENCES dataloggerprogramfiles(programid) ON DELETE CASCADE;


--
-- TOC entry 2978 (class 2606 OID 19167)
-- Name: fk_dataloggerprogramfiles_affiliations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataloggerprogramfiles
    ADD CONSTRAINT fk_dataloggerprogramfiles_affiliations FOREIGN KEY (affiliationid) REFERENCES affiliations(affiliationid) ON DELETE CASCADE;


--
-- TOC entry 2979 (class 2606 OID 19172)
-- Name: fk_dataquality_cv_dataqualitytype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataquality
    ADD CONSTRAINT fk_dataquality_cv_dataqualitytype FOREIGN KEY (dataqualitytypecv) REFERENCES cv_dataqualitytype(name) ON DELETE CASCADE;


--
-- TOC entry 2980 (class 2606 OID 19177)
-- Name: fk_dataquality_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY dataquality
    ADD CONSTRAINT fk_dataquality_units FOREIGN KEY (dataqualityvalueunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 2981 (class 2606 OID 19182)
-- Name: fk_datasetcitations_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetcitations
    ADD CONSTRAINT fk_datasetcitations_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 2982 (class 2606 OID 19187)
-- Name: fk_datasetcitations_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetcitations
    ADD CONSTRAINT fk_datasetcitations_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 2983 (class 2606 OID 19192)
-- Name: fk_datasetcitations_datasets; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetcitations
    ADD CONSTRAINT fk_datasetcitations_datasets FOREIGN KEY (datasetid) REFERENCES datasets(datasetid) ON DELETE CASCADE;


--
-- TOC entry 2984 (class 2606 OID 19197)
-- Name: fk_datasets_cv_datasettypecv; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasets
    ADD CONSTRAINT fk_datasets_cv_datasettypecv FOREIGN KEY (datasettypecv) REFERENCES cv_datasettype(name) ON DELETE CASCADE;


--
-- TOC entry 2985 (class 2606 OID 19202)
-- Name: fk_datasetsresults_datasets; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetsresults
    ADD CONSTRAINT fk_datasetsresults_datasets FOREIGN KEY (datasetid) REFERENCES datasets(datasetid) ON DELETE CASCADE;


--
-- TOC entry 2986 (class 2606 OID 19207)
-- Name: fk_datasetsresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY datasetsresults
    ADD CONSTRAINT fk_datasetsresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 2987 (class 2606 OID 19212)
-- Name: fk_directives_cv_directivetype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY directives
    ADD CONSTRAINT fk_directives_cv_directivetype FOREIGN KEY (directivetypecv) REFERENCES cv_directivetype(name) ON DELETE CASCADE;


--
-- TOC entry 2988 (class 2606 OID 19217)
-- Name: fk_equipment_cv_equipmenttype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT fk_equipment_cv_equipmenttype FOREIGN KEY (equipmenttypecv) REFERENCES cv_equipmenttype(name) ON DELETE CASCADE;


--
-- TOC entry 2989 (class 2606 OID 19222)
-- Name: fk_equipment_equipmentmodels; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT fk_equipment_equipmentmodels FOREIGN KEY (equipmentmodelid) REFERENCES equipmentmodels(equipmentmodelid) ON DELETE CASCADE;


--
-- TOC entry 2990 (class 2606 OID 19227)
-- Name: fk_equipment_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT fk_equipment_organizations FOREIGN KEY (equipmentvendorid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 2991 (class 2606 OID 19232)
-- Name: fk_equipment_people; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipment
    ADD CONSTRAINT fk_equipment_people FOREIGN KEY (equipmentownerid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- TOC entry 2995 (class 2606 OID 19237)
-- Name: fk_equipmentactions_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentused
    ADD CONSTRAINT fk_equipmentactions_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 2996 (class 2606 OID 19242)
-- Name: fk_equipmentactions_equipment; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentused
    ADD CONSTRAINT fk_equipmentactions_equipment FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid) ON DELETE CASCADE;


--
-- TOC entry 2992 (class 2606 OID 19247)
-- Name: fk_equipmentannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentannotations
    ADD CONSTRAINT fk_equipmentannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 2993 (class 2606 OID 19252)
-- Name: fk_equipmentannotations_equipment; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentannotations
    ADD CONSTRAINT fk_equipmentannotations_equipment FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid) ON DELETE CASCADE;


--
-- TOC entry 2994 (class 2606 OID 19257)
-- Name: fk_equipmentmodels_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY equipmentmodels
    ADD CONSTRAINT fk_equipmentmodels_organizations FOREIGN KEY (modelmanufacturerid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 2997 (class 2606 OID 19262)
-- Name: fk_extensionproperties_cv_propertydatatype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY extensionproperties
    ADD CONSTRAINT fk_extensionproperties_cv_propertydatatype FOREIGN KEY (propertydatatypecv) REFERENCES cv_propertydatatype(name) ON DELETE CASCADE;


--
-- TOC entry 2998 (class 2606 OID 19267)
-- Name: fk_extensionproperties_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY extensionproperties
    ADD CONSTRAINT fk_extensionproperties_units FOREIGN KEY (propertyunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 2999 (class 2606 OID 19272)
-- Name: fk_externalidentifiersystems_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY externalidentifiersystems
    ADD CONSTRAINT fk_externalidentifiersystems_organizations FOREIGN KEY (identifiersystemorganizationid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 3000 (class 2606 OID 19277)
-- Name: fk_featureactions_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY featureactions
    ADD CONSTRAINT fk_featureactions_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 3001 (class 2606 OID 19282)
-- Name: fk_featureactions_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY featureactions
    ADD CONSTRAINT fk_featureactions_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3087 (class 2606 OID 19287)
-- Name: fk_featureparents_featuresparent; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures
    ADD CONSTRAINT fk_featureparents_featuresparent FOREIGN KEY (relatedfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3088 (class 2606 OID 19292)
-- Name: fk_featureparents_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures
    ADD CONSTRAINT fk_featureparents_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3089 (class 2606 OID 19297)
-- Name: fk_featureparents_spatialoffsets; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures
    ADD CONSTRAINT fk_featureparents_spatialoffsets FOREIGN KEY (spatialoffsetid) REFERENCES spatialoffsets(spatialoffsetid) ON DELETE CASCADE;


--
-- TOC entry 2960 (class 2606 OID 19302)
-- Name: fk_fieldcalibrationstandards_referencematerials; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY calibrationstandards
    ADD CONSTRAINT fk_fieldcalibrationstandards_referencematerials FOREIGN KEY (referencematerialid) REFERENCES referencematerials(referencematerialid) ON DELETE CASCADE;


--
-- TOC entry 3002 (class 2606 OID 19307)
-- Name: fk_instrumentoutputvariables_equipmentmodels; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables
    ADD CONSTRAINT fk_instrumentoutputvariables_equipmentmodels FOREIGN KEY (modelid) REFERENCES equipmentmodels(equipmentmodelid) ON DELETE CASCADE;


--
-- TOC entry 3003 (class 2606 OID 19312)
-- Name: fk_instrumentoutputvariables_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables
    ADD CONSTRAINT fk_instrumentoutputvariables_methods FOREIGN KEY (instrumentmethodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 3004 (class 2606 OID 19317)
-- Name: fk_instrumentoutputvariables_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables
    ADD CONSTRAINT fk_instrumentoutputvariables_units FOREIGN KEY (instrumentrawoutputunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3005 (class 2606 OID 19322)
-- Name: fk_instrumentoutputvariables_variables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY instrumentoutputvariables
    ADD CONSTRAINT fk_instrumentoutputvariables_variables FOREIGN KEY (variableid) REFERENCES variables(variableid) ON DELETE CASCADE;


--
-- TOC entry 3006 (class 2606 OID 19327)
-- Name: fk_maintenanceactions_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY maintenanceactions
    ADD CONSTRAINT fk_maintenanceactions_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 3007 (class 2606 OID 19332)
-- Name: fk_measurementresults_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3008 (class 2606 OID 19337)
-- Name: fk_measurementresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3009 (class 2606 OID 19342)
-- Name: fk_measurementresults_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3010 (class 2606 OID 19347)
-- Name: fk_measurementresults_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3011 (class 2606 OID 19352)
-- Name: fk_measurementresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3012 (class 2606 OID 19357)
-- Name: fk_measurementresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3013 (class 2606 OID 19362)
-- Name: fk_measurementresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3014 (class 2606 OID 19367)
-- Name: fk_measurementresults_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3015 (class 2606 OID 19372)
-- Name: fk_measurementresults_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresults
    ADD CONSTRAINT fk_measurementresults_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3016 (class 2606 OID 19377)
-- Name: fk_measurementresultvalueannotations_measurementresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalueannotations
    ADD CONSTRAINT fk_measurementresultvalueannotations_measurementresultvalues FOREIGN KEY (valueid) REFERENCES measurementresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3018 (class 2606 OID 19382)
-- Name: fk_measurementresultvalues_measurementresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalues
    ADD CONSTRAINT fk_measurementresultvalues_measurementresults FOREIGN KEY (resultid) REFERENCES measurementresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3019 (class 2606 OID 19387)
-- Name: fk_methodannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodannotations
    ADD CONSTRAINT fk_methodannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3020 (class 2606 OID 19392)
-- Name: fk_methodannotations_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodannotations
    ADD CONSTRAINT fk_methodannotations_methods FOREIGN KEY (methodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 3021 (class 2606 OID 19397)
-- Name: fk_methodcitations_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodcitations
    ADD CONSTRAINT fk_methodcitations_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 3022 (class 2606 OID 19402)
-- Name: fk_methodcitations_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodcitations
    ADD CONSTRAINT fk_methodcitations_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3023 (class 2606 OID 19407)
-- Name: fk_methodcitations_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodcitations
    ADD CONSTRAINT fk_methodcitations_methods FOREIGN KEY (methodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 3024 (class 2606 OID 19412)
-- Name: fk_methodextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodextensionpropertyvalues
    ADD CONSTRAINT fk_methodextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 3025 (class 2606 OID 19417)
-- Name: fk_methodextensionpropertyvalues_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodextensionpropertyvalues
    ADD CONSTRAINT fk_methodextensionpropertyvalues_methods FOREIGN KEY (methodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 3026 (class 2606 OID 19422)
-- Name: fk_methodexternalidentifiers_externalidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodexternalidentifiers
    ADD CONSTRAINT fk_methodexternalidentifiers_externalidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3027 (class 2606 OID 19427)
-- Name: fk_methodexternalidentifiers_methods; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methodexternalidentifiers
    ADD CONSTRAINT fk_methodexternalidentifiers_methods FOREIGN KEY (methodid) REFERENCES methods(methodid) ON DELETE CASCADE;


--
-- TOC entry 3028 (class 2606 OID 19432)
-- Name: fk_methods_cv_methodtype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methods
    ADD CONSTRAINT fk_methods_cv_methodtype FOREIGN KEY (methodtypecv) REFERENCES cv_methodtype(name) ON DELETE CASCADE;


--
-- TOC entry 3029 (class 2606 OID 19437)
-- Name: fk_methods_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY methods
    ADD CONSTRAINT fk_methods_organizations FOREIGN KEY (organizationid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 3030 (class 2606 OID 19442)
-- Name: fk_modelaffiliations_affiliations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY modelaffiliations
    ADD CONSTRAINT fk_modelaffiliations_affiliations FOREIGN KEY (affiliationid) REFERENCES affiliations(affiliationid) ON DELETE CASCADE;


--
-- TOC entry 3031 (class 2606 OID 19447)
-- Name: fk_modelaffiliations_models; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY modelaffiliations
    ADD CONSTRAINT fk_modelaffiliations_models FOREIGN KEY (modelid) REFERENCES models(modelid) ON DELETE CASCADE;


--
-- TOC entry 3032 (class 2606 OID 19452)
-- Name: fk_organizations_cv_organizationtype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT fk_organizations_cv_organizationtype FOREIGN KEY (organizationtypecv) REFERENCES cv_organizationtype(name) ON DELETE CASCADE;


--
-- TOC entry 3033 (class 2606 OID 19457)
-- Name: fk_organizations_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT fk_organizations_organizations FOREIGN KEY (parentorganizationid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 3173 (class 2606 OID 19462)
-- Name: fk_parenttaxon_taxon; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifiers
    ADD CONSTRAINT fk_parenttaxon_taxon FOREIGN KEY (parenttaxonomicclassifierid) REFERENCES taxonomicclassifiers(taxonomicclassifierid) ON DELETE CASCADE;


--
-- TOC entry 3034 (class 2606 OID 19467)
-- Name: fk_personexternalidentifiers_externalidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY personexternalidentifiers
    ADD CONSTRAINT fk_personexternalidentifiers_externalidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3035 (class 2606 OID 19472)
-- Name: fk_personexternalidentifiers_people; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY personexternalidentifiers
    ADD CONSTRAINT fk_personexternalidentifiers_people FOREIGN KEY (personid) REFERENCES people(personid) ON DELETE CASCADE;


--
-- TOC entry 3036 (class 2606 OID 19477)
-- Name: fk_pointcoverageresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3037 (class 2606 OID 19482)
-- Name: fk_pointcoverageresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3038 (class 2606 OID 19487)
-- Name: fk_pointcoverageresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3039 (class 2606 OID 19492)
-- Name: fk_pointcoverageresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_xunits FOREIGN KEY (intendedxspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3040 (class 2606 OID 19497)
-- Name: fk_pointcoverageresults_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_yunits FOREIGN KEY (intendedyspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3041 (class 2606 OID 19502)
-- Name: fk_pointcoverageresults_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresults
    ADD CONSTRAINT fk_pointcoverageresults_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3042 (class 2606 OID 19507)
-- Name: fk_pointcoverageresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalueannotations
    ADD CONSTRAINT fk_pointcoverageresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3043 (class 2606 OID 19512)
-- Name: fk_pointcoverageresultvalueannotations_pointcoverageresultvalue; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalueannotations
    ADD CONSTRAINT fk_pointcoverageresultvalueannotations_pointcoverageresultvalue FOREIGN KEY (valueid) REFERENCES pointcoverageresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3044 (class 2606 OID 19517)
-- Name: fk_pointcoverageresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT fk_pointcoverageresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3045 (class 2606 OID 19522)
-- Name: fk_pointcoverageresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT fk_pointcoverageresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3046 (class 2606 OID 19527)
-- Name: fk_pointcoverageresultvalues_pointcoverageresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT fk_pointcoverageresultvalues_pointcoverageresults FOREIGN KEY (resultid) REFERENCES pointcoverageresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3047 (class 2606 OID 19532)
-- Name: fk_pointcoverageresultvalues_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT fk_pointcoverageresultvalues_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3048 (class 2606 OID 19537)
-- Name: fk_pointcoverageresultvalues_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY pointcoverageresultvalues
    ADD CONSTRAINT fk_pointcoverageresultvalues_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3049 (class 2606 OID 19542)
-- Name: fk_profileresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3050 (class 2606 OID 19547)
-- Name: fk_profileresults_dunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_dunits FOREIGN KEY (intendedzspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3051 (class 2606 OID 19552)
-- Name: fk_profileresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3052 (class 2606 OID 19557)
-- Name: fk_profileresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3053 (class 2606 OID 19562)
-- Name: fk_profileresults_tunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_tunits FOREIGN KEY (intendedtimespacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3054 (class 2606 OID 19567)
-- Name: fk_profileresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3055 (class 2606 OID 19572)
-- Name: fk_profileresults_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresults
    ADD CONSTRAINT fk_profileresults_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3056 (class 2606 OID 19577)
-- Name: fk_profileresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalueannotations
    ADD CONSTRAINT fk_profileresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3057 (class 2606 OID 19582)
-- Name: fk_profileresultvalueannotations_profileresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalueannotations
    ADD CONSTRAINT fk_profileresultvalueannotations_profileresultvalues FOREIGN KEY (valueid) REFERENCES profileresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3058 (class 2606 OID 19587)
-- Name: fk_profileresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT fk_profileresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3059 (class 2606 OID 19592)
-- Name: fk_profileresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT fk_profileresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3060 (class 2606 OID 19597)
-- Name: fk_profileresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT fk_profileresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3061 (class 2606 OID 19602)
-- Name: fk_profileresultvalues_dunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT fk_profileresultvalues_dunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3062 (class 2606 OID 19607)
-- Name: fk_profileresultvalues_profileresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY profileresultvalues
    ADD CONSTRAINT fk_profileresultvalues_profileresults FOREIGN KEY (resultid) REFERENCES profileresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3065 (class 2606 OID 19612)
-- Name: fk_referencematerials_cv_medium; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials
    ADD CONSTRAINT fk_referencematerials_cv_medium FOREIGN KEY (referencematerialmediumcv) REFERENCES cv_medium(name) ON DELETE CASCADE;


--
-- TOC entry 3066 (class 2606 OID 19617)
-- Name: fk_referencematerials_organizations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials
    ADD CONSTRAINT fk_referencematerials_organizations FOREIGN KEY (referencematerialorganizationid) REFERENCES organizations(organizationid) ON DELETE CASCADE;


--
-- TOC entry 3067 (class 2606 OID 19622)
-- Name: fk_referencematerials_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerials
    ADD CONSTRAINT fk_referencematerials_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3068 (class 2606 OID 19627)
-- Name: fk_referencematerialvalues_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues
    ADD CONSTRAINT fk_referencematerialvalues_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 3069 (class 2606 OID 19632)
-- Name: fk_referencematerialvalues_referencematerials; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues
    ADD CONSTRAINT fk_referencematerialvalues_referencematerials FOREIGN KEY (referencematerialid) REFERENCES referencematerials(referencematerialid) ON DELETE CASCADE;


--
-- TOC entry 3070 (class 2606 OID 19637)
-- Name: fk_referencematerialvalues_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues
    ADD CONSTRAINT fk_referencematerialvalues_units FOREIGN KEY (unitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3071 (class 2606 OID 19642)
-- Name: fk_referencematerialvalues_variables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialvalues
    ADD CONSTRAINT fk_referencematerialvalues_variables FOREIGN KEY (variableid) REFERENCES variables(variableid) ON DELETE CASCADE;


--
-- TOC entry 3063 (class 2606 OID 19647)
-- Name: fk_refmaterialextidentifiers_extidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialexternalidentifiers
    ADD CONSTRAINT fk_refmaterialextidentifiers_extidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3064 (class 2606 OID 19652)
-- Name: fk_refmaterialextidentifiers_refmaterials; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY referencematerialexternalidentifiers
    ADD CONSTRAINT fk_refmaterialextidentifiers_refmaterials FOREIGN KEY (referencematerialid) REFERENCES referencematerials(referencematerialid) ON DELETE CASCADE;


--
-- TOC entry 3072 (class 2606 OID 19657)
-- Name: fk_relatedactions_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedactions
    ADD CONSTRAINT fk_relatedactions_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 3073 (class 2606 OID 19662)
-- Name: fk_relatedactions_actions_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedactions
    ADD CONSTRAINT fk_relatedactions_actions_arerelated FOREIGN KEY (relatedactionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 3074 (class 2606 OID 19667)
-- Name: fk_relatedactions_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedactions
    ADD CONSTRAINT fk_relatedactions_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3075 (class 2606 OID 19672)
-- Name: fk_relatedannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedannotations
    ADD CONSTRAINT fk_relatedannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3076 (class 2606 OID 19677)
-- Name: fk_relatedannotations_annotations_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedannotations
    ADD CONSTRAINT fk_relatedannotations_annotations_arerelated FOREIGN KEY (relatedannotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3077 (class 2606 OID 19682)
-- Name: fk_relatedannotations_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedannotations
    ADD CONSTRAINT fk_relatedannotations_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3078 (class 2606 OID 19687)
-- Name: fk_relatedcitations_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedcitations
    ADD CONSTRAINT fk_relatedcitations_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 3079 (class 2606 OID 19692)
-- Name: fk_relatedcitations_citations_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedcitations
    ADD CONSTRAINT fk_relatedcitations_citations_arerelated FOREIGN KEY (relatedcitationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 3080 (class 2606 OID 19697)
-- Name: fk_relatedcitations_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedcitations
    ADD CONSTRAINT fk_relatedcitations_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3081 (class 2606 OID 19702)
-- Name: fk_relateddatasets_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relateddatasets
    ADD CONSTRAINT fk_relateddatasets_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3082 (class 2606 OID 19707)
-- Name: fk_relateddatasets_datasets; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relateddatasets
    ADD CONSTRAINT fk_relateddatasets_datasets FOREIGN KEY (datasetid) REFERENCES datasets(datasetid) ON DELETE CASCADE;


--
-- TOC entry 3083 (class 2606 OID 19712)
-- Name: fk_relateddatasets_datasets_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relateddatasets
    ADD CONSTRAINT fk_relateddatasets_datasets_arerelated FOREIGN KEY (relateddatasetid) REFERENCES datasets(datasetid) ON DELETE CASCADE;


--
-- TOC entry 3084 (class 2606 OID 19717)
-- Name: fk_relatedequipment_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedequipment
    ADD CONSTRAINT fk_relatedequipment_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3085 (class 2606 OID 19722)
-- Name: fk_relatedequipment_equipment; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedequipment
    ADD CONSTRAINT fk_relatedequipment_equipment FOREIGN KEY (equipmentid) REFERENCES equipment(equipmentid) ON DELETE CASCADE;


--
-- TOC entry 3086 (class 2606 OID 19727)
-- Name: fk_relatedequipment_equipment_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedequipment
    ADD CONSTRAINT fk_relatedequipment_equipment_arerelated FOREIGN KEY (relatedequipmentid) REFERENCES equipment(equipmentid) ON DELETE CASCADE;


--
-- TOC entry 3090 (class 2606 OID 19732)
-- Name: fk_relatedfeatures_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedfeatures
    ADD CONSTRAINT fk_relatedfeatures_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3091 (class 2606 OID 19737)
-- Name: fk_relatedmodels_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedmodels
    ADD CONSTRAINT fk_relatedmodels_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3092 (class 2606 OID 19742)
-- Name: fk_relatedmodels_models; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedmodels
    ADD CONSTRAINT fk_relatedmodels_models FOREIGN KEY (modelid) REFERENCES models(modelid) ON DELETE CASCADE;


--
-- TOC entry 3093 (class 2606 OID 19747)
-- Name: fk_relatedresults_cv_relationshiptype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedresults
    ADD CONSTRAINT fk_relatedresults_cv_relationshiptype FOREIGN KEY (relationshiptypecv) REFERENCES cv_relationshiptype(name) ON DELETE CASCADE;


--
-- TOC entry 3094 (class 2606 OID 19752)
-- Name: fk_relatedresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedresults
    ADD CONSTRAINT fk_relatedresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3095 (class 2606 OID 19757)
-- Name: fk_relatedresults_results_arerelated; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY relatedresults
    ADD CONSTRAINT fk_relatedresults_results_arerelated FOREIGN KEY (relatedresultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3096 (class 2606 OID 19762)
-- Name: fk_resultannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultannotations
    ADD CONSTRAINT fk_resultannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3097 (class 2606 OID 19767)
-- Name: fk_resultannotations_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultannotations
    ADD CONSTRAINT fk_resultannotations_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3098 (class 2606 OID 19772)
-- Name: fk_resultderivationequations_derivationequations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultderivationequations
    ADD CONSTRAINT fk_resultderivationequations_derivationequations FOREIGN KEY (derivationequationid) REFERENCES derivationequations(derivationequationid) ON DELETE CASCADE;


--
-- TOC entry 3099 (class 2606 OID 19777)
-- Name: fk_resultderivationequations_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultderivationequations
    ADD CONSTRAINT fk_resultderivationequations_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3100 (class 2606 OID 19782)
-- Name: fk_resultextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultextensionpropertyvalues
    ADD CONSTRAINT fk_resultextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 3101 (class 2606 OID 19787)
-- Name: fk_resultextensionpropertyvalues_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultextensionpropertyvalues
    ADD CONSTRAINT fk_resultextensionpropertyvalues_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3102 (class 2606 OID 19792)
-- Name: fk_resultnormalizationvalues_referencematerialvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultnormalizationvalues
    ADD CONSTRAINT fk_resultnormalizationvalues_referencematerialvalues FOREIGN KEY (normalizedbyreferencematerialvalueid) REFERENCES referencematerialvalues(referencematerialvalueid) ON DELETE CASCADE;


--
-- TOC entry 3103 (class 2606 OID 19797)
-- Name: fk_resultnormalizationvalues_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultnormalizationvalues
    ADD CONSTRAINT fk_resultnormalizationvalues_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3104 (class 2606 OID 19802)
-- Name: fk_results_cv_medium; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_cv_medium FOREIGN KEY (sampledmediumcv) REFERENCES cv_medium(name) ON DELETE CASCADE;


--
-- TOC entry 3105 (class 2606 OID 19807)
-- Name: fk_results_cv_resulttype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_cv_resulttype FOREIGN KEY (resulttypecv) REFERENCES cv_resulttype(name) ON DELETE CASCADE;


--
-- TOC entry 3106 (class 2606 OID 19812)
-- Name: fk_results_cv_status; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_cv_status FOREIGN KEY (statuscv) REFERENCES cv_status(name) ON DELETE CASCADE;


--
-- TOC entry 3107 (class 2606 OID 19817)
-- Name: fk_results_featureactions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_featureactions FOREIGN KEY (featureactionid) REFERENCES featureactions(featureactionid) ON DELETE CASCADE;


--
-- TOC entry 3108 (class 2606 OID 19822)
-- Name: fk_results_processinglevels; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_processinglevels FOREIGN KEY (processinglevelid) REFERENCES processinglevels(processinglevelid) ON DELETE CASCADE;


--
-- TOC entry 3109 (class 2606 OID 19827)
-- Name: fk_results_taxonomicclassifiers; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_taxonomicclassifiers FOREIGN KEY (taxonomicclassifierid) REFERENCES taxonomicclassifiers(taxonomicclassifierid) ON DELETE CASCADE;


--
-- TOC entry 3110 (class 2606 OID 19832)
-- Name: fk_results_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_units FOREIGN KEY (unitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3111 (class 2606 OID 19837)
-- Name: fk_results_variables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY results
    ADD CONSTRAINT fk_results_variables FOREIGN KEY (variableid) REFERENCES variables(variableid) ON DELETE CASCADE;


--
-- TOC entry 3112 (class 2606 OID 19842)
-- Name: fk_resultsdataquality_dataquality; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultsdataquality
    ADD CONSTRAINT fk_resultsdataquality_dataquality FOREIGN KEY (dataqualityid) REFERENCES dataquality(dataqualityid) ON DELETE CASCADE;


--
-- TOC entry 3113 (class 2606 OID 19847)
-- Name: fk_resultsdataquality_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY resultsdataquality
    ADD CONSTRAINT fk_resultsdataquality_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3017 (class 2606 OID 19852)
-- Name: fk_resultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY measurementresultvalueannotations
    ADD CONSTRAINT fk_resultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3114 (class 2606 OID 19857)
-- Name: fk_samplingfeatureannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureannotations
    ADD CONSTRAINT fk_samplingfeatureannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3115 (class 2606 OID 19862)
-- Name: fk_samplingfeatureannotations_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureannotations
    ADD CONSTRAINT fk_samplingfeatureannotations_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3116 (class 2606 OID 19867)
-- Name: fk_samplingfeatureextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureextensionpropertyvalues
    ADD CONSTRAINT fk_samplingfeatureextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 3117 (class 2606 OID 19872)
-- Name: fk_samplingfeatureextensionpropertyvalues_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureextensionpropertyvalues
    ADD CONSTRAINT fk_samplingfeatureextensionpropertyvalues_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3118 (class 2606 OID 19877)
-- Name: fk_samplingfeatureexternalidentifiers_externalidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureexternalidentifiers
    ADD CONSTRAINT fk_samplingfeatureexternalidentifiers_externalidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3119 (class 2606 OID 19882)
-- Name: fk_samplingfeatureexternalidentifiers_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatureexternalidentifiers
    ADD CONSTRAINT fk_samplingfeatureexternalidentifiers_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3120 (class 2606 OID 19887)
-- Name: fk_samplingfeatures_cv_elevationdatum; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures
    ADD CONSTRAINT fk_samplingfeatures_cv_elevationdatum FOREIGN KEY (elevationdatumcv) REFERENCES cv_elevationdatum(name) ON DELETE CASCADE;


--
-- TOC entry 3121 (class 2606 OID 19892)
-- Name: fk_samplingfeatures_cv_samplingfeaturegeotype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures
    ADD CONSTRAINT fk_samplingfeatures_cv_samplingfeaturegeotype FOREIGN KEY (samplingfeaturegeotypecv) REFERENCES cv_samplingfeaturegeotype(name) ON DELETE CASCADE;


--
-- TOC entry 3122 (class 2606 OID 19897)
-- Name: fk_samplingfeatures_cv_samplingfeaturetype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY samplingfeatures
    ADD CONSTRAINT fk_samplingfeatures_cv_samplingfeaturetype FOREIGN KEY (samplingfeaturetypecv) REFERENCES cv_samplingfeaturetype(name) ON DELETE CASCADE;


--
-- TOC entry 3123 (class 2606 OID 19902)
-- Name: fk_sectionresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3124 (class 2606 OID 19907)
-- Name: fk_sectionresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3125 (class 2606 OID 19912)
-- Name: fk_sectionresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3126 (class 2606 OID 19917)
-- Name: fk_sectionresults_tmunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_tmunits FOREIGN KEY (intendedtimespacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3127 (class 2606 OID 19922)
-- Name: fk_sectionresults_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_units FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3128 (class 2606 OID 19927)
-- Name: fk_sectionresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_xunits FOREIGN KEY (intendedxspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3129 (class 2606 OID 19932)
-- Name: fk_sectionresults_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresults
    ADD CONSTRAINT fk_sectionresults_zunits FOREIGN KEY (intendedzspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3130 (class 2606 OID 19937)
-- Name: fk_sectionresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalueannotations
    ADD CONSTRAINT fk_sectionresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3131 (class 2606 OID 19942)
-- Name: fk_sectionresultvalueannotations_sectionresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalueannotations
    ADD CONSTRAINT fk_sectionresultvalueannotations_sectionresultvalues FOREIGN KEY (valueid) REFERENCES sectionresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3132 (class 2606 OID 19947)
-- Name: fk_sectionresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3133 (class 2606 OID 19952)
-- Name: fk_sectionresultvalues_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3134 (class 2606 OID 19957)
-- Name: fk_sectionresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3135 (class 2606 OID 19962)
-- Name: fk_sectionresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3136 (class 2606 OID 19967)
-- Name: fk_sectionresultvalues_sectionresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_sectionresults FOREIGN KEY (resultid) REFERENCES sectionresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3137 (class 2606 OID 19972)
-- Name: fk_sectionresultvalues_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3138 (class 2606 OID 19977)
-- Name: fk_sectionresultvalues_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sectionresultvalues
    ADD CONSTRAINT fk_sectionresultvalues_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3139 (class 2606 OID 19982)
-- Name: fk_simulations_actions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY simulations
    ADD CONSTRAINT fk_simulations_actions FOREIGN KEY (actionid) REFERENCES actions(actionid) ON DELETE CASCADE;


--
-- TOC entry 3140 (class 2606 OID 19987)
-- Name: fk_simulations_models; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY simulations
    ADD CONSTRAINT fk_simulations_models FOREIGN KEY (modelid) REFERENCES models(modelid) ON DELETE CASCADE;


--
-- TOC entry 3141 (class 2606 OID 19992)
-- Name: fk_sites_cv_sitetype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT fk_sites_cv_sitetype FOREIGN KEY (sitetypecv) REFERENCES cv_sitetype(name) ON DELETE CASCADE;


--
-- TOC entry 3142 (class 2606 OID 19997)
-- Name: fk_sites_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT fk_sites_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3143 (class 2606 OID 20002)
-- Name: fk_sites_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT fk_sites_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3144 (class 2606 OID 20007)
-- Name: fk_spatialoffsets_cv_spatialoffsettype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets
    ADD CONSTRAINT fk_spatialoffsets_cv_spatialoffsettype FOREIGN KEY (spatialoffsettypecv) REFERENCES cv_spatialoffsettype(name) ON DELETE CASCADE;


--
-- TOC entry 3145 (class 2606 OID 20012)
-- Name: fk_spatialoffsets_offset1units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets
    ADD CONSTRAINT fk_spatialoffsets_offset1units FOREIGN KEY (offset1unitid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3146 (class 2606 OID 20017)
-- Name: fk_spatialoffsets_offset2units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets
    ADD CONSTRAINT fk_spatialoffsets_offset2units FOREIGN KEY (offset2unitid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3147 (class 2606 OID 20022)
-- Name: fk_spatialoffsets_offset3units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialoffsets
    ADD CONSTRAINT fk_spatialoffsets_offset3units FOREIGN KEY (offset3unitid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3148 (class 2606 OID 20027)
-- Name: fk_spatialreferenceexternalidentifiers_externalidentifiersystem; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferenceexternalidentifiers
    ADD CONSTRAINT fk_spatialreferenceexternalidentifiers_externalidentifiersystem FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3149 (class 2606 OID 20032)
-- Name: fk_spatialreferenceexternalidentifiers_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spatialreferenceexternalidentifiers
    ADD CONSTRAINT fk_spatialreferenceexternalidentifiers_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3150 (class 2606 OID 20037)
-- Name: fk_specimenbatchpostions_featureactions; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimenbatchpostions
    ADD CONSTRAINT fk_specimenbatchpostions_featureactions FOREIGN KEY (featureactionid) REFERENCES featureactions(featureactionid) ON DELETE CASCADE;


--
-- TOC entry 3151 (class 2606 OID 20042)
-- Name: fk_specimens_cv_medium; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimens
    ADD CONSTRAINT fk_specimens_cv_medium FOREIGN KEY (specimenmediumcv) REFERENCES cv_medium(name) ON DELETE CASCADE;


--
-- TOC entry 3152 (class 2606 OID 20047)
-- Name: fk_specimens_cv_specimentype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimens
    ADD CONSTRAINT fk_specimens_cv_specimentype FOREIGN KEY (specimentypecv) REFERENCES cv_specimentype(name) ON DELETE CASCADE;


--
-- TOC entry 3153 (class 2606 OID 20052)
-- Name: fk_specimens_samplingfeatures; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimens
    ADD CONSTRAINT fk_specimens_samplingfeatures FOREIGN KEY (samplingfeatureid) REFERENCES samplingfeatures(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3154 (class 2606 OID 20057)
-- Name: fk_specimentaxonomicclassifiers_citations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimentaxonomicclassifiers
    ADD CONSTRAINT fk_specimentaxonomicclassifiers_citations FOREIGN KEY (citationid) REFERENCES citations(citationid) ON DELETE CASCADE;


--
-- TOC entry 3155 (class 2606 OID 20062)
-- Name: fk_specimentaxonomicclassifiers_specimens; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimentaxonomicclassifiers
    ADD CONSTRAINT fk_specimentaxonomicclassifiers_specimens FOREIGN KEY (samplingfeatureid) REFERENCES specimens(samplingfeatureid) ON DELETE CASCADE;


--
-- TOC entry 3156 (class 2606 OID 20067)
-- Name: fk_specimentaxonomicclassifiers_taxonomicclassifiers; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY specimentaxonomicclassifiers
    ADD CONSTRAINT fk_specimentaxonomicclassifiers_taxonomicclassifiers FOREIGN KEY (taxonomicclassifierid) REFERENCES taxonomicclassifiers(taxonomicclassifierid) ON DELETE CASCADE;


--
-- TOC entry 3157 (class 2606 OID 20072)
-- Name: fk_spectraresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3158 (class 2606 OID 20077)
-- Name: fk_spectraresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3159 (class 2606 OID 20082)
-- Name: fk_spectraresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3160 (class 2606 OID 20087)
-- Name: fk_spectraresults_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_units FOREIGN KEY (intendedwavelengthspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3161 (class 2606 OID 20092)
-- Name: fk_spectraresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3162 (class 2606 OID 20097)
-- Name: fk_spectraresults_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3163 (class 2606 OID 20102)
-- Name: fk_spectraresults_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresults
    ADD CONSTRAINT fk_spectraresults_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3164 (class 2606 OID 20107)
-- Name: fk_spectraresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalueannotations
    ADD CONSTRAINT fk_spectraresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3165 (class 2606 OID 20112)
-- Name: fk_spectraresultvalueannotations_spectraresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalueannotations
    ADD CONSTRAINT fk_spectraresultvalueannotations_spectraresultvalues FOREIGN KEY (valueid) REFERENCES spectraresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3166 (class 2606 OID 20117)
-- Name: fk_spectraresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT fk_spectraresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3167 (class 2606 OID 20122)
-- Name: fk_spectraresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT fk_spectraresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3168 (class 2606 OID 20127)
-- Name: fk_spectraresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT fk_spectraresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3169 (class 2606 OID 20132)
-- Name: fk_spectraresultvalues_spectraresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT fk_spectraresultvalues_spectraresults FOREIGN KEY (resultid) REFERENCES spectraresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3170 (class 2606 OID 20137)
-- Name: fk_spectraresultvalues_wunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY spectraresultvalues
    ADD CONSTRAINT fk_spectraresultvalues_wunits FOREIGN KEY (wavelengthunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3171 (class 2606 OID 20142)
-- Name: fk_taxonomicclassifierextids_extidsystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifierexternalidentifiers
    ADD CONSTRAINT fk_taxonomicclassifierextids_extidsystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3172 (class 2606 OID 20147)
-- Name: fk_taxonomicclassifierextids_taxonomicclassifiers; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifierexternalidentifiers
    ADD CONSTRAINT fk_taxonomicclassifierextids_taxonomicclassifiers FOREIGN KEY (taxonomicclassifierid) REFERENCES taxonomicclassifiers(taxonomicclassifierid) ON DELETE CASCADE;


--
-- TOC entry 3174 (class 2606 OID 20152)
-- Name: fk_taxonomicclassifiers_cv_taxonomicclassifiertype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY taxonomicclassifiers
    ADD CONSTRAINT fk_taxonomicclassifiers_cv_taxonomicclassifiertype FOREIGN KEY (taxonomicclassifiertypecv) REFERENCES cv_taxonomicclassifiertype(name) ON DELETE CASCADE;


--
-- TOC entry 3175 (class 2606 OID 20157)
-- Name: fk_timeseriesresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3176 (class 2606 OID 20162)
-- Name: fk_timeseriesresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3177 (class 2606 OID 20167)
-- Name: fk_timeseriesresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3178 (class 2606 OID 20172)
-- Name: fk_timeseriesresults_tunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_tunits FOREIGN KEY (intendedtimespacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3179 (class 2606 OID 20177)
-- Name: fk_timeseriesresults_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3180 (class 2606 OID 20182)
-- Name: fk_timeseriesresults_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3181 (class 2606 OID 20187)
-- Name: fk_timeseriesresults_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresults
    ADD CONSTRAINT fk_timeseriesresults_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3182 (class 2606 OID 20192)
-- Name: fk_timeseriesresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalueannotations
    ADD CONSTRAINT fk_timeseriesresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3183 (class 2606 OID 20197)
-- Name: fk_timeseriesresultvalueannotations_timeseriesresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalueannotations
    ADD CONSTRAINT fk_timeseriesresultvalueannotations_timeseriesresultvalues FOREIGN KEY (valueid) REFERENCES timeseriesresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3184 (class 2606 OID 20202)
-- Name: fk_timeseriesresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT fk_timeseriesresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3185 (class 2606 OID 20207)
-- Name: fk_timeseriesresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT fk_timeseriesresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3186 (class 2606 OID 20212)
-- Name: fk_timeseriesresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT fk_timeseriesresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3187 (class 2606 OID 20217)
-- Name: fk_timeseriesresultvalues_timeseriesresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY timeseriesresultvalues
    ADD CONSTRAINT fk_timeseriesresultvalues_timeseriesresults FOREIGN KEY (resultid) REFERENCES timeseriesresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3188 (class 2606 OID 20222)
-- Name: fk_trajectoryresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT fk_trajectoryresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3189 (class 2606 OID 20227)
-- Name: fk_trajectoryresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT fk_trajectoryresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3190 (class 2606 OID 20232)
-- Name: fk_trajectoryresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT fk_trajectoryresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3191 (class 2606 OID 20237)
-- Name: fk_trajectoryresults_tsunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT fk_trajectoryresults_tsunits FOREIGN KEY (intendedtrajectoryspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3192 (class 2606 OID 20242)
-- Name: fk_trajectoryresults_tunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresults
    ADD CONSTRAINT fk_trajectoryresults_tunits FOREIGN KEY (intendedtimespacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3193 (class 2606 OID 20247)
-- Name: fk_trajectoryresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalueannotations
    ADD CONSTRAINT fk_trajectoryresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3194 (class 2606 OID 20252)
-- Name: fk_trajectoryresultvalueannotations_trajectoryresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalueannotations
    ADD CONSTRAINT fk_trajectoryresultvalueannotations_trajectoryresultvalues FOREIGN KEY (valueid) REFERENCES trajectoryresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3195 (class 2606 OID 20257)
-- Name: fk_trajectoryresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3196 (class 2606 OID 20262)
-- Name: fk_trajectoryresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3197 (class 2606 OID 20267)
-- Name: fk_trajectoryresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3198 (class 2606 OID 20272)
-- Name: fk_trajectoryresultvalues_distanceunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_distanceunits FOREIGN KEY (trajectorydistanceunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3199 (class 2606 OID 20277)
-- Name: fk_trajectoryresultvalues_trajectoryresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_trajectoryresults FOREIGN KEY (resultid) REFERENCES trajectoryresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3200 (class 2606 OID 20282)
-- Name: fk_trajectoryresultvalues_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3201 (class 2606 OID 20287)
-- Name: fk_trajectoryresultvalues_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3202 (class 2606 OID 20292)
-- Name: fk_trajectoryresultvalues_zunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY trajectoryresultvalues
    ADD CONSTRAINT fk_trajectoryresultvalues_zunits FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3203 (class 2606 OID 20297)
-- Name: fk_transectresults_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3204 (class 2606 OID 20302)
-- Name: fk_transectresults_results; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_results FOREIGN KEY (resultid) REFERENCES results(resultid) ON DELETE CASCADE;


--
-- TOC entry 3205 (class 2606 OID 20307)
-- Name: fk_transectresults_spatialreferences; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_spatialreferences FOREIGN KEY (spatialreferenceid) REFERENCES spatialreferences(spatialreferenceid) ON DELETE CASCADE;


--
-- TOC entry 3206 (class 2606 OID 20312)
-- Name: fk_transectresults_tmunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_tmunits FOREIGN KEY (intendedtimespacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3207 (class 2606 OID 20317)
-- Name: fk_transectresults_tsunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_tsunits FOREIGN KEY (intendedtransectspacingunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3208 (class 2606 OID 20322)
-- Name: fk_transectresults_units; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresults
    ADD CONSTRAINT fk_transectresults_units FOREIGN KEY (zlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3209 (class 2606 OID 20327)
-- Name: fk_transectresultvalueannotations_annotations; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalueannotations
    ADD CONSTRAINT fk_transectresultvalueannotations_annotations FOREIGN KEY (annotationid) REFERENCES annotations(annotationid) ON DELETE CASCADE;


--
-- TOC entry 3210 (class 2606 OID 20332)
-- Name: fk_transectresultvalueannotations_transectresultvalues; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalueannotations
    ADD CONSTRAINT fk_transectresultvalueannotations_transectresultvalues FOREIGN KEY (valueid) REFERENCES transectresultvalues(valueid) ON DELETE CASCADE;


--
-- TOC entry 3211 (class 2606 OID 20337)
-- Name: fk_transectresultvalues_aiunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_aiunits FOREIGN KEY (timeaggregationintervalunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3212 (class 2606 OID 20342)
-- Name: fk_transectresultvalues_cv_aggregationstatistic; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_cv_aggregationstatistic FOREIGN KEY (aggregationstatisticcv) REFERENCES cv_aggregationstatistic(name) ON DELETE CASCADE;


--
-- TOC entry 3213 (class 2606 OID 20347)
-- Name: fk_transectresultvalues_cv_censorcode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_cv_censorcode FOREIGN KEY (censorcodecv) REFERENCES cv_censorcode(name) ON DELETE CASCADE;


--
-- TOC entry 3214 (class 2606 OID 20352)
-- Name: fk_transectresultvalues_cv_qualitycode; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_cv_qualitycode FOREIGN KEY (qualitycodecv) REFERENCES cv_qualitycode(name) ON DELETE CASCADE;


--
-- TOC entry 3215 (class 2606 OID 20357)
-- Name: fk_transectresultvalues_distanceunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_distanceunits FOREIGN KEY (transectdistanceunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3216 (class 2606 OID 20362)
-- Name: fk_transectresultvalues_transectresults; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_transectresults FOREIGN KEY (resultid) REFERENCES transectresults(resultid) ON DELETE CASCADE;


--
-- TOC entry 3217 (class 2606 OID 20367)
-- Name: fk_transectresultvalues_xunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_xunits FOREIGN KEY (xlocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3218 (class 2606 OID 20372)
-- Name: fk_transectresultvalues_yunits; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY transectresultvalues
    ADD CONSTRAINT fk_transectresultvalues_yunits FOREIGN KEY (ylocationunitsid) REFERENCES units(unitsid) ON DELETE CASCADE;


--
-- TOC entry 3219 (class 2606 OID 20377)
-- Name: fk_units_cv_unitstype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT fk_units_cv_unitstype FOREIGN KEY (unitstypecv) REFERENCES cv_unitstype(name) ON DELETE CASCADE;


--
-- TOC entry 3220 (class 2606 OID 20382)
-- Name: fk_variableextensionpropertyvalues_extensionproperties; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableextensionpropertyvalues
    ADD CONSTRAINT fk_variableextensionpropertyvalues_extensionproperties FOREIGN KEY (propertyid) REFERENCES extensionproperties(propertyid) ON DELETE CASCADE;


--
-- TOC entry 3221 (class 2606 OID 20387)
-- Name: fk_variableextensionpropertyvalues_variables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableextensionpropertyvalues
    ADD CONSTRAINT fk_variableextensionpropertyvalues_variables FOREIGN KEY (variableid) REFERENCES variables(variableid) ON DELETE CASCADE;


--
-- TOC entry 3222 (class 2606 OID 20392)
-- Name: fk_variableexternalidentifiers_externalidentifiersystems; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableexternalidentifiers
    ADD CONSTRAINT fk_variableexternalidentifiers_externalidentifiersystems FOREIGN KEY (externalidentifiersystemid) REFERENCES externalidentifiersystems(externalidentifiersystemid) ON DELETE CASCADE;


--
-- TOC entry 3223 (class 2606 OID 20397)
-- Name: fk_variableexternalidentifiers_variables; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variableexternalidentifiers
    ADD CONSTRAINT fk_variableexternalidentifiers_variables FOREIGN KEY (variableid) REFERENCES variables(variableid) ON DELETE CASCADE;


--
-- TOC entry 3224 (class 2606 OID 20402)
-- Name: fk_variables_cv_speciation; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT fk_variables_cv_speciation FOREIGN KEY (speciationcv) REFERENCES cv_speciation(name) ON DELETE CASCADE;


--
-- TOC entry 3225 (class 2606 OID 20407)
-- Name: fk_variables_cv_variablename; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT fk_variables_cv_variablename FOREIGN KEY (variablenamecv) REFERENCES cv_variablename(name) ON DELETE CASCADE;


--
-- TOC entry 3226 (class 2606 OID 20412)
-- Name: fk_variables_cv_variabletype; Type: FK CONSTRAINT; Schema: odm2; Owner: -
--

ALTER TABLE ONLY variables
    ADD CONSTRAINT fk_variables_cv_variabletype FOREIGN KEY (variabletypecv) REFERENCES cv_variabletype(name) ON DELETE CASCADE;


-- Completed on 2017-09-25 12:57:21 PDT

--
-- PostgreSQL database dump complete
--

