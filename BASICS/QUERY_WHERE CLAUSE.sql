CREATE DATABASE COMPANY;
USE COMPANY;
CREATE TABLE EMPLOYEE(
EMP_ID INT,
EMP_NAME VARCHAR(20),
JOB_DESC VARCHAR(20),
SALARY INT);
INSERT INTO EMPLOYEE VALUES
(1,'Ram','ADMIN',1000000),
(2,'Harini','MANAGER',2500000),
(3,'George','SALES',2000000),
(4,'Ramya','SALES',1300000),
(5,'Meena','HR',2000000),
(6,'Ashok','MANAGER',3000000),
(7,'Abdul','HR',2000000),
(8,'Ramya','ENGINEER',1000000),
(9,'Raghu','CEO',8000000),
(10,'Arvind','MANAGER',2800000),
(11,'Akshay','ENGINEER',1000000),
(12,'John','ADMIN',2200000);

-- QUERY 1
SELECT* FROM EMPLOYEE;
SELECT* FROM EMPLOYEE WHERE SALARY=1000000 ; 

-- QUERY 2
SELECT* FROM EMPLOYEE
WHERE JOB_DESC = 'MANAGER' AND SALARY >= 1000000 ; 

-- QUERY 3
SELECT EMP_NAME FROM EMPLOYEE 
WHERE EMP_NAME <> 'RAMYA' ; 

-- QUERY 4
SELECT* FROM EMPLOYEE 
WHERE SALARY = 2000000 OR EMP_NAME = 'MEENA' ; 

-- QUERY 5
SELECT* FROM EMPLOYEE 
WHERE JOB_DESC IN ('MANAGER', 'SALES') AND SALARY > 2000000; 

-- QUERY 6
SELECT* FROM EMPLOYEE 
WHERE JOB_DESC NOT IN ('CEO', 'ENGINEER') ; 

-- QUERY 7
SELECT* FROM EMPLOYEE 
WHERE SALARY BETWEEN 2000000 AND 8000000 ; 

-- QUERY 8
SELECT* FROM EMPLOYEE
LIMIT 6;









