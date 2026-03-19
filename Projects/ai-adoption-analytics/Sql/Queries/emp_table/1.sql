/*
Question 1--Which departments have the most employees?
Business value: Understand workforce distribution.
*/

SELECT department,
       COUNT(*) as total_employees
FROM employees
GROUP BY department
ORDER BY total_employees DESC;