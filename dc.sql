SELECT *
FROM VOUCHER
WHERE SER_NUM IN ('020000002479039', '020000002479141', '020000002479111', '020000002479037', '020000002479221');
SELECT *
FROM VOUCHER
     --where ORDER_ID=1000001153
ORDER BY order_id DESC;
SELECT *
FROM API_REQUEST
WHERE REQUEST_TIME >= TRUNC(SYSDATE)
  AND TRANS_ID IN (
                   'ct2_mpl_api_1665026662586',
                   'ct2_mpl_api_1665027821074',
                   'ct2_mpl_api_1663660235648',
                   'ct2_mpl_api_1665027822959',
                   'ct2_mpl_api_1663660239273'
    );

SELECT *
FROM VOUCHER_ORDER
WHERE ORDER_id = 1000001157
ORDER BY ORDER_ID DESC;

SELECT *
FROM VOUCHER_ORDER_DETAIL
WHERE ORDER_ID = 1000001157;

SELECT *
FROM temp_dc_use_20220905;


SELECT *
FROM EMAIL_HISTORY
WHERE ORDER_ID = 1000003239;
SELECT *
FROM EMAIL_QUEUE;


--
SELECT *
FROM job
WHERE p1 = '3201';
--email id (email_queue)
--Cập nhật lại trạng thái job bị lỗi (id job lấy trên log tiến trình gửi email)
SELECT *
FROM job
WHERE JOB_ID IN (11167, 11169, 11173, 11171, 11175);
UPDATE job
SET status = 0
WHERE job_id IN (11155);
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
FROM DSP_COMPANY
WHERE COM_ID = 881;

SELECT *
FROM VOUCHER_PROFILE
ORDER BY PROFILE_ID;

SELECT *
FROM VOUCHER
WHERE ORDER_ID = '1000000891'
  AND USED <> '1';


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
                          exp_dat < TO_DATE('28/08/2022', 'dd/mm/yyyy') AND USED = 0 THEN 1
                     ELSE 0
                 END)                            expired_in_period
      FROM voucher
      WHERE ORDER_ID = '1000001270'
        AND exp_dat >= TO_DATE('27/08/2022', 'dd/mm/yyyy')
        AND cre_dat < TO_DATE('28/08/2022', 'dd/mm/yyyy')
      GROUP BY TO_DATE('27/08/2022', 'dd/mm/yyyy'), TRUNC(cre_dat), order_id, addon, profile_code) a;


SELECT *
FROM RPT_ORDER_SUMMARY_DAILY
WHERE TOTAL = EXPIRED_IN_PERIOD


  AND TOTAL = USED + NOT_YET;

SELECT *
FROM VOUCHER
WHERE ORDER_ID = 1000001419;

SELECT *
FROM RPT_ORDER_SUMMARY_DAILY
WHERE ORDER_ID = 1000001270
ORDER BY SUM_DAT;


UPDATE RPT_ORDER_SUMMARY_DAILY
SET EXPIRED_IN_PERIOD=NOT_YET
WHERE TOTAL = EXPIRED_IN_PERIOD;
COMMIT;

SELECT profile_code,
       SUM(activeN2),
       SUM(activeN1),
       SUM(created),
       SUM(used),
       SUM(locked),
       SUM(deleted),
       SUM(activeN1) - SUM(activeN2) - SUM(created) + SUM(used) + SUM(locked) delta
FROM (SELECT profile_code, SUM(active) activeN2, 0 activeN1, 0 created, 0 used, 0 locked, 0 deleted
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
FROM API_REQUEST;