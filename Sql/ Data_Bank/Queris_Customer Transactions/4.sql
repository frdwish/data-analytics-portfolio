-- What is the closing balance for each customer at the end of the month?

SET search_path TO data_bank;
SELECT *
FROM customer_transactions;



1--> WE NEED CUSTOMER ID AND FOR SURE WE WILL GROUP BY 
2--> WE NEED TO FIND THE TOTAL AMOUNT OF TXN_AMOUNT WHICH IS START WITH MONTH OF LETS SAY 01
-- AND END IN 02 , SO FROM 01-02 WE NEED TO FIND THAT TOTAL AMOUNT WHICH IS REFFRED AS CLOSING AMMOUNT


--> Monthly net amount
WITH monthly AS (
    SELECT
        customer_id,
        DATE_TRUNC('month', txn_date) AS month,
        SUM(txn_amount) AS monthly_net
    FROM customer_transactions
    GROUP BY customer_id, month
)

SELECT
    customer_id,
    month,
    monthly_net,
    SUM(monthly_net) OVER (
        PARTITION BY customer_id
        ORDER BY month
    ) AS closing_balance
FROM monthly
ORDER BY customer_id, month;



