--  Query 100
--      Find 2 products that are sold together frequently, ordered by how frequently they are sold together.
--  Query type: self-joins, PKFK joins
define YEAR = random(1998,2000,uniform);
define CATEGORY = sulist(dist(categories,1,1), 2);
define MANAGER = range(random(1, 100, uniform), 20);
define MS = dist(marital_status, 1, 1);
define ES = dist(education, 1, 1);
define PRICE = range(random(1, 300, uniform), 5);

select 
    min(item1.i_item_sk),
    min(item2.i_item_sk),
    min(s1.ss_ticket_number),
    min(s1.ss_item_sk)
FROM item as item1,
     item as item2,
     store_sales as s1,
     store_sales as s2,
     date_dim as dd,
     customer as c,
     customer_address as ca,
     customer_demographics as cd
WHERE item1.i_item_sk < item2.i_item_sk
  AND s1.ss_ticket_number = s2.ss_ticket_number
  AND s1.ss_item_sk = item1.i_item_sk
  AND s2.ss_item_sk = item2.i_item_sk
  AND s1.ss_customer_sk = c.c_customer_sk
  AND c.c_current_addr_sk = ca.ca_address_sk
  AND c.c_current_cdemo_sk = cd.cd_demo_sk
  AND dd.d_year between [YEAR] and [YEAR] + 1
  AND dd.d_date_sk = s1.ss_sold_date_sk
  AND item1.i_category in ('[CATEGORY.1]', '[CATEGORY.2]')
  AND item2.i_manager_id between [MANAGER.begin] and [MANAGER.end]
  AND cd.cd_marital_status = '[MS]'
  AND cd.cd_education_status = '[ES]'
  AND s1.ss_list_price between [PRICE.begin] and [PRICE.end]
  AND s2.ss_list_price between [PRICE.begin] and [PRICE.end]
;
