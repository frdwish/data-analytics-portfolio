-- How many days on average are customers reallocated to a different node?
-- SET search_path TO data_bank;
-- SELECT *
-- FROM customer_nodes




SELECT 
       AVG(end_date - start_date) AS avg_days
FROM customer_nodes
WHERE end_date IS NOT NULL;




---- sum (start_date- end_date )  group by node_id 



