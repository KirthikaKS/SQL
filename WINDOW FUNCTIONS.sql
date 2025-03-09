drop table employee;
create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;

---- best way to understand window fn is to go through window functions

select * from employee;

select dept_name,max(salary) as max_sal
from employee
group by dept_name;


select e.* ,
max(salary) over(partition by dept_name) as max_salary
from employee e;

--- over clause treats max as window function, over creates a window for the r

--- 	ROW NUMBER - ASSIGNS UNIQUE VALUE TO EACH RECORD

select e.*,
row_number() over() as rn
from employee e;

select e.*,
row_number() over(partition by dept_name) as rn
from employee e;

---  Fetch the first 2 employees from each department to join the company 

select *
from (select e.*,
      row_number() over(partition by dept_name order by emp_id) as rn
       from employee e) as x
where x.rn < 3;

--- RANK ()

--- Fetch the top 3 employees in each dept earning max salary

select *
from (select e.*,
      rank() over(partition by dept_name order by salary desc) as rnk
      from employee e) as x
where x.rnk < 4;


-- Rank skips a value for the duplicat evalye found where as dense rank does not skip a value even when there is duplicate
-- when two employees have same salary rank is give 2 , 2 for both and the rank of the next person is 4 but it should be 3 right , dense rank does that and gives 3 

--- DENSE RANK()

select e.*,
rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk,
row_number() over(partition by dept_name order by salary desc) as rn
from employee e;

--- LEAD() AND LAG()

--- Fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee
-- lag - before, lead  - after

select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_emp_salary
from employee e ;

--lag(salary,2,0) - 2 is the number of steps like two rows before value and 0 is the default value when u don't have two rows before the actual row u are seeing

select e.*,
lag(salary,2,0) over(partition by dept_name order by emp_id) as prev_emp_salary
from employee e ;

select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_emp_salary,
lead(salary) over(partition by dept_name order by emp_id) as next_emp_salary
from employee e ;


select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_emp_salary,
case when e.salary > lag(salary) over(partition by dept_name order by emp_id) then 'Higher than previous employee'
     when e.salary < lag(salary) over(partition by dept_name order by emp_id) then 'Lower than previous employee'
     when e.salary = lag(salary) over(partition by dept_name order by emp_id) then 'Same as the previous employee'
     end sal_range
from employee e;

DROP TABLE product;
CREATE TABLE product
( 
    product_category varchar(255),
    brand varchar(255),
    product_name varchar(255),
    price int
);

INSERT INTO product VALUES
('Phone', 'Apple', 'iPhone 12 Pro Max', 1300),
('Phone', 'Apple', 'iPhone 12 Pro', 1100),
('Phone', 'Apple', 'iPhone 12', 1000),
('Phone', 'Samsung', 'Galaxy Z Fold 3', 1800),
('Phone', 'Samsung', 'Galaxy Z Flip 3', 1000),
('Phone', 'Samsung', 'Galaxy Note 20', 1200),
('Phone', 'Samsung', 'Galaxy S21', 1000),
('Phone', 'OnePlus', 'OnePlus Nord', 300),
('Phone', 'OnePlus', 'OnePlus 9', 800),
('Phone', 'Google', 'Pixel 5', 600),
('Laptop', 'Apple', 'MacBook Pro 13', 2000),
('Laptop', 'Apple', 'MacBook Air', 1200),
('Laptop', 'Microsoft', 'Surface Laptop 4', 2100),
('Laptop', 'Dell', 'XPS 13', 2000),
('Laptop', 'Dell', 'XPS 15', 2300),
('Laptop', 'Dell', 'XPS 17', 2500),
('Earphone', 'Apple', 'AirPods Pro', 280),
('Earphone', 'Samsung', 'Galaxy Buds Pro', 220),
('Earphone', 'Samsung', 'Galaxy Buds Live', 170),
('Earphone', 'Sony', 'WF-1000XM4', 250),
('Headphone', 'Sony', 'WH-1000XM4', 400),
('Headphone', 'Apple', 'AirPods Max', 550),
('Headphone', 'Microsoft', 'Surface Headphones 2', 250),
('Smartwatch', 'Apple', 'Apple Watch Series 6', 1000),
('Smartwatch', 'Apple', 'Apple Watch SE', 400),
('Smartwatch', 'Samsung', 'Galaxy Watch 4', 600),
('Smartwatch', 'OnePlus', 'OnePlus Watch', 220);
COMMIT;




