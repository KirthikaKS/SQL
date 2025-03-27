CREATE TABLE job_postings (
    id INT PRIMARY KEY,
    user_id INT,
    job_id INT,
    posted_date TIMESTAMP
);

INSERT INTO job_postings (id, user_id, job_id, posted_date) VALUES
    (1, 1, 101, '2024-01-01'),
    (2, 1, 102, '2024-01-02'),
    (3, 2, 201, '2024-01-01'),
    (4, 2, 201, '2024-01-15'),
    (5, 2, 202, '2024-01-03'),
    (6, 3, 301, '2024-01-01'),
    (7, 4, 401, '2024-01-01'),
    (8, 4, 401, '2024-01-15'),
    (9, 4, 402, '2024-01-02'),
    (10, 4, 402, '2024-01-16'),
    (11, 5, 501, '2024-01-05'),
    (12, 5, 502, '2024-01-10');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema



--- Question
/*Given a table of job postings, write a query to retrieve the number of users that have posted each job only once and the number of users that have posted at least one job multiple times.

Output Schema:

Column

Type

single_post_users

INT

multiple_post_users

INT */


-- Answer

SELECT * FROM job_postings ;


SELECT USER_ID,
	   CASE WHEN COUNT = 2 THEN 'MULTIPLE POSTING'
	   ELSE 'SINGLE POSTING'
	   END AS CATEGORY
FROM (SELECT USER_ID, JOB_ID , COUNT(*) 
	  FROM JOB_POSTINGS
	  GROUP BY 1,2
	  ORDER BY 1);


---count of the id is equal to the sum of the value if you assign 1 to single job posting
-- if the sum of that is greater than the count if the id then multi posting?

WITH MULTI AS (
    SELECT USER_ID, JOB_ID, COUNT(*) 
    FROM JOB_POSTINGS
    GROUP BY 1,2
    HAVING COUNT(*) > 1
),
SINGLE AS (
    SELECT USER_ID, JOB_ID, COUNT(*) 
    FROM JOB_POSTINGS
    WHERE USER_ID NOT IN (SELECT USER_ID FROM MULTI)
    GROUP BY 1,2
)

SELECT COUNT(DISTINCT SINGLE.USER_ID) AS single_post_users , 
       COUNT(DISTINCT MULTI.USER_ID) AS multiple_post_users
FROM SINGLE, MULTI;
				 
		

