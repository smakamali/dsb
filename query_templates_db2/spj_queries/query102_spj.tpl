-- Query 102
--      Find the customer demographics where the customer buys an item from the store and buys it again from web,
--      where the initial purchase could have been made from the web as well.
-- Query type: non PKFK joins
define YEAR = random(1998,2002,uniform);
define STATE = sulist(dist(fips_county, 2, 1), 5);
define MANAGER = sulist(random(1, 100, uniform), 10);
define CATEGORY = sulist(dist(categories,1,1), 3);
define WHOLESALE_COST = range(random(0, 100, uniform), 20);

select 
    min(ss.ss_item_sk),
    min(ss.ss_ticket_number),
    min(ws.ws_order_number),
    min(c.c_customer_sk),
    min(cd.cd_demo_sk),
    min(hd.hd_demo_sk)
from store_sales as ss,
     web_sales as ws,
     date_dim as d1,
     date_dim as d2,
     customer as c,
     inventory as inv,
     store as s,
     warehouse as w,
     item as i,
     customer_demographics as cd,
     household_demographics as hd,
     customer_address as ca
where ss.ss_item_sk = i.i_item_sk
  and ws.ws_item_sk = ss.ss_item_sk
  and ss.ss_sold_date_sk = d1.d_date_sk
  and ws.ws_sold_date_sk = d2.d_date_sk
  and d2.d_date between d1.d_date and (d1.d_date + interval '30 day')
  and ss.ss_customer_sk = c.c_customer_sk
  and ws.ws_bill_customer_sk = c.c_customer_sk
  and ws.ws_warehouse_sk = inv.inv_warehouse_sk
  and ws.ws_warehouse_sk = w.w_warehouse_sk
  and inv.inv_item_sk = ss.ss_item_sk
  and inv.inv_date_sk = ss.ss_sold_date_sk
  and inv.inv_quantity_on_hand >= ss.ss_quantity
  and s.s_state = w.w_state
  and i.i_category IN ('[CATEGORY.1]', '[CATEGORY.2]', '[CATEGORY.3]')
  and i.i_manager_id IN ([MANAGER.1], [MANAGER.2], [MANAGER.3], [MANAGER.4], [MANAGER.5],
                         [MANAGER.6], [MANAGER.7], [MANAGER.8], [MANAGER.9], [MANAGER.10])
  and c.c_current_cdemo_sk = cd.cd_demo_sk
  and c.c_current_hdemo_sk = hd.hd_demo_sk
  and c.c_current_addr_sk = ca.ca_address_sk
  and ca.ca_state in ('[STATE.1]', '[STATE.2]', '[STATE.3]', '[STATE.4]', '[STATE.5]')
  and d1.d_year = [YEAR]
  and ws.ws_wholesale_cost BETWEEN [WHOLESALE_COST.begin] AND [WHOLESALE_COST.end]
;
