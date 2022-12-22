/*DROP TABLE shop;
DROP TABLE company;*/

CREATE TABLE shop
(
    shop_id      NUMBER(20)         NOT NULL
        CONSTRAINT shop_pk PRIMARY KEY,
    parent_id    NUMBER(20),
    shop_code    VARCHAR2(20 BYTE)  NOT NULL
        CONSTRAINT shop_uk
            UNIQUE,
    shop_level   NUMBER(2)          NOT NULL,
    name         VARCHAR2(80 BYTE)  NOT NULL,
    contact_name VARCHAR2(150 BYTE),
    mobile       VARCHAR2(100 BYTE),
    fax          VARCHAR2(100 BYTE),
    email        VARCHAR2(100 BYTE),
    status       VARCHAR2(1 BYTE)   NOT NULL,
    address      VARCHAR2(150 BYTE) NOT NULL,
    description  VARCHAR2(150 BYTE),
    web_user_id  NUMBER(10)         NOT NULL
        CONSTRAINT shop_am_user_fk1 REFERENCES am_user,
    create_by    VARCHAR(50)        NOT NULL,
    create_date  DATE DEFAULT SYSDATE,
    upd_by       VARCHAR(50),
    upt_date     DATE DEFAULT SYSDATE
);

CREATE SEQUENCE shop_seq
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOCYCLE
    NOORDER
    CACHE 20
/



CREATE TABLE company
(
    com_id         NUMBER(20)     NOT NULL
        CONSTRAINT company_pk PRIMARY KEY,
    parent_id      NUMBER(20),
    com_name       NVARCHAR2(200) NOT NULL,
    shop_id        NUMBER(20)     NOT NULL,
    tax_code       VARCHAR2(50),
    bus_code       VARCHAR2(15),
    mobile         VARCHAR2(15),
    email          VARCHAR2(100),
    status         VARCHAR2(1)    NOT NULL,
    description    VARCHAR2(200),
    comp_level     NUMBER(2)      NOT NULL,
    rep_name       VARCHAR2(50),
    rep_mobile     VARCHAR2(15),
    rep_position   VARCHAR2(50),
    province       VARCHAR2(100),
    city           VARCHAR2(100),
    district       VARCHAR2(100),
    ward           VARCHAR2(100),
    address        VARCHAR2(400),
    web_user_id    NUMBER(10)     NOT NULL
        CONSTRAINT comp_am_user_fk1 REFERENCES am_user,
    api_user_id    NUMBER(10)     NOT NULL
        CONSTRAINT comp_am_user_fk2 REFERENCES am_user,
    public_key     CLOB,
    public_key_upt DATE,
    file_path      VARCHAR2(200),
    create_by      VARCHAR(50)    NOT NULL,
    create_date    DATE DEFAULT SYSDATE,
    upd_by         VARCHAR(50),
    upt_date       DATE DEFAULT SYSDATE
)
/

CREATE SEQUENCE company_seq
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOCYCLE
    NOORDER
    CACHE 20
/

CREATE TABLE shop_level
(
    id         NUMBER(10)    NOT NULL
        CONSTRAINT shop_level_pk
            PRIMARY KEY,
    shop_level NUMBER(1)     NOT NULL
        CONSTRAINT shop_level_uk UNIQUE,
    name       VARCHAR2(200) NOT NULL
)/

INSERT INTO shop_level
VALUES (1, 1, 'Cấp 1');
INSERT INTO shop_level
VALUES (2, 2, 'Cấp 2');
INSERT INTO shop_level
VALUES (3, 3, 'Cấp 3');
INSERT INTO shop_level
VALUES (4, 4, 'Cấp 4');
COMMIT;


CREATE TABLE sub_service
(
    isdn           VARCHAR2(20)          NOT NULL,
    service        VARCHAR2(50)          NOT NULL,
    start_time     DATE                  NOT NULL,
    end_time       DATE                  NOT NULL,
    profile_code   VARCHAR2(30),
    initial_amount NUMBER(10),
    total_amount   NUMBER(15),
    serial         VARCHAR2(30),
    alert_end_time VARCHAR2(1) DEFAULT 0 NOT NULL,
    last_update    DATE,
    hid            NUMBER(15),
    request_id     VARCHAR2(100),
    channel        VARCHAR2(1)
)
/

COMMENT ON COLUMN sub_service.alert_end_time IS '1: da canh bao, 0: chua canh bao'
/
COMMENT ON COLUMN sub_service.channel IS '1: SMS, 2: WEB, 3: API'
/

CREATE INDEX sub_service_pk
    ON sub_service (isdn, service)
/

CREATE TRIGGER sub_service_bu
    BEFORE UPDATE
    ON sub_service
    FOR EACH ROW
BEGIN
    IF :new.end_time != :old.end_time AND :old.alert_end_time = '1' THEN
        :new.alert_end_time := '0';
    END IF;
END;
/

CREATE TABLE sub_service_history
(
    hid            NUMBER(15)            NOT NULL
        CONSTRAINT sub_service_history_pk PRIMARY KEY,
    isdn           VARCHAR2(20)          NOT NULL,
    service        VARCHAR2(50)          NOT NULL,
    start_time     DATE                  NOT NULL,
    end_time       DATE                  NOT NULL,
    profile_code   VARCHAR2(30),
    initial_amount NUMBER(10),
    total_amount   NUMBER(15),
    serial         VARCHAR2(30),
    alert_end_time VARCHAR2(1) DEFAULT 0 NOT NULL,
    last_update    DATE,
    request_id     VARCHAR2(100),
    channel        VARCHAR2(1)
)
/

CREATE TABLE mt_queue
(
    id           NUMBER(15)            NOT NULL
        CONSTRAINT mt_queue_pk
            PRIMARY KEY,
    request_id   VARCHAR2(100)         NOT NULL,
    isdn         VARCHAR2(15)          NOT NULL,
    content      VARCHAR2(1000)        NOT NULL,
    shortcode    VARCHAR2(15),
    retries      NUMBER(2)             NOT NULL,
    sent_time    TIMESTAMP(7),
    process_time TIMESTAMP(7),
    status       VARCHAR2(1) DEFAULT 0 NOT NULL
)
/