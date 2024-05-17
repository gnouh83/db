SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 'mm/yyyy') thang,
       co.com_name                                              ctkv,
       c.com_id                                                 ma_dn,
       c.com_name                                               doanh_nghiep,
       o.order_id,
       (SELECT (1 - paid_cost / contract_value) * 100
        FROM dsp_order
        WHERE order_id = o.order_id)                            tyle_ck,
       NVL((SELECT remain_value
            FROM rpt_order_summary
            WHERE sum_date = TRUNC(ADD_MONTHS(SYSDATE, -2), 'MM')
              AND order_id = o.order_id), 0)                    gt_ton,
       NVL((SELECT contract_value
            FROM dsp_order
            WHERE status IN (2, 3)
              AND TRUNC(activated_date, 'MM') = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
              AND order_id = o.order_id), 0)                    gt_taomoi,
       o.used_value                                             gt_sudung,
       o.remain_value                                           gt_cuoiky,
       o.expired_value                                          gt_hethan,
       a.status                                                 trang_thai
FROM rpt_order_summary o,
     dsp_company_leveled c,
     dsp_company co,
     dsp_order a
WHERE o.sum_date = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
  AND o.com_id = c.com_id
  AND c.top_id = co.com_id
  AND o.order_id = a.order_id;

SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 'mm/yyyy') thang,
       co.com_name                                              ctkv,
       c.bus_code                                               ma_dn,
       c.com_name                                               doanh_nghiep,
       o.order_id,
       (SELECT (1 - paid_cost / contract_value) * 100
        FROM dsp_order
        WHERE order_id = o.order_id
          AND status IN (2, 3))                                 tyle_ck,
       NVL((SELECT remain_value
            FROM rpt_order_summary
            WHERE sum_date = TRUNC(ADD_MONTHS(SYSDATE, -2), 'MM')
              AND order_id = o.order_id), 0)                    gt_ton,
       NVL((SELECT contract_value
            FROM dsp_order
            WHERE status IN (2, 3)
              AND TRUNC(activated_date, 'MM') = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
              AND order_id = o.order_id), 0)                    gt_taomoi,
       o.used_value                                             gt_sudung,
       o.remain_value                                           gt_cuoiky,
       o.expired_value                                          gt_hethan
FROM rpt_order_summary o,
     dsp_company_leveled c,
     dsp_company co
WHERE o.sum_date = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
  AND o.com_id = c.com_id
  AND c.top_id = co.com_id;

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