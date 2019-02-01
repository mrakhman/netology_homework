SELECT 'ФИО: Мария Рахман';

-- 1. Простые выборки
-- 1.1
SELECT * FROM ratings
LIMIT 10;


-- 1.2
SELECT * FROM links
WHERE imdbid LIKE '%42' AND
movieid >= 100 AND movieid <= 1000;


-- 2. Сложные выборки: JOIN
-- 2.1
SELECT links.imdbid FROM links INNER JOIN ratings
ON links.movieid = ratings.movieid 
WHERE ratings.rating = 5
GROUP BY imdbid
LIMIT 10;


-- 3. Аггрегация данных: базовые статистики
-- 3.1
SELECT count(*) FROM links LEFT JOIN ratings
ON links.movieid = ratings.movieid 
WHERE ratings.rating IS NULL;

-- 3.2
SELECT userid, avg(rating) AS top_rating
FROM ratings
GROUP BY userid
HAVING avg(rating) > 3.5
ORDER BY avg(rating) DESC
LIMIT 10;


-- 4. Иерархические запросы

-- 4.1 Как сделать через SELECT DISTINCT до меня так и не дошло)

-- 4.1 Этот запрос исполняется за 0,48 секунды:
WITH tmp_table AS
(
	SELECT movieid, avg(rating) AS avg_rating
	FROM ratings
	GROUP BY movieid
	HAVING avg(rating) > 3.5
)

SELECT links.imdbid FROM links INNER JOIN tmp_table
ON links.movieid = tmp_table.movieid
ORDER BY imdbid -- чтобы сравнить выдачу разных запросов: так останутся не рандомные значения
LIMIT 10;

-- 4.1 Этот запрос исполняется за 2,49 секунды:
SELECT imdbid
FROM links
INNER JOIN ratings ON links.movieid = ratings.movieid
GROUP BY imdbid
HAVING avg(rating) > 3.5
ORDER BY imdbid -- чтобы сравнить выдачу разных запросов: так останутся не рандомные значения
LIMIT 10;

-- 4.1 Этот запрос исполняется за 0,51 секунды:
SELECT imdbid
FROM links
WHERE
	links.movieid IN (SELECT ratings.movieid
	FROM ratings
	GROUP BY ratings.movieid
	HAVING avg(rating) > 3.5
	)
ORDER BY imdbid -- чтобы сравнить выдачу разных запросов: так останутся не рандомные значения
LIMIT 10;


-- 4.2
WITH tmp_table AS
(
	SELECT userid, avg(rating) AS usr_rating
	FROM ratings
	GROUP BY userid
	HAVING count(rating) > 10
)

SELECT avg(usr_rating) AS average_rating FROM tmp_table;

