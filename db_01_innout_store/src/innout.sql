-- CS3810: Principles of Database Systems
-- Instructor: Thyago Mota
-- Student(s): Matt Bacheldor
-- Description: SQL for the In-N-Out Store

DROP DATABASE innout;

CREATE DATABASE innout;

\c innout

-- TODO: table create statements
CREATE TABLE Customers (
    id SERIAL PRIMARY KEY,
    email VARCHAR(30),
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    gender CHAR(1) DEFAULT '?',
    address VARCHAR(60)     
);

CREATE TABLE Items (
    item_code SERIAL PRIMARY KEY,
    description VARCHAR(200),
    price MONEY
);

CREATE TABLE Sales (
    sale_number SERIAL PRIMARY KEY,
    date DATE,
    time TIME,
    customer_id INTEGER,
    FOREIGN KEY (customer_id) 
    REFERENCES Customers(id)
);

CREATE TABLE SaleItems (
    item_code INTEGER,
    sale_number INTEGER,
    price_paid MONEY,
    quantity INTEGER,
    PRIMARY KEY (item_code, sale_number)
);

CREATE TABLE Categories (
    code CHAR(3) PRIMARY KEY,
    description VARCHAR(200)
);

CREATE TABLE ItemCategories (
    category_code CHAR(3),
    item_code INTEGER,
    PRIMARY KEY (category_code, item_code)
);

-- TODO: table insert statements
INSERT INTO Customers (email, first_name, last_name, gender, address) VALUES
    ('mattyb@gmail.com', 'Matt', 'Bacheldor', 'M', '123 Fake Street'),
    ('taylorB@gmail.com', 'Taylor', 'Bacheldor', 'F', '123 Fake Street'),
    ('Robin@hotmail.com', 'Robin', 'Schoenfeld', 'F', '597 Motherinlaw Road'),
    ('Rick@comcast.net', 'Rick', 'Schoenfeld', DEFAULT, '2349 Fatherinlaw Blvd.'),
    ('Chris@gmail.com', 'Christopher', 'Bacheldor', 'M', '12412 Brother Court');

INSERT INTO Categories VALUES
    ('BVR', 'beverages'),
    ('DRY', 'dairy'),
    ('PRD', 'produce'),
    ('FRZ', 'frozen'),
    ('BKY', 'bakery'),
    ('MEA', 'meat');

INSERT INTO Items (description, price) VALUES
    ('bread', '$2.98'),
    ('coffee', '$9.76'),
    ('eggs', '$9000.75'),
    ('gum', '$0.75'),
    ('ham', '$6.98'),
    ('milk', '$5.89'),
    ('pizza', '$2.50');

INSERT INTO ItemCategories VALUES
    ('BKY', 1),
    ('BVR', 2),
    ('DRY', 3),
    ('MEA', 5),
    ('DRY', 6),
    ('FRZ', 7);

INSERT INTO Sales (date, time, customer_id) VALUES
    ('12-21-1987', '12:01', '1'),
    ('08-10-1988', '14:55', '2'),
    ('10-16-2014', '07:59', '3'),
    ('12-21-2016', '22:30', '5')
    ('07-04-1776', '08:02', '1');

INSERT INTO SaleItems VALUES
    ('1', '1', '$4.00', '5'),
    ('5', '2', '$3.76', '3'),
    ('6', '2', '$0.75', '5'),
    ('2', '3', '$15.24', '1'),
    ('3', '3', '$5.33', '3'),
    ('3', '4', '$4.77', '1'),
    ('6', '4', '$8.99', '2')
    ('5', '5', '$17.76', '4');

-- TODO: SQL queries

-- a) all customer names in alphabetical order
SELECT CONCAT(first_name, ' ', last_name) AS name FROM Customers
ORDER BY Name;

-- b) number of items (labeled as total_items) in the database 
SELECT COUNT(*) AS total_items FROM Items;

-- c) number of customers (labeled as number_customers) by gender
SELECT gender,
COUNT(gender) AS number_customers FROM Customers
GROUP BY gender;

-- d) a list of all item codes (labeled as code) and descriptions (labeled as description) 
--    followed by their category descriptions (labeled as category) in numerical order of their codes 
--    (items that do not have a category should not be displayed)
SELECT A.item_code AS code, A.description, C.description AS category FROM Items A
NATURAL JOIN ItemCategories B
INNER JOIN Categories C 
ON B.category_code = C.code
ORDER BY code;

-- e) a list of all item codes (labeled as code) and descriptions (labeled as description) 
--    in numerical order of their codes for the items that do not have a category
SELECT item_code AS code, description FROM Items 
WHERE item_code NOT IN (
    SELECT item_code FROM ItemCategories
)
ORDER BY code;

-- f) a list of the category descriptions (labeled as category) that do not have an item in alphabetical order
SELECT description AS category FROM Categories
WHERE code NOT IN (
    SELECT category_code FROM ItemCategories
)
ORDER BY category;

-- g) set a variable named "ID" and assign a valid customer id to it; 
--    then show the content of the variable using a select statement
\set ID 
    'id FROM Customers
    GROUP BY id LIMIT 1'

SELECT :ID;

-- h) a list describing all items purchased by the customer identified by the variable "ID" 
--    (you must used the variable), showing, the date of the purchase (labeled as date), 
--    the time of the purchase (labeled as time and in hh:mm:ss format), the item's description 
--    (labeled as item), the quantity purchased (labeled as qtt), the item price (labeled as price), 
--    and the total amount paid (labeled as total_paid).
SELECT A.date, A.time, B.quantity, SUM(B.quantity * B.price_paid) AS total_paid
FROM Sales A 
NATURAL JOIN SaleItems B
WHERE A.customer_id = (SELECT :ID)
GROUP BY (A.date, A.time, B.quantity);

-- i) the total amount of sales per day showing the date and the total amount paid in chronological order
SELECT A.date, COUNT(DISTINCT B.sale_number) AS number_sales, 
SUM(B.quantity * B.price_paid) AS total_amount
FROM Sales A 
NATURAL JOIN SaleItems B
GROUP BY (date, sale_number)
ORDER BY date;

-- j) the description of the top item (labeled as item) in sales with the total sales amount 
--    (labeled as total_paid)
SELECT A.description AS item,
SUM(B.quantity * B.price_paid) AS total_paid
FROM Items A 
NATURAL JOIN SaleItems B
GROUP BY item
ORDER BY total_paid DESC LIMIT 1;

-- k) the descriptions of the top 3 items (labeled as item) in number of times they were purchased, showing that quantity as well (labeled as total)
SELECT A.description AS item,
SUM(B.quantity) AS total
FROM Items A 
NATURAL JOIN SaleItems B 
GROUP BY item
ORDER BY total DESC LIMIT 3;

-- l) the name of the customers who never made a purchase 
SELECT CONCAT(first_name, ' ', last_name) as name
FROM Customers
WHERE id NOT IN (
    SELECT customer_id FROM Sales
);