
CREATE TABLE EMPLOYEE1 
(
EMP_ID INT,
EMP_NAME VARCHAR(50),
DEPT_NAME VARCHAR(50),
SALARY INT
);

INSERT INTO EMPLOYEE1 (EMP_ID,EMP_NAME,DEPT_NAME,SALARY)
VALUES
       ('101','Mohan','Admin','4000'),
	   ('102','Rajkumar','HR','3000'),
	    ('103','Akbar','IT','4000'),
		 ('104','Dorvin','Finance','6500'),
		  ('105','Rohit','HR','3000'),
		   ('106','Rajesh','Finance','5000'),
		    ('107','Preet','HR','7000')


CREATE TABLE DEPARTMENT1
(DEPT_ID INT,
 DEPT_NAME VARCHAR(50),
 LOCATION VARCHAR(100));

DROP TABLE IF EXISTS DEPARTMENT1;

INSERT INTO DEPARTMENT1(DEPT_ID,DEPT_NAME,LOCATION)
VALUES ('1','Admin','Bangalore'),
		('2','HR','Bangalore'),
		('3','IT','Bangalore'),
		('4','Finance','Mumbai'),
		('5','Sales','Mumbai');


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




			  