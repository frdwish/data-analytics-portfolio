/*Q1. Which department uses AI tools the most?*/


SELECT e.department,
COUNT(a.usage_id) AS total_usage
FROM employees e
JOIN ai_usage a
ON e.employee_id = a.employee_id
GROUP BY e.department
ORDER BY total_usage DESC;


/*Ans--->
department      tools_used

"Engineering"	1096
"Product"	     511
"Finance"	     347
"Sales"	         224
"Marketing"	     216
"HR"	         129