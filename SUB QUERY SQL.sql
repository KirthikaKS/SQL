DROP TABLE IF EXISTS EMPLOYEE1
CREATE TABLE EMPLOYEE1
(
    EMP_ID      INT PRIMARY KEY,
    EMP_NAME    VARCHAR(50) NOT NULL,
    DEPT_NAME   VARCHAR(50) NOT NULL,
    SALARY      INT,
    constraint fk_emp foreign key(dept_name) references department1(dept_name)
);

insert into employee1 values(101, 'Mohan', 'Admin', 4000);
insert into employee1 values(102, 'Rajkumar', 'HR', 3000);
insert into employee1 values(103, 'Akbar', 'IT', 4000);
insert into employee1 values(104, 'Dorvin', 'Finance', 6500);
insert into employee1 values(105, 'Rohit', 'HR', 3000);
insert into employee1 values(106, 'Rajesh',  'Finance', 5000);
insert into employee1 values(107, 'Preet', 'HR', 7000);
insert into employee1 values(108, 'Maryam', 'Admin', 4000);
insert into employee1 values(109, 'Sanjay', 'IT', 6500);
insert into employee1 values(110, 'Vasudha', 'IT', 7000);
insert into employee1 values(111, 'Melinda', 'IT', 8000);
insert into employee1 values(112, 'Komal', 'IT', 10000);
insert into employee1 values(113, 'Gautham', 'Admin', 2000);
insert into employee1 values(114, 'Manisha', 'HR', 3000);
insert into employee1 values(115, 'Chandni', 'IT', 4500);
insert into employee1 values(116, 'Satya', 'Finance', 6500);
insert into employee1 values(117, 'Adarsh', 'HR', 3500);
insert into employee1 values(118, 'Tejaswi', 'Finance', 5500);
insert into employee1 values(119, 'Cory', 'HR', 8000);
insert into employee1 values(120, 'Monica', 'Admin', 5000);
insert into employee1 values(121, 'Rosalin', 'IT', 6000);
insert into employee1 values(122, 'Ibrahim', 'IT', 8000);
insert into employee1 values(123, 'Vikram', 'IT', 8000);
insert into employee1 values(124, 'Dheeraj', 'IT', 11000);


DROP TABLE IF EXISTS DEPARTMENT1 ;

create table department1
(
	dept_id		int ,
	dept_name	varchar(50) PRIMARY KEY,
	location	varchar(100)
);

insert into department1 values (1, 'Admin','Bangalore'),
(2, 'HR','Bangalore'),
(3, 'IT','Bangalore'),
(4, 'Finance','Mumbai'),
(5, 'Marketing','Bangalore'),
(6, 'Sales','Mumbai') ;



--- sub-query -- query placed inside a query 

---Find the employees who's salary is more that the average salary earned by all employees

select* from employee1;

select * 
from employee1
where salary > (select avg(salary)
                from employee1) ;

--- types of subquery
    -- SCALAR SUBQUERY
	-- MULTIPLE ROW SUBQUERY
	-- CORRELATED SUBQUERY


--SCALAR - JUST RETURNS ONE ROW AND ONE COLUMN. WE CAN USE IT IN THE SELECT CLAUSE AND FROM CLAUSE ALSO

select *
from employee1
where salary > (select avg(salary)
                from employee1) ;

select * 
from employee1 e
join (select avg(salary) sal
                from employee1) avg_sal
on e.salary > avg_sal.sal ;


--- MULTIPLE ROW SUBQUERY - RETURNS MULTIPLE ROWS
-- 2 TYPES    -- MULTIPLE COLUMN AND MULTIPLE ROW
	          --- RETURNS ONE COLUMN AND MULTIPLE ROWS

--- Find the employees who earn the highest salary in each department
-- = one row but in considers multiple rows
--- this subquery can exist alone and doesnot depend on main query 

select *
from employee1
where (dept_name,salary) in (select dept_name,max(salary)
                       			from employee1
								group by dept_name);

--- single column and multiple row

-- find the department that has no employees

select*
from department1
where dept_name not in (select distinct dept_name from employee1);


--- CORRELATED SUBQUERY - SUBQUERY RELATED TO OUTER QUERY
--- VALUES OF THE SUBQUERY DEPENDS ON THE VALUES RETURNED BY THE SUBQUERY

--- Find the employees in each dept whose earn more hat the average salary in that department
--- for every single employee the subquery is executed once
--- if there are many records it takes much time to process



select *
from employee1 e1
where salary > (select avg(salary)
				from employee1 e2
				where e2.dept_name = e1.dept_name);


---- Find departments who do not have any employees

Select* from department1;
Select* from employee1;

Select dept_name
from department1 as d1
where dept_name not in (select dept_name  -- or where not exits also works
                        from employee1 as e1
						 where d1.dept_name = e1.dept_name);


--- NESTED SUBQUERY



create table sales
(
	store_id  		int,
	store_name  	varchar(50),
	product_name	varchar(50),
	quantity		int,
	price	     	int
);

insert into sales values
(1, 'Apple Store 1','iPhone 13 Pro', 1, 1000),
(1, 'Apple Store 1','MacBook pro 14', 3, 6000),
(1, 'Apple Store 1','AirPods Pro', 2, 500),
(2, 'Apple Store 2','iPhone 13 Pro', 2, 2000),
(3, 'Apple Store 3','iPhone 12 Pro', 1, 750),
(3, 'Apple Store 3','MacBook pro 14', 1, 2000),
(3, 'Apple Store 3','MacBook Air', 4, 4400),
(3, 'Apple Store 3','iPhone 13', 2, 1800),
(3, 'Apple Store 3','AirPods Pro', 3, 750),
(4, 'Apple Store 4','iPhone 12 Pro', 2, 1500),
(4, 'Apple Store 4','MacBook pro 16', 1, 3500);


--- Find stores who's sales were better than the average sales accross all stores

---1) total sales for each store
---2) avg sales for all the stores
---3) compare 1 and 2


SELECT *
FROM ( SELECT STORE_NAME,SUM(PRICE) AS TOTAL_SALES
               FROM SALES
               GROUP BY STORE_NAME) SALES
JOIN (SELECT AVG(TOTAL_PRICE) AS SALES
      FROM (SELECT STORE_NAME,SUM(PRICE) AS TOTAL_PRICE
               FROM SALES
               GROUP BY STORE_NAME)X) AVG_SALES
	  ON SALES.TOTAL_SALES > AVG_SALES.SALES;

--- MODIFYING THE ABOVE USING WITH CLAUSE 

WITH SALES AS 
     ( SELECT STORE_NAME,SUM(PRICE) AS TOTAL_SALES
       FROM SALES
       GROUP BY STORE_NAME)
SELECT *
FROM SALES
JOIN (SELECT AVG(TOTAL_SALES) AS SALES
      FROM SALES ) AVG_SALES
	  ON SALES.TOTAL_SALES > AVG_SALES.SALES ;

---- USING WHERE AND CORRELATED SUBQUERY FOR THE ABOVE
WITH SALES AS  
(  
   SELECT STORE_NAME, SUM(PRICE) AS TOTAL_SALES  
   FROM SALES  
   GROUP BY STORE_NAME  
)  
SELECT *  
FROM SALES  
WHERE TOTAL_SALES > (SELECT AVG(TOTAL_SALES) FROM SALES);

--- DIFFERENT CLAUSE IN SQL TO USE SUBQUERY

-- SELECT
-- FROM
-- WHERE
-- HAVING

---- USING SUBQUERY IN SELECT - (NOT RECOMMENDED BUT GOOD TO KNOW)


