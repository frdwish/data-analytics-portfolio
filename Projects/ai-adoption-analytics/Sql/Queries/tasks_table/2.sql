/*Question 2

Which task types benefit the most from AI?*/

SELECT 
      task_type,
	  ROUND(AVG(estimated_time_min - actual_time_min),2) as average_time_saved
FROM tasks
WHERE ai_used = 'Yes'
GROUP BY task_type
ORDER BY average_time_saved DESC;