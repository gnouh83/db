-- jdbc:oracle:thin:@10.3.15.63:1521:datacode
ALTER TABLE DSP_COMPANY ADD DEBT_AMOUNT NUMBER(15);
/

ALTER TABLE VOUCHER_PROFILE ADD SERVICE_CODE VARCHAR2(2);
/

INSERT INTO AP_PARAM(PAR_TYPE, PAR_NAME, PAR_VALUE, DESCRIPTION) VALUES ('SRV_CODE', 'DataCode', '1', 'Datacode');
INSERT INTO AP_PARAM(PAR_TYPE, PAR_NAME, PAR_VALUE, DESCRIPTION) VALUES ('SRV_CODE', 'MobiEdu', '2', 'MobiEdu');
INSERT INTO AP_PARAM(PAR_TYPE, PAR_NAME, PAR_VALUE, DESCRIPTION) VALUES ('SRV_CODE', 'ClipTV', '3', 'ClipTV');
INSERT INTO AP_PARAM(PAR_TYPE, PAR_NAME, PAR_VALUE, DESCRIPTION) VALUES ('SRV_CODE', 'MobiOn', '4', 'MobiOn');

create table DSP_SERVICE
(
    SERVICE_ID   NUMBER(10)   not null
        constraint PK_DSP_SERVICE
            primary key,
    SERVICE_NAME VARCHAR2(50) not null,
    STATUS       VARCHAR2(1)  not null,
    SERVICE_CODE VARCHAR2(10) not null,
    MANAGER VARCHAR2(50) not null,
    DESCRIPTION  VARCHAR2(100)
)
/

CREATE SEQUENCE DSP_SERVICE_SEQ
    START WITH     1
    INCREMENT BY   1
    NOCACHE
    NOCYCLE;
commit;

-- Update tiến trình tổng hợp bảng voucher_statistic (Mobifone DC Service-01 63- port 8338)
SELECT SYSDATE stat_date,
       a.service_id,
       v.order_id,
       v.status,
       COUNT (1) total
FROM voucher v, dsp_service a, voucher_profile b
WHERE a.service_id = b.service_id AND b.profile_code = v.profile_code
GROUP BY a.service_id, order_id, v.status;
-- end

-- test
create table VOUCHER_STATISTIC
(
    STAT_DATE DATE,
    ORDER_ID  NUMBER(10),
    STATUS    NUMBER(2),
    TOTAL     NUMBER
)
/
--