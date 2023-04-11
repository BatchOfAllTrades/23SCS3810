DROP DATABASE test;

CREATE DATABASE test;

DROP TABLE Movies;

CREATE TABLE Movies (
    title CHAR(100),
    year INT,
    length INT, 
    genre VARCHAR(10) DEFAULT '?',
    PRIMARY KEY (title, year)
);



DROP TABLE Stars;

CREATE TABLE Stars (
    name VARCHAR(30) PRIMARY KEY,
    gender CHAR(1) DEFAULT '?'
);

\copy Stars from '/Users/matthewbacheldor/Documents/CS3810/names.csv' DELIMETER ','

INSERT INTO Stars VALUES
    ('Jane FOnda', 'F'),
    ('Harrison Ford', 'M');

DROP TABLE Employees;

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    salary INT NOT NULL
);

INSERT INTO Employees VALUES
    (1, 'John', 60000),
    (2, 'Mary', 55000),
    (3, 'Harry', 80000),
    (4, 'Rebecca', 80000);

DROP TABLE Departments;

CREATE TABLE Departments (
    depCode CHAR(2),
    description VARCHAR(59)
);

INSERT INTO Departments VALUES
    ('HR', 'Human Resources'),
    ('IT', 'Information Technology'),
    ('MK', 'Marketing'),
    ('SL', 'Sales');

SELECT * FROM Employees_B
NATURAL JOIN Departments;

SELECT * FROM Employees_B A
INNER JOIN Departments B
ON A.code = B.code;

SELECT * FROM Employees_B A
INNER JOIN Departments B
ON A.code = B.code;

DROP TABLE Employees_B;

SELECT * FROM Employees A,
Departments B 
WHERE A.depCode = B.code 
AND A.salary > 60000;

SELECT * FROM Employees;