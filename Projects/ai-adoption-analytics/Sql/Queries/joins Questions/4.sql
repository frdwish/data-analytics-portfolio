/*Q4. Which AI tool leads to better productivity?*/

SELECT a.tool_used,
ROUND(AVG(t.estimated_time_min - t.actual_time_min),2) AS avg_time_saved
FROM ai_usage a
JOIN tasks t
ON a.employee_id = t.employee_id
GROUP BY a.tool_used
ORDER BY avg_time_saved DESC;


tool_used            avg_time_saved
"ChatGPT"	         17.33
"Microsoft Copilot"	 16.92