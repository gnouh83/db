/*20231108*/
INSERT INTO api VALUES ('50','Nap TopUp','/nap_top_up','Cộng dịch vụ DATA/VASP profile bằng API','1');
COMMIT ;
/*DROP TABLE shop;
DROP TABLE company;*/
GRANT SELECT ON dsp_sub_service TO icccds_owner;
GRANT SELECT ON company TO dsp_owner;
GRANT SELECT, INSERT ON mo_queue TO dsp_owner;

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

CREATE SEQUENCE company_seq MINVALUE 1000000 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1000000 CACHE 20 NOORDER NOCYCLE;

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
CREATE INDEX "SUB_SERVICE_HID_index"
    ON sub_service (hid)
/
CREATE INDEX "SUB_SERVICE_END_TIME_index"
    ON sub_service (end_time)
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
    hid            NUMBER(15)            NOT NULL,
    isdn           VARCHAR2(20)          NOT NULL,
    service        VARCHAR2(50)          NOT NULL,
    start_time     DATE                  NOT NULL,
    end_time       DATE                  NOT NULL,
    cancel_time    DATE,
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

--dsp_owner:
GRANT SELECT ON dsp_owner.dsp_sub_service TO icccds_owner;

CREATE OR REPLACE FUNCTION check_sub_service(p_isdn IN VARCHAR2,
                                             p_service IN VARCHAR2)
    RETURN NUMBER
    IS
    v_count NUMBER(10) := 0;
BEGIN
    SELECT COUNT(1)
    INTO v_count
    FROM dsp_owner.dsp_sub_service
    WHERE isdn = p_isdn
      AND service = p_service
      AND end_time > SYSDATE;

    IF v_count > 0
    THEN
        RETURN v_count;
    END IF;

    SELECT COUNT(1)
    INTO v_count
    FROM sub_service
    WHERE isdn = p_isdn
      AND service = p_service
      AND end_time > SYSDATE;

    RETURN v_count;
END;
/
--dsp_owner:
GRANT SELECT ON dsp_owner.dsp_sms_command TO icccds_owner;
ALTER TABLE dsp_owner.dsp_sms_command
    ADD sys_type varchar2(1) DEFAULT '0' NOT NULL;

CREATE VIEW sms_command AS
SELECT cmd_id,
       cmd_code,
       cmd_type,
       cmd_msg_content,
       cmd_param_count,
       description,
       cmd_regex,
       status
FROM dsp_owner.dsp_sms_command
WHERE sys_type IN (1, 3);


INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA_OK', 'O',
        'Quý khách được cộng thêm {0}MB data tốc độ cao từ datacode (sử dụng tại Việt Nam), thời hạn sử dụng đến {1}.Tắt tất cả ứng dụng internet hoặc khởi động lại máy để được tính cước theo gói đã nạp. Chi tiết liên hệ 9090.',
        0,
        'KH nhắn tin đúng cú pháp, hiện không sử dụng gói datacode thường khác, đúng mã datacode    Quý khách được cộng thêm xMB data tốc độ cao từ datacode (sử dụng tại Việt Nam), thời hạn sử dụng đến dd/mm/yyyy. Chi tiết liên hệ 9090.    ',
        NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA_ON_OK', 'O',
        'Quý khách được cộng thêm {0}MB data tốc độ cao từ datacode addon (sử dụng tại Việt Nam). Tổng dung lượng còn lại từ datacode addon là {2}MB, thời hạn sử dụng đến {1}.Tắt tất cả ứng dụng internet hoặc khởi động lại máy để được tính cước theo gói đã nạp. Chi tiết liên hệ 9090.',
        0, 'KH nhắn tin đúng cú pháp, đúng mã datacode addon', NULL, '1', '1');


INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA', 'I', NULL, 3,
        'KHCN Nạp DATA từ DATA-CODE thông thường. Cú pháp DK_DATA_Ma_data_code(N....)', 'DK DATA N\d{14}', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA_ON', 'I', NULL, 3,
        'KHCN Nạp DATA từ DATA-CODE AddOn. Cú pháp DK_DATAON_Ma_data_code (A....)', 'DK DATAON A\d{14}', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_1', 'I', NULL, 3, 'Đăng ký dịch vụ KHCN', 'DK CB (90N|D60)\d{12}', '1',
        '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_2', 'I', NULL, 5, 'Đăng ký dịch vụ KHCN (Đại lý DK)',
        'DK CB \d{15} (90N|D60)\d{12} \d{9}', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA_F1', 'O',
        'Quý khách hiện đang có một mã datacode khác còn hiệu lực. Để nạp datacode mới, quý khách vui lòng hủy gói datacode bằng cách soạn HUY_DC gửi 9xxx, trong đó “_” là dấu cách. Hoặc chờ mã datacode cũ hết hạn sử dụng. Chi tiết liên hệ 9090.    ',
        0, 'KH nhắn tin đúng cú pháp, nhưng đang sử dụng gói datacode thường khác    ', NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_DATA_F2', 'O',
        'Mã datacode không hợp lệ. Quý khách vui lòng kiểm tra lại mã datacode. Chi tiết liên hệ 9090.', 0,
        'KH nhắn tin đúng cú pháp, hiện không sử dụng gói datacode thường khác, sai mã datacode', NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_2_OK', 'O',
        'Gói DC90N đã được đăng ký thành công cho thuê bao {0}. Chi tiết liên hệ 9090. Xin cảm ơn!', 0, 'Thành công',
        NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_1_F2', 'O',
        'Quý khách không thuộc đối tượng tham gia chương trình. Chi tiết liên hệ 9090. Xin cảm ơn!', 0,
        'Quý khách không thuộc đối tượng tham gia chương trình. Chi tiết liên hệ 9090. Xin cảm ơn!', NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_2_F1', 'O',
        'Thông tin datacode không hợp lệ. Quý khách vui lòng kiểm tra lại. Chi tiết liên hệ 9090. Xin cảm ơn!', 0,
        'Thông tin datacode không hợp lệ. Quý khách vui lòng kiểm tra lại. Chi tiết liên hệ 9090. Xin cảm ơn!', NULL,
        '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_2_F2', 'O',
        'Thuê bao đăng ký không thuộc đối tượng tham gia chương trình. Chi tiết liên hệ 9090. Xin cảm ơn!', 0,
        'Thuê bao đăng ký không thuộc đối tượng tham gia chương trình. Chi tiết liên hệ 9090. Xin cảm ơn!', NULL, '1',
        '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_2_F3', 'O', 'Thuê bao bán hàng {0} không phải là thuê bao VAS!', 0,
        'Thuê bao bán hàng {0} không phải là thuê bao VAS!', NULL, '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'DK_CB_1_OK', 'O',
        'Gói DC90N đã được đăng ký thành công. Quý khách được miễn phí thoại nội mạng cho tất cả các cuộc gọi dưới 20 phút, 50 phút gọi liên mạng trong nước, 4GB data tốc độ cao/ngày. HSD gói: {0}. Từ chu kỳ thứ 2 trở đi, giá gói 90.000 đ/30 ngày. Chi tiết liên hệ 9090. Xin cảm ơn!',
        0, 'Thành công', NULL, '1', '1');

INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'KT_DATA', 'I', NULL, 2,
        'KHCN kiem tra DATA từ DATA-CODE thông thường. Cú pháp DK_DATA', 'KT DATA', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'KT_DATA_ON', 'I', NULL, 2,
        'KHCN kiem tra DATA ADDON từ DATA-CODE ADDON. Cú pháp DK_DATAON', 'KT DATAON', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'HUY_DATA', 'I', NULL, 2,
        'KHCN huy DATA từ DATA-CODE thông thường. Cú pháp HUY_DATA', 'HUY DATA', '1', '1');
INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'HUY_DATA_ON', 'I', NULL, 2,
        'KHCN huy DATA từ DATA-CODE ADDON. Cú pháp HUY_DATAON', 'HUY DATAON', '1', '1');

INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'KT_DATA_OK', 'O',
        'Quý khách còn lại {0}MB data tốc độ cao từ datacode (sử dụng tại Việt Nam), thời hạn sử dụng đến {1}. Chi tiết liên hệ 9090.    ',
        0, 'KH nhắn tin đúng cú pháp tra cứu KT_DATA', NULL, '1', '1');

INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'KT_DATA_ON_OK', 'O',
        'Quý khách còn lại {0}MB data tốc độ cao từ datacode addon (sử dụng tại Việt Nam), thời hạn sử dụng đến {1}. Chi tiết liên hệ 9090.',
        0, 'KH nhắn tin đúng cú pháp tra cứu KT_DATAON', NULL, '1', '1');


INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'HUY_DATA_OK', 'O',
        'Quý khách đã hủy thành công gói datacode. Chi tiết liên hệ 9090.', 0,
        'KH nhắn tin đúng cú pháp hủy HUY_DATA', NULL, '1', '1');

INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'HUY_DATA_ON_OK', 'O',
        'Quý khách đã hủy thành công gói datacode addon. Chi tiết liên hệ 9090.', 0,
        'KH nhắn tin đúng cú pháp tra cứu HUY_DATAON', NULL, '1', '1');

INSERT INTO dsp_sms_command
VALUES (dsp_sms_command_seq.nextval, 'TOP_UP_OK', 'O',
        'Quý khách đã nạp thành công gói {0}. Chi tiết liên hệ 9090.', 0,
        'KH nhắn tin đúng cú pháp tra cứu HUY_DATAON', NULL, '1', '1');


UPDATE dsp_sms_command
SET sys_type ='3'
WHERE cmd_code IN
      ('DK_FAIL_ADD_DATA', 'DK_FAIL', 'DK_FAIL_NO_RETRY', 'NO_GPRS', 'SUB_NOT_EXIST', 'LOCK_ISDN', 'VOUCHER_USED',
       'VOUCHER_NOT_FOUND', 'INVALID_FORMAT', 'SYSTEM_ERROR', 'KT_INVALID_SRV', 'SYSTEM_UPGRADING');

COMMIT;

CREATE TABLE mt_queue
(
    id           NUMBER(15)            NOT NULL
        CONSTRAINT mt_queue_pk
            PRIMARY KEY,
    request_id   NUMBER(15),
    trans_id     VARCHAR2(1000),
    isdn         VARCHAR2(15)          NOT NULL,
    content      VARCHAR2(1000)        NOT NULL,
    shortcode    VARCHAR2(15),
    retries      NUMBER(2)   DEFAULT 3 NOT NULL,
    sent_time    TIMESTAMP(7),
    process_time TIMESTAMP(7),
    status       VARCHAR2(1) DEFAULT 0 NOT NULL
)
/

CREATE TABLE mt_history
(
    id           NUMBER(15)     NOT NULL,
    request_id   NUMBER(15),
    trans_id     VARCHAR2(1000),
    isdn         VARCHAR2(15)   NOT NULL,
    content      VARCHAR2(1000) NOT NULL,
    shortcode    VARCHAR2(15),
    retries      NUMBER(2)      NOT NULL,
    sent_time    TIMESTAMP(7),
    process_time TIMESTAMP(7)
)
/

COMMENT ON COLUMN mt_history.isdn IS 'So thue bao, dinh dang 84xxxxxxxxx'
/

COMMENT ON COLUMN mt_history.content IS 'Noi dung tin nhan SMS'
/

COMMENT ON COLUMN mt_history.shortcode IS 'Dau so dich vu'
/

COMMENT ON COLUMN mt_history.retries IS 'So lan retry con lai'
/

CREATE TABLE mo_queue
(
    request_id    NUMBER(15)                   NOT NULL
        CONSTRAINT cb_mo_queue_pk
            PRIMARY KEY,
    isdn          VARCHAR2(15)                 NOT NULL,
    content       VARCHAR2(300)                NOT NULL,
    received_time TIMESTAMP(6) DEFAULT SYSDATE NOT NULL,
    shortcode     VARCHAR2(15)                 NOT NULL,
    retries       NUMBER(2)                    NOT NULL
)
/

CREATE TABLE mo_history
(
    request_id    NUMBER(15)                   NOT NULL,
    trans_id      VARCHAR2(1000),
    isdn          VARCHAR2(15)                 NOT NULL,
    content       VARCHAR2(300)                NOT NULL,
    received_time TIMESTAMP(6) DEFAULT SYSDATE NOT NULL,
    shortcode     VARCHAR2(15)                 NOT NULL,
    retries       NUMBER(2)                    NOT NULL,
    description   VARCHAR2(100)
)
/

INSERT INTO ap_param
VALUES ('DATA', 'SRV_NAME', 'BDATASPONSOR1', 'Ten dich vu DATA');
INSERT INTO ap_param
VALUES ('DATA_ADDON', 'SRV_NAME', 'BDATASPONSOR2', 'Ten dich vu DATA_ADDON');
COMMIT;



