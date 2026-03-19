--For each month, calculate:

-- Total deposits

-- Total withdrawals

-- Net balance change


WITH monthly_totals AS (
    SELECT
        DATE_TRUNC('month', txn_date) AS month,
        SUM(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END) AS total_deposits,
        SUM(CASE WHEN txn_type = 'withdrawal' THEN txn_amount ELSE 0 END) AS total_withdrawals
    FROM customer_transactions
    GROUP BY month
)

SELECT
    month,
    total_deposits,
    total_withdrawals,
    total_deposits - total_withdrawals AS net_balance_change
FROM monthly_totals
ORDER BY month;