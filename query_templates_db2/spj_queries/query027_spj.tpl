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
 define GEN= dist(gender, 1, 1);
 define MS= dist(marital_status, 1, 1);
 define ES= dist(education, 1, 1);
 define STATE=dist(fips_county,3,1);
 define CATEGORY = dist(categories,1,1);

 select min(i.i_item_id),
        min(s.s_state),
        min(ss.ss_quantity),
        min(ss.ss_list_price),
        min(ss.ss_coupon_amt),
        min(ss.ss_sales_price),
        min(ss.ss_item_sk),
        min(ss.ss_ticket_number)
 from store_sales as ss,
      customer_demographics as cd,
      date_dim as dd,
      store as s,
      item as i
 where ss.ss_sold_date_sk = dd.d_date_sk
   and ss.ss_item_sk = i.i_item_sk
   and ss.ss_store_sk = s.s_store_sk
   and ss.ss_cdemo_sk = cd.cd_demo_sk
   and cd.cd_gender = '[GEN]'
   and cd.cd_marital_status = '[MS]'
   and cd.cd_education_status = '[ES]'
   and dd.d_year = [YEAR]
   and s.s_state = '[STATE]'
   and i.i_category = '[CATEGORY]'
 ;

