SELECT * FROM v$version;
 select open_mode, controlfile_type from v$database;
SELECT dest_id, database_mode, recovery_mode, protection_mode FROM v$archive_dest_status WHERE destination IS NOT NULL;
SELECT log_mode FROM v$database;
SELECT *
FROM dsp_loyalty ORDER BY loyalty_id DESC ;

SELECT *
FROM ap_param where par_type='LOYALTY_COMPANY';

SELECT *
FROM api_request;


SELECT *
FROM dba_data_files where tablespace_name ='DATA';


--ALTER TABLESPACE indx200801  ADD DATAFILE '/u03/app/oracle/oradata/bill/indx200801_04.dbf' SIZE 16GB;

ALTER TABLESPACE DATA ADD DATAFILE '+DATA/dsp/datafile/data.296' size 16G AUTOEXTEND OFF;
ALTER TABLESPACE DATA ADD DATAFILE '+DATA/dsp/datafile/data.297' size 16G AUTOEXTEND OFF;
ALTER TABLESPACE DATA ADD DATAFILE '+DATA/dsp/datafile/data.298' size 16G AUTOEXTEND OFF;
ALTER TABLESPACE DATA ADD DATAFILE '+DATA/dsp/datafile/data.299' size 16G AUTOEXTEND OFF;


select name,total_mb,free_mb,free_mb/total_mb*100 "%Free space" from v$asm_diskgroup;
------------------------------------------------------------------------------------------------------------------------
SELECT *
FROM dsp_company;
SELECT *
FROM dsp_sms_command
ORDER BY cmd_id;

SELECT *
FROM dsp_sys_log
WHERE exec_datetime >= TRUNC(SYSDATE)
  AND trans_id = 'vmedia_api_com_1670474904633'
ORDER BY log_id;

SELECT *
FROM dsp_sys_log
WHERE exec_datetime >= TO_DATE('24/06/2023', 'dd/mm/yyyy')
  AND exec_datetime < TO_DATE('24/06/2023', 'dd/mm/yyyy') + 1
  AND isdn = '936707038'
  AND request LIKE '%020000010582948%'
ORDER BY log_id;

SELECT *
FROM dsp_mt_history
WHERE isdn = '84936707038'
  AND process_time >= TO_DATE('24/06/2023', 'dd/mm/yyyy');

SELECT *
FROM dsp_mo_history
WHERE isdn = '936707038';

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
FROM dsp_company;

SELECT bus_code, email, public_key, get_serial_prefix(com_id) serial_prefix, user_id
FROM dsp_company
WHERE com_id = 881
  AND com_name = 'COM_LOYALTY';


SELECT *
FROM dsp_company
WHERE com_id = 881;

SELECT *
FROM dsp_sms_command
WHERE cmd_code = 'LOYALTY';

SELECT *
FROM dsp_mt_history
WHERE isdn = '84937122801'
  AND sent_time >= TO_DATE('09/10/2022', 'dd/mm/yyyy');


SELECT *
FROM dsp_sys_log
ORDER BY log_id DESC;

SELECT *
FROM dsp_mo_queue;

SELECT *
FROM dsp_mo_history
WHERE isdn = '937122801'
  AND received_time >= TO_DATE('09/10/2022', 'dd/mm/yyyy')
ORDER BY request_id DESC;
--987433123


/*
insert into  DSP_MO_QUEUE values (1,'936009977',null,'TRACUU 000000000004328',sysdate,'9999','3');
commit;*/
INSERT INTO dsp_owner.dsp_sms_command (cmd_id, cmd_code, cmd_type, cmd_msg_content, cmd_param_count, description,
                                       cmd_regex, status)
VALUES (71, 'DK_EDU_F2', 'O',
        'Đăng ký không thành công dịch vụ, thuê bao đã có gói cước. Chi tiết liên hệ 9090. Xin cảm ơn!', 0,
        'Đăng ký không thành công dịch vụ, thuê bao đã có gói cước. Chi tiết liên hệ 9090. Xin cảm ơn!', NULL, '1');


