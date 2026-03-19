SET search_path TO data_bank;
WITH monthly AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', txn_date) AS month,
        SUM(txn_amount) AS monthly_net
    FROM customer_transactions
    GROUP BY customer_id, month
),
closing AS (
    SELECT
        customer_id,
        month,
        SUM(monthly_net) OVER (
            PARTITION BY customer_id
            ORDER BY month
        ) AS closing_balance
    FROM monthly
),
growth AS (
    SELECT
        customer_id,
        month,
        ((closing_balance -
          LAG(closing_balance) OVER (
              PARTITION BY customer_id
              ORDER BY month
          )) /
          LAG(closing_balance) OVER (
              PARTITION BY customer_id
              ORDER BY month
          )
        ) * 100 AS pct_growth
    FROM closing
)
SELECT
    ROUND(
        COUNT(DISTINCT customer_id) * 100.0 /
        (SELECT COUNT(DISTINCT customer_id) FROM customer_transactions),
        2
    ) AS percentage_customers
FROM growth
WHERE pct_growth > 5;