CREATE TABLE lock_object
(
    locked_object VARCHAR2(50) NOT NULL,
    issue_date    DATE         NOT NULL,
    count         NUMBER(1)    NOT NULL,
    type          VARCHAR2(1)  NOT NULL,
    CONSTRAINT lock_object_uk
        UNIQUE (locked_object, issue_date)
)
/

COMMENT ON COLUMN lock_object.locked_object IS 'Khoa so thue bao (ISDN) hoac API user'
/

COMMENT ON COLUMN lock_object.type IS '0: isdn; 1: api_user'
/


CREATE VIEW dsp_owner.v_company AS
SELECT com_id,
       com_name,
       tax_code,
       bus_code,
       address,
       vas_mobile,
       representative,
       rep_phone,
       rep_mobile,
       rep_position,
       email,
       public_key,
       updated_key,
       user_id,
       parent_id,
       status,
       description,
       type,
       province,
       city,
       district,
       ward,
       file_path,
       cps_mobile,
       serial_prefix,
       api_public_key,
       api_updated_key,
       api_user_id,
       group_id,
       api_group_id,
       bhtt_code,
       check_date,
       bk_check_date,
       cust_type
FROM dsp_company
UNION ALL
SELECT com_id,
       com_name,
       tax_code,
       bus_code,
       address,
       cps_mobile         vas_mobile,
       rep_name           representative,
       NULL               rep_phone,
       rep_mobile,
       rep_position,
       email,
       public_key,
       public_key_upt     updated_key,
       web_user_id        user_id,
       parent_id,
       status,
       description,
       NVL(comp_level, 0) type,
       province,
       city,
       district,
       ward,
       file_path,
       cps_mobile,
       NULL               serial_prefix,
       NULL               api_public_key,
       NULL               api_updated_key,
       api_user_id,
       NULL               group_id,
       NULL               api_group_id,
       NULL               bhtt_code,
       NULL               check_date,
       NULL               bk_check_date,
       '3'                cust_type
FROM icccds_owner.company;

CREATE OR REPLACE PROCEDURE dsp_owner.forward_icccds_mo(p_request_id NUMBER, p_isdn VARCHAR2, p_content VARCHAR2,
                                                        p_shortcode VARCHAR2, p_retries NUMBER)
    IS
BEGIN
    INSERT INTO icccds_owner.mo_queue VALUES (p_request_id, p_isdn, p_content, SYSDATE, p_shortcode, p_retries);
    COMMIT;
END;
/

--20230905

CREATE SEQUENCE icccds_owner.mbf30_file_seq
    NOCACHE
/

ALTER TABLE orders ADD file_id_list varchar2(500);

CREATE TABLE mbf30_file
(
    file_id        NUMBER(10)              NOT NULL,
    file_name      VARCHAR2(1000),
    com_id         NUMBER(10)              NOT NULL
        CONSTRAINT mbf30_file_fk
            REFERENCES icccds_owner.company,
    profile_id     NUMBER(10),
    profile_code   VARCHAR2(20)            NOT NULL,
    total          NUMBER(10)              NOT NULL,
    issue_datetime DATE        DEFAULT SYSDATE,
    status         VARCHAR2(1) DEFAULT '0' NOT NULL
        CONSTRAINT "MBF30_FILE_fk2"
            REFERENCES icccds_owner.profile,
    CONSTRAINT mbf30_file_pk
        PRIMARY KEY (file_id, com_id, profile_code)
)
/

COMMENT ON COLUMN mbf30_file.status IS '0: Chua xu ly, 1: Da tao don thanh cong'
/


CREATE TABLE mbf30_file_dtl
(
    file_id        number(10)     NOT NULL,
    isdn           varchar2(20)
        CONSTRAINT isdn_uk UNIQUE NOT NULL,
    com_id         number(10)     NOT NULL
        CONSTRAINT mbf30_file_dtl_fk
            REFERENCES icccds_owner.company,
    profile_code   varchar2(20)   NOT NULL,
    issue_datetime date DEFAULT SYSDATE
);

ALTER TABLE mbf30_file
    DROP PRIMARY KEY
/

ALTER TABLE mbf30_file
    ADD CONSTRAINT mbf30_file_pk
        PRIMARY KEY (file_id, com_id, profile_code)
/







