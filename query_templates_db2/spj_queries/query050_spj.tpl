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
define MONTH = random(1,12,uniform);
define STATE = sulist(dist(fips_county,2,1),3);
define DAY = random(1, 7, uniform);

select
   min(s.s_store_name),
   min(s.s_company_id),
   min(s.s_street_number),
   min(s.s_street_name),
   min(s.s_suite_number),
   min(s.s_city),
   min(s.s_zip),
   min(ss.ss_ticket_number),
   min(ss.ss_sold_date_sk),
   min(sr.sr_returned_date_sk),
   min(ss.ss_item_sk),
   min(d1.d_date_sk)
from store_sales as ss,
     store_returns as sr,
     store as s,
     date_dim as d1,
     date_dim as d2
where d2.d_moy = [MONTH]
  and ss.ss_ticket_number = sr.sr_ticket_number
  and ss.ss_item_sk = sr.sr_item_sk
  and ss.ss_sold_date_sk = d1.d_date_sk
  and sr.sr_returned_date_sk = d2.d_date_sk
  and ss.ss_customer_sk = sr.sr_customer_sk
  and ss.ss_store_sk = s.s_store_sk
  and sr.sr_store_sk = s.s_store_sk
  and d1.d_date between (d2.d_date - interval '120 day') and d2.d_date
  and d1.d_dow = [DAY]
  and s.s_state in ('[STATE.1]','[STATE.2]','[STATE.3]')
;

