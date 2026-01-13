
-- Create Database
CREATE DATABASE AnalyticIQ_Lab7;
GO

USE AnalyticIQ_Lab7;
GO

--------------------------------------------------------
-- 1. Department Table
--------------------------------------------------------
CREATE TABLE Department (
    DeptID INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

INSERT INTO Department VALUES
(1,'Human Resources','New York'),
(2,'Finance','Chicago'),
(3,'IT','San Francisco'),
(4,'Marketing','Boston'),
(5,'Operations','Houston'),
(6,'Sales','Atlanta'),
(7,'R&D','Seattle');

--------------------------------------------------------
-- 2. Job Table
--------------------------------------------------------
CREATE TABLE Job (
    JobID INT PRIMARY KEY,
    JobTitle VARCHAR(50)
);

INSERT INTO Job VALUES
(1,'Data Analyst'),
(2,'Software Engineer'),
(3,'HR Manager'),
(4,'Accountant'),
(5,'Marketing Specialist');

--------------------------------------------------------
-- 3. Salary Table (Salary Grades)
--------------------------------------------------------
CREATE TABLE Salary (
    SalaryID INT PRIMARY KEY,
    SalaryGrade VARCHAR(20),
    Amount DECIMAL(10,2)
);

INSERT INTO Salary VALUES
(1,'Grade 1',45000),
(2,'Grade 2',52000),
(3,'Grade 3',58000),
(4,'Grade 4',62000),
(5,'Grade 5',66000),
(6,'Grade 6',72000),
(7,'Grade 7',77000),
(8,'Grade 8',82000),
(9,'Grade 9',88000),
(10,'Grade 10',92000),
(11,'Grade 11',97000),
(12,'Grade 12',103000),
(13,'Grade 13',110000),
(14,'Grade 14',118000),
(15,'Grade 15',125000),
(16,'Grade 16',131000),
(17,'Grade 17',140000),
(18,'Grade 18',148000),
(19,'Grade 19',156000),
(20,'Grade 20',165000);

--------------------------------------------------------
-- 4. Projects Table
--------------------------------------------------------
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

INSERT INTO Projects VALUES
(1,'HR Onboarding System','2024-01-10','2024-06-30'),
(2,'Financial Data Warehouse','2023-09-01','2024-12-20'),
(3,'Sales CRM Upgrade','2024-02-15','2024-09-30'),
(4,'Website Rebranding','2023-11-01','2024-03-20'),
(5,'Cloud Migration','2024-04-01','2025-01-15'),
(6,'AI Chatbot System','2024-05-10','2024-11-10'),
(7,'Customer Analytics Dashboard','2024-06-01','2024-12-01'),
(8,'Inventory Optimization','2024-03-05','2024-08-25'),
(9,'Payroll Modernization','2023-12-12','2024-07-15'),
(10,'Product R&D Launch','2024-01-25','2025-04-30');

--------------------------------------------------------
-- 5. Employee Table
--------------------------------------------------------
CREATE TABLE Employee (
    EmpID INT PRIMARY KEY,
    EmpName VARCHAR(60),
    Age INT,
    Gender VARCHAR(10),
    DeptID INT,
    JobID INT,
    SalaryID INT,
    ProjectID INT,
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
    FOREIGN KEY (JobID) REFERENCES Job(JobID),
    FOREIGN KEY (SalaryID) REFERENCES Salary(SalaryID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

INSERT INTO Employee VALUES
(1,'Emma Johnson',29,'Female',1,3,5,1),
(2,'Liam Smith',34,'Male',2,4,8,2),
(3,'Noah Williams',27,'Male',3,2,6,3),
(4,'Olivia Brown',41,'Female',4,5,9,4),
(5,'Ava Davis',32,'Female',5,1,4,5),
(6,'Isabella Miller',30,'Female',6,1,3,3),
(7,'Sophia Wilson',38,'Female',3,2,12,5),
(8,'James Taylor',45,'Male',7,2,14,10),
(9,'Benjamin Anderson',26,'Male',6,5,2,3),
(10,'Mason Thomas',33,'Male',1,3,7,1),
(11,'Ethan Jackson',29,'Male',2,4,6,9),
(12,'Alexander White',42,'Male',5,1,8,8),
(13,'Jacob Harris',37,'Male',7,2,13,10),
(14,'Michael Martin',31,'Male',3,2,10,6),
(15,'Daniel Thompson',28,'Male',4,5,5,7),
(16,'Henry Garcia',35,'Male',5,1,7,8),
(17,'Jackson Martinez',44,'Male',6,5,11,9),
(18,'Sebastian Robinson',39,'Male',2,4,10,2),
(19,'Mateo Clark',25,'Male',1,1,2,1),
(20,'Logan Rodriguez',30,'Male',3,2,9,6),
(21,'Elijah Lewis',47,'Male',7,3,15,5),
(22,'Lucas Lee',36,'Male',4,5,8,4),
(23,'Harper Walker',29,'Female',5,1,4,8),
(24,'Ella Hall',33,'Female',2,4,6,9),
(25,'Grace Young',40,'Female',1,3,12,7);

-- Question 1: Clustered Index Performance
-- Create a clustered index on the Employee table based on the EmpName column.
-- 1.	Measure and compare the query execution time before and after creating the index for the following query:
-- 2.	SELECT * FROM Employee WHERE EmpName LIKE 'E%';

ALTER TABLE Employee
DROP CONSTRAINT PK__Employee__AF2DBA79098854DA;

ALTER TABLE Employee
DROP CONSTRAINT FK__Employee__DeptID__3F466844;

ALTER TABLE Employee
DROP CONSTRAINT FK__Employee__JobID__403A8C7D;

ALTER TABLE Employee
DROP CONSTRAINT FK__Employee__Projec__4222D4EF;

ALTER TABLE Employee
DROP CONSTRAINT FK__Employee__Salary__412EB0B6;

-- Before Index

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT * FROM Employee WHERE EmpName LIKE 'E%';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- After Index

CREATE CLUSTERED INDEX CIX_EmpName
ON Employee(EmpName ASC);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT * FROM Employee WHERE EmpName LIKE 'E%';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Question 2: Non-Clustered Index for Search Optimization
-- Create a non-clustered index on the SalaryID column of the Employee table.
-- 1.	Run the following query before and after creating the index:
-- 2.	SELECT EmpName, SalaryID FROM Employee WHERE SalaryID BETWEEN 5 AND 10;

-- Before Index

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT EmpName, SalaryID FROM Employee WHERE SalaryID BETWEEN 5 AND 10;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- After Index

CREATE NONCLUSTERED INDEX NIX_SalaryID
ON Employee(SalaryID ASC);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT EmpName, SalaryID FROM Employee WHERE SalaryID BETWEEN 5 AND 10;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

-- Question 3: View Creation and Analysis
-- Create a view named vw_EmployeeSalaryDetails that displays the following fields:
-- EmpName, DeptName, JobTitle, and Amount
-- (using joins between Employee, Department, Job, and Salary tables)
-- Then,
-- 1.	Query the view to display employees whose salary amount is greater than 90,000.

CREATE VIEW vw_EmployeeSalaryDetails AS
SELECT e.EmpName, d.DeptName, j.JobTitle, s.Amount
FROM Employee e
JOIN Department d ON e.DeptID = D.DeptID
JOIN Job j ON e.JobID = j.JobID
JOIN Salary s ON s.SalaryID = e.SalaryID;

SELECT *
FROM vw_EmployeeSalaryDetails
WHERE Amount > 90000
ORDER BY Amount DESC;

-- Question 4: Materialized View for Department-Level Summary
-- Create a materialized view (or indexed view in SQL Server) named mv_DepartmentAvgSalary that shows:
-- DeptName, and average salary amount of employees in that department.
-- Also, query the materialized view to find departments with an average salary greater than 100,000.

CREATE VIEW mv_DepartmentAvgSalary 
WITH SCHEMABINDING
AS
SELECT d.DeptName, AVG(s.Amount) AS AvgSalary
FROM dbo.Employee e
JOIN dbo.Department d ON e.DeptID = d.DeptID
JOIN dbo.Salary s ON e.SalaryID = s.SalaryID
GROUP BY d.DeptName;
GO

SELECT *
FROM mv_DepartmentAvgSalary
WHERE AvgSalary > 100000;

CREATE UNIQUE CLUSTERED INDEX IX_mv_DepartmentAvgSalary
ON mv_DepartmentAvgSalary(DeptName);

SELECT *
FROM mv_DepartmentAvgSalary
WHERE AvgSalary > 100000;

-- Question 5: Comparative Analysis — Index vs. View
-- Execute and analyze the following scenario:
-- Write a query to get all employees working on the project 'AI Chatbot System' along with their department and salary.
-- Compare execution performance:
--	1. Without any index
--	2. With a non-clustered index on ProjectID
--	3. Using a view that joins Employee, Projects, and Salary tables

-- 1. Without any index
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount, p.ProjectName
FROM Employee e
JOIN Projects p ON e.ProjectID = p.ProjectID
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID
WHERE p.ProjectName = 'AI Chatbot System';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--	2. With a non-clustered index on ProjectID
CREATE NONCLUSTERED INDEX NIX_ProjectID
ON Employee(ProjectID ASC);

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount, p.ProjectName
FROM Employee e
JOIN Projects p ON e.ProjectID = p.ProjectID
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID
WHERE p.ProjectName = 'AI Chatbot System';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

--	3. Using a view that joins Employee, Projects, and Salary tables
CREATE VIEW vw_EmployeeAIChatbot AS
SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount, p.ProjectName
FROM Employee e
JOIN Projects p ON e.ProjectID = p.ProjectID
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID
WHERE p.ProjectName = 'AI Chatbot System';
GO

SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT *
FROM vw_EmployeeAIChatbot;

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;

