SELECT *
FROM dsp_company;
SELECT *
FROM dsp_sms_command
ORDER BY cmd_id;

SELECT *
FROM dsp_sys_log
WHERE exec_datetime >= trunc(sysdate)
  and TRANS_ID = 'vmedia_api_com_1670474904633'
ORDER BY log_id;

SELECT *
FROM dsp_sys_log
WHERE exec_datetime >= TO_DATE('24/06/2023', 'dd/mm/yyyy')
  and exec_datetime < TO_DATE('24/06/2023', 'dd/mm/yyyy') + 1
  AND ISDN = '936707038'
  and REQUEST like '%020000010582948%'
ORDER BY log_id;

select *
from DSP_MT_HISTORY where ISDN='84936707038' and PROCESS_TIME>=TO_DATE('24/06/2023', 'dd/mm/yyyy');

select *
from DSP_MO_HISTORY where isdn='936707038';

--The da nap
SELECT b.card_name, SUM(b.amount) AS amount, c.price, c.cap_max, a.res_order_id
FROM dsp_transaction a,
     dsp_dc_detail b,
     dsp_service_price c
WHERE a.transaction_id = b.transaction_id
  AND b.price_id = c.price_id
  AND a.request_time >= TO_DATE('16/01/2022', 'dd/mm/yyyy')
  AND a.request_time <= TO_DATE('30/04/2022', 'dd/mm/yyyy')
  AND a.status IN (3, 6)
GROUP BY b.card_name, c.price, c.cap_max, a.res_order_id
ORDER BY b.card_name
;
--The da mua theo dai ly
CREATE TABLE temp_comp_20220906 AS
SELECT d.com_name,
       b.card_name,
       SUM(b.amount)           AS amount,
       c.price,
       c.cap_max,
       SUM(b.amount) * c.price AS total,
       a.res_order_id
FROM dsp_transaction a,
     dsp_dc_detail b,
     dsp_service_price c,
     dsp_company d
WHERE a.transaction_id = b.transaction_id
  AND b.price_id = c.price_id
  AND a.com_id = d.com_id
  AND a.request_time >= TO_DATE('16/01/2022', 'dd/mm/yyyy')
  AND a.request_time <= TO_DATE('30/04/2022', 'dd/mm/yyyy')
  AND a.status IN (3, 6)
GROUP BY d.com_name, b.card_name, c.price, c.cap_max, a.res_order_id
ORDER BY d.com_name, b.card_name
;
SELECT *
FROM dsp_transaction;
SELECT *
FROM dsp_dc_detail;
SELECT *
FROM temp_20220905;
SELECT *
FROM dsp_service_price
WHERE tab_id = 261;
SELECT *
FROM dsp_service_price_tab
WHERE tab_id = 261;

SELECT *
FROM api;


ALTER TABLE dsp_cps_queue
    MODIFY (status NUMBER(1) DEFAULT 0 NOT NULL);


SELECT *
FROM dsp_mt_history
WHERE sent_time > TO_DATE('06/09/2022 12:17:00', 'dd/mm/yyyy hh24:mi:ss');

SELECT *
FROM dsp_mo_history
WHERE received_time > TRUNC(SYSDATE);

SELECT *
FROM dsp_cps_queue;
SELECT *
FROM dsp_cps_queue_split;


INSERT INTO dsp_owner.dsp_cps_queue_split (transaction_id, vas_mobile, request_time, status, retries, amount,
                                           description, result, request_id, req_no)
VALUES (1, '899507964', SYSDATE, 0, 3, 1, NULL, NULL,
        '63', 1);

COMMIT;


SELECT request_id, transaction_id, vas_mobile, amount, NVL(retries, 3) retries, request_time, req_no
FROM dsp_cps_queue_split
WHERE status = '0'
  AND NVL(retries, 3) > 0;


SELECT *
FROM dsp_order_policy_tab;

UPDATE dsp_order_policy_tab
SET cust_type = '0'
WHERE def = 1;
COMMIT;

SELECT *
FROM temp_comp_20220906;

SELECT *
FROM DSP_COMPANY;

SELECT bus_code, email, public_key, get_serial_prefix(com_id) serial_prefix, user_id
FROM dsp_company
WHERE com_id = 881
  AND com_name = 'COM_LOYALTY';


SELECT *
FROM dsp_company
WHERE com_id = 881;

SELECT *
FROM DSP_SMS_COMMAND
WHERE CMD_CODE = 'LOYALTY';

