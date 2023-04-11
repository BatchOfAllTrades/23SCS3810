-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Description: The hr database

CREATE DATABASE hotels;

\c hotels

CREATE TABLE hotels (
    code SERIAL PRIMARY KEY, 
    name VARCHAR(50) NOT NULL, 
    city VARCHAR(50) NOT NULL, 
    state CHAR(2) NOT NULL
);

INSERT INTO hotels (name, city, state) VALUES 
    ('Le Boutique', 'New Orleans', 'LA'),
    ('Supreme', 'San Francisco', 'CA');

    CREATE USER "hotel_manager" PASSWORD '135791';
GRANT ALL ON TABLE hotels TO "hotel_manager";
GRANT ALL ON SEQUENCE hotels_code_seq TO "hotel_manager";