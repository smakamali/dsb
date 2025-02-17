--
-- Legal Notice
--
-- This document and associated source code (the "Work") is a part of a
-- benchmark specification maintained by the TPC.
--
-- The TPC reserves all right, title, and interest to the Work as provided
-- under U.S. and international laws, including without limitation all patent
-- and trademark rights therein.
--
-- No Warranty
--
-- 1.1 TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE INFORMATION
--     CONTAINED HEREIN IS PROVIDED "AS IS" AND WITH ALL FAULTS, AND THE
--     AUTHORS AND DEVELOPERS OF THE WORK HEREBY DISCLAIM ALL OTHER
--     WARRANTIES AND CONDITIONS, EITHER EXPRESS, IMPLIED OR STATUTORY,
--     INCLUDING, BUT NOT LIMITED TO, ANY (IF ANY) IMPLIED WARRANTIES,
--     DUTIES OR CONDITIONS OF MERCHANTABILITY, OF FITNESS FOR A PARTICULAR
--     PURPOSE, OF ACCURACY OR COMPLETENESS OF RESPONSES, OF RESULTS, OF
--     WORKMANLIKE EFFORT, OF LACK OF VIRUSES, AND OF LACK OF NEGLIGENCE.
--     ALSO, THERE IS NO WARRANTY OR CONDITION OF TITLE, QUIET ENJOYMENT,
--     QUIET POSSESSION, CORRESPONDENCE TO DESCRIPTION OR NON-INFRINGEMENT
--     WITH REGARD TO THE WORK.
-- 1.2 IN NO EVENT WILL ANY AUTHOR OR DEVELOPER OF THE WORK BE LIABLE TO
--     ANY OTHER PARTY FOR ANY DAMAGES, INCLUDING BUT NOT LIMITED TO THE
--     COST OF PROCURING SUBSTITUTE GOODS OR SERVICES, LOST PROFITS, LOSS
--     OF USE, LOSS OF DATA, OR ANY INCIDENTAL, CONSEQUENTIAL, DIRECT,
--     INDIRECT, OR SPECIAL DAMAGES WHETHER UNDER CONTRACT, TORT, WARRANTY,
--     OR OTHERWISE, ARISING IN ANY WAY OUT OF THIS OR ANY OTHER AGREEMENT
--     RELATING TO THE WORK, WHETHER OR NOT SUCH AUTHOR OR DEVELOPER HAD
--     ADVANCE NOTICE OF THE POSSIBILITY OF SUCH DAMAGES.
--
-- Contributors:
--
define YEAR = random(1998, 2002, uniform);
define BP = text({"1001-5000",1},{">10000",1},{"501-1000",1});
define MS = dist(marital_status, 1, 1);
define DEP_COUNT = range(random(0, 9, uniform), 30);
define CATEGORY = sulist(dist(categories,1,1), 3);
define WHOLESALE_COST = range(random (0, 100, uniform), 20);

select
    min(i.i_item_sk),
    min(w.w_warehouse_name),
    min(d1.d_week_seq),
    min(cs.cs_item_sk),
    min(cs.cs_order_number),
    min(inv.inv_item_sk)
from catalog_sales as cs
join inventory as inv
    on (cs.cs_item_sk = inv.inv_item_sk)
join warehouse as w
    on (w.w_warehouse_sk = inv.inv_warehouse_sk)
join item as i
    on (i.i_item_sk = cs.cs_item_sk)
join customer_demographics as cd
    on (cs.cs_bill_cdemo_sk = cd.cd_demo_sk)
join household_demographics as hd
    on (cs.cs_bill_hdemo_sk = hd.hd_demo_sk)
join date_dim as d1
    on (cs.cs_sold_date_sk = d1.d_date_sk)
join date_dim as d2
    on (inv.inv_date_sk = d2.d_date_sk)
join date_dim as d3
    on (cs.cs_ship_date_sk = d3.d_date_sk)
left outer join promotion as p
    on (cs.cs_promo_sk = p.p_promo_sk)
left outer join catalog_returns as cr
    on (cr.cr_item_sk = cs.cs_item_sk and cr.cr_order_number = cs.cs_order_number)
where d1.d_week_seq = d2.d_week_seq
  and inv.inv_quantity_on_hand < cs.cs_quantity
  and d3.d_date > d1.d_date
  and hd.hd_buy_potential = '[BP]'
  and d1.d_year = [YEAR]
  and cd.cd_marital_status = '[MS]'
  and cd.cd_dep_count between [DEP_COUNT.begin] and [DEP_COUNT.end]
  and i.i_category IN ('[CATEGORY.1]', '[CATEGORY.2]', '[CATEGORY.3]')
  and cs.cs_wholesale_cost BETWEEN [WHOLESALE_COST.begin] AND [WHOLESALE_COST.end]
;