SELECT *
FROM DSP_MT_HISTORY
WHERE ISDN = '84937122801'
  AND SENT_TIME >= TO_DATE('09/10/2022', 'dd/mm/yyyy');


SELECT *
FROM DSP_SYS_LOG
ORDER BY LOG_ID DESC;

SELECT *
FROM DSP_MO_QUEUE;

SELECT *
FROM DSP_MO_HISTORY
WHERE ISDN = '937122801'
  AND RECEIVED_TIME >= TO_DATE('09/10/2022', 'dd/mm/yyyy')
ORDER BY REQUEST_ID DESC;
--987433123


/*
insert into  DSP_MO_QUEUE values (1,'936009977',null,'TRACUU 000000000004328',sysdate,'9999','3');
commit;*/
INSERT INTO DSP_OWNER.DSP_SMS_COMMAND (CMD_ID, CMD_CODE, CMD_TYPE, CMD_MSG_CONTENT, CMD_PARAM_COUNT, DESCRIPTION,
                                       CMD_REGEX, STATUS)
VALUES (71, 'DK_EDU_F2', 'O',
        'Đăng ký không thành công dịch vụ, thuê bao đã có gói cước. Chi tiết liên hệ 9090. Xin cảm ơn!', 0,
        'Đăng ký không thành công dịch vụ, thuê bao đã có gói cước. Chi tiết liên hệ 9090. Xin cảm ơn!', NULL, '1');


INSERT INTO DSP_MO_QUEUE
VALUES (1, '906045666', '', 'EDU MA3309682438120', SYSDATE, '9999', '3');
COMMIT;

SELECT *
FROM dsp_transaction;



WITH rpt_dc_order_summary AS (SELECT order_code,
                                     cre_dat,
                                     order_id,
                                     addon,
                                     profile_code,
                                     total,
                                     SUM(used_in_period)    used_in_period,
                                     MIN(used)              used,
                                     MIN(not_yet)           not_yet,
                                     SUM(expired_in_period) expired_in_period
                              FROM rpt_dc_order_summary_daily
                              WHERE sum_dat >= TO_DATE('01/01/2022', 'dd/mm/yyyy')
                                AND sum_dat < TO_DATE('10/10/2022', 'dd/mm/yyyy') + 1
                              GROUP BY order_code, cre_dat, order_id, addon, profile_code, total
                              ORDER BY order_id, profile_code)
SELECT *
FROM (SELECT dt.com_name                                 DOANH_NGHIEP,
             TO_CHAR(t.transaction_id)                   MA_ORDER,
             s.service_name,
             o.profile_code,
             p.price                                     PRICE,
             o.used_in_period,
             p.price * o.used_in_period                  TOT_USED,
             o.expired_in_period,
             p.price * o.expired_in_period               TOT_EXPIRED,
             p.price * (o.not_yet - o.expired_in_period) TOT_REMAIN,
             p.price * (o.total - o.used)                TOT_START,
             o.not_yet
      FROM dsp_transaction t,
           dsp_company_leveled dt,
           rpt_dc_order_summary o,
           dsp_service_price p,
           dsp_service s
      WHERE t.com_id = dt.com_id
        AND t.status = 6
        AND o.order_code = t.res_order_id
        AND p.tab_id = t.tab_id
        AND p.name = o.profile_code
        AND s.service_id = t.service_id
        AND dt.top_id = 542
        AND o.order_id IN (SELECT DISTINCT order_id
                           FROM rpt_dc_order_summary
                           WHERE (expired_in_period > 0 OR used_in_period > 0))
      UNION ALL
      SELECT dt.com_name        DOANH_NGHIEP,
             'API'              MA_ORDER,
             s.service_name     DICH_VU,
             h.profile          PROFILE,
             sp.price           DON_GIA,
             SUM(amount) / 1024 SAN_LUONG,
             SUM(h.req_cost)    THANH_TIEN,
             0,
             0,
             0,
             0,
             0
      FROM dsp_dd_history h,
           dsp_service_price sp,
           dsp_service_price_tab st,
           dsp_service s,
           dsp_order o,
           dsp_company_leveled dt
      WHERE h.status = 1
        AND h.price_tab_id = sp.tab_id
        AND sp.tab_id = st.tab_id
        AND st.service_id = s.service_id
        AND h.profile = sp.name
        AND h.profile IS NOT NULL
        AND h.order_id = o.order_id
        AND o.com_id = dt.com_id
        AND h.request_time >= TO_DATE('01/01/2022', 'dd/mm/yyyy')
        AND h.request_time < TO_DATE('10/10/2022', 'dd/mm/yyyy') + 1
        AND dt.top_id = 542
      GROUP BY dt.com_name, s.service_name, h.profile, sp.price)
