CREATE TABLE customer_sales (
id INT PRIMARY KEY,
transaction_value DECIMAL(10, 2),
created_at TIMESTAMP
);

INSERT INTO customer_sales (id, transaction_value, created_at)
VALUES
(1, 50.00, '2025-01-23 10:15:00'),
(2, 30.00, '2025-01-23 15:45:00'),
(3, 20.00, '2025-01-23 18:30:00'),
(4, 45.00, '2025-01-24 09:20:00'),
(5, 60.00, '2025-01-24 22:10:00'),
(6, 25.00, '2025-01-25 11:30:00'),
(7, 35.00, '2025-01-25 14:50:00'),
(8, 55.00, '2025-01-25 19:05:00');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

---QUESTION
/*Given a table of customer sales in a retail store with columns id, transaction_value, and created_at representing the date and time for each transaction, write a query to get the last transaction for each day.

The output should include the ID of the transaction, datetime of the transaction, and the transaction amount. Order the transactions by datetime.

Output Schema:

Column

Type

id

INT

created_at

DATETIME

transaction_value

FLOAT

*/

----ANSWER 

SELECT * FROM CUSTOMER_SALES;

WITH CTE AS (SELECT CREATED_AT, 
    SUM(EXTRACT(HOUR FROM created_at)) AS total_hours,
    SUM(EXTRACT(MINUTE FROM created_at)) AS total_minutes,
    SUM(EXTRACT(SECOND FROM created_at)) AS total_seconds
FROM customer_sales
GROUP BY CREATED_AT );

with cte as (SELECT id,transaction_value, created_at,
    				CAST(created_at AS DATE) AS date_part,  -- Extract the DATE part
    				CAST(created_at AS TIME) AS time_part   -- Extract the TIME part
			  FROM customer_sales),


cte1 as (select id,created_at,transaction_value,dense_rank() over (partition by date_part order by time_part desc) as rank
              from cte)

			  
select id,created_at,transaction_value
from cte1
where rank =1 ;




--- SQLite


WITH latest_transaction AS (SELECT id,
								    created_at,
								    transaction_value,
								    DENSE_RANK() OVER (PARTITION BY DATE(created_at) ORDER BY TIME(created_at) DESC ) AS rank
              				FROM customer_sales)
			  
SELECT id,
	   created_at,
	   transaction_value
FROM latest_transaction
WHERE rank = 1;





