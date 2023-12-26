/*THEM TRUONG TRONG BANG -----------------------------------------------------------------------------------------------*/
/*09-2023*/
ALTER TABLE voucher
    ADD hold_time date;

INSERT INTO api
VALUES (40, 'HoldDC', '/usr/hold_dc', 'Giu the truoc khi gach the', '1');
INSERT INTO api
VALUES (41, 'UnHoldDC', '/usr/un_hold_dc', 'Bo giu the truoc khi gach the', '1');
COMMIT;
/*----------------------------------------------------------------------------------------------------------------------*/
SELECT ser_num, addon, cre_dat, exp_dat, dat_amt, dat_day, profile_code
FROM voucher
WHERE order_id = 0;

SELECT *
FROM voucher
WHERE enc_pin = 'R4TZ5maG2eUBSSLiIkjW/LT51sBQ6w3hqwdUzDD7DOQ=';
SELECT *
FROM voucher
WHERE ser_num IN ('020000002479039', '020000002479141', '020000002479111', '020000002479037', '020000002479221');
SELECT *
FROM voucher
--where ORDER_ID=1000001153
ORDER BY order_id DESC;


SELECT *
FROM voucher_2;
SELECT *
FROM api_request
WHERE request_time >= TRUNC(SYSDATE)
  AND trans_id IN (
                   'ct2_mpl_api_1665026662586',
                   'ct2_mpl_api_1665027821074',
                   'ct2_mpl_api_1663660235648',
                   'ct2_mpl_api_1665027822959',
                   'ct2_mpl_api_1663660239273'
    );

SELECT *
FROM voucher_order
WHERE order_id = 1000001157
ORDER BY order_id DESC;

SELECT *
FROM voucher_order_detail
WHERE order_id = 1000001157;

SELECT *
FROM temp_dc_use_20220905;


SELECT *
FROM email_history
WHERE order_id = 1000003239;
SELECT *
FROM email_queue;


--
SELECT *
FROM job
WHERE p1 = '3201';
--email id (email_queue)
--Cập nhật lại trạng thái job bị lỗi (id job lấy trên log tiến trình gửi email)
SELECT *
FROM job
WHERE job_id IN (18532);
UPDATE job
SET status = 0
WHERE job_id IN (18532);
COMMIT;

/*CREATE TABLE temp_dc_use_20220905 AS*/
SELECT a.profile_code, COUNT(1) amount, b.order_code
FROM voucher a,
     voucher_order b
WHERE a.order_id = b.order_id
  AND a.used = '1'
  AND a.use_tim >= TO_DATE('16/01/2022', 'dd/mm/yyyy')
  AND a.use_tim <= TO_DATE('30/04/2022', 'dd/mm/yyyy')
GROUP BY a.profile_code, b.order_code
;

SELECT *
FROM voucher;


SELECT a.card_name, SUM(b.amount) amount, a.price, SUM(b.amount) * a.price AS total
FROM temp_20220905 a,
     temp_dc_use_20220905 b
WHERE a.res_order_id = b.order_code
  AND a.card_name = b.profile_code
GROUP BY a.card_name, a.price
ORDER BY a.card_name
;

SELECT *
FROM temp_dc_use_20220905;


SELECT SUM(a.cap_max) amount, SUM(b.amount * a.price) AS total
FROM temp_20220905 a,
     temp_dc_use_20220905 b
WHERE a.res_order_id = b.order_code
  AND a.card_name = b.profile_code;

SELECT a.com_name, SUM(a.cap_max) amount, SUM(b.amount * a.price) AS total
FROM temp_comp_20220906 a,
     temp_dc_use_20220905 b
WHERE a.res_order_id = b.order_code
  AND a.card_name = b.profile_code
GROUP BY a.com_name
;

SELECT *
FROM dsp_company
WHERE com_id = 881;

SELECT *
FROM voucher_profile
ORDER BY profile_id;

SELECT *
FROM voucher
WHERE order_id = '1000000891'
  AND used <> '1';


BEGIN
    summary_order_daily(SYSDATE);
END;


/*insert into RPT_ORDER_SUMMARY_DAILY*/

SELECT (SELECT order_code FROM voucher_order o WHERE o.order_id = a.order_id) order_code,
       a.*
FROM (SELECT TO_DATE('27/08/2022', 'dd/mm/yyyy') sum_dat,
             TRUNC(cre_dat)                      cre_dat,
             order_id,
             addon,
             profile_code,
             COUNT(1)                            total,
             SUM(CASE
                     WHEN use_tim >= TO_DATE('27/08/2022', 'dd/mm/yyyy') AND
                          use_tim < TO_DATE('28/08/2022', 'dd/mm/yyyy') THEN 1
                     ELSE 0
                 END)                            used_in_period,
             SUM(CASE
                     WHEN use_tim < TO_DATE('28/08/2022', 'dd/mm/yyyy') THEN 1
                     ELSE 0
                 END)                            used,
             SUM(CASE
                     WHEN use_tim IS NULL OR use_tim >= TO_DATE('27/08/2022', 'dd/mm/yyyy') THEN 1
                     ELSE 0
                 END)                            not_yet,
             SUM(CASE
                     WHEN exp_dat >= TO_DATE('27/08/2022', 'dd/mm/yyyy') AND
                          exp_dat < TO_DATE('28/08/2022', 'dd/mm/yyyy') AND used = 0 THEN 1
                     ELSE 0
                 END)                            expired_in_period
      FROM voucher
      WHERE order_id = '1000001270'
        AND exp_dat >= TO_DATE('27/08/2022', 'dd/mm/yyyy')
        AND cre_dat < TO_DATE('28/08/2022', 'dd/mm/yyyy')
      GROUP BY TO_DATE('27/08/2022', 'dd/mm/yyyy'), TRUNC(cre_dat), order_id, addon, profile_code) a;


