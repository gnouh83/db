SELECT TRANS_ID,response,a.* FROM dsp_sys_log a WHERE isdn = '936722927' AND exec_datetime >= TO_DATE ('05/11/2022', 'dd/mm/yyyy')
AND exec_datetime < TO_DATE ('06/11/2022', 'dd/mm/yyyy') + 1
AND response LIKE '%020000007232407%' ORDER BY exec_datetime;

SELECT * FROM dsp_recharge WHERE isdn = '936722927' ORDER BY issue_date;
COMMIT;
/*rollback;*/
--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DataQT42',4194304,30,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DataQT56',5242880,30,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DataQT84',8388608,30,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DataQT28',2935808,10,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DataQT14',1468416,10,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DC10',1048576,10,'020000007232407','0','0',NULL,'443611',NULL);

INSERT INTO dsp_recharge
VALUES ('936722927',SYSDATE,'DC5',1048576,1,'020000007232407','0','0',NULL,'443611',NULL);

--UseDCResObj{transaction_id='443611', code='0', description='null', serial='020000007232407', transaction_id='443611', dat_amt=4194304, dat_day=30, order_code='QvjNW04TDg7vwB4G3t/90joB+9U=', reseller='0311719703', profile_code='DataQT42'}