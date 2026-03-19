-- For each customer, find the month in which they made their highest deposit.


-- SET search_path TO data_bank; 
-- SELECT *
-- FROM customer_transactions;


-- cutomer/month/highest deposit
-- 1st we need the customer id for sure
-- 2nd we need month and where txn_type is deposit 
-- 3rd 




SET search_path TO data_bank;
WITH monthly_deposits AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', txn_date) AS month,
        SUM(txn_amount) AS total_deposit
    FROM customer_transactions
    WHERE txn_type = 'deposit'
    GROUP BY customer_id, month
)

SELECT customer_id, month, total_deposit
FROM (
    SELECT *,
           RANK() OVER (
               PARTITION BY customer_id
               ORDER BY total_deposit DESC
           ) AS rnk
    FROM monthly_deposits
) t
WHERE rnk = 1
ORDER BY customer_id;