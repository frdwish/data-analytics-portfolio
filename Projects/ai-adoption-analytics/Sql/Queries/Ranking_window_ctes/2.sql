--Which department performs best in terms of time saved using AI?(Window Function)

SELECT 
    e.department,
    ROUND(AVG(t.estimated_time_min - t.actual_time_min),2) AS avg_time_saved,
    RANK() OVER (ORDER BY AVG(t.estimated_time_min - t.actual_time_min) DESC) AS dept_rank
FROM tasks t
JOIN employees e
ON t.employee_id = e.employee_id
WHERE t.ai_used = 'Yes'
GROUP BY e.department;



/*department.   avg_time_saved  dept_rank

"Product"	    27.42	         1
"Engineering"	27.37	         2
"HR"	        27.04	         3
"Sales"	        27.02	         4
"Finance"	    26.91	         5
"Marketing"	    24.29	         6