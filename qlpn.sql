CREATE DATABASE LINK "db_90012"
    CONNECT TO "qlpn" IDENTIFIED BY "qlpn"
    USING '(DESCRIPTION = (ADDRESS_LIST = (ADDRESS = (PROTOCOL = TCP)(HOST = 10.10.8.181)(PORT = 1521)))(CONNECT_DATA =(SID = tc8)(SERVER = SHARED)))';


GRANT CREATE ANY MATERIALIZED VIEW TO qlpn;


--source
CREATE MATERIALIZED VIEW LOG ON pn_lai_lich WITH PRIMARY KEY;
--DROP MATERIALIZED VIEW LOG ON profile;
--dest
--DROP MATERIALIZED VIEW mv_pn_lai_lich;
CREATE MATERIALIZED VIEW mv_90012_pn_lai_lich
    REFRESH FAST ON DEMAND START WITH SYSDATE NEXT SYSDATE + INTERVAL '5' MINUTE
AS
SELECT *
FROM qlpn.pn_lai_lich@db_90012;

SELECT *
FROM mv_90012_pn_lai_lich;

CREATE OR REPLACE VIEW v_pn_lai_lich AS
SELECT *
FROM mv_90012_pn_lai_lich
UNION ALL
SELECT *
FROM mv_90012_pn_lai_lich;


SELECT COUNT(*)
FROM v_pn_lai_lich;
------------------------------------------------------------------------------------------------------------------------

SELECT *
FROM pn_lai_lich;

SELECT *
FROM pn_tong_hop_tha_co_dk;

SELECT *
FROM qlpn.mv_profile ORDER BY profile_id;
/*

CREATE MATERIALIZED VIEW mv_profile
    REFRESH FAST ON DEMAND
AS
SELECT *
FROM icccds_owner.profile@icccds;

BEGIN
    dbms_mview.refresh('mv_profile');
END;
--drop MATERIALIZED VIEW mv_profile;


SELECT *
FROM mv_profile;

SQL> conn bp/bp
Connected.
SQL> create database link self connect to bp identified by bp
     using 'localhost:1521/RYMIN19';

Database link created.

SQL> create table t1 (c1 number not null unique, c2 number);

Table created.

SQL> create materialized view log on t1 with primary key;

Materialized view log created.

SQL> create materialized view mv1 refresh fast on demand as select * from t1@self;

Materialized view created.

SQL> insert into t1 values (1, 1);

1 row created.

SQL> insert into t1 values (2, 2);

1 row created.

SQL> commit;

Commit complete.



THEN

SQL> exec dbms_mview.refresh('MV1', 'f');

PL/SQL procedure successfully completed.

SQL> select last_refresh_type from user_mviews where mview_name = 'MV1';

LAST_REF
--------
FAST


*/