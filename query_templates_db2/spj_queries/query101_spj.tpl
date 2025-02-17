-- Query 101
--      Find the cities and item brands where a customer first buys and returns on web, and then buys again from store.
-- Query type: non PKFK joins
define YEAR = random(1998,2000, uniform);
define CATEGORY = sulist(dist(categories,1,1), 3);
define STATE = sulist(dist(fips_county, 2, 1), 5);
define INCOME = range(random(0, 20, uniform), 30);
define BUY_POTENTIAL = dist(buy_potential, 1, 2);
define DISCOUNT = RANGE(RANDOM(0, 100, UNIFORM), 20);

select 
    min(c.c_customer_sk), 
    min(ss.ss_item_sk), 
    min(sr.sr_ticket_number), 
    min(ws.ws_order_number)
from store_sales as ss,
     store_returns as sr,
     web_sales as ws,
     date_dim as d1,
     date_dim as d2,
     item as i,
     customer as c,
     customer_address as ca,
     household_demographics as hd
where ss.ss_ticket_number = sr.sr_ticket_number
  and ss.ss_customer_sk = ws.ws_bill_customer_sk
  and ss.ss_customer_sk = c.c_customer_sk
  and c.c_current_addr_sk = ca.ca_address_sk
  and c.c_current_hdemo_sk = hd.hd_demo_sk
  and ss.ss_item_sk = sr.sr_item_sk
  and sr.sr_item_sk = ws.ws_item_sk
  and i.i_item_sk = ss.ss_item_sk
  and i.i_category IN ('[CATEGORY.1]', '[CATEGORY.2]', '[CATEGORY.3]')
  and sr.sr_returned_date_sk = d1.d_date_sk
  and ws.ws_sold_date_sk = d2.d_date_sk
  and d2.d_date between d1.d_date AND (d1.d_date + interval '90 day')
  and ca.ca_state in ('[STATE.1]', '[STATE.2]', '[STATE.3]', '[STATE.4]', '[STATE.5]')
  and d1.d_year = [YEAR]
  and hd.hd_income_band_sk BETWEEN [INCOME.begin] AND [INCOME.end]
  and hd.hd_buy_potential = '[BUY_POTENTIAL]'
  and ss.ss_sales_price / ss.ss_list_price BETWEEN [DISCOUNT.begin] * 0.01 AND [DISCOUNT.end] * 0.01
;
