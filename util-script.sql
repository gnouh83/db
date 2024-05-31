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
  AND t.owner = 'SCHEMA_NAME'
GROUP BY t.owner,
         t.table_name
ORDER BY size_mb DESC;


SELECT ROUND(SUM(bytes) / (1024 * 1024 * 1024), 2) AS size_gb
FROM dba_data_files;

SELECT ROUND(SUM(bytes) / (1024 * 1024 * 1024), 2) AS used_size_gb
FROM dba_segments;