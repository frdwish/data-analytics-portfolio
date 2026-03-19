/*For each region, calculate the total number of unique customers who made 
at least one transaction.*/
-- SET search_path TO data_bank; 
-- SELECT *
-- FROM regions, customer_nodes;

SET search_path TO data_bank;
SELECT 
       r.region_name,
	   COUNT(DISTINCT cn.customer_id) AS unique_customers
FROM customer_nodes cn
JOIN regions r
ON cn.region_id = r.region_id
JOIN customer_transactions ct
ON cn.customer_id = ct.customer_id
GROUP BY r.region_name
ORDER BY r.region_name;

