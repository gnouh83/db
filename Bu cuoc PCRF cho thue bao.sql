SELECT TRANS_ID,response,a.* FROM dsp_sys_log a WHERE isdn = '937450793' AND exec_datetime >= TO_DATE ('01/09/2022', 'dd/mm/yyyy')
/*AND exec_datetime < TO_DATE ('13/09/2022', 'dd/mm/yyyy') + 1*/
AND response LIKE '%020000004380747%' ORDER BY exec_datetime;

SELECT * FROM dsp_recharge WHERE isdn = '937450793' ORDER BY issue_date;
COMMIT;
/*rollback;*/
--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DataQT42',4194304,30,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DataQT56',5242880,30,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DataQT84',8388608,30,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DataQT28',2935808,10,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DataQT14',1468416,10,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DC10',1048576,10,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

INSERT INTO dsp_recharge
VALUES ('937450793',SYSDATE,'DC5',1048576,1,'020000004380747','0','0',NULL,'ct5_duygia_api_1663658563439',NULL);

--UseDCResObj{transaction_id='ct5_duygia_api_1663658563439', code='0', description='null', serial='020000004380747', transaction_id='ct5_duygia_api_1663658563439', dat_amt=4194304, dat_day=30, order_code='QvjNW04TDg7vwB4G3t/90joB+9U=', reseller='0311719703', profile_code='DataQT42'}