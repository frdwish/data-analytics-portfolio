/*Q3. Which employees are high AI users AND high performers?*/


SELECT e.employee_id,
e.department,
COUNT(a.usage_id) AS ai_usage_count,
ROUND(AVG(t.quality_score),2) AS avg_quality
FROM employees e
JOIN ai_usage a ON e.employee_id = a.employee_id
JOIN tasks t ON e.employee_id = t.employee_id
GROUP BY e.employee_id, e.department
ORDER BY ai_usage_count DESC, avg_quality DESC
LIMIT 10;




employee_id department      ai_usage_count avg_quality
5	        "Engineering"	 945	       7.80
60	        "Finance"	     900	       6.87
55	        "Finance"	     870	       7.33
49	        "Product"	     855	       7.60
17	        "Engineering"	 825	       7.67
46	        "Product"	     825	       7.47
74	        "Sales"	         825	       7.13
50	        "Product"	     795	       7.80
2	        "Engineering"	 795	       7.73
53	        "Finance"	     795	       7.40



