CREATE TABLE Department (
        id INTEGER PRIMARY KEY,
        name VARCHAR (256) NOT NULL
);

CREATE TABLE Employee (
        id INTEGER PRIMARY KEY,
  		department_id INTEGER REFERENCES Department(id),
  		chief_doc_id INTEGER,
        name VARCHAR (256) NOT NULL,
        num_public INTEGER
);

insert into Department values
('1', 'Therapy'),
('2', 'Neurology'),
('3', 'Cardiology'),
('4', 'Gastroenterology'),
('5', 'Hematology'),
('6', 'Oncology');
 
insert into Employee values
('1', '1', '1', 'Kate', 4),
('2', '1', '1', 'Lidia', 2),
('3', '1', '1', 'Alexey', 1),
('4', '1', '2', 'Pier', 7),
('5', '1', '2', 'Aurel', 6),
('6', '1', '2', 'Klaudia', 1),
('7', '2', '3', 'Klaus', 12),
('8', '2', '3', 'Maria', 11),
('9', '2', '4', 'Kate', 10),
('10', '3', '5', 'Peter', 8),
('11', '3', '5', 'Sergey', 9),
('12', '3', '6', 'Olga', 12),
('13', '3', '6', 'Maria', 14),
('14', '4', '7', 'Irina', 2),
('15', '4', '7', 'Grit', 10),
('16', '4', '7', 'Vanessa', 16),
('17', '5', '8', 'Sascha', 21),
('18', '5', '8', 'Ben', 22),
('19', '6', '9', 'Jessy', 19),
('20', '6', '9', 'Ann', 18);


-- a
-- Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов
SELECT Department.name, count(DISTINCT chief_doc_id) AS num_chief_doc
FROM Department INNER JOIN Employee
ON Department.id = Employee.department_id
GROUP BY Department.name;


-- b
-- Вывести список департаментов, в которых работают 3 и более сотрудников 
-- (id и название департамента, количество сотрудников)
SELECT Department.id, Department.name, count(Employee.id) AS num_employees
FROM Department INNER JOIN Employee
ON Department.id = Employee.department_id
GROUP BY Department.id
HAVING count(Employee.id) >= 3
ORDER BY Department.id ASC;


-- c
-- Вывести список департаментов с максимальным количеством публикаций 
-- (id и название департамента, количество публикаций)
WITH tmp_table AS
(
	SELECT Department.id AS id, Department.name AS name, sum(Employee.num_public) AS depart_pub_sum
	FROM Department INNER JOIN Employee
	ON Department.id = Employee.department_id
	GROUP BY Department.id
)
SELECT * FROM tmp_table
WHERE depart_pub_sum = (SELECT max(depart_pub_sum) FROM tmp_table);


-- d
-- Вывести список сотрудников с минимальным количеством публикаций в своем департаменте 
-- (id и название департамента, имя сотрудника, количество публикаций)

