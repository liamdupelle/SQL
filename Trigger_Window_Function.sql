
-- Create Database
CREATE DATABASE AnalyticIQ_Lab6;
GO

USE AnalyticIQ_Lab6;
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
-- 3.  Salary Table (Salary Grades)
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

-- Q1. Create a trigger on the Employee table that records each newly inserted employee
-- into a new table called EmployeeAudit with fields: AuditID (PK), EmpID, EmpName, 
-- ActionType, and ActionDate.

CREATE TABLE EmployeeAudit (
	AuditID INT IDENTITY(1,1) PRIMARY KEY,
    EmpID INT,
    EmpName VARCHAR(60),
	ActionType VARCHAR(20),
	ActionDate DATE
)

CREATE TRIGGER new_employee
ON Employee
AFTER INSERT
AS
BEGIN
	INSERT INTO EmployeeAudit (EmpID, EmpName, ActionType, ActionDate)
	SELECT EmpID, EmpName, 'INSERT', GETDATE()
	FROM inserted
END;

INSERT INTO Employee (EmpID, EmpName, Age, Gender, DeptID, JobID, SalaryID, ProjectID)
VALUES (26,'John Tall',46,'Male',1,3,11,7),
(27,'Jack Green',35,'Male',1,4,12,8),
(28,'Tom Doe',50,'Male',2,5,13,9);

SELECT * FROM EmployeeAudit;

-- Q2. Create a trigger on the Employee table that moves deleted employee records into 
-- a table named EmployeeArchive.

CREATE TABLE EmployeeArchive (
	ArchiveID INT IDENTITY(1,1) PRIMARY KEY,
    EmpID INT,
    EmpName VARCHAR(60),
    DeptID INT,
    JobID INT,
    SalaryID INT,
    ProjectID INT,
	DeletedDate DATE
)

CREATE TRIGGER removed_employee
ON Employee
AFTER DELETE
AS
BEGIN
	INSERT INTO EmployeeArchive (EmpID, EmpName, DeptID, JobID, SalaryID, ProjectID, DeletedDate)
	SELECT EmpID, EmpName, DeptID, JobID, SalaryID, ProjectID, GETDATE()
	FROM deleted
END;

DELETE FROM Employee
WHERE EmpID IN (2, 5, 8, 10);

SELECT * FROM EmployeeArchive;

-- Q3. Write a trigger that stores old salary and new salary information when the SalaryID 
-- field of an Employee is updated. Store results in a new table named SalaryChangeLog.

CREATE TABLE SalaryChangeLog (
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmpID INT,
	EmpName VARCHAR(60),
    OldSalary INT,
    NewSalary INT
)

CREATE TRIGGER log_salary_change
ON Employee
AFTER UPDATE
AS
BEGIN
	INSERT INTO SalaryChangeLog (EmpID, EmpName, OldSalary, NewSalary)
	SELECT d.EmpID AS EmpID, d.EmpName AS EmpName,  d.SalaryID AS OldSalary, i.SalaryID AS NewSalary
	FROM deleted d
	JOIN inserted i ON d.EmpID = i.EmpID
END;

UPDATE Employee
SET SalaryID = 5
WHERE EmpID IN (6, 10, 15, 20);

SELECT * FROM SalaryChangeLog;

-- Q4. Create a trigger on the Employee table that prevents deletion of employees working 
-- in R&D department (DeptID = 7) and prints a message:
-- "Employees in R&D cannot be deleted due to critical project involvement."

CREATE TRIGGER trg_InsteadOfDelete
ON Employee
INSTEAD OF DELETE
AS
BEGIN
	IF (SELECT COUNT(EmpID)
		FROM deleted
		WHERE DeptID = 7
		) > 0
		BEGIN
			PRINT 'Employees in R&D cannot be deleted due to critical project involvement.'
		END
	ELSE
		BEGIN
			DELETE FROM Employee
			WHERE EmpID IN (
				SELECT EmpID 
				FROM deleted)
		END
END;

DELETE FROM Employee
WHERE EmpID = 8;

DELETE FROM Employee
WHERE EmpID = 9;

SELECT *
FROM Employee
WHERE EmpID = 9;

-- Q5. Create a trigger that updates a separate table DeptEmployeeCount(DeptID, EmpCount) every
-- time an employee is inserted, by recalculating employee count per department.

CREATE TABLE DeptEmployeeCount (
    DeptID INT PRIMARY KEY,
    EmpCount INT
)

INSERT INTO DeptEmployeeCount (DeptID, EmpCount)
SELECT DeptID, COUNT(EmpID) AS EmpCount
FROM Employee
GROUP BY DeptID;

SELECT * FROM DeptEmployeeCount;

CREATE TRIGGER trg_count_employee
ON Employee
AFTER INSERT
AS
BEGIN
	UPDATE DeptEmployeeCount
	SET EmpCount = (
	SELECT COUNT(e.EmpID)
	FROM Employee e
	WHERE e.DeptID = de.DeptID
	)
	FROM DeptEmployeeCount de 
	JOIN inserted i ON de.DeptID = i.DeptID
END;

INSERT INTO Employee (EmpID, EmpName, Age, Gender, DeptID, JobID, SalaryID, ProjectID)
VALUES (26,'John Tall',46,'Male',4,3,11,7),
(27,'Jack Green',35,'Male',4,4,12,8),
(28,'Tom Doe',50,'Male',5,5,13,9);

SELECT * FROM DeptEmployeeCount;

-- Q6. Write a query to assign a row number to employees ordered by Salary Amount 
-- (highest to lowest).

SELECT e.EmpID, e.EmpName, s.Amount,
	ROW_NUMBER() OVER(ORDER BY s.Amount DESC) RowNum
FROM Employee e
JOIN Salary s ON e.SalaryID = s.SalaryID;

-- Q7. Display Employee Name, Department Name, Salary Amount, and rank employees 
-- inside each department based on their salary (highest = rank 1).

SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount,
	RANK() OVER(PARTITION BY d.DeptID ORDER BY s.Amount DESC) AS SalaryRank 
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID;

-- Q8. Display the salary ranking across the entire company using DENSE_RANK(),
-- with highest salary getting rank 1.

SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount,
	DENSE_RANK() OVER(ORDER BY s.Amount DESC) AS SalaryRank 
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID;

-- Q9. For employees ordered by Salary Amount descending, show the employee’s 
-- salary and the previous employee’s salary, using LAG().

SELECT e.EmpID, e.EmpName, s.Amount,
	LAG(s.Amount,1) OVER(ORDER BY s.Amount DESC) AS PreviousSalary 
FROM Employee e
JOIN Salary s ON e.SalaryID = s.SalaryID;

-- Q10.Write a query that shows each employee’s name, department, individual 
-- salary, and total salary expenditure for their department

SELECT e.EmpID, e.EmpName, d.DeptName, s.Amount,
	SUM(s.Amount) OVER(PARTITION BY d.DeptID) AS TotalExpenditure 
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
JOIN Salary s ON e.SalaryID = s.SalaryID;


