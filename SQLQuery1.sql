--4.1 
SELECT StdFirstName, StdLastName, StdCity, StdGPA   
FROM Student
WHERE StdGPA >= 3.7
GO

---Q1
SELECT StdFirstName, StdLastName, StdCity, StdGPA
FROM Student
WHERE StdGPA BETWEEN 2.0 AND 3.0 ;

---Q2
SELECT CrsDesc, CrsUnits
FROM Course
WHERE CourseNo LIKE 'IS460';

--4.2
SELECT* FROM Faculty;

--4.3
SELECT FacFirstName, FacLastName, FacCity, FacSalary*1.1 AS InflatedSalary, FacHireDate
FROM Faculty
WHERE year(FacHireDate) > 2008  ;
--(OR)
SELECT FacFirstName, FacLastName, FacCity, FacSalary*1.1 AS InflatedSalary, FacHireDate   
FROM Faculty  
WHERE datepart(year,FacHireDate) > 2008 ;

--4.4a
SELECT FacFirstName, FacLastName, FacHireDate, FacCity
FROM Faculty
WHERE datepart(year,FacHireDate) >= datepart(year,getdate()) - 12;

SELECT* 
FROM Course
WHERE CourseNo LIKE 'IS4%';

-- List the offering number and course number of Summer 2020 offerings without an assigned instructor. 
SELECT * FROM Offering;
SELECT OfferNo, CourseNo
FROM Offering
WHERE ((OffTerm ='SUMMER') AND (OffYear = '2020' )) AND FacNo IS NULL;

-- Always remember to use IS NULL and not = NULL 

--List name and faculty number of Management Science (MS) or Finance (FIN) full professor. (Note, full professors’ FacRank is recorded as PROF.) 
SELECT* FROM Faculty;
SELECT FacNo, FacFirstName, FacLastName
FROM Faculty
WHERE FacRank = 'PROF' AND (FacDept = 'MS' OR FacDept = 'FIN');

--List the offering number, course number, faculty number, term, and year for course offerings scheduled in FALL 2019 or WINTER 2020. 
SELECT OfferNo, CourseNo, FacNo, OffTerm, OffYear 
FROM Offering
WHERE (OffTerm = 'FALL' AND OffYear = '2019') OR (OffTerm = 'WINTER' AND OffYear = '2020');

---List the city and state of faculty members. 
SELECT FacCity, FacState 
FROM Faculty;

--List the unique city and state combinations in the Faculty table. 
SELECT DISTINCT FacCity, FacState
FROM Faculty;

--List the GPA, name, city and state of juniors. Order the result by GPA in ascending order. 
SELECT* FROM Student;
SELECT StdGPA, StdFirstName, StdLastName, StdState, StdClass
FROM Student
WHERE StdClass LIKE 'JR'
ORDER BY StdGPA;

---List the rank, salary, name, and department of faculty. Order the result by ascending (alphabetic) rank and descending salary. 
SELECT* FROM Faculty;
SELECT FacRank, FacSalary, FacFirstName, FacLastName, FacDept
FROM Faculty
ORDER BY FacRank ASC , FacSalary DESC ;
--but the above does not make sense as ordering faculty by alphabetical is not correct, we have to order by designation so we will follow the below steps

SELECT* FROM Faculty;
SELECT FacRank, FacSalary, FacFirstName, FacLastName, FacDept
FROM Faculty
ORDER BY CASE FacRank 
      WHEN 'ASST' THEN 1
	  WHEN 'ASSC' THEN 2
	  WHEN 'PROF' THEN 3
	  END,FacSalary DESC ;