ORDER BY DOANH_NGHIEP, MA_ORDER, profile_code, PRICE;

SELECT *
FROM dsp_company_leveled;

SELECT order_code,
       cre_dat,
       order_id,
       addon,
       profile_code,
       total,
       SUM(used_in_period)    used_in_period,
       MIN(used)              used,
       MIN(not_yet)           not_yet,
       SUM(expired_in_period) expired_in_period
FROM rpt_dc_order_summary_daily
WHERE sum_dat >= TO_DATE('01/01/2022', 'dd/mm/yyyy')
  AND sum_dat < TO_DATE('10/10/2022', 'dd/mm/yyyy') + 1
  AND ORDER_CODE = 'dO5SVIExyM93asUvzmJNvQxtPFc='
GROUP BY order_code, cre_dat, order_id, addon, profile_code, total
ORDER BY order_id, profile_code;

SELECT *
FROM dsp_transaction
WHERE TRANSACTION_ID = 922;


SELECT *
FROM RPT_DC_ORDER_SUMMARY_DAILY
WHERE ORDER_CODE = 'iLYWi+y7rU+VzyWz9db9QTzWvDM='
ORDER BY SUM_DAT;
--SUM_DAT,ORDER_ID,ORDER_CODE,CRE_DAT,ADDON,PROFILE_CODE,TOTAL,USED_IN_PERIOD,USED,NOT_YET,EXPIRED_IN_PERIOD

SELECT *
FROM RPT_DC_ORDER_SUMMARY_DAILY
WHERE TOTAL = EXPIRED_IN_PERIOD;

UPDATE RPT_DC_ORDER_SUMMARY_DAILY
SET EXPIRED_IN_PERIOD=NOT_YET
WHERE TOTAL = EXPIRED_IN_PERIOD;
COMMIT;

SELECT *
FROM API;



SELECT o.com_id,
       o.ORDER_ID,
       CASE
           WHEN o.order_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy') THEN NVL(o.contract_value, 0)
           ELSE NVL(ol.remain_value, 0)
           END               start_value,
       NVL(u.amount_used, 0) used_value,
       CASE
           WHEN o.expire_time < TO_DATE('10/04/2022', 'dd/mm/yyyy') THEN NVL(o.remain_value, 0)
           ELSE 0
           END               expired_value,
       CASE
           WHEN o.order_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy') THEN NVL(o.contract_value, 0)
           ELSE NVL(ol.remain_value, 0)
           END - NVL(u.amount_used, 0) - CASE
                                             WHEN o.expire_time < TO_DATE('10/04/2022', 'dd/mm/yyyy')
                                                 THEN NVL(o.remain_value, 0)
                                             ELSE 0
           END               remain_value,
       TO_DATE('09/04/2022', 'dd/mm/yyyy')
FROM dsp_order o,
     (SELECT * FROM TMP_RPT_ORDER_SUMMARY_DAILY WHERE sum_date = TO_DATE('09/04/2022', 'dd/mm/yyyy') - 1) ol,
     (SELECT order_id, SUM(NVL(ot.amount, 0)) amount_used
      FROM dsp_order_transaction ot,
           dsp_transaction t
      WHERE ot.transaction_id = t.transaction_id
        AND t.status = 6
        AND ot.issue_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy')
        AND ot.issue_time < TO_DATE('10/04/2022', 'dd/mm/yyyy')
      GROUP BY ot.ORDER_ID) u
WHERE o.order_id = ol.order_id(+)
  AND o.ORDER_ID = u.ORDER_ID(+)
  AND TRUNC(o.order_time) < TO_DATE('10/04/2022', 'dd/mm/yyyy')
  AND o.expire_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy');


CREATE TABLE RPT_ORDER_SUMMARY_DAILY_BAK AS
SELECT *
FROM RPT_ORDER_SUMMARY_DAILY
ORDER BY SUM_DATE;


SELECT *
FROM RPT_ORDER_SUMMARY_DAILY
WHERE REMAIN_VALUE < 0;

DECLARE
    dfrom date;
    dtill date;
    day   date;
BEGIN
    dfrom := TO_DATE('01.12.2021', 'dd.mm.yyyy');
    dtill := TO_DATE('31.03.2022', 'dd.mm.yyyy');
    day := dfrom;

    WHILE day <= dtill
        LOOP
            DBMS_OUTPUT.PUT_LINE(day);
            summary_order_daily(day);
            day := day + 1;
        END LOOP;