-- All the SQL Queries written during the video

select * from product;


-- FIRST_VALUE 
-- Write query to display the most expensive product under each category (corresponding to each record)

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product
from product ;

---LAST_VALUE
-- Write query to display the least expensive product under each category (corresponding to each record)

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name) over(partition by product_category order by price desc) as least_exp_product
from product ;

---FRAME CLAUSE
--- window fn creates a window/partitions , within which we can create a subset called frame


--- default frame clause is -- range between unbounded preceding and current row

--- it mostly impact teh last value, nth value and aggregate functions

--- so we are modifying the default fram clause from current row to unbounded following
-- can say range between or rows between - rows will consider exact row alone, range will consider if it has duplicate value for which it is ordered 
---range considers all duplicate values
--- nstead of unbounded you can even say 2 preceding and 2 following etc

select *,
first_value(product_name) over(partition by product_category order by price desc) as most_exp_product,
last_value(product_name) over(partition by product_category order by price desc
                              range between unbounded preceding and unbounded following) as least_exp_product
from product ;


--- Alternate way to write window functions
--- reducing repeating over () when we have to write multiple window functions

select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product
from product 
window w as (partition by product_category order by price desc
                              range between unbounded preceding and unbounded following) ;
							  

---- windows has to be after where and before order by if mentioned 

--- N th Value
---Write query to display the second most expensive product under each category

select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_product
from product 
window w as (partition by product_category order by price desc
                              range between unbounded preceding and unbounded following) ;
							  
-- if the nth value does not exist let say we use 5 for n in above query it will return null 

select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 5) over w as second_most_exp_product
from product 
window w as (partition by product_category order by price desc
                              range between unbounded preceding and unbounded following) ;
							  
--- mentioning proper frame is very important for nth value as well
select *,
first_value(product_name) over w as most_exp_product,
last_value(product_name) over w as least_exp_product,
nth_value(product_name, 2) over w as second_most_exp_product
from product 
window w as (partition by product_category order by price desc);
                              
--- NTILE 
-- group together a set of data in the partition and place it into certain buckets and each bucket will have almost the equal number of records

--- divide data equally in few different groups

--- Write a query to segregate all the expensive phones, mid range ohones and the cheaper phones

select *,
ntile(3) over(order by price desc) as buckets
from product
where product_category = 'Phone' ;

select *,
ntile(5) over(order by price desc) as buckets
from product
where product_category = 'Phone' ;



select product_name,
case when x.buckets = 1 then 'Expensive Phones'
     when x.buckets = 2 then 'Mid range Phones'
	 when x.buckets = 3 then 'Cheaper Phones' End phone_category
from(select *,
     ntile(3) over(order by price desc) as buckets
     from product
     where product_category = 'Phone' ) x ;

---CUME_DIST  
--- identify the distribution percentage of each record wrt to all rows within a list
-- always gives values within range 0 and 1

-- does not accept any argument

select product_name,(cume_dist_percentage||'%') as cume_dist_percentage
from (
    select*,
    cume_dist() over(order by price desc) as cume_distribution,
    round(cume_dist() over (order by price desc)::numeric * 100,2) as cume_dist_percentage
    from product) x
where x.cume_dist_percentage <= 30 ;


--- PERCENT_RANK
---- PROVIDE RELATIVE RANK TO EACH ROW BASED ON PERCENTAGE

--- Query to identify how much percentage more expensive is "Galaxy Z fold 3" when compared to all products

select product_name, per_rnk
from(
   select*,
   percent_rank() over(order by price) as percentage_rank,
   round(percent_rank() over(order by price):: numeric * 100,2) as per_rnk
   from product) x
where x.product_name = 'Galaxy Z Fold 3' ;















