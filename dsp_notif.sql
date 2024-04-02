CREATE TABLE dsp_owner.dsp_notif_config
(
    id           NUMBER(15)                 NOT NULL,
    srv_name     VARCHAR2(200)              NOT NULL,
    package_code VARCHAR2(500)              NOT NULL,
    qtastatus    VARCHAR2(500)              NOT NULL,
    qtavalue     NUMBER(15),
    dest_api     VARCHAR2(2000)             NOT NULL,
    proxy_api    VARCHAR2(2000) DEFAULT 'http://10.54.18.151:6666',
    status       varchar2(1)    DEFAULT '1' NOT NULL
)
/


ALTER TABLE dsp_notif_config
    ADD CONSTRAINT "DSP_NOTIF_CONFIG_pk"
        PRIMARY KEY (id)
/

CREATE SEQUENCE dsp_notif_config_seq
/
CREATE TABLE dsp_notif_queue
(
    id                 NUMBER(15)              NOT NULL
        CONSTRAINT dsp_notif_queue_pk
            PRIMARY KEY,
    isdn               varchar2(15)            NOT NULL,
    srv_name           varchar2(200)           NOT NULL,
    qta_status         varchar2(500)           NOT NULL,
    qta_value          number(15),
    srv_start_datetime varchar2(500),
    srv_end_datetime   varchar2(500),
    des_api            VARCHAR2(2000)          NOT NULL,
    proxy_api          VARCHAR2(2000)          NOT NULL,
    notif_date         date        DEFAULT SYSDATE,
    exec_date          date,
    retries            varchar2(1) DEFAULT '3' NOT NULL
)
/

CREATE SEQUENCE dsp_notif_queue_seq
/

