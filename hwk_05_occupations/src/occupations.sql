-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student: Matt Bacheldor
-- Description: a database of occupations

CREATE DATABASE occupations;

\c occupations

DROP TABLE IF EXISTS Occupations;

-- TODO: create table Occupations
CREATE TABLE Occupations(
    code CHAR(10) PRIMARY KEY,
    occupation VARCHAR(105),
    jobFamily VARCHAR(50)
);

-- TODO: populate table Occupations
    \copy Occupations
        (code, occupation, jobFamily)
        from /var/lib/postgresql/data/occupations.csv 
        DELIMITER ',' CSV HEADER;

-- TODO: a) the total number of occupations (expect 1016).
SELECT COUNT(*) AS "Total # Occupations" FROM Occupations;

-- TODO: b) a list of all job families in alphabetical order (expect 23).
SELECT DISTINCT jobFamily AS "Job Familes" FROM Occupations ORDER BY jobFamily;

-- TODO: c) the total number of job families (expect 23)
SELECT COUNT(DISTINCT jobFamily) AS "Total # Job Families" FROM Occupations;

-- TODO: d) the total number of occupations per job family in alphabetical order of job family.
SELECT DISTINCT jobFamily AS "Job Familes", 
    COUNT(occupation) AS total FROM Occupations
    GROUP BY jobFamily
    ORDER BY jobFamily;

-- TODO: e) the number of occupations in the "Computer and Mathematical" job family (expect 38)
SELECT jobFamily AS "Job Family", 
    COUNT(occupation) AS total FROM Occupations
    WHERE jobFamily='Computer and Mathematical'
    GROUP BY jobFamily;

-- BONUS POINTS

-- TODO: f) an alphabetical list of occupations in the "Computer and Mathematical" job family.
SELECT occupation AS "Occupations in Computer and Mathematical Job Family" 
FROM Occupations
WHERE jobFamily = 'Computer and Mathematical'
ORDER BY occupation;

-- TODO: g) an alphabetical list of occupations in the "Computer and Mathematical" job family that begins with the word "Database"
SELECT occupation AS "Occupations in Databases"
FROM Occupations
WHERE jobFamily = 'Computer and Mathematical'
AND occupation LIKE 'Database%'
ORDER BY occupation;