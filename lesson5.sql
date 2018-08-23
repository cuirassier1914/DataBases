--перевод сотрудника из отдела в отдел--

use employees;

START TRANSACTION ;
BEGIN;

SAVEPOINT stage00;

LOCK TABLES dept_emp read;
UPDATE dept_emp
  SET to_date=date(now())
  WHERE emp_no=10001 and to_date > now();
INSERT INTO dept_emp (emp_no, dept_no, from_date, to_date)
  VALUE (10001, 'd002', date(now())), '9999-01-01');
UNLOCK TABLES;

SAVEPOINT  stage01;

LOCK TABLES salaries read;
UPDATE salaries
  SET to_date=date(now())
  WHERE emp_no=10001 and to_date > now();
UNLOCK TABLES;

SAVEPOINT stage02;

LOCK TABLES titles;
UPDATE titles
  SET to_date=date(now())
  WHERE emp_no=10001 and to_date > now();
INSERT INTO titles (emp_no, title, from_date, to_date)
  VALUE (10001, 'President', date(now())), '9999-01-01');
UNLOCK TABLES;

COMMIT;

