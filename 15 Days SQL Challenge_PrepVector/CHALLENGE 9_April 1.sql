CREATE TABLE monthly_sales (
month DATE,
product_id INTEGER,
amount_sold INTEGER
);

INSERT INTO monthly_sales (month, product_id, amount_sold) VALUES
('2021-01-01', 1, 100),
('2021-01-01', 2, 300),
('2021-02-01', 1, 150),
('2021-02-01', 1, 50),
('2021-02-01', 2, 250),
('2021-03-01', 1, 120),
('2021-03-01', 4, 250),
('2021-04-01', 2, -30),
('2021-04-01', 3, 200),
('2021-05-01', 3, 175),
('2021-06-01', 1, 0),
('2021-06-01', 2, 100);

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema

---QUESTION
/* Given a table containing data for monthly sales, write a query to find the total amount of each product sold for each month, with each product as its own column in the output table.

Output Schema:

Column

Type

month

DATE

product_1

INT

product_2

INT

product_3

INT

product_4

INT
 
*/

SELECT *
FROM monthly_sales;




SELECT month, 
       SUM(CASE WHEN product_id = '1' THEN amount_sold ELSE 0 END) AS product_1,
	   SUM(CASE WHEN product_id = '2' THEN amount_sold ELSE 0 END) AS product_2,
	   SUM(CASE WHEN product_id = '3' THEN amount_sold ELSE 0 END) AS product_3,
	   SUM(CASE WHEN product_id = '4' THEN amount_sold ELSE 0 END) AS product_4

FROM monthly_sales
GROUP BY month



--- DYNAMICALLY CREATING 


CREATE EXTENSION IF NOT EXISTS tablefunc;


SELECT *
FROM crosstab(
  $$
    SELECT 
      month, 
      product_id,
      SUM(amount_sold)
    FROM monthly_sales
    GROUP BY month, product_id
    ORDER BY month, product_id
  $$,
  $$ SELECT DISTINCT product_id FROM monthly_sales ORDER BY 1 $$
) AS ct (
  month DATE,
  product_1 INT,
  product_2 INT,
  product_3 INT,
  product_4 INT
);



