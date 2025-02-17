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
 define YEAR= random(1998, 2002, uniform);
 define MONTH=random(1,12,uniform);
 define CATEGORY = dist(categories,1,1);
 define STATE=dist(fips_county,3,1);
 define BIRTH_MONTH = random(1, 12, uniform);
 define WHOLESALE_COST = range(random (0, 100, uniform), 20);

 select min(i.i_brand_id),
        min(i.i_manufact_id),
        min(ss.ss_ext_sales_price)
 from date_dim as dd,
      store_sales as ss,
      item as i,
      customer as c,
      customer_address as ca,
      store as s
 where dd.d_date_sk = ss.ss_sold_date_sk
   and ss.ss_item_sk = i.i_item_sk
   and ss.ss_customer_sk = c.c_customer_sk
   and c.c_current_addr_sk = ca.ca_address_sk
   and ss.ss_store_sk = s.s_store_sk
   and i.i_category  = '[CATEGORY]'
   and dd.d_year = [YEAR]
   and dd.d_moy = [MONTH]
   and substring(ca.ca_zip,1,5) <> substring(s.s_zip,1,5)
   and ca.ca_state  = '[STATE]'
   and c.c_birth_month = [BIRTH_MONTH]
   and ss.ss_wholesale_cost BETWEEN [WHOLESALE_COST.begin] AND [WHOLESALE_COST.end]
 ;
