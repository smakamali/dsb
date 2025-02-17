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
 define YEAR=random(1998,2002,uniform);
 define SALES_DATE_BEGIN = date([YEAR] || '-01-31', sales);
 define SALES_DATE_END   = date([YEAR] || '-07-01', sales);
 define SALES_DATE=date([YEAR]+"-01-31",[YEAR]+"-7-01",sales);
 define CATEGORY = dist(categories,1,1);
 define COST = range(random(1, 100, uniform), 20);
 define MANAGER = range(random(1, 100, uniform), 40);
 define REASON = random(1, 75, uniform);

 select
   min(w.w_state),
   min(i.i_item_id),
   min(cs.cs_item_sk),
   min(cs.cs_order_number),
   min(cr.cr_item_sk),
   min(cr.cr_order_number)
 from catalog_sales as cs
      left outer join catalog_returns as cr on
         (cs.cs_order_number = cr.cr_order_number
          and cs.cs_item_sk = cr.cr_item_sk),
      warehouse as w,
      item as i,
      date_dim as dd
 where i.i_item_sk = cs.cs_item_sk
   and cs.cs_warehouse_sk = w.w_warehouse_sk
   and cs.cs_sold_date_sk = dd.d_date_sk
   and dd.d_date between cast('[SALES_DATE_BEGIN]' as date)
                      and cast('[SALES_DATE_END]' as date)
   and i.i_category = '[CATEGORY]'
   and i.i_manager_id between [MANAGER.begin] and [MANAGER.end]
   and cs.cs_wholesale_cost between [COST.begin] and [COST.end]
   and cr.cr_reason_sk = [REASON]
;
