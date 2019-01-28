CREATE TABLE films (
        id SERIAL PRIMARY KEY,
        title VARCHAR (256) NOT NULL,
        country VARCHAR (64) NOT NULL,
        box_office INTEGER NOT NULL,
        release_year TIMESTAMP
);
CREATE TABLE persons (
        id SERIAL PRIMARY KEY,
        fio VARCHAR (64) NOT NULL
);
CREATE TABLE persons2content (
        person_id INTEGER REFERENCES persons(id),
        film_id INTEGER REFERENCES films(id),
        person_type VARCHAR (32) NOT NULL
);

INSERT INTO films(title, country, box_office, release_year) 
VALUES
        ('500 дней лета', 'США', 58559042, timestamp '2009-01-01'),
       ('Бруклин', 'Великобритания, США, Ирландия', 62076141, timestamp '2015-01-01'),
       ('Интерстеллар', 'США, Великобритания', 675120017, timestamp '2014-01-01'),
       ('Артист', 'Франция, Бельгия', 133432856, timestamp '2011-01-01'),
       ('12 лет рабства', 'США, Великобритания', 178371993, timestamp '2013-01-01');

INSERT INTO persons(fio)
VALUES 
        ('Matthew McConaughey'),
        ('Anne Hathaway'),
        ('Chiwetel Ejiofor'),
        ('Lupita Nyongo'),
        ('Saoirse Ronan'),
        ('Jean Dujardin'),
        ('Bérénice Bejo');

INSERT INTO persons2content(fio)