INSERT INTO dsp_mo_queue
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
FROM (SELECT dt.com_name                                 doanh_nghiep,
             TO_CHAR(t.transaction_id)                   ma_order,
             s.service_name,
             o.profile_code,
             p.price                                     price,
             o.used_in_period,
             p.price * o.used_in_period                  tot_used,
             o.expired_in_period,
             p.price * o.expired_in_period               tot_expired,
             p.price * (o.not_yet - o.expired_in_period) tot_remain,
             p.price * (o.total - o.used)                tot_start,
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
      SELECT dt.com_name        doanh_nghiep,
             'API'              ma_order,
             s.service_name     dich_vu,
             h.profile          profile,
             sp.price           don_gia,
             SUM(amount) / 1024 san_luong,
             SUM(h.req_cost)    thanh_tien,
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
ORDER BY doanh_nghiep, ma_order, profile_code, price;

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
  AND order_code = 'dO5SVIExyM93asUvzmJNvQxtPFc='
GROUP BY order_code, cre_dat, order_id, addon, profile_code, total
ORDER BY order_id, profile_code;

SELECT *
FROM dsp_transaction
WHERE transaction_id = 922;


SELECT *
FROM rpt_dc_order_summary_daily
WHERE order_code = 'iLYWi+y7rU+VzyWz9db9QTzWvDM='
ORDER BY sum_dat;
--SUM_DAT,ORDER_ID,ORDER_CODE,CRE_DAT,ADDON,PROFILE_CODE,TOTAL,USED_IN_PERIOD,USED,NOT_YET,EXPIRED_IN_PERIOD

SELECT *
FROM rpt_dc_order_summary_daily
WHERE total = expired_in_period;

UPDATE rpt_dc_order_summary_daily
SET expired_in_period=not_yet
WHERE total = expired_in_period;
COMMIT;

SELECT *
FROM api;



SELECT o.com_id,
       o.order_id,
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
     (SELECT * FROM tmp_rpt_order_summary_daily WHERE sum_date = TO_DATE('09/04/2022', 'dd/mm/yyyy') - 1) ol,
     (SELECT order_id, SUM(NVL(ot.amount, 0)) amount_used
      FROM dsp_order_transaction ot,
           dsp_transaction t
      WHERE ot.transaction_id = t.transaction_id
        AND t.status = 6
        AND ot.issue_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy')
        AND ot.issue_time < TO_DATE('10/04/2022', 'dd/mm/yyyy')
      GROUP BY ot.order_id) u
WHERE o.order_id = ol.order_id(+)
  AND o.order_id = u.order_id(+)
  AND TRUNC(o.order_time) < TO_DATE('10/04/2022', 'dd/mm/yyyy')
  AND o.expire_time >= TO_DATE('09/04/2022', 'dd/mm/yyyy');


CREATE TABLE rpt_order_summary_daily_bak AS
SELECT *
FROM rpt_order_summary_daily
ORDER BY sum_date;


SELECT *
FROM rpt_order_summary_daily
WHERE remain_value < 0;

DECLARE
    dfrom    date;
    dtill    date;
    sum_date date;
BEGIN
    dfrom := TO_DATE('01.12.2021', 'dd.mm.yyyy');
    dtill := TO_DATE('31.03.2022', 'dd.mm.yyyy');
    sum_date := dfrom;

    WHILE sum_date <= dtill
        LOOP
            summary_order_daily(p_sum_day => sum_date);
            dbms_output.put_line(sum_date);
            sum_date := sum_date + 1;
        END LOOP;
END;
/
BEGIN
    summary_order_monthly(TO_DATE('01/09/2023', 'dd/mm/yyyy'));
    summary_order_monthly(TO_DATE('01/07/2023', 'dd/mm/yyyy'));
    summary_order_monthly(TO_DATE('01/08/2023', 'dd/mm/yyyy'));
    dbms_output.put_line('Done!');
END;


SELECT *
FROM rpt_order_summary_daily
WHERE remain_value < 0;
SELECT *
FROM tmp_2_rpt_order_summary_daily
WHERE remain_value < 0
ORDER BY sum_date;

SELECT *
FROM dsp_order
WHERE order_id = 745
ORDER BY order_time;

SELECT *
FROM dsp_order_transaction
WHERE transaction_id = 1520;

SELECT *
FROM dsp_transaction
ORDER BY request_time DESC;
SELECT *
FROM dsp_transaction
WHERE transaction_id = 1520;
SELECT *
FROM dsp_dd_detail
WHERE transaction_id = 1520;
SELECT *
FROM dsp_dd_history
WHERE transaction_id = '1520';

SELECT 87110 - 6445
FROM dual;


SELECT *
FROM dsp_lock
WHERE type = '1'
  AND locked_object = 'ct2_mpl_api';

DELETE dsp_lock
WHERE locked_object = 'ct2_mpl_api'
  AND issue_date = TRUNC(SYSDATE);
COMMIT;

SELECT *
FROM dsp_sys_log
WHERE exec_datetime >= TRUNC(SYSDATE)
  AND trans_id LIKE 'ct2_mpl_api%'
  AND request LIKE 'UseDCReqObj%'
  AND status = '0';
--and REQUEST like '%020000007108057%';

SELECT *
FROM dsp_transaction
WHERE transaction_id = 2449;

SELECT table_name,
       column_name,
       data_type || '(' || DECODE(data_type, 'NUMBER', data_precision, data_length) || ')' data_length,
       DECODE(nullable, 'N', 'Y', 'N')                                                     mandatory
FROM user_tab_columns
WHERE table_name LIKE 'DIP_REQUEST_HIST%';

SELECT *
FROM user_tab_columns
WHERE table_name = '2.7.2.21	DIP_REQUEST_HIST_QUEUE';
SELECT *
FROM user_constraints a,
     user_cons_columns b
WHERE a.table_name = 'DSP_TRANSACTION'
  AND a.constraint_type <> 'C'
  AND a.constraint_name = b.constraint_name;

SELECT *
FROM dsp_sys_log;
SELECT *
FROM user_tab_columns;
SELECT *
FROM dsp_com_order_pol;

SELECT *
FROM dsp_transaction
WHERE transaction_id = 2480;

SELECT *
FROM dsp_mo_queue_20220627;
SELECT *
FROM user_tables
ORDER BY table_name;

SELECT *
FROM dsp_mo_history
WHERE received_time >= TRUNC(SYSDATE - 3)
  AND content = 'DK DC N49724941953902';
SELECT *
FROM dsp_mt_history
WHERE isdn = '84765519351'
  AND sent_time >= TRUNC(SYSDATE - 3);

SELECT *
FROM dsp_sys_log
WHERE request LIKE '%%';

--UseDCResObj{transaction_id='10207', code='0', description='null', serial='230000000004746', transaction_id='10207', dat_amt=0, dat_day=180, order_code='mAUBRea2e35g390EYAclsmNffzU=', reseller='100000000241', profile_code='6MA30'}


SELECT *
FROM dsp_order_transaction;
SELECT *
FROM dip_sub_service
WHERE isdn = '918861983'
ORDER BY end_time DESC;
--931040211;

SELECT *
FROM dsp_mo_queue;
SELECT *
FROM dsp_mo_history
ORDER BY received_time DESC;

INSERT INTO dsp_mo_queue
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
FROM dsp_mt_queue
ORDER BY process_time DESC;

SELECT *
FROM dig_sub_service;

INSERT INTO dsp_owner.dsp_mo_queue
VALUES (112, '918861983', NULL, 'EDU M01667289556902', SYSDATE, '9034', 3);
COMMIT;

SELECT LISTAGG(b.order_id, ';') WITHIN GROUP (ORDER BY b.order_id) store_id
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.transaction_id = b.transaction_id
  AND a.res_order_id = 'ruTsQGKTOcsOhKk6Phg7/er6KSo=';


SELECT *
FROM dsp_transaction
WHERE transaction_id IN (SELECT transaction_id FROM dsp_order_transaction GROUP BY transaction_id HAVING COUNT(1) > 1)
  AND res_order_id IS NOT NULL;

SELECT *
FROM dsp_order_transaction
WHERE transaction_id = 1293;

SELECT *
FROM dsp_transaction
WHERE res_order_id = 'ruTsQGKTOcsOhKk6Phg7/er6KSo=';

SELECT *
FROM api_request
ORDER BY req_time DESC;


SELECT u.user_id, u.user_name, u.password, u.expire_status, u.modified_password, c.api_public_key
FROM am_user u,
     am_group_user ug,
     am_group g,
     dsp_company c
WHERE u.user_id = ug.user_id
  AND ug.group_id = g.group_id
  AND u.user_id = c.api_user_id
  AND c.api_public_key IS NOT NULL
  AND g.group_id IN (SELECT par_value
                     FROM ap_param
                     WHERE par_name = 'API_GROUP_ID'
                       AND par_type = 'SYSTEM')
  AND NVL(g.status, 1) > 0
  AND NVL(u.status, 1) > 0
ORDER BY u.user_name;

SELECT *
FROM dsp_company
WHERE com_id = 621;
SELECT *
FROM dip_request_hist
ORDER BY request_time DESC;

SELECT *
FROM dsp_dd_history;

SELECT *
FROM dsp_sms_command
WHERE cmd_code = 'CMD_DK_DIP_OK';
ALTER TABLE dip_request_hist
    ADD order_id NUMBER(15);
SELECT *
FROM dip_sub_service;


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
FROM api_request
ORDER BY req_id DESC;


SELECT *
FROM dsp_sys_log
WHERE exec_datetime > TRUNC(SYSDATE)
  AND trans_id = 'vmedia_api_com_1670224040163';

SELECT *
FROM dsp_order
WHERE order_id = 2161;
SELECT SUM(amount)
FROM dsp_order_transaction
WHERE order_id = 2161;
SELECT *
FROM dsp_order_transaction
WHERE order_id = 2161;
SELECT SUM(b.amount)
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.transaction_id = b.transaction_id
  AND b.order_id = 2161
  AND a.status NOT IN 6;
SELECT *
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.transaction_id = b.transaction_id
  AND b.order_id = 2161
  AND a.status NOT IN 6;
-- 3497
-- 3498
-- 3499
-- 3500
SELECT *
FROM dsp_sys_log
WHERE exec_datetime > TO_DATE('11/07/2023', 'dd/mm/yyyy')
  AND request_id = '3498';

ALTER TABLE dsp_sys_log
    MODIFY reason VARCHAR2(100);

SELECT *
FROM dsp_transaction
ORDER BY transaction_id DESC;

SELECT *
FROM dsp_order
WHERE order_id IN (2223, 2281);


SELECT *
FROM dsp_order_transaction
WHERE transaction_id IN (3539, 3540);

SELECT *
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.status <> 6
  AND b.order_id = 2223
  AND a.transaction_id = b.transaction_id;


SELECT *
FROM dsp_order_transaction
WHERE order_id = 2223;

WITH user_type AS (SELECT type, user_id, com_id
                   FROM dsp_company_leveled
                   WHERE user_id = 1922
                      OR group_id IN (SELECT group_id FROM am_group_user WHERE user_id = 1922))
SELECT c.com_id, c.com_name, c.user_id
FROM dsp_company_leveled c,
     user_type
WHERE c.type IN (1)
  AND (user_type.type = 0
    OR (user_type.type = 1 AND c.com_id = user_type.com_id)
    );

SELECT *
FROM am_user
WHERE user_name = 'THUY.NN';

SELECT *
FROM am_group_user
WHERE user_id = 1922;

SELECT *
FROM am_group
WHERE group_id = 380;

SELECT *
FROM dsp_company_leveled
WHERE group_id = 380;


SELECT *
FROM dsp_company_leveled;

SELECT *
FROM dsp_company
ORDER BY com_name;


SELECT x.order_id, (contract_value - NVL(amount, 0) - NVL(req_cost, 0)) ton
FROM (SELECT order_id, contract_value
      FROM dsp_order
      WHERE order_time < TO_DATE('01/01/2022', 'dd/mm/yyyy')
      ORDER BY order_time) x
         LEFT OUTER JOIN
     (SELECT b.order_id, SUM(CASE WHEN b.success_amount IS NULL THEN b.amount ELSE b.success_amount END) amount
      FROM dsp_transaction a,
           dsp_order_transaction b
      WHERE a.transaction_id = b.transaction_id
        AND a.request_time < TO_DATE('01/01/2022', 'dd/mm/yyyy')
        AND b.issue_time < TO_DATE('01/01/2022', 'dd/mm/yyyy')
        AND status = 6
      GROUP BY b.order_id) y ON x.order_id = y.order_id
         LEFT OUTER JOIN (SELECT order_id, SUM(req_cost) req_cost
                          FROM dsp_dd_history
                          WHERE request_time < TO_DATE('01/01/2022', 'dd/mm/yyyy')
                            AND order_id IS NOT NULL
                          GROUP BY order_id) z ON x.order_id = z.order_id;



SELECT *
FROM dsp_dd_history
WHERE request_time < TO_DATE('01/01/2022', 'dd/mm/yyyy');

SELECT order_id, SUM(req_cost) req_cost
FROM dsp_dd_history
WHERE request_time < TO_DATE('01/01/2022', 'dd/mm/yyyy')
  AND order_id IS NOT NULL
GROUP BY order_id;

SELECT DISTINCT channel
FROM dsp_dd_history;

SELECT DISTINCT channel
FROM dsp_dd_history
WHERE order_id IS NOT NULL;

SELECT *
FROM dsp_dd_history
WHERE channel = 'API';

SELECT *
FROM dsp_order
WHERE order_id = 1141;

SELECT SUM(amount)
FROM dsp_order_transaction
WHERE order_id = 1141
  AND issue_time < TO_DATE('01/01/2022', 'dd/mm/yyyy');

SELECT name, price, active_day
FROM dsp_service_price a,
     dsp_service_price_tab b
WHERE a.tab_id = b.tab_id;

SELECT *
FROM dsp_service_price_tab
WHERE service_id = 50;

SELECT *
FROM dsp_service;

SELECT *
FROM dsp_service_price
WHERE tab_id IN (262, 301);


SELECT *
FROM dsp_mt_history
WHERE isdn = '84937876036'
  AND sent_time > TRUNC(SYSDATE - 1);

SELECT *
FROM dsp_sys_log
WHERE isdn = '937876036'
  AND exec_datetime >= TRUNC(SYSDATE - 1);



SELECT *
FROM dsp_white_list
WHERE isdn = '765826344';

SELECT *
FROM api_request;

-- Đơn tiền
SELECT order_id, com_id, order_time, contract_value, paid_cost
FROM dsp_order
WHERE status IN (2, 21);



SELECT *
FROM dsp_order a,
     dsp_order_transaction b
WHERE a.order_id = b.order_id;

SELECT a.transaction_id,
       order_id,
       service_id,
       request_time,
       b.amount,
       com_id,
       res_order_id,
       tab_id
FROM dsp_transaction a,
     dsp_order_transaction b
WHERE a.transaction_id = b.transaction_id
  AND a.status IN (3, 6)
  AND a.service_id IN (43, 80, 81)
ORDER BY a.transaction_id;

SELECT *
FROM dsp_order_transaction;

SELECT *
FROM dsp_service;



(SELECT transaction_id,
        isdn,
        amount   data_amount,
        active_days,
        req_cost total_cost,
        request_time,
        process_time,
        channel,
        request_id,
        profile
 FROM dsp_dd_history
 WHERE status = 1
   AND process_time >= TRUNC(SYSDATE) - 1
   AND process_time < TRUNC(SYSDATE));


SELECT *
FROM dsp_dd_history;


SELECT *
FROM dsp_service_price;

SELECT *
FROM dsp_order
WHERE order_id = 1921;

SELECT *
FROM dsp_order_transaction
WHERE order_id = 1921;

SELECT *
FROM dsp_transaction
WHERE transaction_id = 3150;

SELECT *
FROM dsp_dd_history
WHERE order_id = 1921;

SELECT *
FROM rpt_order_summary
WHERE order_id = 2182
ORDER BY sum_date;

SELECT *
FROM rpt_order_summary_daily
WHERE order_id = 1921
ORDER BY sum_date;


SELECT *
FROM (
SELECT o.com_id,
       o.order_id,
       CASE
           WHEN o.order_time >= TO_DATE('01/08/2023', 'dd/mm/yyyy')
               THEN
               NVL(o.contract_value, 0)
           ELSE
               NVL(ol.remain_value, '0')
           END               start_value,
       NVL(u.amount_used, 0) used_value,
       CASE
           WHEN o.expire_time < TO_DATE('01/09/2023', 'dd/mm/yyyy') THEN NVL(o.remain_value, 0)
           ELSE 0
           END               expired_value,
       CASE
           WHEN o.order_time >= TO_DATE('01/08/2023', 'dd/mm/yyyy')
               THEN
               NVL(o.contract_value, 0)
           ELSE
               NVL(ol.remain_value, 0)
           END
           - NVL(u.amount_used, 0)
           - CASE
                 WHEN o.expire_time < TO_DATE('01/09/2023', 'dd/mm/yyyy') THEN NVL(o.remain_value, 0)
                 ELSE 0
           END               remain_value,
       TO_DATE('01/08/2023', 'dd/mm/yyyy')
FROM dsp_order o,
     (SELECT *
      FROM rpt_order_summary
      WHERE sum_date = ADD_MONTHS(TO_DATE('01/08/2023', 'dd/mm/yyyy'), -1)) ol,
     (SELECT order_id, SUM(amount_used) amount_used
      FROM (SELECT order_id,
                   SUM(NVL(DECODE(t.service_id, 50, ot.success_amount, 78, ot.success_amount, ot.amount),
                           0)) amount_used
            FROM dsp_order_transaction ot,
                 dsp_transaction t
            WHERE ot.transaction_id = t.transaction_id
              AND t.status IN (6,3)
              AND ot.issue_time >= TO_DATE('01/08/2023', 'dd/mm/yyyy')
              AND ot.issue_time < TO_DATE('01/09/2023', 'dd/mm/yyyy')
            GROUP BY ot.order_id
            UNION ALL
            SELECT TO_NUMBER(order_id) order_id, SUM(req_cost) amount_used
            FROM dsp_dd_history
            WHERE channel IN ('API_DDP', 'API_DD')
              AND status = 1
              AND request_time >= TO_DATE('01/08/2023', 'dd/mm/yyyy')
              AND request_time < TO_DATE('01/09/2023', 'dd/mm/yyyy')
            GROUP BY order_id)
      GROUP BY order_id) u
WHERE o.order_id = ol.order_id(+)
  AND o.order_id = u.order_id(+)
  AND TRUNC(o.order_time, 'mm') < TO_DATE('01/09/2023', 'dd/mm/yyyy')
  AND o.expire_time >= TO_DATE('01/08/2023', 'dd/mm/yyyy')) where order_id = 2182;--44k


SELECT *
FROM dsp_sys_log
WHERE exec_datetime > TO_DATE('01/03/2023', 'dd/mm/yyyy')
  AND exec_datetime < TO_DATE('01/08/2023', 'dd/mm/yyyy')
and trans_id in ('3141',
'3142',
'3143',
'3144',
'3145',
'3146',
'3147',
'3150'
);
  --AND request LIKE '%TleiYTtb6NpLT0UEcvOgXwfl+Yc=%';
SELECT *
FROM dsp_order where order_id='2182';--100k--44k--1k
SELECT *
FROM dsp_transaction where status =3 and request_time>TO_DATE('01/08/2023', 'dd/mm/yyyy');--3633-1k

SELECT *
FROM dsp_order_transaction WHERE  transaction_id='3633';--2182


SELECT *
FROM dsp_order where order_id in (2381,2383);

update dsp_order set status = 4, description ='Hoang Anh y/c ngay 31/08' where order_id in (2381,2383);

COMMIT ;


SELECT *
FROM dsp_order_status  where order_id in (2381,2383) ORDER BY issue_time;




select * from dsp_transaction where service_id = 77 and request_time >= to_date('01/08/2023','dd/mm/yyyy')
    and request_time < to_date('31/08/2023','dd/mm/yyyy')+1 and status = 4;

SELECT *
FROM api_request where request like 'W2GCheckRequest%' and req_time >= to_date('01/08/2023','dd/mm/yyyy') and req_time < to_date('31/08/2023','dd/mm/yyyy')+1
and response like '%code=0%';


SELECT *
FROM m;