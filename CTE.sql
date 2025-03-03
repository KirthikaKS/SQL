DROP TABLE IF EXISTS EMPLOYEE;

Create table Employee_cte
(
emp_id int PRIMARY KEY,
emp_name varchar(50),
salary int ) ;

INSERT INTO EMPLOYEE_cte (emp_id,emp_name,salary)
VALUES
      (101,'Mohan','40000'),
	  (102,'James','50000'),
	  (103,'Robin','60000'),
	  (104,'Carol','70000'),
	  (105,'Alice','80000'),
	  (106,'Jimmy','90000') ;
	  
SELECT * 
FROM EMPLOYEE_cte;

--- Fetch employees who earn more than average salary of all employees

with average_salary (avg_sal) as
       (select cast(avg(salary) as int) from employee_cte)

select *
from employee_cte e, average_salary av
where e.salary > av.avg_sal;


Drop table if exists Sales_cte;


create table Sales_cte (
    StoreId INT,
    StoreName VARCHAR(50),
    ProductName VARCHAR(50),
    Quantity INT,
    Price INT
);

insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (1, 'Apple Store 1', 'IPhone 12 Pro', 1, 1000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (1, 'Apple Store 1', 'Macbook Pro 13', 3, 2000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (1, 'Apple Store 1', 'Airpods Pro', 2, 280);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (2, 'Apple Store 2', 'IPhone 12 Pro', 2, 1000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (3, 'Apple Store 3', 'IPhone 12 Pro', 1, 1000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (3, 'Apple Store 3', 'Macbook Pro 13', 1, 2000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (3, 'Apple Store 3', 'Macbook Air', 4, 1100);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (3, 'Apple Store 3', 'IPhone 12', 2, 1000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (3, 'Apple Store 3', 'Airpods Pro', 3, 280);
insert into Sales_cte(StoreId, StoreName, ProductName, Quantity, Price) values (4, 'Apple Store 4', 'IPhone 12 Pro', 2, 1000);
insert into Sales_cte (StoreId, StoreName, ProductName, Quantity, Price) values (4, 'Apple Store 4', 'Macbook Pro 13', 1, 2500);

SELECT*
FROM Sales_cte ;

--- Find stores who's sales where better than the average sales accross all stores

--- 1) find total sales for each store - so we group by store - total_sales
select s.storeId, sum(Price) as total_sales_per_stores
from sales_cte as s
group by s.storeId;

--- 2) avg of sales of those categories - avg_sales

select cast(avg(total_sales_per_stores) as int ) as avg_sales_all_stores
from(select s.storeId, sum(Price) as total_sales_per_stores
from sales_cte as s
group by s.storeId) x 


--- 3) find the stores where the total sales is greater than the avg sales of all stores


select *
from(select s.storeId, sum(Price) as total_sales_per_store
     from sales_cte as s
     group by s.storeId) total_sales
join (select cast(avg(total_sales_per_store) as int ) as avg_sales_all_stores
      from(select s.storeId, sum(Price) as total_sales_per_stores
      from sales_cte as s
      group by s.storeId) x ) avg_sales
  on total_sales.total_sales_per_store > avg_sales.avg_sales_all_stores;

-- the above query is complicated to even look and we tend to make mistakes and we are using the same subquery twice so we are going for with clause 


with total_sales (storeId,total_sales_per_store) as 
        (select s.storeId, sum(Price) as total_sales_per_store
         from sales_cte as s
         group by s.storeId),
	 avg_sales(avg_sales_all_stores) as
	     (select cast(avg(total_sales_per_store) as int ) as avg_sales_all_stores
          from total_sales)
select *
from total_sales as ts
join avg_sales as av
on ts.total_sales_per_store > av.avg_sales_all_stores;
	 

















