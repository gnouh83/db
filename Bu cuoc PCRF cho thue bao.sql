--Buoc 1:
/*
Tìm thông tin thẻ gạch thành công mà cộng dịch vụ bị lỗi. Thay thế số thuê bao, serial thẻ, ngày thực hiện (phải có thông tin này vì bảng dữ liệu log rất lớn).
Kiểm tra đúng là bị gạch thẻ lỗi mới bù (bỏ serial đi sẽ ra cả bản ghi log cộng dịch vụ)
*/
SELECT TRANS_ID,response,amount,a.* FROM dsp_sys_log a WHERE isdn = '904186790' AND exec_datetime >= TO_DATE ('12/01/2023', 'dd/mm/yyyy')
AND exec_datetime < TO_DATE ('13/01/2023', 'dd/mm/yyyy') + 1
AND response LIKE '%517001723499%'
ORDER BY exec_datetime;
--Bước 2:
/*
Lấy thông tin profile thẻ từ cột response của log gạch thẻ. Ví dụ:
profile thẻ là: DataQT14
UseDCResObj{transaction_id='545497', code='0', description='null', serial='5000000001839083', transaction_id='545497', dat_amt=1434, dat_day=10, order_code='100002684', reseller='1', profile_code='DataQT14'}
*/
--Bước 3:
/*
Insert bản ghi vào bảng dsp_recharge tương ứng với profile như dưới đây. Nếu profile nào chưa có thì thêm inser tương ứng với thông tin về dung lượng và ngày sử dụng.
Nhớ COMMIT;
*/
SELECT * FROM dsp_recharge WHERE isdn = '904186790' ORDER BY issue_date;
COMMIT;
/*rollback;*/

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT42',4194304,30,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT56',5242880,30,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT84',8388608,30,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT28',2935808,10,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT14',1468416,10,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DC10',1048576,10,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DC5',1048576,1,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DataQT150',3145728,30,'517001723499','0','0',NULL,'568011',NULL);

INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DC_ADDON_1GB',1048576,31,'517001723499','0','1',NULL,'568011',NULL);



--------------------------------------------------------------------------------
INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'DFD60',4194304,30,'517001723499','0','0',NULL,'568011',NULL);
INSERT INTO dsp_recharge
VALUES ('904186790',SYSDATE,'C90N',4194304,30,'517001723499','0','0',NULL,'568011',NULL);
--------------------------------------------------------------------------------