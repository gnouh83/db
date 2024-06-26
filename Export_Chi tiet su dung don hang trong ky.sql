SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 'mm/yyyy') thang,
       z.ctkv,
       z.ma_dn,
       z.doanh_nghiep,
       z.ma_order,
       z.profile_code                                           ten_datacode,
       z.price                                                  don_gia,
       z.service_name                                           dv_sudung,
       SUM(z.not_yet_ton)                                       sl_ton,
       SUM(z.taomoi)                                            sl_taomoi,
       SUM(z.used_in_period)                                    sl_tieudung,
       SUM(z.not_yet)                                           sl_cuoiky,
       SUM(z.expired_in_period)                                 sl_hethan
FROM (SELECT (SELECT com_name FROM dsp_company WHERE com_id = dt.top_id) ctkv,
             dt.com_id                                                   ma_dn,
             dt.com_name                                                 doanh_nghiep,
             TO_CHAR(t.transaction_id)                                   ma_order,
             s.service_name,
             o.profile_code,
             p.price                                                     price,
             o.used_in_period,
             p.price * o.used_in_period                                  tot_used,
             o.expired_in_period,
             p.price * o.expired_in_period                               tot_expired,
             o.not_yet                                                   not_yet,
             p.price * (o.total - o.used)                                tot_start,
             NVL((SELECT not_yet
                  FROM rpt_dc_order_summary
                  WHERE sum_dat = TRUNC(ADD_MONTHS(SYSDATE, -2), 'MM')
                    AND order_id = o.order_id
                    AND profile_code = o.profile_code), 0)               not_yet_ton,
             0                                                           taomoi
      FROM dsp_transaction t,
           dsp_company_leveled dt,
           rpt_dc_order_summary o,
           dsp_service_price p,
           dsp_service s
      WHERE t.com_id = dt.com_id
        AND t.status = 6
        AND o.order_code = t.res_order_id
        AND o.sum_dat = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        AND p.tab_id = t.tab_id
        AND p.name = o.profile_code
        AND s.service_id = t.service_id
        AND o.order_id IN (SELECT DISTINCT order_id
                           FROM rpt_dc_order_summary
                           WHERE sum_dat = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
                             AND (expired_in_period > 0 OR used_in_period > 0  OR not_yet > 0))
      UNION ALL
      SELECT c.com_name         ctkv,
             dt.com_id          ma_dn,
             dt.com_name        doanh_nghiep,
             'API'              ma_order,
             s.service_name     dich_vu,
             h.profile          profile,
             sp.price           don_gia,
             SUM(amount) / 1024 san_luong,
             SUM(h.req_cost)    thanh_tien,
             0,
             0,
             0,
             0,
             0,
             0
      FROM dsp_dd_history h,
           dsp_service_price sp,
           dsp_service_price_tab st,
           dsp_service s,
           dsp_order o,
           dsp_company_leveled dt,
           dsp_company c
      WHERE h.status = 1
        AND h.price_tab_id = sp.tab_id
        AND sp.tab_id = st.tab_id
        AND st.service_id = s.service_id
        AND h.profile = sp.name
        AND h.profile IS NOT NULL
        AND h.order_id = o.order_id
        AND o.com_id = dt.com_id
        AND c.com_id = dt.top_id
        AND h.request_time >= TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        AND h.request_time < ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 1)
      GROUP BY c.com_name, dt.com_id, dt.com_name, s.service_name, h.profile, sp.price
      UNION ALL
      SELECT c.com_name                ctkv,
             dt.com_id                 ma_dn,
             dt.com_name               doanh_nghiep,
             TO_CHAR(t.transaction_id) ma_order,
             s.service_name            dich_vu,
             h.card_name               profile,
             p.price                   don_gia,
             h.amount                  san_luong,
             SUM(ot.amount)            thanh_tien,
             0,
             0,
             0,
             0,
             0,
             0
      FROM dsp_dc_history h,
           dsp_service_price p,
           dsp_transaction t,
           dsp_service s,
           dsp_order_transaction ot,
           dsp_company_leveled dt,
           dsp_order o,
           dsp_company c
      WHERE TO_CHAR(t.transaction_id) = h.transaction_id
        AND t.service_id = s.service_id
        AND o.order_id = ot.order_id
        AND t.status = 6
        AND t.transaction_id = ot.transaction_id
        AND h.status = '1'
        AND h.channel = 'W2GRequest'
        AND o.com_id = dt.com_id
        AND h.price_id = p.price_id
        AND c.com_id = dt.top_id
        AND h.request_time >= TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        AND h.request_time
          < ADD_MONTHS(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 1)
      GROUP BY c.com_name, dt.com_id, dt.com_name, t.transaction_id, s.service_name, h.card_name, p.price, h.amount
      UNION ALL
      SELECT (SELECT com_name FROM dsp_company WHERE com_id = f.top_id) ctkv,
             d.com_id                                                   ma_dn,
             d.com_name                                                 doanh_nghiep,
             TO_CHAR(a.transaction_id)                                  ma_order,
             c.service_name                                             dich_vu,
             card_name,
             e.price                                                    don_gia,
             0,
             b.total_cost                                               thanh_tien,
             0,
             0,
             0,
             0,
             0,
             b.amount                                                   taomoi
      FROM dsp_transaction a,
           dsp_dc_detail b,
           dsp_service c,
           dsp_company d,
           dsp_service_price e,
           dsp_company_leveled f
      WHERE a.transaction_id = b.transaction_id
        AND a.com_id = d.com_id
        AND a.service_id = c.service_id
        AND b.price_id = e.price_id
        AND a.com_id = f.com_id
        AND a.status IN (3, 6)
        AND b.request_time >= TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM')
        AND b.request_time < TRUNC(SYSDATE, 'MM')) z
GROUP BY TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM'), 'mm/yyyy'),
         z.ctkv,
         z.ma_dn,
         z.doanh_nghiep,
         z.ma_order,
         z.profile_code,
         z.price,
         z.service_name
ORDER BY doanh_nghiep, ma_order, service_name, profile_code, price;