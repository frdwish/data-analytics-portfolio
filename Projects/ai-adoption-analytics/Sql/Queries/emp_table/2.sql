/*
Question 2--What is the average salary by role level?
Business value: Check salary structure.
*/

SELECT
	  role_level,
	  ROUND(AVG(salary_lpa),2) AS average_salary
FROM employees
GROUP BY role_level
ORDER BY average_salary DESC;

	   



