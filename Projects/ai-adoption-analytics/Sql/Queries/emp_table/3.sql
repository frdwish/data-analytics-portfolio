/*
Question 3--Which department has the highest total salary cost?
Business value: Understand department expenses.
*/

SELECT 
      department,
	  SUM(salary_lpa) AS total_salary_cost
FROM employees
GROUP BY department
ORDER BY total_salary_cost DESC;


-- highest dept
SELECT 
    department,
    SUM(salary_lpa) AS highest_salary_department
FROM employees
GROUP BY department
ORDER BY highest_salary_department DESC
LIMIT 1;



	   



