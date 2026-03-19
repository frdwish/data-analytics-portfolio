--Do top AI users perform better than others?(CTE + Window)

WITH ai_usage_ranked AS (
    SELECT 
        employee_id,
        COUNT(*) AS usage_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS usage_rank
    FROM ai_usage
    GROUP BY employee_id
),

performance AS (
    SELECT 
        employee_id,
        ROUND(AVG(quality_score),2) AS avg_quality
    FROM tasks
    GROUP BY employee_id
)

SELECT 
    a.employee_id,
    a.usage_count,
    a.usage_rank,
    p.avg_quality
FROM ai_usage_ranked a
JOIN performance p
ON a.employee_id = p.employee_id
ORDER BY a.usage_rank
LIMIT 10;

/*employee_id usage_count usage_rank avg_quality

60	             60	       2	     6.87
5	             63	       1	     7.80
55	             58	       3	     7.33
49	             57	       4	     7.60
74	             55	       5	     7.13
46	             55	       5	     7.47
17	             55	       5	     7.67
50	             53	       8	     7.80
53	             53	       8	     7.40
2	             53	       8	     7.73