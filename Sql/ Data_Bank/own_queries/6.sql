-- Find customers who have never made a withdrawal.

SELECT DISTINCT customer_id
FROM customer_transactions
WHERE customer_id NOT IN (
    SELECT customer_id 
    FROM customer_transactions 
    WHERE txn_type = 'withdrawal'
)
ORDER BY customer_id;
