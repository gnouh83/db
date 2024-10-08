--1. Ket xuat du lieu gach the DC
SELECT TO_CHAR(TRUNC(SYSDATE - 1), 'dd/mm/yyyy') exp_date,
       a.order_id                                order_id,
       b.order_code                              order_code,
       ser_num,
       TO_CHAR(cre_dat, 'dd/mm/yyyy')            cre_dat,
       TO_CHAR(use_tim, 'dd/mm/yyyy hh24:mi:ss') use_tim,
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
)
    TABLESPACE "DATA" PARTITION BY RANGE (exp_date)
(
    PARTITION "DATA-20240512" VALUES LESS THAN (TO_DATE(' 2024-05-13 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240513" VALUES LESS THAN (TO_DATE(' 2024-05-14 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240514" VALUES LESS THAN (TO_DATE(' 2024-05-15 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240515" VALUES LESS THAN (TO_DATE(' 2024-05-16 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240516" VALUES LESS THAN (TO_DATE(' 2024-05-17 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240517" VALUES LESS THAN (TO_DATE(' 2024-05-18 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240518" VALUES LESS THAN (TO_DATE(' 2024-05-19 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240519" VALUES LESS THAN (TO_DATE(' 2024-05-20 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240520" VALUES LESS THAN (TO_DATE(' 2024-05-21 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240521" VALUES LESS THAN (TO_DATE(' 2024-05-22 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240522" VALUES LESS THAN (TO_DATE(' 2024-05-23 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240523" VALUES LESS THAN (TO_DATE(' 2024-05-24 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240524" VALUES LESS THAN (TO_DATE(' 2024-05-25 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240525" VALUES LESS THAN (TO_DATE(' 2024-05-26 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240526" VALUES LESS THAN (TO_DATE(' 2024-05-27 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240527" VALUES LESS THAN (TO_DATE(' 2024-05-28 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240528" VALUES LESS THAN (TO_DATE(' 2024-05-29 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240529" VALUES LESS THAN (TO_DATE(' 2024-05-30 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240530" VALUES LESS THAN (TO_DATE(' 2024-05-31 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN')),
    PARTITION "DATA-20240531" VALUES LESS THAN (TO_DATE(' 2024-06-01 00:00:00', 'SYYYY-MM-DD HH24:MI:SS',
                                                        'NLS_CALENDAR=GREGORIAN'))
);


CREATE TABLE "DR_FILE"
(
    "FILE_ID"          NUMBER(10, 0),
    "FILE_NAME"        VARCHAR2(200 BYTE),
    "FILE_MODIFIED"    DATE,
    "FILE_SIZE"        NUMBER(10, 0),
    "FILE_TYPE"        VARCHAR2(10 BYTE),
    "TOTAL_RECORD"     NUMBER(10, 0),
    "PROCESSED_RECORD" NUMBER(10, 0),
    "PROCESSED_TIME"   DATE,
    "DATA_BEGIN_TIME"  DATE,
    "DATA_END_TIME"    DATE,
    "STATUS"           NUMBER(2, 0)
);
--------------------------------------------------------
--  DDL for Index DR_FILE_PK
--------------------------------------------------------

CREATE UNIQUE INDEX "DR_FILE_PK" ON "DR_FILE" ("FILE_ID");
--------------------------------------------------------
--  Constraints for Table DR_FILE
--------------------------------------------------------

ALTER TABLE "DR_FILE"
    ADD CONSTRAINT "DR_FILE_PK" PRIMARY KEY ("FILE_ID")
        USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS
            STORAGE (INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
            PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
            BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
            TABLESPACE "DATA" ENABLE;
ALTER TABLE "DR_FILE"
    MODIFY ("FILE_ID" NOT NULL ENABLE);
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
SELECT NVL(substr(f.ref, instr(f.ref, '|', -1, 1) + 1),
           SUBSTR(f.ref, INSTR(f.ref, '|') + 1, INSTR(f.ref, '|', 1, 2) - INSTR(f.ref, '|') - 1)) isdn,
       c.profile_code                                                                             ma_goi,
       c.price                                                                                    gia_tien,
       a.transaction_id                                                                           ma_dh,
       d.total_cost                                                                               gtdh,
       (1 - d.total_cost / d.contract_cost) * 100                                                 ck,
       e.com_id                                                                                   ma_dly,
       e.com_name                                                                                 ten_dly,
       TO_CHAR(f.use_tim, 'dd/mm/yyyy hh24:mi:ss')                                                thoigian_dk,
       'DATACODE'                                                                                 type
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