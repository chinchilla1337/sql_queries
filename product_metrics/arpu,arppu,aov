WITH revenues AS (SELECT date, SUM(order_price) AS revenue
FROM 
(SELECT order_id, creation_time::DATE AS date, SUM(price) AS order_price
FROM (SELECT order_id, creation_time, UNNEST(product_ids) AS product_id
FROM orders WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')) AS t1 LEFT JOIN products USING(product_id)
GROUP BY order_id, creation_time) AS t3
GROUP BY date),

users_and_orders AS (SELECT time::DATE AS date, COUNT(DISTINCT user_id) AS ordinary,
COUNT(DISTINCT user_id) FILTER(WHERE order_id NOT IN(SELECT order_id FROM user_actions WHERE action='cancel_order' )) AS active, 
COUNT(DISTINCT order_id) FILTER(WHERE order_id NOT IN(SELECT order_id FROM user_actions WHERE action='cancel_order' )) AS orderss
FROM user_actions 
GROUP BY date)

SELECT date, ROUND(revenue/ordinary,2) AS arpu, ROUND(revenue/active,2) AS arppu, ROUND(revenue/orderss,2) AS aou
FROM revenues JOIN users_and_orders USING(date)
