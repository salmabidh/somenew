--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-04-16 17:52:32

SET statement_timeout = 1;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE iot;
--
-- TOC entry 3599 (class 1262 OID 25207)
-- Name: iot; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE iot WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_India.1252' LC_CTYPE = 'English_India.1252';


\connect iot

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 9 (class 2615 OID 25274)
-- Name: iot; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA iot;


--
-- TOC entry 392 (class 1255 OID 26819)
-- Name: scheduleprocedure(); Type: FUNCTION; Schema: iot; Owner: -
--

CREATE FUNCTION iot.scheduleprocedure(OUT p_refcur refcursor) RETURNS refcursor
    LANGUAGE plpgsql
    AS $$
DECLARE
    var_finished INTEGER DEFAULT 0;
    var_userId INTEGER DEFAULT 0;
    var_deviceName VARCHAR(100) DEFAULT '';
    var_operationName VARCHAR(100) DEFAULT '';
    var_cmd VARCHAR(1024) DEFAULT '';
    var_result VARCHAR(256) DEFAULT '';
    curSchedule CURSOR FOR
    SELECT
        ist.userid AS userid, d.devicename AS devicename, ist.submoduleoperationname AS operationname
        FROM iot.iot_scheduletime AS ist
        LEFT OUTER JOIN iot.device AS d
            ON d.deviceid = ist.deviceid
        WHERE LOWER(ist.schedulestatus) = LOWER('On'::VARCHAR(50)) AND LOWER(aws_mysql_ext.eSUBSTRING_INDEX(ist.scheduletime::VARCHAR, ':'::VARCHAR, 2::INT)) = LOWER(aws_mysql_ext.eSUBSTRING_INDEX(aws_mysql_ext.eSUBSTRING_INDEX((clock_timestamp()::TIMESTAMP::TIMESTAMP AT TIME ZONE '+00:00') AT TIME ZONE '+05:30'::VARCHAR, ' '::VARCHAR, - 1::INT)::VARCHAR, ':'::VARCHAR, 2::INT)) AND LOWER(troubleshoot) != LOWER('YES'::VARCHAR(50)) AND (ist.days IS NULL OR ist.days LIKE CONCAT('%', UPPER(to_char((clock_timestamp()::TIMESTAMP::TIMESTAMP AT TIME ZONE '+00:00') AT TIME ZONE '+05:30'::DATE, 'Day')::VARCHAR), '%') OR LOWER(ist.days) LIKE LOWER('%NULL%')) AND (LOWER(ist.isdeleted) <> LOWER('Y'::VARCHAR(50)) OR ist.isdeleted IS NULL);
BEGIN
    OPEN curschedule;

    <<getschedule>>
    LOOP
        FETCH FROM curSchedule INTO var_userId, var_deviceName, var_operationName;

        IF NOT FOUND THEN
            EXIT getschedule;
        END IF;
        /* build email list */
        OPEN p_refcur FOR
        SELECT
            http_post(CONCAT('http://localhost:8080/Smarter/services/OperationSchedule/operatingScheduleOptions?', 'userId=userId&deviceName=deviceName&operationName=operationName'));
    END LOOP getSchedule;
    CLOSE curschedule;
END;
$$;


--
-- TOC entry 205 (class 1259 OID 26194)
-- Name: agentusers_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.agentusers_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


SET default_table_access_method = heap;

