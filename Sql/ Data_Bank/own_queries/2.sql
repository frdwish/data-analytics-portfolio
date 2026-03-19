/*Find the top 5 customers by total deposit amount (all time).*/

SET search_path TO data_bank; 
SELECT *
FROM customer_transactions,customer_nodes;

SELECT 
      customer_id,
      SUM(txn_amount) AS total_deposit_amount
FROM customer_transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id
ORDER BY total_deposit_amount DESC
LIMIT 5;
	  