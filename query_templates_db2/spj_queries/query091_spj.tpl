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
define YEAR = random(1998,2002, uniform);
define MONTH = random(1,12,uniform);
define BUY_POTENTIAL = text({"1001-5000",1},{">10000",1},{"501-1000",1},{"0-500",1},{"Unknown",1},{"5001-10000",1});
define GMT = text({"-6",1},{"-7",1});

select  
    min(cc.cc_call_center_id),
    min(cc.cc_name),
    min(cc.cc_manager),
    min(cr.cr_net_loss),
    min(cr.cr_item_sk),
    min(cr.cr_order_number)
from call_center as cc,
     catalog_returns as cr,
     date_dim as dd,
     customer as c,
     customer_address as ca,
     customer_demographics as cd,
     household_demographics as hd
where cr.cr_call_center_sk = cc.cc_call_center_sk
  and cr.cr_returned_date_sk = dd.d_date_sk
  and cr.cr_returning_customer_sk = c.c_customer_sk
  and cd.cd_demo_sk = c.c_current_cdemo_sk
  and hd.hd_demo_sk = c.c_current_hdemo_sk
  and ca.ca_address_sk = c.c_current_addr_sk
  and dd.d_year = [YEAR]
  and dd.d_moy = [MONTH]
  and (
       (cd.cd_marital_status = 'M' and cd.cd_education_status = 'Unknown')
       or (cd.cd_marital_status = 'W' and cd.cd_education_status = 'Advanced Degree')
      )
  and hd.hd_buy_potential like '[BUY_POTENTIAL]%'
  and ca.ca_gmt_offset = [GMT]
;

