select * from (
select
    dt.com_name DOANH_NGHIEP,
    to_char(t.transaction_id) MA_ORDER,
    s.service_name,
    o.profile_code,
    p.price PRICE,
    o.used_in_period,
    p.price*o.used_in_period TOT_USED,
    o.expired_in_period,
    p.price*o.expired_in_period TOT_EXPIRED,
    p.price*o.not_yet TOT_REMAIN,
    p.price*(o.total - o.used) TOT_START
from dsp_transaction t,dsp_company_leveled dt,rpt_dc_order_summary o, dsp_service_price p,dsp_service s
where t.com_id = dt.com_id
and t.status = 6
and o.order_code = t.res_order_id
and o.sum_dat = to_Date('01/' || ?,'dd/mm/yyyy')
and p.tab_id = t.tab_id
and p.name = o.profile_code
and s.service_id = t.service_id
and dt.top_id = ?
and o.order_id in (select distinct order_id
					from rpt_dc_order_summary
					where sum_dat = to_Date('01/' || ?,'dd/mm/yyyy')
					and (expired_in_period > 0 or used_in_period > 0)
				  )
union all
select
    dt.com_name         DOANH_NGHIEP,
    'API'         		MA_ORDER,
    s.service_name      DICH_VU,
    h.profile    		PROFILE,
    sp.price			DON_GIA,
    sum(amount)/1024    SAN_LUONG,
    sum(h.req_cost)     THANH_TIEN,
    0,
    0,
    0,
    0
from
    dsp_dd_history h, dsp_service_price sp, dsp_service_price_tab st, dsp_service s, dsp_order o,
    dsp_company_leveled dt
where
    h.status = 1
    and h.price_tab_id = sp.tab_id
    and sp.tab_id = st.tab_id
    and st.service_id = s.service_id
    and h.profile = sp.name
    and h.profile is not null
    and h.order_id = o.order_id
    and o.com_id = dt.com_id
    and h.request_time >= to_date('01/' || ?,'dd/mm/yyyy')
    and h.request_time < add_months(to_date('01/' || ?,'dd/mm/yyyy'),1)
    and dt.top_id = ?
group by
    dt.com_name,s.service_name, h.profile,sp.price
)
order by DOANH_NGHIEP, MA_ORDER, service_name, profile_code,price