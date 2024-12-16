SELECT * FROM SCHOOL;
SELECT * FROM SUBJECTS;
SELECT * FROM STAFF;
SELECT * FROM STAFF_SALARY;
SELECT * FROM CLASSES;
SELECT * FROM STUDENTS;
SELECT * FROM PARENTS;
SELECT * FROM STUDENT_CLASSES;
SELECT * FROM STUDENT_PARENT;
SELECT * FROM ADDRESS;

SELECT * FROM STUDENTS ;

SELECT ID, FIRST_NAME FROM STUDENTS ;
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME = 'Mathematics' ;
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME <> 'Mathematics' ;
SELECT * FROM STAFF_SALARY WHERE SALARY <= 10000 ;
SELECT * FROM STAFF_SALARY ORDER BY SALARY DESC ;
SELECT * FROM STAFF_SALARY WHERE SALARY BETWEEN 5000 AND 10000 ORDER BY SALARY ;
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME IN ('Mathematics','Science','Arts');
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME NOT IN ('Mathematics','Science','Arts');
SELECT * FROM SUBJECTS WHERE SUBJECT_NAME LIKE '%c';
SELECT * FROM STAFF WHERE AGE > 50 OR GENDER = 'F';
SELECT (5+2) AS TOTAL; ---ONLY IN POSTGRE SQL YOU CAN USE
SELECT STAFF_TYPE FROM STAFF ;
SELECT DISTINCT STAFF_TYPE FROM STAFF ;
SELECT STAFF_TYPE FROM STAFF LIMIT 5 ;

---CASE STATEMENT -- SIMILAR TO IF ELSE 
SELECT STAFF_ID, SALARY
   ,CASE WHEN SALARY >= 10000 THEN 'HIGH SALARY'
        WHEN SALARY BETWEEN 5000 AND 10000 THEN 'AVERAGE SALARY'
		WHEN SALARY < 5000 THEN 'TOO LOW'
	END AS RANGE
FROM STAFF_SALARY
ORDER BY 2 DESC ;

---- JOINS - TWO WAYS TO WRITE SQL QUERIES
--1 . USING JOIN
-- SELECT T1.COLUMN1 AS C1 FROM TABLE T1 JOIN TABLE2 AS T2 ON T1.C1 = T2.C2;

--2 . USING ,
-- SELECT T1.COLUMN1 AS C1 FROM TABLE1 AS T1, TAABLE2 AS T2 WHERE T1.C1 = T2.C1 AND T1.C2 = T2.C2 ;

--FETCH THE CLASSNAME WHERE MUSIC IS THE SUBJECT
SELECT CLASS_NAME
FROM SUBJECTS SUB
JOIN CLASSES CLS ON SUB.SUBJECT_ID = CLS.SUBJECT_ID
WHERE SUBJECT_NAME = 'Music' ;

--- FETCH FULL NAME OF ALL THE STAFFS WHO TEACH MATHEMATICS
SELECT DISTINCT (STF.FIRST_NAME ||''||STF.LAST_NAME) AS FULL_NAME
FROM SUBJECTS SUB
JOIN CLASSES CLS ON CLS.SUBJECT_ID = SUB.SUBJECT_ID
JOIN STAFF STF ON CLS.TEACHER_ID = STF.STAFF_ID
WHERE SUB.SUBJECT_NAME = 'Mathematics';


-- Fetch all staff who teach grade 8, 9, 10 and also fetch all the non-teaching staff
-- UNION can be used to merge two differnt queries. UNION returns always unique records so any duplicate data while merging these queries will be eliminated.
-- UNION ALL displays all records including the duplicate records.
-- When using both UNION, UNION ALL operators, rememeber that noo of columns and their data type must match among the different queries.
SELECT STF.STAFF_TYPE
,    (STF.FIRST_NAME||' '||STF.LAST_NAME) AS FULL_NAME
,    STF.AGE
,    (CASE WHEN STF.GENDER = 'M' THEN 'Male'
           WHEN STF.GENDER = 'F' THEN 'Female'
      END) AS GENDER
,    STF.JOIN_DATE
FROM STAFF STF
JOIN CLASSES CLS ON STF.STAFF_ID = CLS.TEACHER_ID
WHERE STF.STAFF_TYPE = 'Teaching'
AND   CLS.CLASS_NAME IN ('Grade 8', 'Grade 9', 'Grade 10')
UNION
SELECT STAFF_TYPE
,    (FIRST_NAME||' '||LAST_NAME) AS FULL_NAME, AGE
,    (CASE WHEN GENDER = 'M' THEN 'Male'
           WHEN GENDER = 'F' THEN 'Female'
      END) AS GENDER
