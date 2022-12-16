SELECT TRANS_ID,response,a.* FROM dsp_sys_log a WHERE isdn = '932695180' AND exec_datetime >= TO_DATE ('14/12/2022', 'dd/mm/yyyy')
AND exec_datetime < TO_DATE ('15/12/2022', 'dd/mm/yyyy') + 1
AND response LIKE '%120000007798120%'
ORDER BY exec_datetime;

SELECT * FROM dsp_recharge WHERE isdn = '906328167' ORDER BY issue_date;
COMMIT;
/*rollback;*/
--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('906328167',SYSDATE,'C90N',4194304,30,'120000007798120','0','0',NULL,'932695180_492968',NULL);
--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DataQT42',4194304,30,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DataQT56',5242880,30,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DataQT84',8388608,30,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DataQT28',2935808,10,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DataQT14',1468416,10,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DC10',1048576,10,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

INSERT INTO dsp_recharge
VALUES ('932695180',SYSDATE,'DC5',1048576,1,'120000007798120','0','0',NULL,'ct2_mpl_api_1670223919828',NULL);

--UseDCResObj{transaction_id='ct2_mpl_api_1670223919828', code='0', description='null', serial='120000007798120', transaction_id='ct2_mpl_api_1670223919828', dat_amt=4194304, dat_day=30, order_code='QvjNW04TDg7vwB4G3t/90joB+9U=', reseller='0311719703', profile_code='DataQT42'}