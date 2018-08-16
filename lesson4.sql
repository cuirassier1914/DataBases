CREATE VIEW city_data
  AS SELECT _cities.id, _cities.title as city, _regions.title as region, _countries.title as country
  FROM geodata._cities
  LEFT JOIN geodata._regions ON geodata._cities.region_id=geodata._regions.id
  LEFT JOIN geodata._countries ON geodata._cities.country_id=geodata._countries.id
  ORDER BY _cities.id;
  
CREATE VIEW cities_MD
 AS SELECT _cities.id, _cities.title as city, _regions.title as region, _countries.title as country
  FROM geodata._cities
  LEFT JOIN geodata._regions ON geodata._cities.region_id=geodata._regions.id
  LEFT JOIN geodata._countries ON geodata._cities.country_id=geodata._countries.id
  WHERE geodata._regions.title='Московская область'
  ORDER BY _cities.title;

SELECT * FROM city_data;
SELECT * FROM cities_MD;



-- DB employees
-- объединение работников и начальников

CREATE VIEW all_employees
  AS SELECT dept_emp.emp_no, dept_emp.dept_no, salaries.salary
  FROM employees.dept_emp
  LEFT JOIN employees.salaries ON employees.dept_emp.emp_no=employees.salaries.emp_no
  UNION ALL
  SELECT dept_manager.emp_no, dept_manager.dept_no, salaries.salary
  FROM employees.dept_manager
  LEFT JOIN employees.salaries ON employees.dept_manager.emp_no=employees.salaries.emp_no
  --LIMIT 30 --
  ;


--средняя зарплата по отделам



DROP TABLE IF EXISTS employees.`avg1`;
CREATE TABLE employees.`avg1` (
dept_no CHAR(4),
avg_salary INT(11)
);

INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd001',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d001'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd002',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d002'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd003',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d003'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd004',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d004'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd005',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d005'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd006',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d006'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd007',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d007'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd008',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d008'));
 
INSERT INTO employees.`avg1` (dept_no, avg_salary)
VALUE (
'd009',
(SELECT avg(salary)
FROM all_employees
WHERE all_employees.dept_no='d009'));

SELECT *, departments.dept_name
FROM employees.avg1
LEFT JOIN
employees.departments ON employees.departments.dept_no=employees.avg1.dept_no;


-- максимальная зарплата сотрудника ("менеджеров" сюда тоже включил)

SELECT max(salary) FROM all_amployees;

-- удалить сотрудника с наибольшей зарплатой

DELETE FROM all_employees ORDER BY (salary) DESC LIMIT 1;

-- количество сотрудников во всех отделах

SELECT COUNT(emp_no) FROM all_amployees;

-- найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

DROP TABLE IF EXISTS employees.empl_total;
CREATE TABLE employees.empl_total (
dept_no CHAR(4),
emp_count INT (11),
total_salary INT(11)
);

INSERT INTO employees.empl_total (dept_no, emp_count, total_salary)
VALUE (
'd001',
SELECT COUNT(emp_no) FROM all_amployees WHERE dept_no = 'd001',
SELECT SUM(salary) FROM all_amployees WHERE dept_no = 'd001'
);

SELECT * FROM employees.empl_total;

