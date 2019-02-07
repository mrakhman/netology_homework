-- Оконные функции
SELECT userid, movieid,
	(rating - min(rating) OVER u_id) / (max(rating) OVER u_id - min(rating) OVER u_id) AS normed_rating,
	avg(rating) OVER (PARTITION BY userid) AS avg_rating

FROM (
	SELECT DISTINCT userid, movieid, rating
	FROM ratings
	WHERE userid <> 1 LIMIT 1000
	) AS sample -- выборка в 1000 юзеров, чтобы ускорить запрос
WINDOW u_id AS (PARTITION BY userid)
ORDER BY userid, rating ASC
LIMIT 30;


-- ETL
-- Extract
psql -c '
  CREATE TABLE IF NOT EXISTS keywords_1 (
    id BIGINT,
    tags VARCHAR
  );'

psql -c "\\copy keywords_1 FROM '/usr/local/share/netology/raw_data/keywords.csv' DELIMITER ',' CSV HEADER"


-- Transform
-- ЗАПРОС3
WITH top_rated AS ( 
	SELECT movieid, avg(rating) AS avg_rating
	FROM ratings
	GROUP BY movieid
	HAVING count(rating) > 50
	ORDER BY avg_rating DESC, movieid ASC
	LIMIT 150
 ) 

SELECT movieid, tags AS top_rated_tags INTO top_rated_tags FROM keywords_1 INNER JOIN top_rated
ON keywords_1.id = top_rated.movieid;


-- Load
psql -c "\copy (SELECT * FROM top_rated_tags) TO 'top_rated_tags.csv' WITH CSV HEADER DELIMITER AS E'\t';"


-- Второй вариант выгрузки - сделать dump
pg_dump postgres -t top_rated_tags > top_rated_tags.sql
