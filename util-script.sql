-- Check dung luong tung bang
SELECT owner,
       segment_name,
       ROUND(SUM(bytes) / (1024 * 1024), 2) AS size_mb
FROM dba_segments
WHERE segment_type = 'TABLE'
  AND owner = 'DSP_OWNER'
GROUP BY owner,
         segment_name
ORDER BY size_mb DESC;

-- Check dung luong tung bang PARTITION
SELECT t.owner,
       t.table_name,
       ROUND(SUM(s.bytes) / (1024 * 1024), 2) AS size_mb
FROM dba_part_tables t
         JOIN
     dba_segments s
     ON
         t.table_name = s.segment_name
             AND t.owner = s.owner
WHERE s.segment_type = 'TABLE PARTITION'
  AND t.owner = 'DSP_OWNER'
GROUP BY t.owner,
         t.table_name
ORDER BY size_mb DESC;


SELECT ROUND(SUM(bytes) / (1024 * 1024 * 1024), 2) AS size_gb
FROM dba_data_files;

SELECT ROUND(SUM(bytes) / (1024 * 1024 * 1024), 2) AS used_size_gb
FROM dba_segments;
--Dung lượng archivelog theo từng ngày
SELECT TO_CHAR(first_time, 'YYYY-MM-DD') AS archive_date,
       SUM(blocks * block_size)          AS total_size
FROM v$archived_log
GROUP BY TO_CHAR(first_time, 'YYYY-MM-DD')
ORDER BY archive_date;
-- Add partition
DECLARE
    v_start_date      DATE := TO_DATE('01-JUN-2024', 'DD-MON-YYYY');
    v_end_date        DATE := TO_DATE('30-JUN-2029', 'DD-MON-YYYY');
    v_partition_name  VARCHAR2(50);
    v_partition_limit DATE;
    v_sql             VARCHAR2(1000);
BEGIN
    WHILE v_start_date <= v_end_date
        LOOP
            v_partition_name := 'DATA_' || TO_CHAR(v_start_date, 'YYYYMMDD');
            v_partition_limit := v_start_date + 1;

            v_sql := 'ALTER TABLE voucher_order ADD PARTITION ' || v_partition_name ||
                     ' VALUES LESS THAN (TO_DATE(''' || TO_CHAR(v_partition_limit, 'DD-MON-YYYY') ||
                     ''', ''DD-MON-YYYY'')) TABLESPACE DATA';

            EXECUTE IMMEDIATE v_sql;

            --DBMS_OUTPUT.PUT_LINE(v_sql);
            v_start_date := v_start_date + 1;
        END LOOP;
END;

--Rename partition
DECLARE
    v_start_date      DATE := TO_DATE('01-MAY-2024', 'DD-MON-YYYY');
    v_end_date        DATE := TO_DATE('31-MAY-2024', 'DD-MON-YYYY');
    v_partition_name  VARCHAR2(50);
    v_partition_limit DATE;
    v_sql             VARCHAR2(1000);
BEGIN
    -- Đổi tên partition hiện có (ví dụ)
    DBMS_OUTPUT.PUT_LINE('ALTER TABLE voucher_order RENAME PARTITION p_existing TO p_20240430;');

    -- Thêm các partition mới từ 1/5/2024 đến 30/6/2024
    WHILE v_start_date <= v_end_date
        LOOP
            v_partition_name := 'p_' || TO_CHAR(v_start_date, 'YYYYMMDD');
            v_partition_limit := v_start_date + 1;

            v_sql := 'ALTER TABLE voucher_order ADD PARTITION ' || v_partition_name ||
                     ' VALUES LESS THAN (TO_DATE(''' || TO_CHAR(v_partition_limit, 'DD-MON-YYYY') ||
                     ''', ''DD-MON-YYYY'')) TABLESPACE DATA;';

            DBMS_OUTPUT.PUT_LINE(v_sql);

            v_start_date := v_start_date + 1;
        END LOOP;
END;
/



select NVL(substr(f.ref, instr(f.ref, '|', -1, 1) + 1),
           SUBSTR(f.ref, INSTR(f.ref, '|') + 1, INSTR(f.ref, '|', 1, 2) - INSTR(f.ref, '|') - 1)) isdn,
       f.*
from voucher_order partition (data_20240612) f
where profile_code = 'DH2';