END;
/
begin
    SUMMARY_ORDER_MONTHLY(to_date('01/12/2021', 'dd/mm/yyyy'));
    SUMMARY_ORDER_MONTHLY(to_date('01/01/2022', 'dd/mm/yyyy'));
    SUMMARY_ORDER_MONTHLY(to_date('01/02/2022', 'dd/mm/yyyy'));
    SUMMARY_ORDER_MONTHLY(to_date('01/03/2022', 'dd/mm/yyyy'));
    DBMS_OUTPUT.PUT_LINE('Done!');
end;


SELECT *
FROM RPT_ORDER_SUMMARY_DAILY
WHERE REMAIN_VALUE < 0;
SELECT *
FROM TMP_2_RPT_ORDER_SUMMARY_DAILY
WHERE REMAIN_VALUE < 0
ORDER BY SUM_DATE;

SELECT *
FROM DSP_ORDER
WHERE ORDER_ID = 745
ORDER BY ORDER_TIME;

SELECT *
FROM DSP_ORDER_TRANSACTION
WHERE TRANSACTION_ID = 1520;

SELECT *
FROM DSP_TRANSACTION
ORDER BY REQUEST_TIME DESC;
SELECT *
FROM DSP_TRANSACTION
WHERE TRANSACTION_ID = 1520;
SELECT *
FROM DSP_DD_DETAIL
WHERE TRANSACTION_ID = 1520;
SELECT *
FROM DSP_DD_HISTORY
WHERE TRANSACTION_ID = '1520';

SELECT 87110 - 6445
FROM DUAL;


SELECT *
FROM DSP_LOCK
WHERE type = '1'
  AND LOCKED_OBJECT = 'ct2_mpl_api';

DELETE DSP_LOCK
WHERE LOCKED_OBJECT = 'ct2_mpl_api'
  AND ISSUE_DATE = TRUNC(SYSDATE);
COMMIT;

SELECT *
FROM DSP_SYS_LOG
WHERE EXEC_DATETIME >= TRUNC(SYSDATE)
  AND TRANS_ID LIKE 'ct2_mpl_api%'
  AND REQUEST LIKE 'UseDCReqObj%'
  AND STATUS = '0';
--and REQUEST like '%020000007108057%';

SELECT *
FROM DSP_TRANSACTION
WHERE TRANSACTION_ID = 2449;

SELECT TABLE_NAME,
       COLUMN_NAME,
       DATA_TYPE || '(' || DECODE(DATA_TYPE, 'NUMBER', DATA_PRECISION, DATA_LENGTH) || ')' DATA_LENGTH,
       DECODE(NULLABLE, 'N', 'Y', 'N')                                                     mandatory
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME LIKE 'DIP_REQUEST_HIST%';

SELECT *
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = '2.7.2.21	DIP_REQUEST_HIST_QUEUE';
SELECT *
FROM USER_CONSTRAINTS a,
     USER_CONS_COLUMNS b
WHERE a.TABLE_NAME = 'DSP_TRANSACTION'
  AND a.CONSTRAINT_TYPE <> 'C'
  AND a.CONSTRAINT_NAME = b.CONSTRAINT_NAME;

SELECT *
FROM DSP_SYS_LOG;
SELECT *
FROM USER_TAB_COLUMNS;
SELECT *
FROM DSP_COM_ORDER_POL;

SELECT *
FROM DSP_TRANSACTION
WHERE TRANSACTION_ID = 2480;

SELECT *
FROM DSP_MO_QUEUE_20220627;
SELECT *
FROM USER_TABLES
ORDER BY TABLE_NAME;

SELECT *
FROM DSP_MO_HISTORY
WHERE RECEIVED_TIME >= TRUNC(SYSDATE - 3)
  AND CONTENT = 'DK DC N49724941953902';
SELECT *
FROM DSP_MT_HISTORY
WHERE ISDN = '84765519351'
  AND SENT_TIME >= TRUNC(SYSDATE - 3);

SELECT *
FROM DSP_SYS_LOG
WHERE REQUEST LIKE '%%';

--UseDCResObj{transaction_id='10207', code='0', description='null', serial='230000000004746', transaction_id='10207', dat_amt=0, dat_day=180, order_code='mAUBRea2e35g390EYAclsmNffzU=', reseller='100000000241', profile_code='6MA30'}


SELECT *
FROM DSP_ORDER_TRANSACTION;
SELECT *
FROM dip_sub_service
WHERE isdn = '918861983'
ORDER BY END_TIME DESC;
--931040211;

