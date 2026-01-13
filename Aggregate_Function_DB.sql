-- Create Database called Lab4_AnalytIQ
CREATE DATABASE Lab4_AnalytIQ;
GO

-- Use Database Lab4_AnalytIQ
USE Lab4_AnalytIQ;
GO

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    City VARCHAR(50),
    Country VARCHAR(50),
    Email VARCHAR(100)
);

-- Create Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE,
    PaymentMethod VARCHAR(50)
);

-- Create OrderDetails table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    Total DECIMAL(10,2)
);

-- Insert values into Customers table
INSERT INTO Customers VALUES
(1,'Alice','Smith','Toronto','Canada','alice@email.com'),
(2,'Bob','Johnson','Vancouver','Canada','bob@email.com'),
(3,'Charlie','Brown','New York','USA','charlie@email.com'),
(4,'David','Wilson','London','UK','david@email.com'),
(5,'Eva','Davis','Sydney','Australia','eva@email.com'),
(6,'Frank','Miller','Toronto','Canada','frank@email.com'),
(7,'Grace','Taylor','New York','USA','grace@email.com'),
(8,'Henry','Moore','London','UK','henry@email.com'),
(9,'Ivy','Clark','Chicago','USA','ivy@email.com'),
(10,'Jack','Hall','Sydney','Australia','jack@email.com'),
(11,'Karen','Allen','Toronto','Canada','karen@email.com'),
(12,'Leo','Young','Vancouver','Canada','leo@email.com'),
(13,'Mona','King','London','UK','mona@email.com'),
(14,'Nate','Scott','Chicago','USA','nate@email.com'),
(15,'Olivia','Baker','Sydney','Australia','olivia@email.com'),
(16,'Paul','Adams','Toronto','Canada','paul@email.com'),
(17,'Quinn','Perez','New York','USA','quinn@email.com'),
(18,'Rita','Campbell','London','UK','rita@email.com'),
(19,'Sam','Carter','Chicago','USA','sam@email.com'),
(20,'Tina','Evans','Sydney','Australia','tina@email.com');

-- Insert values into Products table
INSERT INTO Products VALUES
(1,'Laptop','Electronics',1200),(2,'Smartphone','Electronics',800),
(3,'Tablet','Electronics',450),(4,'Smartwatch','Electronics',250),
(5,'Headphones','Accessories',150),(6,'Charger','Accessories',50),
(7,'Office Chair','Furniture',300),(8,'Desk','Furniture',500),
(9,'Bookshelf','Furniture',200),(10,'Printer','Electronics',350),
(11,'Monitor','Electronics',400),(12,'Keyboard','Accessories',70),
(13,'Mouse','Accessories',40),(14,'Camera','Electronics',950),
(15,'Speaker','Accessories',180),(16,'Coffee Table','Furniture',220),
(17,'Sofa','Furniture',800),(18,'Dining Table','Furniture',1200),
(19,'Lamp','Accessories',90),(20,'TV','Electronics',1500);

-- Insert values into Orders table
INSERT INTO Orders VALUES
(101,1,'2024-01-05','Credit Card'),(102,2,'2024-01-10','PayPal'),
(103,3,'2024-01-12','Cash'),(104,4,'2024-01-20','Credit Card'),
(105,5,'2024-02-02','PayPal'),(106,6,'2024-02-05','Credit Card'),
(107,7,'2024-02-15','Cash'),(108,8,'2024-02-18','Credit Card'),
(109,9,'2024-02-20','PayPal'),(110,10,'2024-03-01','Cash'),
(111,11,'2024-03-05','Credit Card'),(112,12,'2024-03-10','PayPal'),
(113,13,'2024-03-12','Credit Card'),(114,14,'2024-03-15','Cash'),
(115,15,'2024-03-20','Credit Card'),(116,16,'2024-04-01','PayPal'),
(117,17,'2024-04-05','Credit Card'),(118,18,'2024-04-08','Cash'),
(119,19,'2024-04-12','PayPal'),(120,20,'2024-04-15','Credit Card');

-- Insert values into OrderDetails table 
INSERT INTO OrderDetails VALUES
(1,101,1,1,1200),(2,101,5,2,300),(3,102,2,1,800),
(4,103,3,2,900),(5,104,7,1,300),(6,105,8,1,500),
(7,106,4,2,500),(8,107,6,3,150),(9,108,10,1,350),
(10,109,14,1,950),(11,110,15,2,360),(12,111,11,1,400),
(13,112,20,1,1500),(14,113,13,2,80),(15,114,9,1,200),
(16,115,16,1,220),(17,116,17,1,800),(18,117,18,1,1200),
(19,118,19,2,180),(20,119,12,3,210);

