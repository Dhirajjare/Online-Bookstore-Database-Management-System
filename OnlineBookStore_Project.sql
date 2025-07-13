USE OnlineBookstore;

-- 
-- CREATE DATABASE 
CREATE DATABASE OnlineBookStore;

-- USE DATABASE
USE OnlineBookStore;


-- CREATE TABLE 1 BOOK


CREATE TABLE BookS(
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR (100),
    Genre VARCHAR(50),
    Published_year INT,
    Prise NUMERIC(10,2),
    Stock INT
);

-- CREATE TABLE 2 CUSTOMER

CREATE TABLE Customers(
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR (100),
    Email VARCHAR (100),
    Phone VARCHAR (15),
    City VARCHAR (50),
    Country VARCHAR (150)
);

-- CRATE TABLE 3 ORDERS
CREATE TABLE Orders(
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID ),
    Book_ID INT REFERENCES Books(Book_id),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10,2)
);


SELECT * FROM Books;

SELECT * FROM Customers;

SELECT * FROM orders;


SHOW GLOBAL VARIABLES LIKE 'local_infile';

-- If OFF, enable it:
SET GLOBAL local_infile = 0;

-- IMPORT DATA INTO BOOK TABLE

LOAD DATA LOCAL INFILE 'E:/Dhiraj doc 2023/STUDY/MY SQL/Project1/Books.csv'
INTO TABLE Books
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM books;

-- IMPORT DATA INTO CUSTOMERS
LOAD DATA LOCAL INFILE 'E:/Dhiraj doc 2023/STUDY/MY SQL/Project1/Customers.csv'
INTO TABLE Customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- IMPORT DATA INTO ORDERS

LOAD DATA LOCAL INFILE 'E:/Dhiraj doc 2023/STUDY/MY SQL/Project1/Orders.csv'
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SELECT * FROM orders;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Q.1) Retrieve all books in the "Fiction" genre

SELECT Genre FROM Books WHERE Genre='Fiction';

-- Q.2) Find books published after the year 1950:

SELECT * FROM BOOKS WHERE Published_year>1950;

-- Q.3) List all customers from the Canada:

SELECT * FROM Customers 
WHERE Country = 'Canada' ;

SELECT Country, LENGTH(Country) AS ActualLength
FROM Customers
WHERE Country LIKE 'Canada%';

SELECT Country, HEX(Country) AS Country_Hex
FROM Customers
WHERE Country LIKE 'Canada%';

UPDATE Customers
SET Country = REPLACE(Country, CHAR(13), '')
WHERE Country LIKE 'Canada%';



-- Q.4) Retrieve the total stock of books available
SELECT SUM(Stock) AS 'Sum_of_Stock' FROM Books;

-- Q.5) Find the details of the most expensive book

SELECT * FROM Books ORDER BY Prise DESC LIMIT 1;

-- Q.6) Show orders placed in November 2023:


SELECT * FROM orders WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- Q.7) Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders WHERE Quantity>1;

-- Q.8) Retrieve all orders where the total amount exceeds $20

SELECT * FROM Orders WHERE Total_Amount>20;

-- Q.9) List all genres available in the Books table

SELECT DISTINCT genre FROM Books;
SELECT Genre FROM BOOKS GROUP BY Genre;

-- Q.10) Find the book with the lowest stock

SELECT * FROM Books ORDER BY Stock LIMIT 1;

-- Q.11) Calculate the total revenue generated from all orders

SELECT SUM(Total_Amount) AS 'Revenue' FROM Orders;

-- ------------------------------------------------------------------------------------------------------------------------------------------

-- Advance Questions 

-- Q.1) Retrieve the total number of books sold for each genre



-- Type 1)
SELECT B.Genre,SUM(O.Quantity) AS 'Toatal_Sold'
FROM Books B 
JOIN Orders O ON B.Book_ID=O.Book_ID
GROUP BY B.Genre;

-- Type 2)
SELECT Genre,SUM(Quantity) AS 'Toatal_Sold'
FROM Books 
JOIN Orders  ON Books.Book_ID=Orders.Book_ID
GROUP BY Genre;

-- Q.2) Find the average price of books in the "Fantasy" genre

SELECT Genre,AVG(Prise) AS 'Average_Price' FROM Books WHERE Genre='Fantasy';

-- Q.3) List customers who have placed at least 2 orders

-- With Name
SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;

-- Without Name
SELECT customer_ID ,COUNT(Order_ID) AS 'Order_count'
FROM orders 
GROUP BY  Customer_ID 
HAVING COUNT(Order_ID)>2;

-- Q.4) Find the most frequently ordered book


SELECT O.Book_id ,B.Title, COUNT(O.Order_ID) AS "Order_Count"
FROM Orders O 
JOIN Books B ON O.Book_ID=B.Book_id 
GROUP BY O.Book_ID,B.Title
ORDER BY Order_count DESC LIMIT 1;

-- Q.5) Show the top 3 most expensive books of 'Fantasy' Genre

SELECT * FROM books
WHERE Genre='Fantasy'
ORDER BY Prise DESC LIMIT 3;

-- Q.6) Retrieve the total quantity of books sold by each author

SELECT B.Author, SUM(O.Quantity) AS 'Total_Books_Sold'
FROM Orders O
JOIN Books B ON O.Book_ID=B.Book_ID
GROUP BY B.Author;

-- Q.7)List the cities where customers who spent over $30 are located

-- Type 1)
SELECT C.City,O.Total_Amount 
FROM Orders O
JOIN Customers C ON O.Customer_ID=C.Customer_ID
WHERE Total_Amount>30;

 -- Type 2)
SELECT DISTINCT c.city, total_amount
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
WHERE o.total_amount > 30;

-- Q.8) Find the customer who spent the most on orders


SELECT C.Customer_ID,C.Name,SUM(O.Total_Amount) AS 'Total_spent'
FROM Customers C  
JOIN Orders O ON C.Customer_ID=O.Customer_ID
GROUP BY C.Name,O.Customer_ID
ORDER BY Total_Spent DESC LIMIT 1;