SELECT *
FROM DSP_MO_QUEUE;
SELECT *
FROM DSP_MO_HISTORY
ORDER BY RECEIVED_TIME DESC;

INSERT INTO DSP_MO_QUEUE
VALUES (1, '918861983', '', 'KT IP', SYSDATE, '9034', '3');
COMMIT;

SELECT DISTINCT a.package_id,
                a.service_id,
                TO_CHAR(a.start_time, 'dd/MM/yyyy HH24:mi:ss') AS start_time,
                b.channel,
                b.user_id,
                TO_CHAR(a.end_time, 'dd/MM/yyyy HH24:mi:ss')   AS end_time,
                a.initial_amount,
                a.active_day
FROM dip_sub_service a,
     dip_request_hist b,
     dip_package c
WHERE a.package_id = c.package_id
  AND b.package_code = c.package_code
  AND a.isdn = '918861983'
  AND a.end_time > SYSDATE
  AND a.isdn = b.isdn
  AND b.status = 1;

SELECT *
FROM dip_request_hist
WHERE isdn = '918861983';
SELECT *
FROM dip_package;
SELECT *
FROM DSP_MT_QUEUE
ORDER BY PROCESS_TIME DESC;

SELECT *
FROM DIG_SUB_SERVICE;

INSERT INTO DSP_OWNER.DSP_MO_QUEUE
VALUES (112, '918861983', NULL, 'EDU M01667289556902', SYSDATE, '9034', 3);
COMMIT;

SELECT LISTAGG(b.order_id, ';') WITHIN GROUP (ORDER BY b.order_id) store_id
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.transaction_id = b.transaction_id
  AND a.res_order_id = 'ruTsQGKTOcsOhKk6Phg7/er6KSo=';


SELECT *
FROM DSP_TRANSACTION
WHERE TRANSACTION_ID IN (SELECT TRANSACTION_ID FROM DSP_ORDER_TRANSACTION GROUP BY TRANSACTION_ID HAVING COUNT(1) > 1)
  AND RES_ORDER_ID IS NOT NULL;

SELECT *
FROM DSP_ORDER_TRANSACTION
WHERE TRANSACTION_ID = 1293;

SELECT *
FROM DSP_TRANSACTION
WHERE RES_ORDER_ID = 'ruTsQGKTOcsOhKk6Phg7/er6KSo=';

SELECT *
from API_REQUEST
ORDER BY REQ_TIME desc;


SELECT u.user_id, u.user_name, u.password, u.expire_status, u.modified_password, c.api_public_key
FROM am_user u,
     am_group_user ug,
     am_group g,
     dsp_company c
WHERE u.user_id = ug.user_id
  AND ug.GROUP_ID = g.GROUP_ID
  AND u.user_id = c.api_user_id
  AND c.api_public_key IS NOT NULL
  AND g.GROUP_ID IN (SELECT par_value
                     FROM ap_param
                     WHERE par_name = 'API_GROUP_ID'
                       AND par_type = 'SYSTEM')
  AND NVL(g.status, 1) > 0
  AND NVL(u.status, 1) > 0
order by u.USER_NAME;

select *
from DSP_COMPANY
where COM_ID = 621;
SELECT *
from DIP_REQUEST_HIST
ORDER BY REQUEST_TIME desc;

select *
from DSP_DD_HISTORY;

select *
from DSP_SMS_COMMAND
where CMD_CODE = 'CMD_DK_DIP_OK';
alter TABLE DIP_REQUEST_HIST
    ADD ORDER_ID NUMBER(15);
select *
from dip_sub_service;


SELECT MAX((100 - ROUND((NVL(b.bytes_free, 0) / a.bytes_alloc) * 100, 2)))
FROM (SELECT f.tablespace_name,
             SUM(f.bytes)                                                    bytes_alloc,
             SUM(DECODE(f.autoextensible, 'YES', f.maxbytes, 'NO', f.bytes)) maxbytes,
             COUNT(1)                                                        datafiles
      FROM dba_data_files f
      GROUP BY tablespace_name) a,
     (SELECT f.tablespace_name,
             SUM(f.bytes) bytes_free
      FROM dba_free_space f
      GROUP BY tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name(+)
  AND a.tablespace_name = 'DATA';

SELECT *
from API_REQUEST
order by REQ_ID desc;


select *
from DSP_SYS_LOG
where EXEC_DATETIME > trunc(sysdate)
  and TRANS_ID = 'vmedia_api_com_1670224040163';