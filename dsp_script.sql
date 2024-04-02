DROP TABLE dsp_pcrf_srv_config;
DROP SEQUENCE dsp_pcrf_srv_config_seq;

CREATE TABLE dsp_pcrf_srv_config
(
    id                  NUMERIC(10)             NOT NULL
        CONSTRAINT dsp_pcrf_srv_config_pk
            PRIMARY KEY,
    sys_type            VARCHAR2(100)           NOT NULL,
    service_type        VARCHAR2(100)           NOT NULL,
    service_name        VARCHAR2(100)           NOT NULL,
    service_name_unique VARCHAR2(4000),
    pin_prefix          VARCHAR2(5)             NOT NULL,
    add_on              VARCHAR2(1) DEFAULT '0' NOT NULL,
    description         VARCHAR2(500)           NOT NULL,
    status              VARCHAR2(1) DEFAULT '1' NOT NULL,
    CONSTRAINT dsp_pcrf_srv_config_uk1
        UNIQUE (sys_type, service_name, pin_prefix),
    CONSTRAINT dsp_pcrf_srv_config_uk2
        UNIQUE (pin_prefix)
)
/


CREATE SEQUENCE dsp_pcrf_srv_config_seq
/

INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'DCON', 'BDATASPONSOR2', NULL, 'A', '1', 'Dich vu DATA_CODE ADD_ON', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'CD', 'BDATASPONSOR3', NULL, 'CD', '1', 'Dich vu DATA chu dong', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'DC', 'BDATASPONSOR1', NULL, 'N', '0', 'Dich vu DATA_CODE thong thuong', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'MVF60', 'MVF60', 'MVF60,MVF75,MVF200,MVF450,MVF900', 'V1', '0', 'Dich vu Vinfast', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'MVF75', 'MVF75', 'MVF60,MVF75,MVF200,MVF450,MVF900', 'V2', '0', 'Dich vu Vinfast', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'MVF200', 'MVF200', 'MVF60,MVF75,MVF200,MVF450,MVF900', 'V3', '0', 'Dich vu Vinfast', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'MVF450', 'MVF450', 'MVF60,MVF75,MVF200,MVF450,MVF900', 'V4', '0', 'Dich vu Vinfast', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'MVF900', 'MVF900', 'MVF60,MVF75,MVF200,MVF450,MVF900', 'V5', '0', 'Dich vu Vinfast', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'BLF1', 'BLF1', NULL, 'L1', '1', 'Dich vu LF1', '1');
INSERT INTO dsp_pcrf_srv_config
VALUES (dsp_pcrf_srv_config_seq.nextval, 'PCRFGW', 'BLF2', 'BLF2', NULL, 'L2', '1', 'Dich vu LF2', '1');


COMMIT;


