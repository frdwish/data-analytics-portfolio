-- Find customers who made deposits in every month of 2020.

-- SET search_path TO data_bank; 
-- SELECT *
-- FROM customer_transactions;


SET search_path TO data_bank; 
SELECT
       customer_id
FROM customer_transactions
WHERE txn_type = 'deposit'
  AND EXTRACT(YEAR FROM txn_date) = 2020
GROUP BY customer_id
HAVING COUNT(DISTINCT DATE_TRUNC('month', txn_date)) = 12;