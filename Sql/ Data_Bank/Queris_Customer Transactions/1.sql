-- What is the unique count and total amount for each transaction type?

-- SET search_path TO data_bank;
-- SELECT *
-- FROM customer_transactions;



SET search_path TO data_bank;
SELECT txn_type,
       COUNT(*),
       SUM(txn_amount)
FROM customer_transactions
GROUP BY txn_type;