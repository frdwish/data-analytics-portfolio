/*Question 3

Does AI improve task quality?*/



SELECT 
      ai_used,
	  ROUND(AVG(quality_score),2) AS avg_quality_score
FROM tasks
GROUP BY ai_used
ORDER BY avg_quality_score DESC;