SELECT *
FROM rpt_order_summary_daily
WHERE total = expired_in_period
  AND total = used + not_yet;

SELECT *
FROM voucher
WHERE order_id = 1000001419;

SELECT *
FROM rpt_order_summary_daily
WHERE order_id = 1000001270
ORDER BY sum_dat;


UPDATE rpt_order_summary_daily
SET expired_in_period=not_yet
WHERE total = expired_in_period;
COMMIT;

SELECT profile_code,
       SUM(activen2),
       SUM(activen1),
       SUM(created),
       SUM(used),
       SUM(locked),
       SUM(deleted),
       SUM(activen1) - SUM(activen2) - SUM(created) + SUM(used) + SUM(locked) delta
FROM (SELECT profile_code, SUM(active) activen2, 0 activen1, 0 created, 0 used, 0 locked, 0 deleted
      FROM voucher_statistic_daily
      WHERE stat_date = TRUNC(SYSDATE) - 1
      GROUP BY profile_code
      UNION ALL
      SELECT profile_code, 0, SUM(active), SUM(created), SUM(used), SUM(locked), SUM(deleted)
      FROM voucher_statistic_daily
      WHERE stat_date = TRUNC(SYSDATE)
      GROUP BY profile_code)
GROUP BY profile_code
ORDER BY profile_code;


SELECT *
FROM api_request;


SELECT *
FROM voucher_order
WHERE order_id = 3567;

SELECT *
FROM voucher_profile;

SELECT *
FROM voucher
WHERE ser_num = '5000000001348567';

UPDATE voucher
SET dat_amt= 1024000
WHERE old_card = '1'
  AND profile_code = 'DC10'
  AND dat_amt = '512000';


SELECT dat_amt, COUNT(1)
FROM voucher
WHERE old_card = '1'
  AND profile_code = 'DC10'
GROUP BY dat_amt;

UPDATE voucher
SET act_dat=TRUNC(cre_dat) + 1
WHERE ser_num = '5000000001348567';
COMMIT;

SELECT *
FROM api_request
WHERE request_content LIKE '';

SELECT *
FROM rpt_order_summary
WHERE order_id = 1000001969;

SELECT *
FROM voucher
WHERE profile_code = 'QT150';

SELECT COUNT(*)
FROM voucher;--10 712 538


SELECT *
FROM voucher
WHERE use_tim IS NULL
  AND cre_dat < TO_DATE('01/01/2022', 'dd/mm/yyyy');


SELECT *
FROM voucher
WHERE ser_num = '020000012975427';


SELECT a.ser_num,
       a.cre_dat,
       a.act_dat,
       a.use_tim,
       a.exp_dat,
       a.del_dat,
       a.sus_dat,
       a.used,
       a.ref,
       a.order_id,
       a.status,
       a.dat_amt,
       a.dat_day,
       a.addon,
       a.profile_code,
       a.old_card
FROM voucher a;


SELECT COUNT(1)
FROM voucher_order;

SELECT *
FROM voucher_order_detail;
SELECT ser_num
           cre_dat,
       act_dat,
       use_tim,
       exp_dat,
       del_dat,
       sus_dat,
       used,
       ref,
       order_id,
       status,
       dat_amt,
       dat_day,
       addon,
       profile_code,
       old_card
FROM voucher;


SELECT *
FROM voucher_order
WHERE order_code = '4rFkrWiND5jq1LzDgCkvLctjd7w=';--> order_id = 1000004326

SELECT count(1)
FROM voucher
WHERE order_id = 1000004404
  AND used = 1
  AND use_tim >= TO_DATE('01/06/2023', 'dd/mm/yyyy')
  AND use_tim < TO_DATE('30/06/2023', 'dd/mm/yyyy')+1 ORDER BY  use_tim ;

SELECT *
FROM voucher_profile;

SELECT *
FROM voucher
WHERE enc_pin = 'WLVIHKNIHCEYHw8AEN46uXdGZP0amshas1SKxnXx7Hs='
  AND ser_num = '020000012975427';

SELECT *
FROM voucher where ser_num='120000010883788';


SELECT *
FROM api;



SELECT *
FROM voucher_used;

SELECT *
FROM api_request where request_content like '%120000010883788%' and REQUEST_TIME> TO_DATE('01/06/2023', 'dd/mm/yyyy')
  AND REQUEST_TIME < TO_DATE('02/06/2023', 'dd/mm/yyyy') + 3;


SELECT *
FROM api_request
WHERE request_time > TRUNC(SYSDATE)
  AND trans_id = 'webapi_1690519107934';

SELECT *
FROM voucher_profile;

SELECT *
FROM am_user;
