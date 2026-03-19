--Who are the top 5 employees based on quality score and productivity?(ranking+cte)

WITH performance AS (
    SELECT 
        employee_id,
        ROUND(AVG(quality_score),2) AS avg_quality,
        ROUND(AVG(estimated_time_min - actual_time_min),2) AS avg_time_saved
    FROM tasks
    GROUP BY employee_id
)

SELECT *,
RANK() OVER (ORDER BY avg_quality DESC, avg_time_saved DESC) AS rank
FROM performance
LIMIT 5;


/*
employee_id     avg_quality   avg_time_saved   rank
4	            8.07	      23.47	           1
26	            8.07	      22.00	           2
93	            8.07	      20.73	           3
27	            8.00	      25.27	           4
63	            8.00	      22.40	           5
*/