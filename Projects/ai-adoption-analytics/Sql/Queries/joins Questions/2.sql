/*Q2. Does AI improve productivity across departments?*/


SELECT e.department,
ROUND(AVG(t.estimated_time_min - t.actual_time_min),2) AS avg_time_saved
FROM tasks t
JOIN employees e
ON t.employee_id = e.employee_id
WHERE t.ai_used = 'Yes'
GROUP BY e.department
ORDER BY avg_time_saved DESC;




department    avg_time_saved

"Engineering"	27.4
"Product"	    27.4
"HR"	        27.0
"Sales"	        27.0
"Finance"	    26.9
"Marketing"	    24.3