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

