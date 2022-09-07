SELECT *
FROM temp_20220905;

SELECT *
FROM temp_dc_use_20220905;

CREATE TABLE temp_dc_use_20220905 AS
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

SELECT * from temp_dc_use_20220905;


SELECT SUM(a.cap_max) amount, SUM(b.amount * a.price) AS total
FROM temp_20220905 a,
     temp_dc_use_20220905 b
WHERE a.res_order_id = b.order_code
  AND a.card_name = b.profile_code
;

SELECT a.com_name,SUM(a.cap_max) amount, SUM(b.amount * a.price) AS total
FROM temp_comp_20220906 a,
     temp_dc_use_20220905 b
WHERE a.res_order_id = b.order_code
  AND a.card_name = b.profile_code
group by a.com_name
;