SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 'mm/yyyy') thang,
       co.com_name                                              ctkv,
       c.bus_code                                               ma_dn,
       c.com_name                                               doanh_nghiep,
       o.order_id,
       (SELECT (1 - paid_cost / contract_value) * 100
        FROM dsp_order
        WHERE order_id = o.order_id)                            tyle_ck,
       o.start_value                                            gt_dauky,
       o.used_value                                             gt_sudung,
       o.remain_value                                           gt_cuoiky,
       o.expired_value                                          gt_hethan
FROM rpt_order_summary o,
     dsp_company_leveled c,
     dsp_company co
WHERE o.sum_date = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
  AND o.com_id = c.com_id
  AND c.top_id = co.com_id;