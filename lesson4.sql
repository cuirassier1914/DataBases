-- 1) Создать VIEW на предыдущую ДЗ


CREATE VIEW city_data
  AS SELECT _cities.id, _cities.title as city, _regions.title as region, _countries.title as country
  FROM geodata._cities
  LEFT JOIN geodata._regions ON geodata._cities.region_id=geodata._regions.id
  LEFT JOIN geodata._countries ON geodata._cities.country_id=geodata._countries.id
  GROUP BY _cities.id;

CREATE VIEW cities_MD
 AS SELECT _cities.id, _cities.title as city, _regions.title as region, _countries.title as country
  FROM geodata._cities
  LEFT JOIN geodata._regions ON geodata._cities.region_id=geodata._regions.id
  LEFT JOIN geodata._countries ON geodata._cities.country_id=geodata._countries.id
  WHERE geodata._regions.title='Московская область'
  GROUP BY _cities.title;

SELECT * FROM city_data;
SELECT * FROM cities_MD;



-- DB employees

--средняя зарплата по отделам
use employees;

CREATE VIEW view_employees_salaries
  AS SELECT dept_emp.emp_no, dept_emp.dept_no, salaries.salary
      FROM employees.dept_emp
      LEFT JOIN salaries ON dept_emp.emp_no=salaries.emp_no
      WHERE dept_emp.to_date > now() && salaries.to_date > now()
      GROUP BY dept_emp.emp_no;

CREATE VIEW view_dept_avg_salaries
  AS SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d001'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d002'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d003'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d004'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d005'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d006'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d007'
   UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d008'UNION
   SELECT dept_no, avg(salary)
   FROM view_employees_salaries
   WHERE dept_no='d009';

SELECT * FROM view_dept_avg_salaries;



-- максимальная зарплата сотрудника

CREATE VIEW view_max_salary AS
  SELECT emp_no, dept_no, max(salary) FROM view_employees_salaries;

SELECT * FROM view_max_salary;

-- удалить сотрудника с наибольшей зарплатой

DELETE FROM employees
WHERE emp_no=(SELECT emp_no FROM view_max_salary);
DELETE FROM salaries
WHERE emp_no=(SELECT emp_no FROM view_max_salary);
DELETE FROM dept_emp
WHERE emp_no=(SELECT emp_no FROM view_max_salary);

-- количество сотрудников во всех отделах

SELECT COUNT(emp_no) FROM view_employees_salaries;

-- найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

CREATE VIEW view_empl_count_total_salary AS
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d001'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d002'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d003'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d004'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d005'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d006'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d007'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d008'
 UNION
 SELECT dept_no, COUNT(emp_no), SUM(salary)
 FROM view_employees_salaries
 WHERE dept_no='d009';

 SELECT * FROM view_empl_count_total_salary;




--2) Создать функцию, которая найдет менеджера по имени и фамилии

delimiter //
  CREATE FUNCTION func_find_manager (full_name VARCHAR(30))
    RETURNS INT(11)
    BEGIN
     DECLARE result INT(11);
     SET result=(SELECT emp_no FROM employees WHERE CONCAT(first_name, ' ', last_name)=full_name);
     RETURN result;
    END//
delimiter ;

SELECT func_find_manager('Bezalel Simmel');



--3) Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус,
-- занося запись в таблицу salary

delimiter //
  CREATE TRIGGER trig_new_emp
    AFTER INSERT ON employees
    FOR EACH ROW
    BEGIN
      SET @bonus=50000;
      INSERT INTO salaries (emp_no, salary, from_date, to_date)
              VALUE
                ((NEW.emp_no), @bonus, date(now()), date_add(date(now()), INTERVAL 1 MONTH));
    END//
delimiter ;
