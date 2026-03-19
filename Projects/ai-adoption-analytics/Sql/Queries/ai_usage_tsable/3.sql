/*Question 3
Which tool requires the most time per session?*/


SELECT tool_used,
ROUND(AVG(time_spent_min),2) AS avg_time_spent
FROM ai_usage
GROUP BY tool_used
ORDER BY avg_time_spent DESC;
