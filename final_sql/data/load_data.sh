#!/bin/sh

psql -c "DROP SCHEMA IF EXISTS final_sql;"
psql -c "CREATE SCHEMA final_sql;"
psql -c "SET search_path TO final_sql;"

psql -c "DROP TABLE IF EXISTS booking"
psql -c "DROP TABLE IF EXISTS call"
psql -c "DROP TABLE IF EXISTS client"
psql -c "DROP TABLE IF EXISTS expense"
psql -c "DROP TABLE IF EXISTS shift"
psql -c "DROP TABLE IF EXISTS visit"

echo "Загружаем booking.csv..."
psql -c '
  CREATE TABLE final_sql.booking (
    booking_id bigint,
    client_id bigint,
    place_id int,
    creation_utc timestamp,
    employee_id bigint
  );'

psql -c \
    "\\copy final_sql.booking FROM 'booking.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем call.csv..."
psql -c '
  CREATE TABLE final_sql.call (
    timestamp_utc timestamp,
    place_id int
  );'

psql -c \
    "\\copy final_sql.call FROM 'call.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем client.csv..."
psql -c '
  CREATE TABLE final_sql.client (
    client_id bigint,
    card_level int,
    creator_employee_id bigint,
    creation_utc timestamp,
    creation_place_id int
  );'

psql -c \
    "\\copy final_sql.client FROM 'client.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем expense.csv..."
psql -c '
  CREATE TABLE final_sql.expense (
    expense_id bigint,
    client_id bigint,
    place_id int,
    is_promo_type bool,
    creation_utc timestamp,
    creator_employee_id int
  );'

psql -c \
    "\\copy final_sql.expense FROM 'expense.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем shift.csv..."
psql -c '
  CREATE TABLE final_sql.shift (
    shift_id bigint,
    place_id int,
    employee_id bigint,
    start_utc timestamp,
    finish_utc timestamp
  );'

psql -c \
    "\\copy final_sql.shift FROM 'shift.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем visit.csv..."
psql -c '
  CREATE TABLE final_sql.visit (
    visit_id bigint,
    client_id bigint,
    place_id int,
    start_utc timestamp,
    finish_utc timestamp
  );'

psql -c \
    "\\copy final_sql.visit FROM 'visit.csv' DELIMITER ';' CSV HEADER"