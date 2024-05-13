--1. Ket xuat du lieu gach the DC
SELECT TO_CHAR(TRUNC(SYSDATE - 1), 'dd/mm/yyyy') exp_date,
       a.order_id,
       b.order_code,
       ser_num,
       TO_CHAR(cre_dat, 'dd/mm/yyyy'),
       TO_CHAR(use_tim, 'dd/mm/yyyy hh24:mi:ss'),
       ref,
       a.status,
       dat_amt,
       dat_day,
       addon,
       profile_code
FROM voucher a,
     voucher_order b
WHERE used = 1
  AND a.order_id = b.order_id
  AND a.use_tim >= TRUNC(SYSDATE - 1)
  AND a.use_tim < TRUNC(SYSDATE);

--2. Import de lieu gach the DC vao bang voucher_order tren ICCCDS

CREATE TABLE voucher_order
(
    exp_date     date,
    order_id     NUMBER(10),
    order_code   VARCHAR2(50),
    ser_num      VARCHAR2(32),
    cre_dat      DATE,
    use_tim      DATE,
    ref          VARCHAR2(100),
    status       NUMBER(2),
    dat_amt      NUMBER(10),
    dat_day      NUMBER(5),
    addon        NUMBER(1),
    profile_code VARCHAR2(20)
);

--3. Ket xuat du lieu
SELECT SUBSTR(a.description, INSTR(a.description, '->', -1, 1) + 2) isdn,
       c.profile_code                                               ma_goi,
       a.total_cost                                                 gia_tien,
       a.transaction_id                                             ma_dh,
       d.total_cost                                                 gtdh,
       (1 - d.total_cost / d.contract_cost) * 100                   ck,
       e.com_id                                                     ma_dly,
       e.com_name                                                   ten_dly,
       TO_CHAR(request_time, 'dd/mm/yyyy hh24:mi:ss')               thoigian_dk,
       'TOPUP'                                                      type
FROM m_transaction a,
     m_transaction_detail b,
     profile c,
     m_order d,
     company e
WHERE a.transaction_id = b.transaction_id
  AND b.profile_id = c.profile_id
  AND a.org_order_id = d.order_id
  AND a.com_id = e.com_id
  AND a.status = 6
  AND a.res_order_id IS NULL
  AND a.request_time >= TRUNC(SYSDATE - 1)
  AND a.request_time < TRUNC(SYSDATE)
UNION ALL
SELECT SUBSTR(f.ref, INSTR(f.ref, '|', -1, 1) + 1) isdn,
       c.profile_code                              ma_goi,
       c.price                                     gia_tien,
       a.transaction_id                            ma_dh,
       d.total_cost                                gtdh,
       (1 - d.total_cost / d.contract_cost) * 100  ck,
       e.com_id                                    ma_dly,
       e.com_name                                  ten_dly,
       TO_CHAR(f.use_tim, 'dd/mm/yyyy hh24:mi:ss') thoigian_dk,
       'DATACODE'                                  type
FROM m_transaction a,
     m_transaction_detail b,
     profile c,
     m_order d,
     company e,
     voucher_order f
WHERE a.transaction_id = b.transaction_id
  AND b.profile_id = c.profile_id
  AND a.org_order_id = d.order_id
  AND a.com_id = e.com_id
  AND a.res_order_id = f.order_code
  AND a.status = 6
  AND a.res_order_id IS NOT NULL
  AND f.exp_date >= TRUNC(SYSDATE - 1)
  AND f.exp_date < TRUNC(SYSDATE);