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

psql -c '
  CREATE TABLE IF NOT EXISTS keywords (
    id BIGINT,
    tags VARCHAR,
    timestamp bigint
  );'