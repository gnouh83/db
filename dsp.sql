select * from DSP_COMPANY;
select  * from DSP_SMS_COMMAND;
select * from DSP_SYS_LOG where EXEC_DATETIME>trunc(sysdate) order by LOG_ID desc;