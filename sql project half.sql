
--netflix project
DROP TABLE IF EXISTS netflix_p1;
CREATE TABLE netflix_p1(
						show_id	VARCHAR(7) PRIMARY KEY,
						type VARCHAR(7),
						title VARCHAR(150),
						director VARCHAR(208),
						casts VARCHAR(1000),
						country VARCHAR(150),
						date_added	VARCHAR(50),
						release_year INT,
						rating	VARCHAR(10),
						duration VARCHAR(15),	
						listed_in VARCHAR(100),
						description VARCHAR(250)
						)	


SELECT * FROM netflix_p1

-- count the ROWS
SELECT COUNT(*) 
	AS total_count 
FROM netflix_p1


---- 15 Business Problems & Solutions

---1. Count the number of Movies vs TV Shows
---2. Find the most common rating for movies and TV shows
---3. List all movies released in a specific year (e.g., 2020)
---4. Find the top 5 countries with the most content on Netflix
---5. Identify the longest movie
---6. Find content added in the last 5 years
---7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
---8. List all TV shows with more than 5 seasons
---9. Count the number of content items in each genre
---10.Find each year and the average numbers of content release in India on netflix. 
---return top 5 year with highest avg content release!
---11. List all movies that are documentaries
---12. Find all content without a director
---13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
---14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
---15.
---Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
---the description field. Label content containing these keywords as 'Bad' and all other 
---content as 'Good'. Count how many items fall into each category.


--Lets START
---1. Count the number of Movies vs TV Shows

SELECT type, 
	COUNT(type) AS total_cout
FROM netflix_p1
GROUP BY 1


---2. Find the most common rating for movies and TV shows
SELECT 
	type,
	rating
FROM(
SELECT 
	rating,
	type,
	COUNT(rating) AS count_rating,
	RANK() OVER(PARTITION BY type ORDER  BY COUNT(rating) DESC) AS ranking
FROM netflix_p1
GROUP BY 1, 2
) AS r1
WHERE ranking = 1


---3. List all movies released in a specific year (e.g., 2020)
SELECT *
FROM netflix_p1
WHERE release_year = 2020
	  AND
	  type = 'Movie'
	

---4. Find the top 5 countries with the most content on Netflix
SELECT 
	UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country, -- Seperate the COUNTRY	
	COUNT(show_id) AS total_content
FROM netflix_p1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


---5. Identify the longest movie
SELECT *
FROM netflix_p1
WHERE 
	type = 'Movie'
	AND
	duration = (SELECT MAX(duration) FROM netflix_p1)


---6. Find content added in the last 5 years
SELECT 
	show_id,
	title,
	release_year
FROM netflix_p1
WHERE 
	release_year BETWEEN 2015 AND 2020;


---7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT 
	type,
	director
FROM netflix_p1
WHERE director LIKE '%Rajiv Chilaka%'


---8. List all TV shows with more than 5 seasons
SELECT 
	type,
	SPLIT_PART(duration, ' ', 1 ) AS seasone,
	title
FROM netflix_p1
WHERE type = 'TV Show'
			AND
			duration > '5 Seasons'
				

---9. Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(show_id)
FROM netflix_p1
GROUP BY 1


---10.Find each year and the average numbers of content release in India on netflix. 
---return top 5 year with highest avg content release!
SELECT 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as date,
	COUNT(*),
	COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix_p1 WHERE country = 'India')::numeric * 100 as average_content_per_year
FROM netflix_p1
WHERE country = 'India'
GROUP BY 1	


---11. List all movies that are documentaries
SELECT
	*
FROM netflix_p1
WHERE listed_in LIKE '%Documentaries%'


---12. Find all content without a director
SELECT  
	show_id,
	director
FROM netflix_p1
WHERE director IS NULL


---13. Find how many movies actor 'Salman Khan' appeared in last 20 years!
SELECT 
	*
FROM netflix_p1
WHERE  casts ILIKE '%Salman Khan%'
	AND
	release_year BETWEEN 2000 AND 2020


---14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
	UNNEST(STRING_TO_ARRAY(casts, ',')) AS new_actor,
	COUNTRY,
	COUNT(show_id)
FROM netflix_p1
WHERE country ILIKE '%India%'
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10


---15.
---Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
---the description field. Label content containing these keywords as 'Bad' and all other 
---content as 'Good'. Count how many items fall into each category.
SELECT 
	*
FROM netflix_p1
WHERE description ILIKE '%kill%'
	OR
	description ILIKE '%violence%'


--creat function
WITH new_table
AS
(
SELECT 
	*,
CASE
WHEN
	(description ILIKE '%kill%') OR
	(description ILIKE '%violence%') THEN 'Bad'
	ELSE 'Good'
END category
FROM netflix_p1
)
SELECT 
	category,
	COUNT(*) AS total_conenet
FROM new_table
GROUP BY 1








