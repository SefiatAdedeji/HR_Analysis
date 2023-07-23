# Creating a Database 
CREATE DATABASE HR;

USE HR;

/* Create our Tables */
CREATE TABLE Jobs (
Job_IDENT INT NOT NULL,
Job_title VARCHAR (50),
Min_salary DECIMAL(10,2),
Max_salary DECIMAL(10,2),
PRIMARY KEY(Job_IDENT)
);

# Inserting data into our jobs table
INSERT INTO Jobs (Job_IDENT, Job_title, Min_salary, Max_salary)
VALUES
(100, 'Sr_Analyst', 120000, 250000),
(200, 'Sr_Software _Developer', 150000, 300000),
(300, 'Jr_Software_Developer', 70000, 100000),
(400, 'Cloud_Engineer', 80000, 110000),
(500, 'Jr_Analyst', 10000, 80000),
(550, 'Cloud_Engineer', 80000, 110000),
(600, 'Jr_Designer', 60000, 70000),
(620, 'Sr_Designer', 80000, 150000),
(120, 'Sr_Analyst', 120000, 250000),
(220, 'Jr_Analyst', 50000, 80000);
SELECT * FROM Jobs;
CREATE TABLE Locations (
Dept_ID_Loc CHAR(10) NOT NULL,
Location_ID INT NOT NULL,
PRIMARY KEY (Location_ID)
);
INSERT INTO Locations(Dept_ID_Loc, Location_ID)
VALUES 
('L0001', 3),
('L0002', 5),
('L0003', 7);
SELECT * FROM Locations;
CREATE TABLE Job_history (
Emp_ID CHAR(9) NOT NULL,
Start_Date DATE,
Jobs_ID INT,
Dept_ID INT NOT NULL,
PRIMARY KEY (Emp_ID)
);
INSERT INTO Job_history (Emp_ID, Start_Date, Jobs_ID, Dept_ID)
VALUES 
('E1001', '1988-08-01', 100, 3),
('E1002', '2001-08-01', 200, 5),
('E1003', '2004-08-16', 300, 5),
('E1004', '2000-08-16', 400, 4),
('E1005', '1999-05-30', 500, 2),
('E1006', '2001-08-16', 550, 2),
('E1007', '2002-05-30', 600, 7),
('E1008', '2010-05-06', 620, 3),
('E1009', '2020-08-16', 120, 7),
('E1010', '2016-08-20', 220, 4);
SELECT * FROM Job_history;
CREATE TABLE Departments (
Department_ID INT NOT NULL,
Dep_name VARCHAR(25),
Manager_ID CHAR(10) NOT NULL,
Loc_ID CHAR(10) NOT NULL,
PRIMARY KEY (Department_ID)
);
INSERT INTO Departments (Department_ID, Dep_name, Manager_ID, Loc_ID)
VALUES
(3, 'Analyst_group', '50003', 'L0001'),
(5, 'Developer_group', '50005',	'L0002'),
(7,	'Designer_team', '50007', 'L0003');
SELECT * FROM Departments;

