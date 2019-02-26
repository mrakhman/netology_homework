SET search_path TO final_sql;


-- 1 [expense]
-- Показать топ 10 клиентов, которые потратили больше всего денег в антикафе.
SELECT client_id, sum(amount) AS total_expense
FROM expense
GROUP BY client_id
ORDER BY sum(amount) DESC
LIMIT 10;



-- 2 [expense + visit]
-- Показать число посещений и выручку за ноябрь 2018 по каждому антикафе.
WITH n_visits AS
(
	SELECT visit.place_id, count(visit_id) AS n_visits
	FROM visit
	WHERE start_utc >= '2018-10-01 00:00:00'
	AND start_utc < '2018-11-01 00:00:00'
	GROUP BY visit.place_id
)

SELECT expense.place_id, sum(amount) AS revenue, n_visits
FROM expense LEFT JOIN n_visits
ON expense.place_id = n_visits.place_id
WHERE expense.creation_utc >= '2018-10-01 00:00:00'
AND expense.creation_utc < '2018-11-01 00:00:00'
GROUP BY expense.place_id, n_visits.n_visits
ORDER BY sum(amount) DESC;



-- 3 [expense + client]
-- Показать, какую выручку в % приносят клиенты с каждым типом карты (card_level).
SELECT card_level, sum(amount) AS revenue,
sum(sum(amount)) OVER () AS total_revenue,
-- Берем (revenue по типу карты / total_revenue) * 100 % и округляем до 2 знаков после ,
round(sum(amount) * 100 / sum(sum(amount)) OVER (), 2) AS percent_of_revenue
FROM client INNER JOIN expense
ON client.client_id = expense.client_id
GROUP BY card_level
ORDER BY sum(amount) DESC;



-- 4 [client]
-- Кто из сотрудников зарегистрировал больше всего клиентов, топ 10.
SELECT creation_place_id AS cafe_id, creator_employee_id AS employee_id, count(creator_employee_id) AS n_registered_users
FROM client
GROUP BY creation_place_id, creator_employee_id
ORDER BY count(creator_employee_id) DESC
LIMIT 10;



-- 5 [client + visit]
-- Выбрать всех клиентов, которых зарегали первые 3 сотрудника (из предыдущего запроса). 
-- Посмотреть количество посещений по каждому сотруднику отдельно у топ 40 клиентов.
WITH first_three AS
(
	SELECT creator_employee_id, count(creator_employee_id) AS n_registered_users
	FROM client
	GROUP BY creator_employee_id
	ORDER BY count(creator_employee_id) DESC
	LIMIT 3
)

, client_list AS
(
	SELECT first_three.creator_employee_id, client_id 
	FROM client INNER JOIN first_three
	ON client.creator_employee_id = first_three.creator_employee_id
)

SELECT creator_employee_id, visit.client_id, count(visit_id) AS n_visits
FROM visit INNER JOIN client_list
ON visit.client_id = client_list.client_id
GROUP BY creator_employee_id, visit.client_id
ORDER BY count(visit_id) DESC
LIMIT 40;



-- 6 [client + visit]
-- Показать долю посещений клиентов с гостевой картой от общего числа посещений по каждому антикафе.
SELECT place_id, count(visit_id) AS total_visits, 
count(visit_id) FILTER (WHERE client_id IN (SELECT client_id FROM client WHERE card_level = 1)) AS guest_visits,
100 * count(visit_id) FILTER (WHERE client_id IN (SELECT client_id FROM client WHERE card_level = 1)) / count(visit_id) AS guests_percent
FROM visit
GROUP BY visit.place_id
ORDER BY count(visit_id) DESC;



-- 7 [booking + client]
-- Показать, клиенты с каким уровнем карты чаще всего бронируют комнаты, по убыванию.
SELECT card_level, count(booking_id) AS n_bookings
FROM booking INNER JOIN client
ON booking.client_id = client.client_id
GROUP BY card_level
ORDER BY count(booking_id) DESC;



-- 8 [client + shift]
-- Топ 10 количества регистраций новых клиентов за смену.
SELECT shift_id, shift.employee_id, count(client.client_id)
FROM shift INNER JOIN client
ON shift.employee_id = client.creator_employee_id
WHERE client.creation_utc >= shift.start_utc
AND client.creation_utc <= shift.finish_utc
GROUP BY shift.shift_id, shift.employee_id
ORDER BY count(client.client_id) DESC
LIMIT 10;



-- 9 [visit]
-- Показать среднее количество посещений за последние 3 месяца (23.08.18 - 23.11.18) в выходной день и в рабочий.
SELECT 
count(visit_id) FILTER (WHERE EXTRACT(DOW FROM start_utc) >= 1 AND EXTRACT(DOW FROM start_utc) <= 5) AS total_weekday,
count(visit_id) FILTER (WHERE EXTRACT(DOW FROM start_utc) = 0 OR EXTRACT(DOW FROM start_utc) = 6) AS total_weekend,
(count(visit_id) FILTER (WHERE EXTRACT(DOW FROM start_utc) >= 1 AND EXTRACT(DOW FROM start_utc) <= 5)) / 5 AS avg_weekday,
(count(visit_id) FILTER (WHERE EXTRACT(DOW FROM start_utc) = 0 OR EXTRACT(DOW FROM start_utc) = 6)) / 2 AS avg_weekend
FROM visit 
WHERE start_utc >= '2018-08-23 00:00:00' 
AND finish_utc <= '2018-11-23 23:59:59';



-- 10 [visit]
-- Среднее количество гостей в утреннюю, дневную, вечернюю смену за последний месяц по каждому кафе.
-- Для этого не обязательно JOIN'ить таблицу shift, так как и там и там используется timestamp 
-- и время смен всегда одигаковое: 08:00 - 15:00, 15:00 - 22:00, 22:00 - 08:00
-- в базе время стоит в UTC, а Москва UTC+3. Поэтому в запросе пересменки в 05:00, 12:00 и 19:00
SELECT place_id AS cafe_id,
(count(visit_id) FILTER (WHERE start_utc::time >= '05:00:00'::time AND start_utc::time < '12:00:00'::time)) / 31 AS morning_shift,
(count(visit_id) FILTER (WHERE start_utc::time >= '12:00:00'::time AND start_utc::time < '19:00:00'::time)) / 31 AS daytime_shift,
(count(visit_id) FILTER (WHERE (start_utc::time >= '19:00:00'::time AND start_utc::time <= '23:59:59'::time) OR (start_utc::time >= '00:00:00'::time AND start_utc::time < '05:00:00'::time))) / 31 AS night_shift
FROM visit 
WHERE start_utc >= '2018-10-23 00:00:00'
AND finish_utc <= '2018-11-23 23:59:59'
GROUP BY place_id;






