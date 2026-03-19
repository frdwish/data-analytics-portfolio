/*
Question 4--How many employees joined each year?
Business value: Hiring trends.
*/

SELECT
	  joining_year AS join_year,
	  COUNT(*) as hires
FROM employees
GROUP BY joining_year
ORDER BY joining_year;



