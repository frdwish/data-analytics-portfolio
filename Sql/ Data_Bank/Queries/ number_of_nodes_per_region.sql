--What is the number of nodes per region?

-- SET search_path TO data_bank;
-- SELECT region_id,
--                 COUNT(DISTINCT node_id) as node_count
-- FROM customer_nodes
-- GROUP BY region_id
-- ORDER BY region_id;

-- optimal one 

SET search_path TO data_bank;

SELECT r.region_name,
       COUNT(DISTINCT cn.node_id) AS node_count
FROM customer_nodes cn
JOIN regions r
ON cn.region_id = r.region_id
GROUP BY r.region_name
ORDER BY r.region_name;



