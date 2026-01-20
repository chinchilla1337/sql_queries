WITH rev AS (SELECT date, SUM(revenue) OVER(ORDER BY date) AS total_revenue 
FROM (SELECT date, SUM(order_price) AS revenue
FROM 
(SELECT order_id, creation_time::DATE AS date, SUM(price) AS order_price
FROM (SELECT order_id, creation_time, UNNEST(product_ids) AS product_id
FROM orders WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')) AS t1 LEFT JOIN products USING(product_id)
GROUP BY order_id, creation_time) AS t3
GROUP BY date) AS t66),

us AS (SELECT date, SUM(ord) OVER(ORDER BY date) AS total_ord, SUM(pay) OVER(ORDER BY date) AS total_pay
FROM (SELECT ordinary::DATE AS date, COUNT(DISTINCT user_id) AS ord FROM (SELECT user_id, MIN(time) AS ordinary
FROM user_actions 
GROUP BY user_id) AS t2334 
GROUP BY date) AS t00 JOIN (SELECT paying::DATE AS date, COUNT(DISTINCT user_id) AS pay FROM (SELECT user_id,  MIN(time) FILTER(WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order' )) AS paying
FROM user_actions
GROUP BY user_id) AS t5
GROUP BY date) AS t42 USING(date)),

ords AS (SELECT date, SUM(orderss) OVER(ORDER BY date) AS total_orders FROM 
(SELECT creation_time::DATE AS date, COUNT(order_id) AS orderss
FROM orders
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action ='cancel_order')
GROUP BY date) AS t233)
                     


SELECT date,
       round(total_revenue/total_ord, 2) as running_arpu, 
       round(total_revenue/total_pay, 2) as running_arppu,
       round(total_revenue/total_orders, 2) as running_aov
       
FROM   rev join us using(date) JOIN ords USING(date)
ORDER BY date
