
CREATE TABLE events2 (
user_id INT,
created_at TIMESTAMP,
action VARCHAR(20)
);

INSERT INTO events2 VALUES 
(1, '2020-01-01 10:00:00', 'post_enter'),
(1, '2020-01-01 10:05:00', 'post_submit'),
(2, '2020-01-01 11:00:00', 'post_enter'),
(2, '2020-01-01 11:10:00', 'post_canceled'),
(3, '2020-01-01 15:00:00', 'post_enter'),
(3, '2020-01-01 15:30:00', 'post_submit'),
(4, '2020-01-02 09:00:00', 'post_enter'),
(4, '2020-01-02 09:15:00', 'post_canceled'),
(5, '2020-01-02 10:00:00', 'post_enter'),
(5, '2020-01-02 10:10:00', 'post_canceled'),
(10, '2020-01-15 14:00:00', 'post_enter'),
(10, '2020-01-15 14:30:00', 'post_submit'),
(6, '2019-12-31 23:55:00', 'post_enter'),
(6, '2020-01-01 00:05:00', 'post_submit'),
(7, '2020-02-01 00:00:00', 'post_enter'),
(7, '2020-02-01 00:10:00', 'post_submit'),
(8, '2019-01-15 10:00:00', 'post_enter'),
(8, '2019-01-15 10:30:00', 'post_submit'),
(9, '2021-01-01 09:00:00', 'post_enter'),
(9, '2021-01-01 09:10:00', 'post_canceled');

-- Do not modify the schema or data definitions above

-- Implement your SQL query below, utilizing the provided schema


/*Consider the events table, which contains information about the phases of writing a new social media post.

The action column can have values post_enter, post_submit, or post_canceled for when a user starts to write (post_enter), ends up canceling their post (post_cancel), or posts it (post_submit). Write a query to get the post-success rate for each day in the month of January 2020.

Note: Post Success Rate is defined as the number of posts submitted (post_submit) divided by the number of posts entered (post_enter) for each day.

Output Schema:

Column

Type

date

DATE

total_enters

INT

total_submits

INT

success_rate

FLOAT */

SELECT * FROM EVENTS2 ;

SELECT
    DATE(created_at) AS date,
    SUM(CASE WHEN action = 'post_enter' THEN 1 ELSE 0 END) AS total_enters,
    SUM(CASE WHEN action = 'post_submit' THEN 1 ELSE 0 END) AS total_submits,
    ROUND(
        SUM(CASE WHEN action = 'post_submit' THEN 1 ELSE 0 END) * 1.0 /
        NULLIF(SUM(CASE WHEN action = 'post_enter' THEN 1 ELSE 0 END), 0),
    2) AS success_rate
FROM events2
WHERE created_at >= '2020-01-01' AND created_at < '2020-02-01'
GROUP BY DATE(created_at)
ORDER BY date;


--------

WITH cte AS	(SELECT *,
				date(created_at) AS date_part
		     FROM events2),	

cte1 AS(SELECT date_part , 
			   action ,
			   count(*) as count
		FROM cte
		WHERE EXTRACT (YEAR FROM date_part) = '2020' 
               AND EXTRACT (MONTH FROM date_part)= '01'  
		GROUP BY date_part, action),

cte2 as (SELECT date_part as date,
                SUM(CASE WHEN action = 'post_enter' THEN count END) AS total_enters,
	            SUM(CASE WHEN action = 'post_submit' THEN count END) AS total_submits
		 FROM cte1
         GROUP BY 1)

SELECT *,  ROUND(
            CASE 
               WHEN total_enters = 0 THEN 0
               ELSE (total_submits * 1.0 / total_enters) * 100
            END, 2) AS success_rate
FROM cte2;











