CREATE TABLE transactions2 (
id INTEGER PRIMARY KEY,
user_id INTEGER,
created_at TIMESTAMP,
product_id INTEGER,
quantity INTEGER
);

INSERT INTO transactions2 (id, user_id, created_at, product_id, quantity) VALUES
(1, 101, '2024-01-01 10:00:00', 1, 1),  
(2, 101, '2024-01-01 14:00:00', 2, 1),
(3, 101, '2024-01-15 09:00:00', 3, 1), 
(4, 102, '2024-01-05 11:00:00', 1, 2),
(5, 102, '2024-01-05 11:30:00', 2, 1),
(6, 103, '2024-01-02 15:00:00', 1, 1),
(7, 104, '2024-01-01 09:00:00', 1, 1),
(8, 104, '2024-01-02 10:00:00', 2, 1),
(9, 104, '2024-01-03 11:00:00', 3, 1);

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema


---QUESTION
/*We’re given a table of product purchases. Each row in the table represents an individual user product purchase.

Write a query to get the number of customers that were upsold by purchasing additional products.

Note: If a customer purchased multiple products on the same day, it does not count as an upsell. An upsell is considered only if they made purchases on separate days

Output Schema:

Column

Type

upsold_customer_count

INT */


---ANSWER
SELECT * FROM transactions2;

SELECT DATE(created_at)
FROM transactions2

WITH CTE AS (SELECT user_id,DATE(created_at), COUNT(*) OVER (PARTITION BY user_id ORDER BY user_id) as count
			 FROM transactions2 
			GROUP BY 1, DATE(created_at)),

CTE1 AS (SELECT user_id, count(*) AS final_count
			FROM cte
			GROUP BY user_id)

SELECT COUNT(*) AS upsold_customer_count
FROM CTE1
WHERE final_count > 1;