,    JOIN_DATE
FROM STAFF
WHERE STAFF_TYPE = 'Non-Teaching';

----Count no of students in each class
select * from student_classes;

SELECT SC.CLASS_ID, COUNT(*) AS "NO.OF STUDENTS"
FROM STUDENT_CLASSES AS SC
GROUP BY SC.CLASS_ID
ORDER BY SC.CLASS_ID;

--- MORE THAN 100 STUDENTS IN A CLASS
SELECT CLASS_ID, COUNT(CLASS_ID) AS "NO.OF STUDENTS"
FROM STUDENT_CLASSES 
GROUP BY CLASS_ID
HAVING COUNT(CLASS_ID) > 100
ORDER BY CLASS_ID;

--- PARENTS WITH MORE THAN 1 KID IN SCHOOL
SELECT PARENT_ID , COUNT(PARENT_ID) AS "CHILD COUNT"
FROM STUDENT_PARENT
GROUP BY PARENT_ID
HAVING COUNT(PARENT_ID) > 1 ;

--- *SUBQUERY*:QUERY WRITTEN WITHIN A QUERY
--- FETCH THE DETAILS OF PARENTS HAVING MORE THAN 1 KID GOING TO THIS SCHOOL
SELECT (P.FIRST_NAME||' '||P.LAST_NAME) AS PARENT_NAME,
       (S.FIRST_NAME||' '||S.LAST_NAME) AS STUDENT_NAME,
	   S.AGE AS STUDENTS_AGE,
	   S.GENDER AS STUDENT_GENDER,
	   (ADR.STREET||', '||ADR.CITY||', '||ADR.STATE||','||ADR.COUNTRY) AS ADDRESS
FROM PARENTS AS P
JOIN STUDENT_PARENT SP ON P.ID = SP.PARENT_ID
JOIN STUDENTS S ON S.ID = SP.STUDENT_ID
JOIN ADDRESS ADR ON P.ADDRESS_ID = ADR.ADDRESS_ID
WHERE P.ID IN ( SELECT PARENT_ID
                FROM STUDENT_PARENT SP
				GROUP BY PARENT_ID
				HAVING COUNT(1)>1)
ORDER BY 1;

----AGGREGATE FUNCTIONS
-- AVG
SELECT AVG(SS.SALARY) AS AVERAGE_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
WHERE STF.STAFF_TYPE = 'Non-Teaching';

--SUM, MIN,MAX
-- SUM: Calculates the total sum of all values in the given column.
SELECT STF.STAFF_TYPE, SUM(SS.SALARY)::NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

-- MIN: Returns the record with minimun value in the given column.
SELECT STF.STAFF_TYPE, MIN(SS.SALARY)::NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

-- MAX: Returns the record with maximum value in the given column.
SELECT STF.STAFF_TYPE, MAX(SS.SALARY)::NUMERIC(10,2) AS AVG_SALARY
FROM STAFF_SALARY SS
JOIN STAFF STF ON STF.STAFF_ID = SS.STAFF_ID
GROUP BY STF.STAFF_TYPE;

/*
SQL Joins: There are several types of JOIN but we look at the most commonly used:
1) Inner Join
    - Inner joins fetches records when there are matching values in both tables.
2) Outer Join
    - Left Outer Join
        - Left join fetches all records from left table and the matching records from right table.
        - The count of the query will be the count of the Left table.
        - Columns which are fetched from right table and do not have a match will be passed as NULL.
    - Right Outer Join
        - Right join fetches all records from right table and the matching records from left table.
        - The count of the query will be the count of the right table.
        - Columns which are fetched from left table and do not have a match will be passed as NULL.
    - Full Outer Join
        - Full join always return the matching and non-matching records from both left and right table.
*/
-- INNER JOIN
SELECT COUNT(1)
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

SELECT DISTINCT (STF.FIRST_NAME||' '||STF.LAST_NAME) AS FULL_NAME, SS.SALARY
FROM STAFF STF
JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 2;

-- All records from LEFT table with be fetched irrespective of whether there is matching record in the RIGHT table.
SELECT COUNT(1)
FROM STAFF STF
LEFT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

-- All records from RIGHT table with be fetched irrespective of whether there is matching record in the LEFT table.
SELECT COUNT(1)
FROM STAFF STF
RIGHT JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

-- All records from both LEFT and RIGHT table with be fetched irrespective of whether there is matching record in both these tables.
SELECT COUNT(1)
FROM STAFF STF
FULL OUTER JOIN STAFF_SALARY SS ON SS.STAFF_ID = STF.STAFF_ID
ORDER BY 1;

