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
 define MS= list(dist(marital_status, 1, 1), 3);
 define ES= list(dist(education, 1, 1), 3);
 define STATE_LIST_A= sulist(dist(fips_county, 2, 1), 3);
 define STATE_LIST_B= sulist(dist(fips_county, 2, 1), 3);
 define STATE_LIST_C= sulist(dist(fips_county, 2, 1), 3);

 select min(ss.ss_quantity)
       ,min(ss.ss_ext_sales_price)
       ,min(ss.ss_ext_wholesale_cost)
       ,min(ss.ss_ext_sales_price)
 from store_sales as ss,
      store as s,
      customer_demographics as cd,
      household_demographics as hd,
      customer_address as ca,
      date_dim as dd
 where s.s_store_sk = ss.ss_store_sk
   and ss.ss_sold_date_sk = dd.d_date_sk
   and dd.d_year = 2001
   and ((ss.ss_hdemo_sk = hd.hd_demo_sk
         and cd.cd_demo_sk = ss.ss_cdemo_sk
         and cd.cd_marital_status = '[MS.1]'
         and cd.cd_education_status = '[ES.1]'
         and ss.ss_sales_price between 100.00 and 150.00
         and hd.hd_dep_count = 3)
        or (ss.ss_hdemo_sk = hd.hd_demo_sk
         and cd.cd_demo_sk = ss.ss_cdemo_sk
         and cd.cd_marital_status = '[MS.2]'
         and cd.cd_education_status = '[ES.2]'
         and ss.ss_sales_price between 50.00 and 100.00
         and hd.hd_dep_count = 1)
        or (ss.ss_hdemo_sk = hd.hd_demo_sk
         and cd.cd_demo_sk = ss.ss_cdemo_sk
         and cd.cd_marital_status = '[MS.3]'
         and cd.cd_education_status = '[ES.3]'
         and ss.ss_sales_price between 150.00 and 200.00
         and hd.hd_dep_count = 1))
   and ((ss.ss_addr_sk = ca.ca_address_sk
         and ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_A.1]', '[STATE_LIST_A.2]', '[STATE_LIST_A.3]')
         and ss.ss_net_profit between 100 and 200)
        or (ss.ss_addr_sk = ca.ca_address_sk
         and ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_B.1]', '[STATE_LIST_B.2]', '[STATE_LIST_B.3]')
         and ss.ss_net_profit between 150 and 300)
        or (ss.ss_addr_sk = ca.ca_address_sk
         and ca.ca_country = 'United States'
         and ca.ca_state in ('[STATE_LIST_C.1]', '[STATE_LIST_C.2]', '[STATE_LIST_C.3]')
         and ss.ss_net_profit between 50 and 250))
;