--
-- TOC entry 263 (class 1259 OID 26310)
-- Name: agentusers; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.agentusers (
    agentusersid integer DEFAULT nextval('iot.agentusers_seq'::regclass) NOT NULL,
    username character varying(50),
    password character varying(50),
    phonenumber character varying(50),
    email character varying(50),
    photo text,
    address character varying(50),
    area character varying(50),
    location character varying(50),
    agentid integer,
    status character varying(50),
    startdate character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 206 (class 1259 OID 26196)
-- Name: configdevices_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.configdevices_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 264 (class 1259 OID 26317)
-- Name: configdevices; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.configdevices (
    id integer DEFAULT nextval('iot.configdevices_seq'::regclass) NOT NULL,
    devicename character varying(50)
);


--
-- TOC entry 265 (class 1259 OID 26321)
-- Name: confiuredevice; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.confiuredevice (
    id integer,
    devicename character varying(50),
    devicetype character varying(50),
    status character varying(50),
    configureddevice character varying(50),
    devicepassword character varying(50)
);


--
-- TOC entry 207 (class 1259 OID 26198)
-- Name: currentloggings_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.currentloggings_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 266 (class 1259 OID 26324)
-- Name: currentloggings; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.currentloggings (
    sno integer DEFAULT nextval('iot.currentloggings_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    status character varying(50) NOT NULL,
    logindatetime character varying(50),
    connectionid integer NOT NULL,
    appname character varying(50)
);


--
-- TOC entry 208 (class 1259 OID 26200)
-- Name: customercarecuurentlogins_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.customercarecuurentlogins_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 267 (class 1259 OID 26328)
-- Name: customercarecuurentlogins; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.customercarecuurentlogins (
    customercarecuurentloginid integer DEFAULT nextval('iot.customercarecuurentlogins_seq'::regclass) NOT NULL,
    userid integer,
    status character varying(50),
    logindatetime character varying(50),
    connectionid integer
);


--
-- TOC entry 209 (class 1259 OID 26202)
-- Name: device_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.device_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 268 (class 1259 OID 26332)
-- Name: device; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.device (
    deviceid integer DEFAULT nextval('iot.device_seq'::regclass) NOT NULL,
    moduletypeid integer NOT NULL,
    devicelocationdetailid integer,
    devicename character varying(50),
    devicepassword character varying(50),
    assigneduserid integer,
    assignedbyuserid integer,
    devicestatus character varying(50),
    currentstatus character varying(50),
    appname character varying(50),
    createddate timestamp without time zone,
    modifieddate timestamp without time zone,
    isdeleted character varying(50),
    displayname character varying(50),
    devicepasscode character varying(50),
    macaddress character varying(50),
    syncid character varying(50),
    tankheight character varying(50),
    tankcapicity character varying(50),
    pirdevice character varying(50),
    pirdevicestatus character varying(50),
    operation character varying(50),
    piroperations character varying(50),
    devicerestartcount integer,
    devicerebootcount integer,
    pushnotificationstatus character varying(50),
    warrantydate character varying(50)
);


--
-- TOC entry 210 (class 1259 OID 26204)
-- Name: devicepaymentdetails_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.devicepaymentdetails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 269 (class 1259 OID 26339)
-- Name: devicepaymentdetails; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.devicepaymentdetails (
    devicepaymentdetailsid integer DEFAULT nextval('iot.devicepaymentdetails_seq'::regclass) NOT NULL,
    count integer,
    devicetype character varying(50),
    itemperprice double precision,
    subtotalprice double precision,
    discountamount double precision,
    pendingamount double precision,
    totalprice double precision,
    agentid integer,
    adminid integer,
    digitalmarketerid integer,
    subadminid integer,
    selledby integer,
    status character varying(50),
    date character varying(50),
    paymentmode character varying(50),
    invoiceid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 211 (class 1259 OID 26206)
-- Name: devicetype_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.devicetype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 270 (class 1259 OID 26343)
-- Name: devicetype; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.devicetype (
    devicetypeid integer DEFAULT nextval('iot.devicetype_seq'::regclass) NOT NULL,
    devicetype character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    createddate character varying(50),
    modifieddate character varying(50),
    isdeleted character varying(50),
    componentid integer
);


--
-- TOC entry 212 (class 1259 OID 26208)
-- Name: dummyimage_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.dummyimage_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 271 (class 1259 OID 26347)
-- Name: dummyimage; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.dummyimage (
    dummyimage integer DEFAULT nextval('iot.dummyimage_seq'::regclass) NOT NULL,
    imagepath text,
    date timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone
);


--
-- TOC entry 213 (class 1259 OID 26210)
-- Name: dumpeddevice_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.dumpeddevice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 272 (class 1259 OID 26355)
-- Name: dumpeddevice; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.dumpeddevice (
    dumpeddeviceid integer DEFAULT nextval('iot.dumpeddevice_seq'::regclass) NOT NULL,
    devicename character varying(50),
    status character varying(50),
    date timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    devicetype character varying(50),
    discription character varying(50),
    devicepassword character varying(50)
);


--
-- TOC entry 214 (class 1259 OID 26212)
-- Name: emplog_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.emplog_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 273 (class 1259 OID 26360)
-- Name: emplog; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.emplog (
    id integer DEFAULT nextval('iot.emplog_seq'::regclass) NOT NULL,
    empid integer,
    "time" timestamp without time zone,
    state integer
);


--
-- TOC entry 215 (class 1259 OID 26214)
-- Name: gysrtemp_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.gysrtemp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 274 (class 1259 OID 26364)
-- Name: gysrtemp; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.gysrtemp (
    gysetempid integer DEFAULT nextval('iot.gysrtemp_seq'::regclass) NOT NULL,
    deviceid integer,
    gysr_temp integer,
    startdate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone
);


--
-- TOC entry 216 (class 1259 OID 26216)
-- Name: iot_analytic_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_analytic_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 275 (class 1259 OID 26369)
-- Name: iot_analytic; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_analytic (
    analyticid integer DEFAULT nextval('iot.iot_analytic_seq'::regclass) NOT NULL,
    deviceid integer NOT NULL,
    submoduletypeid integer NOT NULL,
    submoduleoperationid integer,
    startdatetime timestamp without time zone,
    enddatetime timestamp without time zone,
    status character varying(50),
    description character varying(50),
    isdeleted character varying(50),
    userid integer,
    operationmessage character varying(50),
    allpinsstatus character varying(50),
    operationtype character varying(50)
);


--
-- TOC entry 217 (class 1259 OID 26218)
-- Name: iot_appregister_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_appregister_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 276 (class 1259 OID 26373)
-- Name: iot_appregister; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_appregister (
    registerappid integer DEFAULT nextval('iot.iot_appregister_seq'::regclass) NOT NULL,
    appuserid integer,
    appname character varying(50),
    userid integer
);


--
-- TOC entry 218 (class 1259 OID 26220)
-- Name: iot_assignmember_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_assignmember_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 277 (class 1259 OID 26377)
-- Name: iot_assignmember; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_assignmember (
    assignmemberid integer DEFAULT nextval('iot.iot_assignmember_seq'::regclass) NOT NULL,
    complaintid integer,
    teammemberid integer,
    targetdate timestamp without time zone,
    status character varying(50),
    assignsubadminid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 219 (class 1259 OID 26222)
-- Name: iot_customersupport_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_customersupport_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 278 (class 1259 OID 26381)
-- Name: iot_customersupport; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_customersupport (
    iot_customersupportid integer DEFAULT nextval('iot.iot_customersupport_seq'::regclass) NOT NULL,
    username character varying(50),
    password character varying(50),
    emailid character varying(50),
    age integer,
    qualification character varying(50),
    isadmin integer,
    issubadmin integer,
    isagent integer,
    assignedby integer,
    iscustomersupport integer,
    isdigitalmarketer integer,
    isindividual integer,
    isagencies integer,
    phonenumber character varying(50),
    salary integer,
    startdate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    modifeddate timestamp without time zone,
    joindate character varying(50),
    enddate timestamp without time zone,
    addedby integer,
    status character varying(50),
    address text,
    otp integer,
    uploadedimage text,
    individualtype character varying(50),
    area character varying(50),
    location character varying(50)
);


--
-- TOC entry 220 (class 1259 OID 26224)
-- Name: iot_custotp_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_custotp_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 279 (class 1259 OID 26389)
-- Name: iot_custotp; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_custotp (
    iot_custotpid integer DEFAULT nextval('iot.iot_custotp_seq'::regclass) NOT NULL,
    userid integer,
    otp integer,
    iot_customersupportid integer,
    senddate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    count integer
);


--
-- TOC entry 221 (class 1259 OID 26226)
-- Name: iot_devicefittinglocation_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_devicefittinglocation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 280 (class 1259 OID 26394)
-- Name: iot_devicefittinglocation; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_devicefittinglocation (
    fittinglocationid integer DEFAULT nextval('iot.iot_devicefittinglocation_seq'::regclass) NOT NULL,
    fittinglocationtype character varying(50),
    fittinglocationname character varying(50),
    fittinglocationarea character varying(50),
    fittinglocationcity character varying(50),
    noofrooms character varying(50),
    userid integer,
    proplevalpushstatus character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 222 (class 1259 OID 26228)
-- Name: iot_devicelocationdetails_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_devicelocationdetails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 281 (class 1259 OID 26398)
-- Name: iot_devicelocationdetails; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_devicelocationdetails (
    devicelocationdetailid integer DEFAULT nextval('iot.iot_devicelocationdetails_seq'::regclass) NOT NULL,
    fittinglocationid integer,
    devicelocationdetailtype character varying(50),
    devicelocationdescription character varying(255),
    userid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 223 (class 1259 OID 26230)
-- Name: iot_deviceswitchtypes_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_deviceswitchtypes_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 282 (class 1259 OID 26402)
-- Name: iot_deviceswitchtypes; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_deviceswitchtypes (
    deviceswitchtypeid integer DEFAULT nextval('iot.iot_deviceswitchtypes_seq'::regclass) NOT NULL,
    devicelocationdetailid integer NOT NULL,
    submoduletypeid integer NOT NULL,
    deviceswitchtype character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 224 (class 1259 OID 26232)
-- Name: iot_fingerprint_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_fingerprint_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 283 (class 1259 OID 26406)
-- Name: iot_fingerprint; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_fingerprint (
    id integer DEFAULT nextval('iot.iot_fingerprint_seq'::regclass) NOT NULL,
    devicename character varying(50),
    fingerprintname character varying(50),
    fingerprintid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 225 (class 1259 OID 26234)
-- Name: iot_macaddresses_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_macaddresses_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 284 (class 1259 OID 26410)
-- Name: iot_macaddresses; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_macaddresses (
    iot_macaddressesid integer DEFAULT nextval('iot.iot_macaddresses_seq'::regclass) NOT NULL,
    devicename character varying(50),
    macaddress character varying(50),
    createddate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    isdeleted character varying(50)
);


--
-- TOC entry 226 (class 1259 OID 26236)
-- Name: iot_moduletype_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_moduletype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 285 (class 1259 OID 26415)
-- Name: iot_moduletype; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_moduletype (
    moduletypeid integer DEFAULT nextval('iot.iot_moduletype_seq'::regclass) NOT NULL,
    modulecode character varying(50),
    moduletypename character varying(50),
    pincount integer
);


--
-- TOC entry 227 (class 1259 OID 26238)
-- Name: iot_piragentcountdetails_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_piragentcountdetails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 286 (class 1259 OID 26419)
-- Name: iot_piragentcountdetails; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_piragentcountdetails (
    iot_pircountdetails_id integer DEFAULT nextval('iot.iot_piragentcountdetails_seq'::regclass) NOT NULL,
    pircount integer,
    agentid integer,
    digitalmarketrid integer,
    subadminid integer,
    invoiceid integer,
    selledby integer,
    status character varying(50),
    startdate character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 228 (class 1259 OID 26240)
-- Name: iot_pirdetails_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_pirdetails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 287 (class 1259 OID 26423)
-- Name: iot_pirdetails; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_pirdetails (
    pirdetailsid integer DEFAULT nextval('iot.iot_pirdetails_seq'::regclass) NOT NULL,
    name character varying(50),
    count integer
);


--
-- TOC entry 229 (class 1259 OID 26242)
-- Name: iot_plugreports_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_plugreports_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 288 (class 1259 OID 26427)
-- Name: iot_plugreports; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_plugreports (
    iot_plugreportsid integer DEFAULT nextval('iot.iot_plugreports_seq'::regclass) NOT NULL,
    deviceid integer,
    userid integer,
    devicetype character varying(50),
    fittinglocationid integer,
    offline_plg_on character varying(50),
    offline_plg_off character varying(50),
    online_plg_on character varying(50),
    online_plg_off character varying(50),
    man_plg_on character varying(50),
    man_plg_off character varying(50),
    man_plg_on_status character varying(50),
    man_plg_off_status character varying(50),
    usercomment character varying(250),
    manualflag character varying(50),
    submitflag character varying(50),
    pdfpath text,
    checkeddate character varying(50),
    modifieddate character varying(50)
);


--
-- TOC entry 230 (class 1259 OID 26244)
-- Name: iot_pushnotifications_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_pushnotifications_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 289 (class 1259 OID 26434)
-- Name: iot_pushnotifications; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_pushnotifications (
    sno integer DEFAULT nextval('iot.iot_pushnotifications_seq'::regclass) NOT NULL,
    token_id text,
    os character varying(50),
    userid integer,
    status character varying(50)
);


--
-- TOC entry 231 (class 1259 OID 26246)
-- Name: iot_report_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_report_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 290 (class 1259 OID 26441)
-- Name: iot_report; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_report (
    id integer DEFAULT nextval('iot.iot_report_seq'::regclass) NOT NULL,
    deviceid integer,
    netstatus character varying(50),
    powerstatus character varying(50),
    operation character varying(50),
    reportmsg text,
    userid integer,
    "time" timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone
);


--
-- TOC entry 232 (class 1259 OID 26248)
-- Name: iot_scheduletime_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_scheduletime_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 291 (class 1259 OID 26449)
-- Name: iot_scheduletime; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_scheduletime (
    scheduletimeid integer DEFAULT nextval('iot.iot_scheduletime_seq'::regclass) NOT NULL,
    deviceid integer,
    userid integer,
    schedulename character varying(50),
    scheduletype character varying(50),
    submoduleoperationname character varying(50),
    scheduletime character varying(50),
    plugtimeperiod character varying(50),
    days text,
    scheduledate timestamp without time zone,
    updateddate timestamp without time zone,
    schedulestatus character varying(50),
    troubleshoot character varying(50),
    troubleshoottime character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 233 (class 1259 OID 26250)
-- Name: iot_securityquestionanswers_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_securityquestionanswers_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 292 (class 1259 OID 26456)
-- Name: iot_securityquestionanswers; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_securityquestionanswers (
    securityanswerid integer DEFAULT nextval('iot.iot_securityquestionanswers_seq'::regclass) NOT NULL,
    userid integer,
    securityquestionid integer,
    answer character varying(50)
);


--
-- TOC entry 234 (class 1259 OID 26252)
-- Name: iot_securityquestions_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_securityquestions_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 293 (class 1259 OID 26460)
-- Name: iot_securityquestions; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_securityquestions (
    securityquestionid integer DEFAULT nextval('iot.iot_securityquestions_seq'::regclass) NOT NULL,
    question text
);


--
-- TOC entry 235 (class 1259 OID 26254)
-- Name: iot_sharedevice_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_sharedevice_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 294 (class 1259 OID 26467)
-- Name: iot_sharedevice; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_sharedevice (
    shareid integer DEFAULT nextval('iot.iot_sharedevice_seq'::regclass) NOT NULL,
    userid integer,
    assigneduserid integer,
    deviceid integer,
    phonenumber character varying(50),
    sharedname character varying(50),
    startdate character varying(50),
    enddate character varying(50),
    hours character varying(50),
    accesskey character varying(50),
    status character varying(50),
    intimatingtime character varying(50),
    track_msgsent character varying(50),
    duration character varying(50),
    troubleshoottime character varying(50),
    troubleshootstatus character varying(50),
    notificationstatus character varying(50)
);


--
-- TOC entry 236 (class 1259 OID 26256)
-- Name: iot_submoduleoperation_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_submoduleoperation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 295 (class 1259 OID 26474)
-- Name: iot_submoduleoperation; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_submoduleoperation (
    submoduleoperationid integer DEFAULT nextval('iot.iot_submoduleoperation_seq'::regclass) NOT NULL,
    submoduletypeid integer NOT NULL,
    submoduleoperationname character varying(50),
    operationcode character varying(50)
);


--
-- TOC entry 237 (class 1259 OID 26258)
-- Name: iot_submoduletype_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_submoduletype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 296 (class 1259 OID 26478)
-- Name: iot_submoduletype; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_submoduletype (
    submoduletypeid integer DEFAULT nextval('iot.iot_submoduletype_seq'::regclass) NOT NULL,
    moduletypeid integer,
    submoduletypename character varying(50),
    submoduletypeno character varying(50),
    status character varying(50)
);


--
-- TOC entry 238 (class 1259 OID 26260)
-- Name: iot_switchreports_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_switchreports_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 297 (class 1259 OID 26482)
-- Name: iot_switchreports; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_switchreports (
    iot_switchreportsid integer DEFAULT nextval('iot.iot_switchreports_seq'::regclass) NOT NULL,
    deviceid integer,
    userid integer,
    devicetype character varying(50),
    fittinglocationid integer,
    offline_l1_on character varying(50),
    offline_l2_on character varying(50),
    offline_l3_on character varying(50),
    offline_swt4fan_on character varying(50),
    offline_fan_1 character varying(50),
    offline_fan_2 character varying(50),
    offline_fan_3 character varying(50),
    offline_fan_4 character varying(50),
    offline_fan_5 character varying(50),
    offline_fan_0 character varying(50),
    pir_offline_l1_on character varying(50),
    pir_offline_l2_on character varying(50),
    pir_offline_l3_on character varying(50),
    offline_all_on character varying(50),
    offline_all_off character varying(50),
    online_l1_on character varying(50),
    online_l2_on character varying(50),
    online_l3_on character varying(50),
    online_swt4fan_on character varying(50),
    online_fan_1 character varying(50),
    online_fan_2 character varying(50),
    online_fan_3 character varying(50),
    online_fan_4 character varying(50),
    online_fan_5 character varying(50),
    online_fan_0 character varying(50),
    pir_online_l1_on character varying(50),
    pir_online_l2_on character varying(50),
    pir_online_l3_on character varying(50),
    online_all_on character varying(50),
    online_all_off character varying(50),
    man_l1_on character varying(50),
    man_l2_on character varying(50),
    man_l3_on character varying(50),
    man_swt4fan_on character varying(50),
    man_fan_1 character varying(50),
    man_fan_2 character varying(50),
    man_fan_3 character varying(50),
    man_fan_4 character varying(50),
    man_fan_5 character varying(50),
    man_fan_0 character varying(50),
    pir_offline_active character varying(50),
    pir_offline_deactive character varying(50),
    pir_online_active character varying(50),
    pir_online_deactive character varying(50),
    man_l1_on_status character varying(50),
    man_l2_on_status character varying(50),
    man_l3_on_status character varying(50),
    man_fan1_status character varying(50),
    man_fan2_status character varying(50),
    man_fan3_status character varying(50),
    man_fan4_status character varying(50),
    man_fan5_status character varying(50),
    man_fan0_status character varying(50),
    usercomment character varying(250),
    manualflag character varying(50),
    submitflag character varying(50),
    pdfpath text,
    checkeddate character varying(50),
    modifieddate character varying(50)
);


--
-- TOC entry 239 (class 1259 OID 26262)
-- Name: iot_sync_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_sync_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 298 (class 1259 OID 26489)
-- Name: iot_sync; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_sync (
    syncid integer DEFAULT nextval('iot.iot_sync_seq'::regclass) NOT NULL,
    syncname character varying(50),
    syncpassword character varying(50),
    status character varying(50),
    createddate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone,
    userid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 240 (class 1259 OID 26264)
-- Name: iot_teammembers_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_teammembers_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 299 (class 1259 OID 26494)
-- Name: iot_teammembers; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_teammembers (
    teammemberid integer DEFAULT nextval('iot.iot_teammembers_seq'::regclass) NOT NULL,
    name character varying(50),
    email character varying(50),
    teamid integer
);


--
-- TOC entry 241 (class 1259 OID 26266)
-- Name: iot_teams_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_teams_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 300 (class 1259 OID 26498)
-- Name: iot_teams; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_teams (
    teamid integer DEFAULT nextval('iot.iot_teams_seq'::regclass) NOT NULL,
    teamname character varying(50)
);


--
-- TOC entry 242 (class 1259 OID 26268)
-- Name: iot_test_appreports_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_test_appreports_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 301 (class 1259 OID 26502)
-- Name: iot_test_appreports; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_test_appreports (
    iot_testappreportsid integer DEFAULT nextval('iot.iot_test_appreports_seq'::regclass) NOT NULL,
    devicename character varying(50),
    deviceid integer,
    userid integer,
    testedby character varying(50),
    devicetype character varying(50),
    offline_l1_on character varying(50),
    offline_l1_off character varying(50),
    offline_l2_on character varying(50),
    offline_l2_off character varying(50),
    offline_l3_on character varying(50),
    offline_l3_off character varying(50),
    offline_swt4fan_on character varying(50),
    offline_swt4fan_off character varying(50),
    offline_fan_1 character varying(50),
    offline_fan_2 character varying(50),
    offline_fan_3 character varying(50),
    offline_fan_4 character varying(50),
    offline_fan_5 character varying(50),
    offline_fan_0 character varying(50),
    pir_offline_l1_on character varying(50),
    pir_offline_l2_on character varying(50),
    pir_offline_l3_on character varying(50),
    offline_all_on character varying(50),
    offline_all_off character varying(50),
    online_l1_on character varying(50),
    online_l1_off character varying(50),
    online_l2_on character varying(50),
    online_l2_off character varying(50),
    online_l3_on character varying(50),
    online_l3_off character varying(50),
    online_swt4fan_on character varying(50),
    online_swt4fan_off character varying(50),
    online_fan_1 character varying(50),
    online_fan_2 character varying(50),
    online_fan_3 character varying(50),
    online_fan_4 character varying(50),
    online_fan_5 character varying(50),
    online_fan_0 character varying(50),
    pir_online_l1_on character varying(50),
    pir_online_l2_on character varying(50),
    pir_online_l3_on character varying(50),
    online_all_on character varying(50),
    online_all_off character varying(50),
    man_l1_on character varying(50),
    man_l1_off character varying(50),
    man_l2_on character varying(50),
    man_l2_off character varying(50),
    man_l3_on character varying(50),
    man_l3_off character varying(50),
    man_swt4fan_on character varying(50),
    man_swt4fan_off character varying(50),
    man_fan_1 character varying(50),
    man_fan_2 character varying(50),
    man_fan_3 character varying(50),
    man_fan_4 character varying(50),
    man_fan_5 character varying(50),
    man_fan_0 character varying(50),
    pir_online_active character varying(50),
    pir_online_deactive character varying(50),
    pir_offline_active character varying(50),
    pir_offline_deactive character varying(50),
    rebooot_status character varying(50),
    checkeddate timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone
);


--
-- TOC entry 243 (class 1259 OID 26270)
-- Name: iot_tickets_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_tickets_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 302 (class 1259 OID 26510)
-- Name: iot_tickets; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_tickets (
    ticketid integer DEFAULT nextval('iot.iot_tickets_seq'::regclass) NOT NULL,
    userid integer,
    discription character varying(50),
    phonenumber character varying(50),
    deviceid integer,
    devicename character varying(50),
    status character varying(50),
    customersupportid integer,
    ticketraiseddate character varying(50),
    ticketsolveddate character varying(50),
    propertyid integer,
    roomid integer,
    propertyname character varying(50),
    roomname character varying(50),
    address character varying(50),
    isdeleted character varying(50)
);


--
-- TOC entry 244 (class 1259 OID 26272)
-- Name: iot_unitcost_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.iot_unitcost_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 303 (class 1259 OID 26517)
-- Name: iot_unitcost; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.iot_unitcost (
    unitid integer DEFAULT nextval('iot.iot_unitcost_seq'::regclass) NOT NULL,
    submoduleoperationid integer,
    unitsperhour integer,
    unitcost integer
);


--
-- TOC entry 245 (class 1259 OID 26274)
-- Name: ioterrors_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.ioterrors_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 304 (class 1259 OID 26521)
-- Name: ioterrors; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.ioterrors (
    errorid integer DEFAULT nextval('iot.ioterrors_seq'::regclass) NOT NULL,
    errorcode character varying(50),
    errormsg character varying(50)
);


--
-- TOC entry 246 (class 1259 OID 26276)
-- Name: mdapplication_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdapplication_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 305 (class 1259 OID 26525)
-- Name: mdapplication; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdapplication (
    mdappid integer DEFAULT nextval('iot.mdapplication_seq'::regclass) NOT NULL,
    appname character varying(50),
    title character varying(255),
    description character varying(255),
    updateddatetime timestamp without time zone DEFAULT '1970-01-01 00:00:00'::timestamp without time zone
);


--
-- TOC entry 247 (class 1259 OID 26278)
-- Name: mdbranch_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdbranch_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 306 (class 1259 OID 26533)
-- Name: mdbranch; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdbranch (
    branchid integer DEFAULT nextval('iot.mdbranch_seq'::regclass) NOT NULL,
    companyid integer NOT NULL,
    branchname character varying(150),
    branchcode character varying(150),
    status character varying(50),
    createddate character varying(50),
    modifieddate character varying(50),
    isdeleted character varying(50),
    componentid integer
);


--
-- TOC entry 248 (class 1259 OID 26280)
-- Name: mdcompany_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdcompany_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 307 (class 1259 OID 26540)
-- Name: mdcompany; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdcompany (
    companyid integer DEFAULT nextval('iot.mdcompany_seq'::regclass) NOT NULL,
    companyname character varying(150),
    companycode character varying(150),
    status character varying(50),
    createddate character varying(50),
    modifieddate character varying(50),
    isdeleted character varying(50),
    componentid integer
);


--
-- TOC entry 249 (class 1259 OID 26282)
-- Name: mdcurrentloggings_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdcurrentloggings_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 308 (class 1259 OID 26547)
-- Name: mdcurrentloggings; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdcurrentloggings (
    sno integer DEFAULT nextval('iot.mdcurrentloggings_seq'::regclass) NOT NULL,
    userid integer NOT NULL,
    status character varying(50) NOT NULL,
    logindatetime character varying(50) NOT NULL,
    connectionid integer NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 26284)
-- Name: mddatastore_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mddatastore_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 309 (class 1259 OID 26551)
-- Name: mddatastore; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mddatastore (
    datastoreid integer DEFAULT nextval('iot.mddatastore_seq'::regclass) NOT NULL,
    datastorename character varying(100) NOT NULL,
    melditengineip character varying(100) NOT NULL,
    webserverip character varying(100) NOT NULL,
    webserverport character varying(100) NOT NULL,
    datastoredbname character varying(50) NOT NULL,
    datastoredbip character varying(50) NOT NULL,
    datastoredbport character varying(50) NOT NULL,
    dbusername character varying(50) NOT NULL,
    dbpassword character varying(50) NOT NULL,
    melditusername character varying(50) NOT NULL,
    melditpassword character varying(50) NOT NULL,
    licencekey character varying(11) NOT NULL,
    createddate character varying(50) NOT NULL,
    createdby integer NOT NULL,
    modifieddate character varying(50) NOT NULL,
    modifiedby character varying(50) NOT NULL,
    acl character varying(100) NOT NULL
);


--
-- TOC entry 251 (class 1259 OID 26286)
-- Name: mdemployees_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdemployees_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 310 (class 1259 OID 26558)
-- Name: mdemployees; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdemployees (
    sno integer DEFAULT nextval('iot.mdemployees_seq'::regclass) NOT NULL,
    employeeid character varying(50) NOT NULL,
    firstname character varying(50) NOT NULL,
    middlename character varying(50) NOT NULL,
    lastname character varying(50) NOT NULL,
    dob character varying(50) NOT NULL,
    photo bytea,
    department character varying(50) NOT NULL,
    designation character varying(50) NOT NULL,
    fathersname character varying(50) NOT NULL,
    address character varying(100) NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    pincode character varying(6) NOT NULL,
    country character varying(50) NOT NULL,
    contactnumber character varying(10) NOT NULL,
    emailid character varying(50) NOT NULL,
    faxno character varying(12) NOT NULL,
    status character varying(50) NOT NULL,
    emailpassword character varying(255)
);


--
-- TOC entry 252 (class 1259 OID 26288)
-- Name: mdfolder_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdfolder_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 311 (class 1259 OID 26565)
-- Name: mdfolder; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdfolder (
    folderid integer DEFAULT nextval('iot.mdfolder_seq'::regclass) NOT NULL,
    foldername character varying(50),
    parentfolderid integer NOT NULL,
    infoclassid integer NOT NULL,
    status character varying(50) NOT NULL,
    foldertype character varying(50),
    createddate character varying(50) NOT NULL,
    modifieddate character varying(50) NOT NULL,
    acl character varying(500),
    createdby integer NOT NULL,
    modifiedby integer NOT NULL,
    folderlevel character varying(10) NOT NULL,
    orderno character varying(50)
);


--
-- TOC entry 312 (class 1259 OID 26572)
-- Name: mdlicenceinfo; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdlicenceinfo (
    licenceid integer NOT NULL,
    licencename character varying(50) NOT NULL,
    licencekey character varying(50) NOT NULL,
    companyname character varying(50) NOT NULL,
    companyaddress character varying(50) NOT NULL,
    companycontactinfo character varying(50) NOT NULL,
    activateddate character varying(50) NOT NULL,
    expirydate character varying(50) NOT NULL,
    nooflicencedusers integer NOT NULL
);


--
-- TOC entry 253 (class 1259 OID 26290)
-- Name: mdloginhistory_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdloginhistory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 313 (class 1259 OID 26575)
-- Name: mdloginhistory; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdloginhistory (
    indexid integer DEFAULT nextval('iot.mdloginhistory_seq'::regclass) NOT NULL,
    loginid character varying(50) NOT NULL,
    loginusername character varying(50) NOT NULL,
    logindatetime character varying(50) NOT NULL,
    hostip character varying(50) NOT NULL,
    logoutdatetime character varying(50) NOT NULL
);


--
-- TOC entry 254 (class 1259 OID 26292)
-- Name: mdprivileges_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdprivileges_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 314 (class 1259 OID 26579)
-- Name: mdprivileges; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdprivileges (
    privilegeid integer DEFAULT nextval('iot.mdprivileges_seq'::regclass) NOT NULL,
    privilegename character varying(50) NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 26294)
-- Name: mdrole_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdrole_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 315 (class 1259 OID 26583)
-- Name: mdrole; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdrole (
    roleid integer DEFAULT nextval('iot.mdrole_seq'::regclass) NOT NULL,
    rolename character varying(100) NOT NULL,
    privilegestring character varying(500) NOT NULL,
    createdby character varying(50) NOT NULL,
    createddate character varying(50) NOT NULL,
    modifiedby character varying(50) NOT NULL,
    modifieddate character varying(50) NOT NULL,
    description character varying(200) NOT NULL
);


--
-- TOC entry 256 (class 1259 OID 26296)
-- Name: mdusers_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.mdusers_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 316 (class 1259 OID 26590)
-- Name: mdusers; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.mdusers (
    userid integer DEFAULT nextval('iot.mdusers_seq'::regclass) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    passwordexpirydate character varying(100),
    status character varying(20),
    photo bytea,
    rolestring character varying(100),
    createddate date,
    modifieddate date,
    createdby integer,
    modifiedby integer,
    loginattempts integer,
    employeeid character varying(50),
    groupname character varying(255),
    companyid integer,
    branchid integer
);


--
-- TOC entry 257 (class 1259 OID 26298)
-- Name: messages_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.messages_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 317 (class 1259 OID 26597)
-- Name: messages; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.messages (
    id integer DEFAULT nextval('iot.messages_seq'::regclass) NOT NULL,
    message character varying(255) NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- TOC entry 258 (class 1259 OID 26300)
-- Name: messagetype_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.messagetype_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 318 (class 1259 OID 26601)
-- Name: messagetype; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.messagetype (
    messagetypeid integer DEFAULT nextval('iot.messagetype_seq'::regclass) NOT NULL,
    messagetype character varying(50) NOT NULL,
    devicetypeid integer NOT NULL,
    description character varying(255) NOT NULL,
    createddate character varying(50),
    modifieddate character varying(50),
    isdeleted character varying(50),
    componentid integer
);


--
-- TOC entry 259 (class 1259 OID 26302)
-- Name: requestedmessages_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.requestedmessages_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 319 (class 1259 OID 26605)
-- Name: requestedmessages; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.requestedmessages (
    requestmessageid integer DEFAULT nextval('iot.requestedmessages_seq'::regclass) NOT NULL,
    deviceid integer NOT NULL,
    submoduletypeid integer,
    submoduleoperationid integer,
    messagestatus character varying(50),
    reasondescripition character varying(50),
    publishmessage character varying(50),
    subscribemessage character varying(50),
    lastoperatedby character varying(20),
    deviceresponse character varying(20) DEFAULT 'success or failure'::character varying,
    appname character varying(50),
    createddate date,
    isdeleted character varying(50),
    lastoperateddate character varying(50)
);


--
-- TOC entry 260 (class 1259 OID 26304)
-- Name: suv_user_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.suv_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 320 (class 1259 OID 26610)
-- Name: suv_user; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.suv_user (
    userid integer DEFAULT nextval('iot.suv_user_seq'::regclass) NOT NULL,
    username character varying(50),
    password character varying(50),
    emailid character varying(50),
    createddate timestamp without time zone,
    modifieddate timestamp without time zone,
    passwordrechange character varying(50),
    phonenumber character varying(50),
    country character varying(10),
    gender character(10),
    dateofbirth date,
    otp integer,
    imagepath character varying(250)
);


--
-- TOC entry 261 (class 1259 OID 26306)
-- Name: userpaymentdetails_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.userpaymentdetails_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 321 (class 1259 OID 26617)
-- Name: userpaymentdetails; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.userpaymentdetails (
    userpaymentdetailsid integer DEFAULT nextval('iot.userpaymentdetails_seq'::regclass) NOT NULL,
    devicecount integer,
    devicetype character varying(50),
    itemperprice double precision,
    subtotalprice double precision,
    discountamount double precision,
    pendingamount double precision,
    totalprice double precision,
    agentid integer,
    agentselledby integer,
    userid integer,
    status character varying(50),
    date character varying(50),
    paymentmode character varying(50),
    agentinvoiceid integer,
    isdeleted character varying(50)
);


--
-- TOC entry 262 (class 1259 OID 26308)
-- Name: userpir_seq; Type: SEQUENCE; Schema: iot; Owner: -
--

CREATE SEQUENCE iot.userpir_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 322 (class 1259 OID 26621)
-- Name: userpir; Type: TABLE; Schema: iot; Owner: -
--

CREATE TABLE iot.userpir (
    userpir integer DEFAULT nextval('iot.userpir_seq'::regclass) NOT NULL,
    pircount integer,
    devicetype character varying(50),
    userid integer,
    agentid integer,
    agentselledby integer,
    status character varying(50),
    date character varying(50),
    isdeleted character varying(50) DEFAULT '0'::character varying NOT NULL
);


--
-- TOC entry 3534 (class 0 OID 26310)
-- Dependencies: 263
-- Data for Name: agentusers; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3535 (class 0 OID 26317)
-- Dependencies: 264
-- Data for Name: configdevices; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3536 (class 0 OID 26321)
-- Dependencies: 265
-- Data for Name: confiuredevice; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3537 (class 0 OID 26324)
-- Dependencies: 266
-- Data for Name: currentloggings; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3538 (class 0 OID 26328)
-- Dependencies: 267
-- Data for Name: customercarecuurentlogins; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3539 (class 0 OID 26332)
-- Dependencies: 268
-- Data for Name: device; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3540 (class 0 OID 26339)
-- Dependencies: 269
-- Data for Name: devicepaymentdetails; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3541 (class 0 OID 26343)
-- Dependencies: 270
-- Data for Name: devicetype; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3542 (class 0 OID 26347)
-- Dependencies: 271
-- Data for Name: dummyimage; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3543 (class 0 OID 26355)
-- Dependencies: 272
-- Data for Name: dumpeddevice; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3544 (class 0 OID 26360)
-- Dependencies: 273
-- Data for Name: emplog; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3545 (class 0 OID 26364)
-- Dependencies: 274
-- Data for Name: gysrtemp; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3546 (class 0 OID 26369)
-- Dependencies: 275
-- Data for Name: iot_analytic; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3547 (class 0 OID 26373)
-- Dependencies: 276
-- Data for Name: iot_appregister; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3548 (class 0 OID 26377)
-- Dependencies: 277
-- Data for Name: iot_assignmember; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3549 (class 0 OID 26381)
-- Dependencies: 278
-- Data for Name: iot_customersupport; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3550 (class 0 OID 26389)
-- Dependencies: 279
-- Data for Name: iot_custotp; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3551 (class 0 OID 26394)
-- Dependencies: 280
-- Data for Name: iot_devicefittinglocation; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3552 (class 0 OID 26398)
-- Dependencies: 281
-- Data for Name: iot_devicelocationdetails; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3553 (class 0 OID 26402)
-- Dependencies: 282
-- Data for Name: iot_deviceswitchtypes; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3554 (class 0 OID 26406)
-- Dependencies: 283
-- Data for Name: iot_fingerprint; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3555 (class 0 OID 26410)
-- Dependencies: 284
-- Data for Name: iot_macaddresses; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3556 (class 0 OID 26415)
-- Dependencies: 285
-- Data for Name: iot_moduletype; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3557 (class 0 OID 26419)
-- Dependencies: 286
-- Data for Name: iot_piragentcountdetails; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3558 (class 0 OID 26423)
-- Dependencies: 287
-- Data for Name: iot_pirdetails; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3559 (class 0 OID 26427)
-- Dependencies: 288
-- Data for Name: iot_plugreports; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3560 (class 0 OID 26434)
-- Dependencies: 289
-- Data for Name: iot_pushnotifications; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3561 (class 0 OID 26441)
-- Dependencies: 290
-- Data for Name: iot_report; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3562 (class 0 OID 26449)
-- Dependencies: 291
-- Data for Name: iot_scheduletime; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3563 (class 0 OID 26456)
-- Dependencies: 292
-- Data for Name: iot_securityquestionanswers; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3564 (class 0 OID 26460)
-- Dependencies: 293
-- Data for Name: iot_securityquestions; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3565 (class 0 OID 26467)
-- Dependencies: 294
-- Data for Name: iot_sharedevice; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3566 (class 0 OID 26474)
-- Dependencies: 295
-- Data for Name: iot_submoduleoperation; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3567 (class 0 OID 26478)
-- Dependencies: 296
-- Data for Name: iot_submoduletype; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3568 (class 0 OID 26482)
-- Dependencies: 297
-- Data for Name: iot_switchreports; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3569 (class 0 OID 26489)
-- Dependencies: 298
-- Data for Name: iot_sync; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3570 (class 0 OID 26494)
-- Dependencies: 299
-- Data for Name: iot_teammembers; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3571 (class 0 OID 26498)
-- Dependencies: 300
-- Data for Name: iot_teams; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3572 (class 0 OID 26502)
-- Dependencies: 301
-- Data for Name: iot_test_appreports; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3573 (class 0 OID 26510)
-- Dependencies: 302
-- Data for Name: iot_tickets; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3574 (class 0 OID 26517)
-- Dependencies: 303
-- Data for Name: iot_unitcost; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3575 (class 0 OID 26521)
-- Dependencies: 304
-- Data for Name: ioterrors; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3576 (class 0 OID 26525)
-- Dependencies: 305
-- Data for Name: mdapplication; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3577 (class 0 OID 26533)
-- Dependencies: 306
-- Data for Name: mdbranch; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3578 (class 0 OID 26540)
-- Dependencies: 307
-- Data for Name: mdcompany; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3579 (class 0 OID 26547)
-- Dependencies: 308
-- Data for Name: mdcurrentloggings; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3580 (class 0 OID 26551)
-- Dependencies: 309
-- Data for Name: mddatastore; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3581 (class 0 OID 26558)
-- Dependencies: 310
-- Data for Name: mdemployees; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3582 (class 0 OID 26565)
-- Dependencies: 311
-- Data for Name: mdfolder; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3583 (class 0 OID 26572)
-- Dependencies: 312
-- Data for Name: mdlicenceinfo; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3584 (class 0 OID 26575)
-- Dependencies: 313
-- Data for Name: mdloginhistory; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3585 (class 0 OID 26579)
-- Dependencies: 314
-- Data for Name: mdprivileges; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3586 (class 0 OID 26583)
-- Dependencies: 315
-- Data for Name: mdrole; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3587 (class 0 OID 26590)
-- Dependencies: 316
-- Data for Name: mdusers; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3588 (class 0 OID 26597)
-- Dependencies: 317
-- Data for Name: messages; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3589 (class 0 OID 26601)
-- Dependencies: 318
-- Data for Name: messagetype; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3590 (class 0 OID 26605)
-- Dependencies: 319
-- Data for Name: requestedmessages; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3591 (class 0 OID 26610)
-- Dependencies: 320
-- Data for Name: suv_user; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3592 (class 0 OID 26617)
-- Dependencies: 321
-- Data for Name: userpaymentdetails; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3593 (class 0 OID 26621)
-- Dependencies: 322
-- Data for Name: userpir; Type: TABLE DATA; Schema: iot; Owner: -
--



--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 205
-- Name: agentusers_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.agentusers_seq', 1, false);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 206
-- Name: configdevices_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.configdevices_seq', 1, false);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 207
-- Name: currentloggings_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.currentloggings_seq', 1, false);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 208
-- Name: customercarecuurentlogins_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.customercarecuurentlogins_seq', 1, false);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 209
-- Name: device_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.device_seq', 1, false);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 210
-- Name: devicepaymentdetails_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.devicepaymentdetails_seq', 1, false);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 211
-- Name: devicetype_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.devicetype_seq', 1, false);


--
-- TOC entry 3607 (class 0 OID 0)
-- Dependencies: 212
-- Name: dummyimage_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.dummyimage_seq', 1, false);


--
-- TOC entry 3608 (class 0 OID 0)
-- Dependencies: 213
-- Name: dumpeddevice_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.dumpeddevice_seq', 1, false);


--
-- TOC entry 3609 (class 0 OID 0)
-- Dependencies: 214
-- Name: emplog_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.emplog_seq', 1, false);


--
-- TOC entry 3610 (class 0 OID 0)
-- Dependencies: 215
-- Name: gysrtemp_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.gysrtemp_seq', 1, false);


--
-- TOC entry 3611 (class 0 OID 0)
-- Dependencies: 216
-- Name: iot_analytic_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_analytic_seq', 1, false);


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 217
-- Name: iot_appregister_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_appregister_seq', 1, false);


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 218
-- Name: iot_assignmember_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_assignmember_seq', 1, false);


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 219
-- Name: iot_customersupport_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_customersupport_seq', 1, false);


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 220
-- Name: iot_custotp_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_custotp_seq', 1, false);


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 221
-- Name: iot_devicefittinglocation_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_devicefittinglocation_seq', 1, false);


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 222
-- Name: iot_devicelocationdetails_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_devicelocationdetails_seq', 1, false);


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 223
-- Name: iot_deviceswitchtypes_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_deviceswitchtypes_seq', 1, false);


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 224
-- Name: iot_fingerprint_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_fingerprint_seq', 1, false);


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 225
-- Name: iot_macaddresses_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_macaddresses_seq', 1, false);


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 226
-- Name: iot_moduletype_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_moduletype_seq', 1, false);


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 227
-- Name: iot_piragentcountdetails_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_piragentcountdetails_seq', 1, false);


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 228
-- Name: iot_pirdetails_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_pirdetails_seq', 1, false);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 229
-- Name: iot_plugreports_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_plugreports_seq', 1, false);


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 230
-- Name: iot_pushnotifications_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_pushnotifications_seq', 1, false);


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 231
-- Name: iot_report_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_report_seq', 1, false);


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 232
-- Name: iot_scheduletime_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_scheduletime_seq', 1, false);


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 233
-- Name: iot_securityquestionanswers_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_securityquestionanswers_seq', 1, false);


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 234
-- Name: iot_securityquestions_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_securityquestions_seq', 1, false);


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 235
-- Name: iot_sharedevice_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_sharedevice_seq', 1, false);


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 236
-- Name: iot_submoduleoperation_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_submoduleoperation_seq', 1, false);


--
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 237
-- Name: iot_submoduletype_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_submoduletype_seq', 1, false);


--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 238
-- Name: iot_switchreports_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_switchreports_seq', 1, false);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 239
-- Name: iot_sync_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_sync_seq', 1, false);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 240
-- Name: iot_teammembers_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_teammembers_seq', 1, false);


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 241
-- Name: iot_teams_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_teams_seq', 1, false);


--
-- TOC entry 3637 (class 0 OID 0)
-- Dependencies: 242
-- Name: iot_test_appreports_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_test_appreports_seq', 1, false);


--
-- TOC entry 3638 (class 0 OID 0)
-- Dependencies: 243
-- Name: iot_tickets_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_tickets_seq', 1, false);


--
-- TOC entry 3639 (class 0 OID 0)
-- Dependencies: 244
-- Name: iot_unitcost_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.iot_unitcost_seq', 1, false);


--
-- TOC entry 3640 (class 0 OID 0)
-- Dependencies: 245
-- Name: ioterrors_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.ioterrors_seq', 1, false);


--
-- TOC entry 3641 (class 0 OID 0)
-- Dependencies: 246
-- Name: mdapplication_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdapplication_seq', 1, false);


--
-- TOC entry 3642 (class 0 OID 0)
-- Dependencies: 247
-- Name: mdbranch_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdbranch_seq', 1, false);


--
-- TOC entry 3643 (class 0 OID 0)
-- Dependencies: 248
-- Name: mdcompany_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdcompany_seq', 1, false);


--
-- TOC entry 3644 (class 0 OID 0)
-- Dependencies: 249
-- Name: mdcurrentloggings_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdcurrentloggings_seq', 1, false);


--
-- TOC entry 3645 (class 0 OID 0)
-- Dependencies: 250
-- Name: mddatastore_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mddatastore_seq', 1, false);


--
-- TOC entry 3646 (class 0 OID 0)
-- Dependencies: 251
-- Name: mdemployees_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdemployees_seq', 1, false);


--
-- TOC entry 3647 (class 0 OID 0)
-- Dependencies: 252
-- Name: mdfolder_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdfolder_seq', 1, false);


--
-- TOC entry 3648 (class 0 OID 0)
-- Dependencies: 253
-- Name: mdloginhistory_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdloginhistory_seq', 1, false);


--
-- TOC entry 3649 (class 0 OID 0)
-- Dependencies: 254
-- Name: mdprivileges_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdprivileges_seq', 1, false);


--
-- TOC entry 3650 (class 0 OID 0)
-- Dependencies: 255
-- Name: mdrole_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdrole_seq', 1, false);


--
-- TOC entry 3651 (class 0 OID 0)
-- Dependencies: 256
-- Name: mdusers_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.mdusers_seq', 1, false);


--
-- TOC entry 3652 (class 0 OID 0)
-- Dependencies: 257
-- Name: messages_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.messages_seq', 1, false);


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 258
-- Name: messagetype_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.messagetype_seq', 1, false);


--
-- TOC entry 3654 (class 0 OID 0)
-- Dependencies: 259
-- Name: requestedmessages_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.requestedmessages_seq', 1, false);


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 260
-- Name: suv_user_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.suv_user_seq', 1, false);


--
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 261
-- Name: userpaymentdetails_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.userpaymentdetails_seq', 1, false);


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 262
-- Name: userpir_seq; Type: SEQUENCE SET; Schema: iot; Owner: -
--

SELECT pg_catalog.setval('iot.userpir_seq', 1, false);


--
-- TOC entry 3300 (class 2606 OID 26733)
-- Name: mddatastore datastorename_mddatastore; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mddatastore
    ADD CONSTRAINT datastorename_mddatastore UNIQUE (datastorename);


--
-- TOC entry 3204 (class 2606 OID 26645)
-- Name: device devicename_device; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.device
    ADD CONSTRAINT devicename_device UNIQUE (devicename);


--
-- TOC entry 3308 (class 2606 OID 26741)
-- Name: mdemployees employeeid_mdemployees; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdemployees
    ADD CONSTRAINT employeeid_mdemployees UNIQUE (employeeid);


--
-- TOC entry 3302 (class 2606 OID 26735)
-- Name: mddatastore licenceid_mddatastore; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mddatastore
    ADD CONSTRAINT licenceid_mddatastore UNIQUE (licencekey);


--
-- TOC entry 3304 (class 2606 OID 26737)
-- Name: mddatastore melditengineip_mddatastore; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mddatastore
    ADD CONSTRAINT melditengineip_mddatastore UNIQUE (melditengineip);


--
-- TOC entry 3194 (class 2606 OID 26635)
-- Name: agentusers pk_agentusers; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.agentusers
    ADD CONSTRAINT pk_agentusers PRIMARY KEY (agentusersid);


--
-- TOC entry 3196 (class 2606 OID 26637)
-- Name: configdevices pk_configdevices; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.configdevices
    ADD CONSTRAINT pk_configdevices PRIMARY KEY (id);


--
-- TOC entry 3198 (class 2606 OID 26639)
-- Name: currentloggings pk_currentloggings; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.currentloggings
    ADD CONSTRAINT pk_currentloggings PRIMARY KEY (sno);


--
-- TOC entry 3202 (class 2606 OID 26643)
-- Name: customercarecuurentlogins pk_customercarecuurentlogins; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.customercarecuurentlogins
    ADD CONSTRAINT pk_customercarecuurentlogins PRIMARY KEY (customercarecuurentloginid);


--
-- TOC entry 3206 (class 2606 OID 26647)
-- Name: device pk_device; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.device
    ADD CONSTRAINT pk_device PRIMARY KEY (deviceid);


--
-- TOC entry 3209 (class 2606 OID 26649)
-- Name: devicepaymentdetails pk_devicepaymentdetails; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.devicepaymentdetails
    ADD CONSTRAINT pk_devicepaymentdetails PRIMARY KEY (devicepaymentdetailsid);


--
-- TOC entry 3211 (class 2606 OID 26651)
-- Name: devicetype pk_devicetype; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.devicetype
    ADD CONSTRAINT pk_devicetype PRIMARY KEY (devicetypeid);


--
-- TOC entry 3213 (class 2606 OID 26653)
-- Name: dummyimage pk_dummyimage; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.dummyimage
    ADD CONSTRAINT pk_dummyimage PRIMARY KEY (dummyimage);


--
-- TOC entry 3215 (class 2606 OID 26655)
-- Name: dumpeddevice pk_dumpeddevice; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.dumpeddevice
    ADD CONSTRAINT pk_dumpeddevice PRIMARY KEY (dumpeddeviceid);


--
-- TOC entry 3217 (class 2606 OID 26657)
-- Name: emplog pk_emplog; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.emplog
    ADD CONSTRAINT pk_emplog PRIMARY KEY (id);


--
-- TOC entry 3220 (class 2606 OID 26659)
-- Name: gysrtemp pk_gysrtemp; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.gysrtemp
    ADD CONSTRAINT pk_gysrtemp PRIMARY KEY (gysetempid);


--
-- TOC entry 3222 (class 2606 OID 26661)
-- Name: iot_analytic pk_iot_analytic; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_analytic
    ADD CONSTRAINT pk_iot_analytic PRIMARY KEY (analyticid);


--
-- TOC entry 3224 (class 2606 OID 26663)
-- Name: iot_appregister pk_iot_appregister; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_appregister
    ADD CONSTRAINT pk_iot_appregister PRIMARY KEY (registerappid);


--
-- TOC entry 3226 (class 2606 OID 26665)
-- Name: iot_assignmember pk_iot_assignmember; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_assignmember
    ADD CONSTRAINT pk_iot_assignmember PRIMARY KEY (assignmemberid);


--
-- TOC entry 3228 (class 2606 OID 26667)
-- Name: iot_customersupport pk_iot_customersupport; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_customersupport
    ADD CONSTRAINT pk_iot_customersupport PRIMARY KEY (iot_customersupportid);


--
-- TOC entry 3230 (class 2606 OID 26669)
-- Name: iot_custotp pk_iot_custotp; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_custotp
    ADD CONSTRAINT pk_iot_custotp PRIMARY KEY (iot_custotpid);


--
-- TOC entry 3232 (class 2606 OID 26671)
-- Name: iot_devicefittinglocation pk_iot_devicefittinglocation; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_devicefittinglocation
    ADD CONSTRAINT pk_iot_devicefittinglocation PRIMARY KEY (fittinglocationid);


--
-- TOC entry 3234 (class 2606 OID 26673)
-- Name: iot_devicelocationdetails pk_iot_devicelocationdetails; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_devicelocationdetails
    ADD CONSTRAINT pk_iot_devicelocationdetails PRIMARY KEY (devicelocationdetailid);


--
-- TOC entry 3236 (class 2606 OID 26675)
-- Name: iot_deviceswitchtypes pk_iot_deviceswitchtypes; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_deviceswitchtypes
    ADD CONSTRAINT pk_iot_deviceswitchtypes PRIMARY KEY (deviceswitchtypeid);


--
-- TOC entry 3238 (class 2606 OID 26677)
-- Name: iot_fingerprint pk_iot_fingerprint; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_fingerprint
    ADD CONSTRAINT pk_iot_fingerprint PRIMARY KEY (id);


--
-- TOC entry 3240 (class 2606 OID 26679)
-- Name: iot_macaddresses pk_iot_macaddresses; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_macaddresses
    ADD CONSTRAINT pk_iot_macaddresses PRIMARY KEY (iot_macaddressesid);


--
-- TOC entry 3242 (class 2606 OID 26681)
-- Name: iot_moduletype pk_iot_moduletype; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_moduletype
    ADD CONSTRAINT pk_iot_moduletype PRIMARY KEY (moduletypeid);


--
-- TOC entry 3244 (class 2606 OID 26683)
-- Name: iot_piragentcountdetails pk_iot_piragentcountdetails; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_piragentcountdetails
    ADD CONSTRAINT pk_iot_piragentcountdetails PRIMARY KEY (iot_pircountdetails_id);


--
-- TOC entry 3246 (class 2606 OID 26685)
-- Name: iot_pirdetails pk_iot_pirdetails; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_pirdetails
    ADD CONSTRAINT pk_iot_pirdetails PRIMARY KEY (pirdetailsid);


--
-- TOC entry 3248 (class 2606 OID 26687)
-- Name: iot_plugreports pk_iot_plugreports; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_plugreports
    ADD CONSTRAINT pk_iot_plugreports PRIMARY KEY (iot_plugreportsid);


--
-- TOC entry 3251 (class 2606 OID 26689)
-- Name: iot_pushnotifications pk_iot_pushnotifications; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_pushnotifications
    ADD CONSTRAINT pk_iot_pushnotifications PRIMARY KEY (sno);


--
-- TOC entry 3255 (class 2606 OID 26691)
-- Name: iot_report pk_iot_report; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_report
    ADD CONSTRAINT pk_iot_report PRIMARY KEY (id);


--
-- TOC entry 3258 (class 2606 OID 26693)
-- Name: iot_scheduletime pk_iot_scheduletime; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_scheduletime
    ADD CONSTRAINT pk_iot_scheduletime PRIMARY KEY (scheduletimeid);


--
-- TOC entry 3260 (class 2606 OID 26695)
-- Name: iot_securityquestionanswers pk_iot_securityquestionanswers; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_securityquestionanswers
    ADD CONSTRAINT pk_iot_securityquestionanswers PRIMARY KEY (securityanswerid);


--
-- TOC entry 3262 (class 2606 OID 26697)
-- Name: iot_securityquestions pk_iot_securityquestions; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_securityquestions
    ADD CONSTRAINT pk_iot_securityquestions PRIMARY KEY (securityquestionid);


--
-- TOC entry 3264 (class 2606 OID 26699)
-- Name: iot_sharedevice pk_iot_sharedevice; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_sharedevice
    ADD CONSTRAINT pk_iot_sharedevice PRIMARY KEY (shareid);


--
-- TOC entry 3266 (class 2606 OID 26701)
-- Name: iot_submoduleoperation pk_iot_submoduleoperation; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_submoduleoperation
    ADD CONSTRAINT pk_iot_submoduleoperation PRIMARY KEY (submoduleoperationid);


--
-- TOC entry 3268 (class 2606 OID 26703)
-- Name: iot_submoduletype pk_iot_submoduletype; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_submoduletype
    ADD CONSTRAINT pk_iot_submoduletype PRIMARY KEY (submoduletypeid);


--
-- TOC entry 3270 (class 2606 OID 26705)
-- Name: iot_switchreports pk_iot_switchreports; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_switchreports
    ADD CONSTRAINT pk_iot_switchreports PRIMARY KEY (iot_switchreportsid);


--
-- TOC entry 3273 (class 2606 OID 26707)
-- Name: iot_sync pk_iot_sync; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_sync
    ADD CONSTRAINT pk_iot_sync PRIMARY KEY (syncid);


--
-- TOC entry 3277 (class 2606 OID 26711)
-- Name: iot_teammembers pk_iot_teammembers; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_teammembers
    ADD CONSTRAINT pk_iot_teammembers PRIMARY KEY (teammemberid);


--
-- TOC entry 3279 (class 2606 OID 26713)
-- Name: iot_teams pk_iot_teams; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_teams
    ADD CONSTRAINT pk_iot_teams PRIMARY KEY (teamid);


--
-- TOC entry 3281 (class 2606 OID 26715)
-- Name: iot_test_appreports pk_iot_test_appreports; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_test_appreports
    ADD CONSTRAINT pk_iot_test_appreports PRIMARY KEY (iot_testappreportsid);


--
-- TOC entry 3284 (class 2606 OID 26717)
-- Name: iot_tickets pk_iot_tickets; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_tickets
    ADD CONSTRAINT pk_iot_tickets PRIMARY KEY (ticketid);


--
-- TOC entry 3286 (class 2606 OID 26719)
-- Name: iot_unitcost pk_iot_unitcost; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_unitcost
    ADD CONSTRAINT pk_iot_unitcost PRIMARY KEY (unitid);


--
-- TOC entry 3288 (class 2606 OID 26721)
-- Name: ioterrors pk_ioterrors; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.ioterrors
    ADD CONSTRAINT pk_ioterrors PRIMARY KEY (errorid);


--
-- TOC entry 3290 (class 2606 OID 26723)
-- Name: mdapplication pk_mdapplication; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdapplication
    ADD CONSTRAINT pk_mdapplication PRIMARY KEY (mdappid);


--
-- TOC entry 3292 (class 2606 OID 26725)
-- Name: mdbranch pk_mdbranch; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdbranch
    ADD CONSTRAINT pk_mdbranch PRIMARY KEY (branchid);


--
-- TOC entry 3294 (class 2606 OID 26727)
-- Name: mdcompany pk_mdcompany; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdcompany
    ADD CONSTRAINT pk_mdcompany PRIMARY KEY (companyid);


--
-- TOC entry 3296 (class 2606 OID 26729)
-- Name: mdcurrentloggings pk_mdcurrentloggings; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdcurrentloggings
    ADD CONSTRAINT pk_mdcurrentloggings PRIMARY KEY (sno);


--
-- TOC entry 3306 (class 2606 OID 26739)
-- Name: mddatastore pk_mddatastore; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mddatastore
    ADD CONSTRAINT pk_mddatastore PRIMARY KEY (datastoreid);


--
-- TOC entry 3310 (class 2606 OID 26743)
-- Name: mdemployees pk_mdemployees; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdemployees
    ADD CONSTRAINT pk_mdemployees PRIMARY KEY (sno);


--
-- TOC entry 3312 (class 2606 OID 26745)
-- Name: mdfolder pk_mdfolder; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdfolder
    ADD CONSTRAINT pk_mdfolder PRIMARY KEY (folderid);


--
-- TOC entry 3314 (class 2606 OID 26747)
-- Name: mdlicenceinfo pk_mdlicenceinfo; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdlicenceinfo
    ADD CONSTRAINT pk_mdlicenceinfo PRIMARY KEY (licenceid);


--
-- TOC entry 3316 (class 2606 OID 26749)
-- Name: mdloginhistory pk_mdloginhistory; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdloginhistory
    ADD CONSTRAINT pk_mdloginhistory PRIMARY KEY (indexid);


--
-- TOC entry 3318 (class 2606 OID 26751)
-- Name: mdprivileges pk_mdprivileges; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdprivileges
    ADD CONSTRAINT pk_mdprivileges PRIMARY KEY (privilegeid);


--
-- TOC entry 3322 (class 2606 OID 26755)
-- Name: mdrole pk_mdrole; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdrole
    ADD CONSTRAINT pk_mdrole PRIMARY KEY (roleid);


--
-- TOC entry 3324 (class 2606 OID 26757)
-- Name: mdusers pk_mdusers; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdusers
    ADD CONSTRAINT pk_mdusers PRIMARY KEY (userid);


--
-- TOC entry 3328 (class 2606 OID 26761)
-- Name: messages pk_messages; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.messages
    ADD CONSTRAINT pk_messages PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 26763)
-- Name: messagetype pk_messagetype; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.messagetype
    ADD CONSTRAINT pk_messagetype PRIMARY KEY (messagetypeid);


--
-- TOC entry 3332 (class 2606 OID 26765)
-- Name: requestedmessages pk_requestedmessages; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.requestedmessages
    ADD CONSTRAINT pk_requestedmessages PRIMARY KEY (requestmessageid);


--
-- TOC entry 3334 (class 2606 OID 26767)
-- Name: suv_user pk_suv_user; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.suv_user
    ADD CONSTRAINT pk_suv_user PRIMARY KEY (userid);


--
-- TOC entry 3338 (class 2606 OID 26771)
-- Name: userpaymentdetails pk_userpaymentdetails; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.userpaymentdetails
    ADD CONSTRAINT pk_userpaymentdetails PRIMARY KEY (userpaymentdetailsid);


--
-- TOC entry 3340 (class 2606 OID 26773)
-- Name: userpir pk_userpir; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.userpir
    ADD CONSTRAINT pk_userpir PRIMARY KEY (userpir);


--
-- TOC entry 3320 (class 2606 OID 26753)
-- Name: mdprivileges privilegename_mdprivileges; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdprivileges
    ADD CONSTRAINT privilegename_mdprivileges UNIQUE (privilegename);


--
-- TOC entry 3275 (class 2606 OID 26709)
-- Name: iot_sync syncname_iot_sync; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_sync
    ADD CONSTRAINT syncname_iot_sync UNIQUE (syncname);


--
-- TOC entry 3200 (class 2606 OID 26641)
-- Name: currentloggings userid_currentloggings; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.currentloggings
    ADD CONSTRAINT userid_currentloggings UNIQUE (userid);


--
-- TOC entry 3298 (class 2606 OID 26731)
-- Name: mdcurrentloggings userid_mdcurrentloggings; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdcurrentloggings
    ADD CONSTRAINT userid_mdcurrentloggings UNIQUE (userid);


--
-- TOC entry 3336 (class 2606 OID 26769)
-- Name: suv_user username_emailid_phonenumber_suv_user; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.suv_user
    ADD CONSTRAINT username_emailid_phonenumber_suv_user UNIQUE (username, emailid, phonenumber);


--
-- TOC entry 3326 (class 2606 OID 26759)
-- Name: mdusers username_mdusers; Type: CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdusers
    ADD CONSTRAINT username_mdusers UNIQUE (username, employeeid);


--
-- TOC entry 3218 (class 1259 OID 26627)
-- Name: deviceid_gysrtemp; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX deviceid_gysrtemp ON iot.gysrtemp USING btree (deviceid);


--
-- TOC entry 3253 (class 1259 OID 26630)
-- Name: deviceid_iot_report; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX deviceid_iot_report ON iot.iot_report USING btree (deviceid);


--
-- TOC entry 3207 (class 1259 OID 26626)
-- Name: syncid_device; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX syncid_device ON iot.device USING btree (syncid);


--
-- TOC entry 3249 (class 1259 OID 26628)
-- Name: userid_iot_plugreports; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX userid_iot_plugreports ON iot.iot_plugreports USING btree (userid);


--
-- TOC entry 3252 (class 1259 OID 26629)
-- Name: userid_iot_pushnotifications; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX userid_iot_pushnotifications ON iot.iot_pushnotifications USING btree (userid);


--
-- TOC entry 3256 (class 1259 OID 26631)
-- Name: userid_iot_report; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX userid_iot_report ON iot.iot_report USING btree (userid);


--
-- TOC entry 3271 (class 1259 OID 26632)
-- Name: userid_iot_switchreports; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX userid_iot_switchreports ON iot.iot_switchreports USING btree (userid);


--
-- TOC entry 3282 (class 1259 OID 26633)
-- Name: userid_iot_test_appreports; Type: INDEX; Schema: iot; Owner: -
--

CREATE INDEX userid_iot_test_appreports ON iot.iot_test_appreports USING btree (userid);


--
-- TOC entry 3341 (class 2606 OID 26774)
-- Name: iot_devicelocationdetails fk_iot_devicelocationdetails_iot_devicefittinglocation; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_devicelocationdetails
    ADD CONSTRAINT fk_iot_devicelocationdetails_iot_devicefittinglocation FOREIGN KEY (fittinglocationid) REFERENCES iot.iot_devicefittinglocation(fittinglocationid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3342 (class 2606 OID 26779)
-- Name: iot_deviceswitchtypes fk_iot_deviceswitchtypes_iot_devicelocationdetails; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_deviceswitchtypes
    ADD CONSTRAINT fk_iot_deviceswitchtypes_iot_devicelocationdetails FOREIGN KEY (devicelocationdetailid) REFERENCES iot.iot_devicelocationdetails(devicelocationdetailid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3343 (class 2606 OID 26784)
-- Name: iot_deviceswitchtypes fk_iot_deviceswitchtypes_iot_submoduletype; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_deviceswitchtypes
    ADD CONSTRAINT fk_iot_deviceswitchtypes_iot_submoduletype FOREIGN KEY (submoduletypeid) REFERENCES iot.iot_submoduletype(submoduletypeid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3344 (class 2606 OID 26789)
-- Name: iot_submoduleoperation fk_iot_submoduleoperation_iot_submoduletype; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_submoduleoperation
    ADD CONSTRAINT fk_iot_submoduleoperation_iot_submoduletype FOREIGN KEY (submoduletypeid) REFERENCES iot.iot_submoduletype(submoduletypeid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3345 (class 2606 OID 26794)
-- Name: iot_submoduletype fk_iot_submoduletype_iot_moduletype; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.iot_submoduletype
    ADD CONSTRAINT fk_iot_submoduletype_iot_moduletype FOREIGN KEY (moduletypeid) REFERENCES iot.iot_moduletype(moduletypeid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3346 (class 2606 OID 26799)
-- Name: mdbranch fk_mdbranch_mdcompany; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdbranch
    ADD CONSTRAINT fk_mdbranch_mdcompany FOREIGN KEY (companyid) REFERENCES iot.mdcompany(companyid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3347 (class 2606 OID 26804)
-- Name: mdusers fk_mdusers_mdbranch; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdusers
    ADD CONSTRAINT fk_mdusers_mdbranch FOREIGN KEY (branchid) REFERENCES iot.mdbranch(branchid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3348 (class 2606 OID 26809)
-- Name: mdusers fk_mdusers_mdcompany; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.mdusers
    ADD CONSTRAINT fk_mdusers_mdcompany FOREIGN KEY (companyid) REFERENCES iot.mdcompany(companyid) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- TOC entry 3349 (class 2606 OID 26814)
-- Name: messagetype fk_messagetype_devicetype; Type: FK CONSTRAINT; Schema: iot; Owner: -
--

ALTER TABLE ONLY iot.messagetype
    ADD CONSTRAINT fk_messagetype_devicetype FOREIGN KEY (devicetypeid) REFERENCES iot.devicetype(devicetypeid) ON UPDATE RESTRICT ON DELETE RESTRICT;


-- Completed on 2020-04-16 17:52:34

--
-- PostgreSQL database dump complete
--

