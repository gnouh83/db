SELECT *
FROM dsp_company;
SELECT *
FROM dsp_sms_command
ORDER BY cmd_id;
SELECT *
FROM dsp_sys_log
WHERE exec_datetime > TRUNC(SYSDATE)
ORDER BY log_id DESC;
--The da mua
SELECT b.card_name, SUM(b.amount) AS amount, c.price, SUM(b.amount) * c.price AS total
FROM dsp_transaction a,
     dsp_dc_detail b,
     dsp_service_price c
WHERE a.transaction_id = b.transaction_id
  AND b.price_id = c.price_id
  AND a.request_time >= TO_DATE('16/01/2022', 'dd/mm/yyyy')
  AND a.request_time <= TO_DATE('30/04/2022', 'dd/mm/yyyy')
  AND a.status IN (3, 6)
GROUP BY b.card_name, c.price
ORDER BY b.card_name
;
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
create table temp_comp_20220906 as
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
WHERE received_time > TO_DATE('06/09/2022 12:15:00', 'dd/mm/yyyy hh24:mi:ss');

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

select * from temp_comp_20220906;