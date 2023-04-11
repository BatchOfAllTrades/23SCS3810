-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): 
-- Description: IPPS database

DROP DATABASE ipps;

CREATE DATABASE ipps;

\c ipps

-- create tables
CREATE TABLE providers (
    Rndrng_Prvdr_CCN INT PRIMARY KEY NOT NULL,
    Rndrng_Prvdr_Org_Name VARCHAR(100) NOT NULL,
    Rndrng_Prvdr_St VARCHAR(80) NOT NULL,
    Rndrng_Prvdr_City VARCHAR(40) NOT NULL,
    Rndrng_Prvdr_State_Abrvtn CHAR(2) NOT NULL,
    Rndrng_Prvdr_State_FIPS INT NOT NULL,
    Rndrng_Prvdr_Zip5 INT NOT NULL,
    Rndrng_Prvdr_RUCA INT NOT NULL
)

CREATE TABLE rucas (
    Rndrng_Prvdr_RUCA INT PRIMARY KEY NOT NULL,
    Rndrng_Prvdr_RUCA_Desc VARCHAR(150) NOT NULL,
    FOREIGN KEY (Rndrng_Prvdr_RUCA) 
        REFERENCES providers (Rndrng_Prvdr_RUCA)
)

CREATE TABLE drgs (
    DRG_Cd INT PRIMARY KEY NOT NULL,
    DRG_Desc VARCHAR(100) NOT NULL
)

CREATE TABLE drg_charges (
    DRG_Cd INT NOT NULL,
    Avg_Submtd_Cvrd_Chrg FLOAT NOT NULL,
    PRIMARY KEY (DRG_Cd, Avg_Submtd_Cvrd_Chrg),
    FOREIGN KEY (DRG_Cd) REFERENCES drgs (DRG_Cd)
)

CREATE TABLE provider_charges (
    Avg_Submtd_Cvrd_Chrg FLOAT NOT NULL,
    Rndrng_Prvdr_CCN INT NOT NULL,
    Avg_Mdcr_Pymt_Amt FLOAT NOT NULL,
    Avg_Mdcr_Pymt_Amt FLOAT NOT NULL,
    Tot_Dschrgs INT NOT NULL,
    PRIMARY KEY (Avg_Submtd_Cvrd_Chrg, Rndrng_Prvdr_CCN),
    FOREIGN KEY (Avg_Submtd_Cvrd_Chrg) REFERENCES drg_charges (Avg_Submtd_Cvrd_Chrg),
    FOREIGN KEY (Rndrng_Prvdr_CCN) REFERENCES providers (Rndrng_Prvdr_CCN)
)


-- create user with appropriate access to the tables

-- queries

-- a) List all diagnosis in alphabetical order.    

-- b) List the names and correspondent states (including Washington D.C.) of all of the providers in alphabetical order (state first, provider name next, no repetition). 

-- c) List the total number of providers.

-- d) List the total number of providers per state (including Washington D.C.) in alphabetical order (also printing out the state).  

-- e) List the providers names in Denver (CO) or in Lakewood (CO) in alphabetical order  

-- f) List the number of providers per RUCA code (showing the code and description)

-- g) Show the DRG description for code 308 

-- h) List the top 10 providers (with their correspondent state) that charged (as described in Avg_Submtd_Cvrd_Chrg) the most for the DRG code 308. Output should display the provider name, their city, state, and the average charged amount in descending order.   

-- i) List the average charges (as described in Avg_Submtd_Cvrd_Chrg) of all providers per state for the DRG code 308. Output should display the state and the average charged amount per state in descending order (of the charged amount) using only two decimals. 

-- j) Which provider and clinical condition pair had the highest difference between the amount charged (as described in Avg_Submtd_Cvrd_Chrg) and the amount covered by Medicare only (as described in Avg_Mdcr_Pymt_Amt)?
