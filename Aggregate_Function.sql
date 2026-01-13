-- Use the database Lab4_AnalytIQ
USE Lab4_AnalytIQ;
GO

-- 1.	List all customers ordered by Country and then by City in ascending order.

SELECT *
FROM Customers
ORDER BY Country, City;

-- 2.	Display all products ordered by Price (descending). If two products have the same price, order them alphabetically by ProductName.

SELECT * 
FROM Products
ORDER BY Price DESC, ProductName;

-- 3.	Find all customers from Canada or USA whose FirstName starts with 'A' or 'B'.

SELECT *
FROM Customers
WHERE (Country = 'Canada' OR Country = 'USA') AND (FirstName LIKE 'A%' OR FirstName LIKE 'B%'); 

-- 4.	Retrieve all orders placed in March 2024 and paid using Credit Card or PayPal.

SELECT * 
FROM Orders
WHERE (OrderDate >= '2024-03-01' AND OrderDate < '2024-04-01')
AND (PaymentMethod = 'Credit Card' OR PaymentMethod = 'Paypal');

-- 5.	Find the total number of orders placed by each customer. Show CustomerID, FullName, and OrderCount.

SELECT c.CustomerID, CONCAT(c.FirstName,' ',c.LastName) AS FullName, COUNT(o.OrderID) AS OrderCount 
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName;

-- 6.	Calculate the average, minimum, and maximum product price for each product category.

SELECT Category, AVG(Price) AS AvgPrice, MIN(Price) AS MinPrice, MAX(Price) AS Maxprice
FROM Products
GROUP BY Category;

-- 7.	Find the top 3 customers with the highest total spending (sum of Total in OrderDetails).  

SELECT TOP 3 c.CustomerID, c.FirstName, c.LastName, SUM(od.Total) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpent DESC;

-- 8.	Find the customers who have placed at least one order containing a product priced above $1000 (use subquery).

SELECT *
FROM Customers
WHERE CustomerID IN (
SELECT o.CustomerID
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Price > 1000
);

-- 9.	Find products that were never ordered (subquery with NOT IN).

SELECT *
FROM Products
WHERE ProductID NOT IN (
SELECT ProductID
FROM OrderDetails
);

-- 10.	Find all customers whose total spending is above the average spending of all customers.

SELECT c.CustomerID, c.FirstName, c.LastName, SUM(od.Total) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SUM(od.Total) > (
SELECT AVG(Total)
FROM OrderDetails
);

-- 11.	List each order with customer name, product name, quantity, and total.

SELECT o.OrderID, c.FirstName, c.LastName, p.ProductName, od.Quantity, od.Total
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;

-- 12.	Show all customers along with the number of products they ordered (using JOIN + GROUP BY).

SELECT c.CustomerID, c.FirstName, c.LastName, SUM(od.Quantity) AS NumberOfProductsOrdered
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID 
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY NumberOfProductsOrdered DESC;

-- 13.	Find the highest-priced product purchased by each customer. 

SELECT c.CustomerID, c.FirstName, c.LastName, p.ProductName, MAX(p.Price) AS MaxPrice
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
GROUP BY c.CustomerID, c.FirstName, c.LastName, p.ProductName;

-- 14.	List all customers and their orders. If a customer has not placed an order, still show their name with NULL in OrderID.

SELECT c.CustomerID, c.FirstName, c.LastName, o.OrderID
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 15.	List all products and the orders they belong to. If a product was never ordered, still show the product name with NULL for OrderID.

SELECT p.ProductID, p.ProductName, od.OrderID
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID;

-- 16.	Find customers who are from Canada OR USA (use UNION).

SELECT *
FROM Customers
WHERE Country = 'Canada'
UNION
SELECT *
FROM Customers
WHERE Country = 'USA';

-- 17.	Find customers who are from Toronto and have also placed at least one order in March 2024 (use INTERSECT).

SELECT *
FROM Customers
WHERE City = 'Toronto'
INTERSECT
SELECT *
FROM Customers c
WHERE CustomerID IN (
SELECT CustomerID
FROM Orders
WHERE (OrderDate >= '2024-03-01' AND OrderDate < '2024-04-01')
);

-- 18.	Find customers from London who have never placed an order (use EXCEPT).

SELECT *
FROM Customers
WHERE City = 'London'
EXCEPT
SELECT *
FROM Customers c
WHERE CustomerID IN (
SELECT CustomerID
FROM Orders
);

-- 19.  Find customers who ordered products in the 'Electronics' category.

SELECT c.CustomerID, c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Electronics';

-- 20.  Find products that were never ordered (using NOT IN subquery).

SELECT *
FROM Products
WHERE ProductID NOT IN (
SELECT ProductID
FROM OrderDetails
);




