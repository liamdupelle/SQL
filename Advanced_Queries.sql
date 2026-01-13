-- Create Database called Lab9_AnalytIQ
CREATE DATABASE Lab9_AnalytIQ;
GO

-- Use Database Lab9_AnalytIQ
USE Lab9_AnalytIQ;
GO

-- Create Departments table
CREATE TABLE Departments ( 
	DepartmentID INT PRIMARY KEY, 
	DepartmentName VARCHAR(50) NOT NULL UNIQUE 
); 

-- Create Employees table
CREATE TABLE Employees ( 
	EmpID INT PRIMARY KEY, 
	EmpName VARCHAR(50) NOT NULL, 
	DepartmentID INT, 
	Salary DECIMAL(10,2) CHECK (Salary >= 30000), 
	HireDate DATE DEFAULT GETDATE(), 
	FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID) 
); 

-- Create Sales table
CREATE TABLE Sales ( 
	SaleID INT PRIMARY KEY, 
	EmpID INT NOT NULL, 
	SaleAmount DECIMAL(10,2) CHECK (SaleAmount > 0), 
	SaleDate DATE DEFAULT GETDATE(), 
	FOREIGN KEY (EmpID) REFERENCES Employees(EmpID) 
);

-- Insert values into Departments table
INSERT INTO Departments VALUES 
(1, 'HR'), 
(2, 'Finance'), 
(3, 'IT'), 
(4, 'Marketing'),
(5, 'Legal'),
(6, 'Customer Service'),
(7, 'Operations'),
(8, 'Health & Safety'),
(9, 'Media Relations'),
(10, 'Quality Assurance');

-- Insert values into Employees table
INSERT INTO Employees VALUES
(101, 'Alice', 3, 72000, '2019-03-10'),
(102, 'Bob', 2, 68000, '2020-06-15'),
(103, 'Cathy', 4, 59000, '2021-08-21'),
(104, 'David', 1, 64000, '2018-09-18'),
(105, 'Eve', 3, 91000, '2017-01-05'),
(106, 'Tom', 9, 56000, '2020-07-08'),
(107, 'Ken', 8, 49000, '2018-04-19'),
(108, 'Ted', 7, 89000, '2022-09-01'),
(109, 'Kim', 6, 70000, '2019-12-08'),
(110, 'Jim', 3, 45000, '2021-02-09');

-- Insert values into Sales table
INSERT INTO Sales VALUES
(1, 101, 12000, '2023-04-15'),
(2, 102, 8500, '2023-05-11'),
(3, 103, 6200, '2023-05-20'),
(4, 105, 15000, '2023-06-02'),
(5, 101, 9800, '2023-07-19'),
(6, 102, 7200, '2023-07-29'),
(7, 102, 4500, '2023-08-22'),
(8, 105, 8600, '2023-09-15'),
(9, 101, 13000, '2023-10-28'),
(10, 103, 7900, '2023-11-07');

-- SUBQUERIES
-- 1.  List of departments where total sales exceed the average sales of all departments. 

SELECT d.DepartmentID, d.DepartmentName, SUM(s.SaleAmount) AS TotalSales
FROM Departments d
JOIN Employees e ON d.DepartmentID = e.DepartmentID
JOIN Sales s ON e.EmpID = s.EmpID
GROUP BY d.DepartmentID, d.DepartmentName
HAVING SUM(s.SaleAmount) > (
SELECT AVG(SaleAmount)
FROM Sales
)
ORDER BY TotalSales DESC;

-- 2.  Display employees who have made more than 2 sales (correlated subquery). 

SELECT *
FROM Employees e
WHERE e.EmpID = (
SELECT s.EmpID
FROM Sales s
WHERE s.EmpID = e.EmpID
GROUP BY s.EmpID
HAVING COUNT(s.SaleID) > 2
);

-- 3.  Find the employee with the highest total sales amount 

SELECT e.EmpID, e.EmpName, TopSale.TotalSales
FROM Employees e
JOIN (
SELECT TOP 1 EmpID, SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY EmpID
ORDER BY TotalSales DESC
) TopSale ON e.EmpID = TopSale.EmpID;


-- 4.  List of employees who have never made a sale. 

SELECT *
FROM Employees
WHERE EmpID NOT IN (
SELECT EmpID
FROM Sales
);

-- CTE
-- 1. Create a CTE to display each employee along with their total sales amount. 

;WITH EmpCTE AS (
    SELECT e.EmpID, e.EmpName, SUM(s.SaleAmount) AS TotalSales
    FROM Employees e
    LEFT JOIN Sales s ON e.EmpID = s.EmpID
	GROUP BY e.EmpID, e.EmpName
)
SELECT * FROM EmpCTE;

-- 2.  Use CTE to find average salary per department; show only departments above $60,000. 

