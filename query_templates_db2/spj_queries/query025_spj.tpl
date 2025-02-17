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
 define YEAR= random(1998,2002, uniform); 
 define MONTH= random(1,10, uniform); 
 
 select
   min(i.i_item_id),
   min(i.i_item_desc),
   min(s.s_store_id),
   min(s.s_store_name),
   min(ss.ss_net_profit),
   min(sr.sr_net_loss),
   min(cs.cs_net_profit),
   min(ss.ss_item_sk),
   min(sr.sr_ticket_number),
   min(cs.cs_order_number)
 from store_sales as ss,
      store_returns as sr,
      catalog_sales as cs,
      date_dim as d1,
      date_dim as d2,
      date_dim as d3,
      store as s,
      item as i
 where d1.d_moy = [MONTH]
   and d1.d_year = [YEAR]
   and d1.d_date_sk = ss.ss_sold_date_sk
   and i.i_item_sk = ss.ss_item_sk
   and s.s_store_sk = ss.ss_store_sk
   and ss.ss_customer_sk = sr.sr_customer_sk
   and ss.ss_item_sk = sr.sr_item_sk
   and ss.ss_ticket_number = sr.sr_ticket_number
   and sr.sr_returned_date_sk = d2.d_date_sk
   and d2.d_moy between [MONTH] and [MONTH] + 2
   and d2.d_year = [YEAR]
   and sr.sr_customer_sk = cs.cs_bill_customer_sk
   and sr.sr_item_sk = cs.cs_item_sk
   and cs.cs_sold_date_sk = d3.d_date_sk
   and d3.d_moy between [MONTH] and [MONTH] + 2
   and d3.d_year = [YEAR]
 ;
