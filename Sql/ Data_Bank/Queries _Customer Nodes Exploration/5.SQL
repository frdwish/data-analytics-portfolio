--  What is the median, 
-- 80th and 95th percentile for this same reallocation days metric for each region?

WITH reallocation_days AS (
    SELECT 
           r.region_name,
           (cn.end_date - cn.start_date) AS days
    FROM customer_nodes cn
    JOIN regions r
    ON cn.region_id = r.region_id
    WHERE cn.end_date IS NOT NULL
)

SELECT 
       region_name,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY days) AS median,
       PERCENTILE_CONT(0.8) WITHIN GROUP (ORDER BY days) AS p80,
       PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY days) AS p95
FROM reallocation_days
GROUP BY region_name
ORDER BY region_name;

