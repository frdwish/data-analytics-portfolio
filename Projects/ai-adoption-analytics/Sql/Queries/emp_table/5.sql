/*
Question 5--Which role level has the highest number of employees?
Business value: Workforce structure.
*/

SELECT 
     role_level,
	 COUNT(*) AS number_employees
FROM employees
GROUP BY role_level
ORDER BY number_employees DESC;






