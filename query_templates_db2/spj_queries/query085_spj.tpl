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
define MS = ulist(dist(marital_status, 1, 1), 3);
define ES = ulist(dist(education, 1, 1), 3);
define STATE_LIST_A = sulist(dist(fips_county, 2, 1), 3);
define STATE_LIST_B = sulist(dist(fips_county, 2, 1), 3);
define STATE_LIST_C = sulist(dist(fips_county, 2, 1), 3);
define YEAR = random(1998,2002, uniform);

select min(ws.ws_quantity),
       min(wr.wr_refunded_cash),
       min(wr.wr_fee),
       min(ws.ws_item_sk),
       min(wr.wr_order_number),
       min(cd1.cd_demo_sk),
       min(cd2.cd_demo_sk)
from web_sales as ws,
     web_returns as wr,
     web_page as wp,
     customer_demographics as cd1,
     customer_demographics as cd2,
     customer_address as ca,
     date_dim as dd,
     reason as r
where ws.ws_web_page_sk = wp.wp_web_page_sk
  and ws.ws_item_sk = wr.wr_item_sk
  and ws.ws_order_number = wr.wr_order_number
  and ws.ws_sold_date_sk = dd.d_date_sk
  and dd.d_year = [YEAR]
  and cd1.cd_demo_sk = wr.wr_refunded_cdemo_sk
  and cd2.cd_demo_sk = wr.wr_returning_cdemo_sk
  and ca.ca_address_sk = wr.wr_refunded_addr_sk
  and r.r_reason_sk = wr.wr_reason_sk
  and (
       (
         cd1.cd_marital_status = '[MS.1]'
         and cd1.cd_marital_status = cd2.cd_marital_status
         and cd1.cd_education_status = '[ES.1]'
         and cd1.cd_education_status = cd2.cd_education_status
         and ws.ws_sales_price between 100.00 and 150.00
       )
       or
       (
         cd1.cd_marital_status = '[MS.2]'
         and cd1.cd_marital_status = cd2.cd_marital_status
         and cd1.cd_education_status = '[ES.2]'
         and cd1.cd_education_status = cd2.cd_education_status
         and ws.ws_sales_price between 50.00 and 100.00
       )
       or
       (
         cd1.cd_marital_status = '[MS.3]'
         and cd1.cd_marital_status = cd2.cd_marital_status
         and cd1.cd_education_status = '[ES.3]'
         and cd1.cd_education_status = cd2.cd_education_status
         and ws.ws_sales_price between 150.00 and 200.00
       )
      )
  and (
       (
         ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_A.1]', '[STATE_LIST_A.2]', '[STATE_LIST_A.3]')
         and ws.ws_net_profit between 100 and 200
       )
       or
       (
         ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_B.1]', '[STATE_LIST_B.2]', '[STATE_LIST_B.3]')
         and ws.ws_net_profit between 150 and 300
       )
       or
       (
         ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_C.1]', '[STATE_LIST_C.2]', '[STATE_LIST_C.3]')
         and ws.ws_net_profit between 50 and 250
       )
      )
;
