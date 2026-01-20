"""Смотрим ежедневную выручку с заказов новых пользователей сервиса. Считаем, какую долю она составляет в общей выручке с заказов всех пользователей — и новых, и старых"""

WITH rev AS  (SELECT date, SUM(order_price) AS revenue
FROM 
(SELECT order_id, creation_time::DATE AS date, SUM(price) AS order_price
FROM (SELECT order_id, creation_time, UNNEST(product_ids) AS product_id
FROM orders WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')) AS t1 LEFT JOIN products USING(product_id)
GROUP BY order_id, creation_time) AS t3
GROUP BY date),

first_revenues AS (SELECT date, SUM(order_price) as new_users_revenue FROM (SELECT *
FROM (SELECT user_id,  
MIN(time)::DATE AS paying
FROM user_actions
GROUP BY user_id) AS t5
 JOIN user_actions ON user_actions.user_id = t5.user_id  AND  user_actions.time::DATE = t5.paying JOIN 
 (SELECT order_id, creation_time::DATE AS date, SUM(price) AS order_price
FROM (SELECT order_id, creation_time, UNNEST(product_ids) AS product_id
FROM orders WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order')) AS t1 LEFT JOIN products USING(product_id)
GROUP BY order_id, creation_time) AS t3 USING(order_id)
 WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action='cancel_order' )) AS t676
 GROUP BY date)


SELECT date, revenue, new_users_revenue, ROUND((new_users_revenue*100)/revenue, 2) AS new_users_revenue_share,
(revenue - new_users_revenue)*100/revenue AS old_users_revenue_share
FROM   rev join first_revenues using(date) 
ORDER BY date
