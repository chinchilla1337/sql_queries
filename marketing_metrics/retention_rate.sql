SELECT DATE_TRUNC('month',start_date)::DATE AS start_month, start_date,date-start_date AS day_number, 
ROUND(us_num::DECIMAL/MAX(us_num) OVER(PARTITION BY start_date),2) AS retention
FROM (SELECT start_date,date, COUNT(user_id) AS us_num
FROM (SELECT DISTINCT MIN(time) OVER(PARTITION BY user_id)::DATE AS start_date, time::DATE AS date, user_id 
FROM user_actions
ORDER BY user_id) AS t1
GROUP BY start_date,date) AS t2
ORDER BY start_date, day_number
