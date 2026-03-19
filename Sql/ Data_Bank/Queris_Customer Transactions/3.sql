-- For each month - how many Data Bank customers make more than 1 deposit 
-- and either 1 purchase or 1 withdrawal in a single month?

SET search_path TO data_bank;
SELECT *
FROM customer_transactions;

1--> we need txn_date ,customer_id, count for every txn_type
2--> group by txn_type and using a where function txn_type = 'deposit' which is > 1 same for both widrwal and purchase 
3--> maybe we should group by txn_date for getting single month but all those have unique dates even if month is 

--> LAYER 1
WITH customer_monthly AS (

    SELECT
        customer_id,
        DATE_TRUNC('month', txn_date) AS month,

        -- count deposits
        COUNT(CASE WHEN txn_type = 'deposit' THEN 1 END) AS deposit_count,

        -- count purchases
        COUNT(CASE WHEN txn_type = 'purchase' THEN 1 END) AS purchase_count,

        -- count withdrawals
        COUNT(CASE WHEN txn_type = 'withdrawal' THEN 1 END) AS withdrawal_count

    FROM customer_transactions
    GROUP BY customer_id, month
)

--> LAYER 2
SELECT
    month,
    COUNT(customer_id) AS qualified_customers

FROM customer_monthly

WHERE
    deposit_count > 1
    AND (
        purchase_count >= 1
        OR withdrawal_count >= 1
    )

GROUP BY month
ORDER BY month;
