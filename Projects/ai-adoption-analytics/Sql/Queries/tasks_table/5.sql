/*Question 5

How many tasks are completed using AI vs without AI?*/


SELECT 
    ai_used,
    COUNT(*) AS total_tasks
FROM tasks
GROUP BY ai_used
ORDER BY total_tasks DESC;