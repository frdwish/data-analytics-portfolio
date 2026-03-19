/*Question 4

Which tasks take the most time on average?*/



SELECT 
    task_type,
    COUNT(*) AS total_tasks,
    ROUND(AVG(actual_time_min),2) AS average_time_minutes
FROM tasks
GROUP BY task_type
ORDER BY average_time_minutes DESC;