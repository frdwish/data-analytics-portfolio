-- Find the second highest deposit amount in 2020.


1--> using offset and limit

SELECT DISTINCT txn_amount 
FROM customer_transactions 
WHERE txn_type = 'deposit' 
  AND txn_date BETWEEN '2020-01-01' AND '2020-12-31'
ORDER BY txn_amount DESC 
LIMIT 1 OFFSET 1;


2-->Using a Subquery 

SELECT MAX(txn_amount) 
FROM customer_transactions 
WHERE txn_type = 'deposit' 
  AND txn_date >= '2020-01-01' AND txn_date <= '2020-12-31'
  AND txn_amount < (
      SELECT MAX(txn_amount) 
      FROM customer_transactions 
      WHERE txn_type = 'deposit' 
        AND txn_date >= '2020-01-01' AND txn_date <= '2020-12-31'
  );

