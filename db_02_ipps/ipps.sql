-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Matt Bacheldor
-- Description: IPPS database

DROP DATABASE ipps;

CREATE DATABASE ipps;

\c ipps

-- create tables
CREATE TABLE RUCAs (
    Rndrng_Prvdr_RUCA FLOAT PRIMARY KEY,
    Rndrng_Prvdr_RUCA_Desc VARCHAR(150)
);

CREATE TABLE providers (
    Rndrng_Prvdr_CCN INT PRIMARY KEY,
    Rndrng_Prvdr_Org_Name VARCHAR(100),
    Rndrng_Prvdr_St VARCHAR(80),
    Rndrng_Prvdr_City VARCHAR(45),
    Rndrng_Prvdr_State_Abrvtn CHAR(2),
    Rndrng_Prvdr_State_FIPS INT,
    Rndrng_Prvdr_Zip5 INT,
    Rndrng_Prvdr_RUCA INT,
    FOREIGN KEY (Rndrng_Prvdr_RUCA) REFERENCES RUCAs (Rndrng_Prvdr_RUCA)
);

CREATE TABLE DRGs (
    DRG_Cd INT PRIMARY KEY,
    DRG_Desc VARCHAR(200)
);

CREATE TABLE ProviderCharges (
    Avg_Submtd_Cvrd_Chrg FLOAT,
    DRG_Cd INT,
    Rndrng_Prvdr_CCN INT,
    Avg_Tot_Pymt_Amt FLOAT,
    Avg_Mdcr_Pymt_Amt FLOAT,
    Tot_Dschrgs INT,
    PRIMARY KEY (Avg_Submtd_Cvrd_Chrg, DRG_Cd, Rndrng_Prvdr_CCN),
    FOREIGN KEY (DRG_Cd) REFERENCES DRGs (DRG_Cd),
    FOREIGN KEY (Rndrng_Prvdr_CCN) REFERENCES Providers (Rndrng_Prvdr_CCN)
);


-- create user with appropriate access to the tables
CREATE USER "Mota" PASSWORD '135791';
GRANT ALL ON TABLE RUCAs TO "Mota";
GRANT ALL ON TABLE Providers TO "Mota";
GRANT ALL ON TABLE DRGs TO "Mota";
GRANT ALL ON TABLE ProviderCharges TO "Mota";

-- queries

-- a) List all diagnosis in alphabetical order.
SELECT DRG_Desc AS Diagnosis FROM DRGs
ORDER BY Diagnosis;    

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers 
-- in alphabetical order (state first, provider name next, no repetition). 
SELECT DISTINCT Rndrng_Prvdr_Org_Name AS provider, Rndrng_Prvdr_State_Abrvtn AS state FROM providers
ORDER BY state, provider;

-- c) List the total number of providers.
SELECT COUNT(*) AS "Total # of Providers" FROM providers;

-- d) List the total number of providers per state (including Washington D.C.) in alphabetical order (also printing out the state).
SELECT Rndrng_Prvdr_State_Abrvtn AS state, COUNT(*) AS "Total # of Providers" FROM providers
GROUP BY state
ORDER BY state;

-- e) List the providers names in Denver (CO) or in Lakewood (CO) in alphabetical order 
SELECT Rndrng_Prvdr_Org_Name as provider, CONCAT(Rndrng_Prvdr_City, ', ', Rndrng_Prvdr_State_Abrvtn) as location FROM providers
WHERE Rndrng_Prvdr_State_Abrvtn = 'CO'
AND (Rndrng_Prvdr_City = 'Denver' OR Rndrng_Prvdr_City = 'Lakewood')
ORDER BY provider; 

-- f) List the number of providers per RUCA code (showing the code and description)
SELECT A.Rndrng_Prvdr_RUCA AS code, A.Rndrng_Prvdr_RUCA_Desc as description, COUNT(B.Rndrng_Prvdr_RUCA) AS "Number of Providers" FROM RUCAs A
NATURAL JOIN providers B 
GROUP BY code
ORDER BY code;

-- g) Show the DRG description for code 308 
SELECT DRG_Desc FROM DRGs
WHERE DRG_Cd = 308;

-- h) List the top 10 providers (with their correspondent state) that charged (as described in Avg_Submtd_Cvrd_Chrg) 
-- the most for the DRG code 308. Output should display the provider name, their city, state, 
-- and the average charged amount in descending order. 
SELECT  A.Rndrng_Prvdr_Org_Name as provider, 
        A.Rndrng_Prvdr_City AS city, 
        A.Rndrng_Prvdr_State_Abrvtn AS state, 
        B.Avg_Submtd_Cvrd_Chrg AS charge FROM providers A
NATURAL JOIN ProviderCharges B 
WHERE DRG_Cd = 308
ORDER BY charge DESC 
LIMIT 10;

-- i) List the average charges (as described in Avg_Submtd_Cvrd_Chrg) of all providers per state for the DRG code 308. 
-- Output should display the state and the average charged amount per state in descending order (of the charged amount) 
-- using only two decimals. 
SELECT A.Rndrng_Prvdr_State_Abrvtn AS state, CONCAT('$', ROUND(AVG(B.Avg_Submtd_Cvrd_Chrg)::DECIMAL, 2)) AS charge FROM providers A 
NATURAL JOIN ProviderCharges B 
WHERE DRG_Cd = 308
GROUP BY state
ORDER BY charge DESC;

-- j) Which provider and clinical condition pair had the highest difference between the amount charged 
-- (as described in Avg_Submtd_Cvrd_Chrg) and the amount covered by Medicare only (as described in Avg_Mdcr_Pymt_Amt)?
SELECT A.Rndrng_Prvdr_Org_Name as provider, 
    C.DRG_Desc as condition, 
    ROUND(MAX(B.Avg_Submtd_Cvrd_Chrg - B.Avg_Mdcr_Pymt_Amt)::DECIMAL, 2) AS difference 
    FROM providers A
NATURAL JOIN ProviderCharges B 
NATURAL JOIN DRGs C
GROUP BY provider, condition
ORDER BY difference DESC LIMIT 1;
