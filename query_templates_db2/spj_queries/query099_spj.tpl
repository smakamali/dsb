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
define DMS = random(1176,1212, uniform);
define PRICE = range(random(1, 300, uniform), 10);
define MODE_TYPE = dist(ship_mode_type, 1, 1);
define CLASS = dist(call_center_class, 1, 1);
define GMT_OFFSET = random(-5, -7, uniform);

select 
    min(w.w_warehouse_name),
    min(sm.sm_type),
    min(cc.cc_name),
    min(cs.cs_order_number),
    min(cs.cs_item_sk)
from catalog_sales as cs,
     warehouse as w,
     ship_mode as sm,
     call_center as cc,
     date_dim as dd
where dd.d_month_seq between [DMS] and [DMS] + 23
  and cs.cs_ship_date_sk = dd.d_date_sk
  and cs.cs_warehouse_sk = w.w_warehouse_sk
  and cs.cs_ship_mode_sk = sm.sm_ship_mode_sk
  and cs.cs_call_center_sk = cc.cc_call_center_sk
  and cs.cs_list_price between [PRICE.begin] and [PRICE.end]
  and sm.sm_type = '[MODE_TYPE]'
  and cc.cc_class = '[CLASS]'
  and w.w_gmt_offset = [GMT_OFFSET]
;
