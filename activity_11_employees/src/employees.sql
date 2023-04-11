-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Description: The employees database

-- TODO: create database employees
CREATE DATABASE employees;
\c employees
-- TODO: create table departments
CREATE TABLE Departments (
    code CHAR(2) PRIMARY KEY,
    "desc" VARCHAR(30)
);
-- TODO: populate table departments
INSERT INTO Departments VALUES 
    ('HR', 'Human Resources'),
    ('IT', 'Information Technology'),
    ('SL', 'Sales');
INSERT INTO Departments VALUES
    ('MK', 'Marketing');

-- TODO: create table employees
CREATE TABLE Employees(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    sal NUMERIC NOT NULL,
    deptCode CHAR(2),
    FOREIGN KEY (deptCode) REFERENCES
    Departments(code)
);
-- TODO: populate table Employees
INSERT INTO Employees (name, sal, deptCode) VALUES
('Sam Mai Tai', '50000', 'HR'),
('James Brandy', '55000', 'HR'),
('Whiskey Strauss', '60000', 'HR'),
('Romeo Curacau', '65000', 'IT'),
('Jose Caipirinha', '65000', 'IT'),
('Tony Gin and Tonic', '80000', 'SL'),
('Debby Derby', '85000', 'SL'),
('Morbid Mojito', '150000', NULL);
-- TODO: a) list all rows in Departments.
SELECT * FROM Departments;

-- TODO: b) list only the codes in Departments.
SELECT code FROM Departments;

-- TODO: c) list all rows in Employees.


-- TODO: d) list only the names in Employees in alphabetical order.

-- TODO: e) list only the names and salaries in Employees, from the highest to the lowest salary.

-- TODO: f) list the cartesian product of Employees and Departments.

-- TODO: g) do the natural join of Employees and Departments; the result should be exactly the same as the cartesian product; do you know why?
SELECT id, deptCode, code FROM Employees
NATURAL JOIN Departments
ORDER BY id, code;

-- TODO: i) do an equi join of Employees and Departments matching the rows by Employees.deptCode and Departments.code (hint: use JOIN and the ON clause).
-- Equijoin (theta join using equality)
SELECT * FROM Employees A, Departments B
WHERE A.deptCode = B.code;

-- Equijoin
SELECT * FROM Employees A
INNER JOIN Departments b
ON A.deptCode = B.code;

-- LEFT OUTER JOIN (Shows not only the employees in relationship with departments but 
-- also the ones not in relationship; in other words, emplyees that aren't currently working ina department)
SELECT * FROM Employees A 
LEFT JOIN Departments B
ON A.deptCode = B.code;

SELECT * FROM Employees A 
RIGHT JOIN Departments B
ON A.deptCode = B.code;

-- TODO: j) same as previous query but project name and salary of the employees plus the description of their departments.
SELECT name, sal AS salary, "desc" AS description
FROM Employees A
INNER JOIN Departments B
ON A.deptCode = B.code;

-- TODO: k) same as previous query but only the employees that earn less than 60000.
SELECT name, sal AS salary, "desc" AS description
FROM Employees A
INNER JOIN Departments B
ON A.deptCode = B.code
WHERE sal < 60000;

-- TODO: l) same as query ‘i’  but only the employees that earn more than ‘Jose Caipirinha’.
SELECT * FROM Employees A
INNER JOIN Departments b
ON A.deptCode = B.code
WHERE sal > (
    SELECT sal FROM Employees WHERE name='Jose Caipirinha'
);

-- TODO: m) list the left outer join of Employees and Departments (use the ON clause to match by department code); how does the result of this query differs from query ‘i’?
-- completed back in TODO: (i)

-- TODO: n) from query ‘m’, how would you do the left anti-join?
SELECT * FROM Employees A 
LEFT JOIN Departments B
ON A.deptCode = B.code
WHERE A.deptCode IS NULL;

-- TODO: o) show the number of employees per department.
SELECT "desc", COUNT(*) AS total
FROM Employees A
INNER JOIN Departments B 
ON A.deptCode = B.code
GROUP BY B.code;

--OR to show the departments that do not have employees--
SELECT "desc", COUNT(A.deptCode) AS total
FROM Employees A
LEFT JOIN Departments B 
ON A.deptCode = B.code
GROUP BY B.code;


-- TODO: p) same as query ‘o’ but I want to see the description of each department (not just their codes).
