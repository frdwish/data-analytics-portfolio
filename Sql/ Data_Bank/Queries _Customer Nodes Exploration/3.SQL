
--> QUESTION-->How many customers are allocated to each region?
-- -- we need customer id sum of customer id whihc will do group by region_name
-- -- we need only region name as region and their total_customers
SELECT 
       regions.region_name AS region,
       COUNT(DISTINCT customer_nodes.customer_id) AS total_customers
FROM customer_nodes
INNER JOIN regions
ON customer_nodes.region_id = regions.region_id
GROUP BY regions.region_name;