;WITH DeptAvg AS (
    SELECT DepartmentID, AVG(Salary) AS AvgSalary
    FROM Employees
    GROUP BY DepartmentID
	HAVING AVG(Salary) > 60000
)
SELECT d.DepartmentID, d.DepartmentName, da.AvgSalary
FROM DeptAvg da
JOIN Departments d ON da.DepartmentID = d.DepartmentID;

-- 3.  Create a recursive CTE to simulate employee–manager hierarchy. 

CREATE TABLE Hierarchy (EmpID INT, ManagerID INT);
INSERT INTO Hierarchy VALUES (1, NULL), (2, 1), (3, 2), (4, 3);

;WITH HierarchyCTE AS (
    SELECT EmpID, ManagerID, 1 AS Level
    FROM Hierarchy
    WHERE ManagerID IS NULL
    UNION ALL
    SELECT h.EmpID, h.ManagerID, hc.Level + 1
    FROM Hierarchy h
    JOIN HierarchyCTE hc ON h.ManagerID = hc.EmpID
)
SELECT * FROM HierarchyCTE;

-- 4.  Combine a CTE with aggregation to display top 3 performing employees. 

;WITH EmpTop AS (
	SELECT TOP 3 EmpID, SUM(SaleAmount) AS TotalSales
	FROM Sales
	GROUP BY EmpID
	ORDER BY SUM(SaleAmount) DESC  
)
SELECT e.EmpID, e.EmpName, et.TotalSales
FROM EmpTop et
JOIN Employees e ON et.EmpID = e.EmpID;

-- Functions
-- 1.  Create a scalar function that calculates 15% commission on a given sale amount. 

CREATE FUNCTION dbo.GetCommision (@Amount DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
    RETURN @Amount * 0.15;
END;
SELECT dbo.GetCommision(2000.00) AS Commission;

-- 2.  Create a table-valued function that returns all sales for a given employee. 

CREATE FUNCTION dbo.GetEmployeeSales (@EmpID INT)
RETURNS TABLE
AS
RETURN (
    SELECT e.EmpID, e.EmpName, s.SaleID, s.SaleAmount, s.SaleDate
    FROM Sales s
	JOIN Employees e ON s.EmpID = e.EmpID
    WHERE e.EmpID = @EmpID
);
SELECT * FROM dbo.GetEmployeeSales(101);

-- 3.  Develop a function that returns performance categories (Excellent, Good, Needs Improvement). 

CREATE FUNCTION dbo.GetPerformanceCategory1 (@TotalSales DECIMAL(10,2))
RETURNS VARCHAR(20)
AS
BEGIN
    DECLARE @Category VARCHAR(20);
    IF @TotalSales > 30000 SET @Category = 'Excellent';
    ELSE IF @TotalSales BETWEEN 20000 AND 30000 SET @Category = 'Good';
    ELSE SET @Category = 'Needs Improvement';
    RETURN @Category;
END;
SELECT dbo.GetPerformanceCategory1(25000) AS PerformanceCategory;

-- 4.  Use the function in a SELECT query to display employee name, total sales, and performance category.

SELECT e.EmpID,	e.EmpName, SUM(s.SaleAmount) AS TotalSales, 
	dbo.GetPerformanceCategory1(SUM(s.SaleAmount)) AS PerformanceCategory
FROM Employees e
JOIN Sales s ON e.EmpID = s.EmpID
GROUP BY e.EmpID, e.EmpName
ORDER BY TotalSales DESC;

-- STORED PROCEDURES
-- 1.  Create a procedure to display all employees. 

CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;

EXEC GetAllEmployees;

-- 2.  Create a procedure that accepts DepartmentID and returns employees in that department. 

CREATE PROCEDURE GetEmployeeByDept @DeptID INT
AS
BEGIN
    SELECT e.EmpID, e.EmpName, e.DepartmentID, d.DepartmentName
	FROM Employees e
	JOIN Departments d ON e.DepartmentID = d.DepartmentID
	WHERE d.DepartmentID = @DeptID;
END;

EXEC GetEmployeeByDept @DeptID = 3;

-- 3.  Write a procedure to increase salary by 10% for employees with above-average total sales.

CREATE PROCEDURE UpdateSalaryIfHighSales
AS
BEGIN
    UPDATE Employees
    SET Salary = Salary * 1.1
    WHERE EmpID IN (
        SELECT EmpID 
		FROM Sales
        GROUP BY EmpID
        HAVING SUM(SaleAmount) > AVG(SaleAmount)
    );
END;

EXEC UpdateSalaryIfHighSales;

SELECT * FROM Employees;

-- 4.  Create a procedure to return department-wise total sales. 

CREATE PROCEDURE DeptSales
AS
BEGIN
    SELECT d.DepartmentID, d.DepartmentName, SUM(s.SaleAmount) AS TotalSales
    FROM Employees e
    JOIN Sales s ON e.EmpID = s.EmpID
    JOIN Departments d ON e.DepartmentID = d.DepartmentID
    GROUP BY d.DepartmentID, d.DepartmentName
	ORDER BY TotalSales DESC;
END;

EXEC DeptSales;
