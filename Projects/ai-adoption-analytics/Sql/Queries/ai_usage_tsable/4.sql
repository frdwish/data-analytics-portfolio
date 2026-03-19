/*Question 4

Which days have the highest AI usage?*/


SELECT month,
count(*) as ai_usage
FROM ai_usage
GROUP BY month
ORDER BY ai_usage DESC;

SELECT month, COUNT(*) AS usage_count
FROM ai_usage
GROUP BY month
ORDER BY usage_count DESC;