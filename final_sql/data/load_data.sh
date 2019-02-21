#!/bin/sh

psql -c "DROP TABLE IF EXISTS booking"
psql -c "DROP TABLE IF EXISTS call"
psql -c "DROP TABLE IF EXISTS client"
psql -c "DROP TABLE IF EXISTS expense"
psql -c "DROP TABLE IF EXISTS shift"
psql -c "DROP TABLE IF EXISTS visit"

echo "Загружаем booking.csv..."
psql -c '
  CREATE TABLE booking (
    booking_id bigint,
    client_id bigint,
    place_id int,
    creation_utc timestamp,
    employee_id bigint
  );'

psql -c \
    "\\copy booking FROM '/data/booking.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем call.csv..."
psql -c '
  CREATE TABLE call (
    timestamp_utc timestamp,
    place_id int
  );'

psql -c \
    "\\copy call FROM '/data/call.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем client.csv..."
psql -c '
  CREATE TABLE client (
    client_id bigint,
    card_level int,
    creator_employee_id bigint,
    creation_utc timestamp,
    creation_place_id int
  );'

psql -c \
    "\\copy client FROM '/data/client.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем expense.csv..."
psql -c '
  CREATE TABLE expense (
    expense_id bigint,
    client_id bigint,
    place_id int,
    is_promo_type bool,
    creation_utc timestamp
  );'

psql -c \
    "\\copy expense FROM '/data/expense.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем shift.csv..."
psql -c '
  CREATE TABLE shift (
    shift_id bigint,
    place_id int,
    employee_id bigint,
    start_utc timestamp,
    finish_utc timestamp
  );'

psql -c \
    "\\copy shift FROM '/data/shift.csv' DELIMITER ';' CSV HEADER"

echo "Загружаем visit.csv..."
psql -c '
  CREATE TABLE visit (
    visit_id bigint,
    client_id bigint,
    place_id int,
    start_utc timestamp,
    finish_utc timestamp
  );'

psql -c \
    "\\copy visit FROM '/data/visit.csv' DELIMITER ';' CSV HEADER"