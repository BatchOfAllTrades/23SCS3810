-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Description: The hr database

CREATE DATABASE hr;

\c hr

CREATE TABLE Employees (
 id INT NOT NULL PRIMARY KEY,
 name VARCHAR(35) NOT NULL,
 sal INT ); 

INSERT INTO Employees VALUES
 ( 1, 'Sam Mai Tai', 35000 ),
 ( 2, 'Morbid Mojito', 65350 );

CREATE USER "hr" PASSWORD '024680';
CREATE USER "hr_admin" PASSWORD '135791';

\du

GRANT SELECT ON TABLE Employees TO "hr";
GRANT ALL ON TABLE Employees TO "hr_admin";

-- docker exec -it postgres psql -d hr -U hr -W

INSERT INTO Employees VALUES (3, 'Thyago', 200000);

-- docker exec -it postgres psql -d hr -U hr_admin -W

