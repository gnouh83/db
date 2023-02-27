--Buoc 1: Dua vao isdn, serial, exec_datetime tìm thông tin gach the thanh cong
SELECT TRANS_ID,response,amount,a.* FROM dsp_sys_log a WHERE isdn = '936195316' AND exec_datetime >= TO_DATE ('1/10/2022', 'dd/mm/yyyy')
AND exec_datetime < TO_DATE ('01/02/2023', 'dd/mm/yyyy') + 1
AND response LIKE '%5000000001348567%'
ORDER BY exec_datetime;
--Buoc 2: Kiem tra lai xem da INSERT chua (thong thuong chi co 1 ban ghi, neu nhieu ban ghi phai kiem tra lai tranh bu lap nhieu lan)
--Sua do COMMIT
SELECT * FROM dsp_recharge WHERE isdn = '934863882' ORDER BY issue_date;
COMMIT;
/*rollback;*/
--Buoc 2: Dua vao response de biet profile the la gi roi chon INSERT tuong ung. Thay TRANS_ID vao cot gan cuoi cau lenh INSERT, vi du '567887' voi profile DataQT42
INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT42',4194304,30,'510000755576','0','0',NULL,'567887',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT56',5242880,30,'510000755576','0','0',NULL,'ct2_mpl_api_1672717588454',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT84',8388608,30,'510000755576','0','0',NULL,'566832',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT28',2935808,10,'510000755576','0','0',NULL,'571307',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT14',1468416,10,'510000755576','0','0',NULL,'567499',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DC10',1048576,10,'510000755576','0','0',NULL,'567410',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DC5',1048576,1,'510000755576','0','0',NULL,'ct2_mpl_api_1672717699340',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DataQT150',3145728,30,'510000755576','0','0',NULL,'ct2_mpl_api_1672717699340',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DC_ADDON_1GB',1048576,31,'510000755576','0','1',NULL,'ct2_mpl_api_1672717638772',NULL);

INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DC_ADDON_3GB',3145728,31,'510000755576','0','1',NULL,'ct2_mpl_api_1671787324628',NULL);



--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'DFD60',4194304,30,'510000755576','0','0',NULL,'ct2_mpl_api_1672717699340',NULL);
INSERT INTO dsp_recharge
VALUES ('934863882',SYSDATE,'C90N',4194304,30,'510000755576','0','0',NULL,'ct2_mpl_api_1672717699340',NULL);
--------------------------------------------------------------------------------