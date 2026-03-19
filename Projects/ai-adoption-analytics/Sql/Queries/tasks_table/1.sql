/*Question 1

What is the average time saved when AI is used vs not used?*/

SELECT 
    ai_used,
    ROUND(AVG(estimated_time_min - actual_time_min),2) AS avg_time_saved_minutes
FROM tasks
GROUP BY ai_used
ORDER BY ai_used DESC;
