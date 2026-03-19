-- What is the average total historical deposit counts and amounts for all customers?

-- SET search_path TO data_bank;
-- SELECT *
-- FROM customer_transactions;

-- 1->average total historical deposit count for all customers
-- 2--> average total ammount for all customers

SET search_path TO data_bank;

SELECT 
       AVG(total_deposit_count) AS avg_deposit_count,
       AVG(total_deposit_amount) AS avg_deposit_amount
FROM (
    SELECT 
           customer_id,
           COUNT(*) AS total_deposit_count,
           SUM(txn_amount) AS total_deposit_amount
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id
) t;