CREATE TABLE Employees (
Employee_ID CHAR(9) NOT NULL,
First_name VARCHAR(15) NOT NULL,
Last_name VARCHAR(15) NOT NULL,
SSN CHAR(9),
D_O_B DATE,
Sex CHAR(2),
Address VARCHAR(50),
Job_ID INT NOT NULL,
Salary DECIMAL(10,2),
Phone_number BIGINT,
Manager_ID CHAR(10),
Dep_ID INT NOT NULL,
PRIMARY KEY (First_name),
FOREIGN KEY(Job_ID) REFERENCES Jobs(Job_IDENT),
FOREIGN KEY(Employee_ID) REFERENCES Job_history(Emp_ID)
);
INSERT INTO Employees (Employee_ID,First_name,Last_name,SSN,D_O_B,Sex,Address,Job_ID,Salary,Phone_number,Manager_ID,Dep_ID)
VALUES('E1001','Bolu','Adeolu','123456','1976-09-01','M','472, Gwarinpa Abuja',100,150000,2347030643695,'50003',3),
      ('E1002','Damilola','James','123457','1998-01-31','F','234,Wuse Zone 3 Abuja',200,200000,2348132199402,'50005',5),
      ('E1003','Tosin','Wellignton','123458','1980-08-10','M','222,Garki 1 Abuja',300,80000,2347035273745,'50005',5),
      ('E1004','Jibril','Kumar','123459','1985-08-15','M','111,Police Court Abuja',400,100000,2348075626294,'50004',4),
      ('E1005','Ahmed','Hussain','123410','1981-01-04','M','101,Lugbe Trademore Abuja',500,70000,2349076737889,'50002',2),
      ('E1006','Gift','Ogbue','123411','1978-08-08','F','220,Dawaki Quarters Abuja',550, 80000, 2349068439805,'50002',2),
      ('E1007','Aisha','Popoola','123412','1991-11-11','F','119,Zone 6 Abuja',600,70000,2347056789504,'50007',7),
      ('E1008','Joshua','Gupta','123413','1985-05-06','M','194,Gwagwalada Abuja',620,100000,2348105679403,'50003',3),
	  ('E1009','Zainab','Adams','123414','1990-07-09','F','120,Fall Creek Gary Abuja',120,150000,2348130366359,'50007',7),
      ('E1010','Mary','Jacob','123415','1982-12-30','F','111,Britany Springs Abuja',220,70000,2348068653600,'50004',4);
SELECT * FROM Employees;
 -- View From a Join Table
 CREATE VIEW Salary_Info
 AS
 SELECT e.First_name, e.Last_name, e.Sex, j.Job_title, e.Salary, e.D_O_B
 FROM Employees e
 JOIN Jobs j
 ON e.Job_ID = j.Job_IDENT
 WHERE Sex = 'f';
 
 -- Stored Function --
 DElIMITER //
 CREATE FUNCTION payable (
 Salary DECIMAL (10,2)
 )
 RETURNS VARCHAR(20)
 DETERMINISTIC 
 BEGIN
      DECLARE Employee_status VARCHAR(20);
	  IF Salary >100000 THEN
      SET Employee_status = 'Senior_level';
      ELSEIF (Salary >= 80000 AND Salary <= 100000) THEN 
      SET Employee_status = 'Middle_level';
      ELSEIF Salary < 80000 THEN
      SET Employee_status = 'Low_level';
      END IF;
      RETURN (Employee_status);
 END//Salary
 DELIMITER ;
 SELECT * FROM Employees;
 SELECT Employee_ID, First_name, Last_name, Salary, payable(Salary) FROM Employees;
 
 -- Subquery --
SELECT * FROM Employees
 WHERE Salary <
 (SELECT AVG(Salary) FROM Employees);
 
/* Stored Procedure */
DELIMITER //
CREATE PROCEDURE Jobs_Update (
IN Job_IDENT INT,
IN Job_title VARCHAR(50),
IN Min_salary DECIMAL(10,2),
IN Max_salary DECIMAL(10,2)
)
BEGIN
INSERT INTO Jobs(Job_IDENT, Job_title, Min_salary, Max_salary)
VALUES(Job_IDENT, Job_title, Min_salary, Max_salary);
END//
DELIMITER ;
CALL Jobs_Update (900,'Jr_Analyst', 30000, 50000);

SELECT * FROM Jobs;
/* Trigger */
DELIMITER //
CREATE TRIGGER Job_title_Staff
BEFORE INSERT ON Jobs
FOR EACH ROW
BEGIN
	SET NEW.Job_title = CONCAT (UPPER(SUBSTRING(NEW.Job_title,1,1),
										 LOWER(SUBSTRING(NEW.Job_title FROM 2)));
END;
DELIMITER ;
INSERT INTO Jobs(Job_IDENT, Job_title, Min_salary, Max_salary)
VALUES (160, 'Jr_Analyst', 70000, 80000);
                        
/* Events part */					
SET GLOBAL event_scheduler = ON;
 USE hr;
CREATE TABLE Daily_reminder
(ID INT NOT NULL AUTO_INCREMENT,
New_Update TIMESTAMP,
PRIMARY KEY (ID));
DELIMITER //
CREATE EVENT one_time
ON SCHEDULE AT NOW() + INTERVAL 1 MINUTE
DO
INSERT INTO Daily_reminder(New_Update)
VALUES (NOW());
END//
DELIMITER ;
SELECT * FROM Daily_reminder;