SELECT * from Employee

SELECT fname, lname, salary, dno
From Employee

SELECT  pname, plocation, dnum
From Project

SELECT fname, salary*0.1 as Annual_Comm 
From Employee

SELECT ssn, fname
From Employee
WHERE Salary*12 > 10000

SELECT fname, salary 
FROM Employee
WHERE Sex = 'F'

select * FROM Departments
SELECT dnum, dname 
From Departments 
WHERE mgrssn = 968574

SELECT * FROM Project

SELECT pnumber, pname, plocation 
FROM Project 
WHERE dnum = 10

SELECT dnum, dname, fname 
From Departments, Employee
WHERE mgrssn = ssn

SELECT dname, pname
FROM Departments d, Project p
WHERE d.dnum = p.dnum

SELECT *, fname  
FROM Dependent, Employee
WHERE SSN = ESSN

SELECT pnumber, pname, plocation
FROM Project
WHERE city in ('cairo', 'alex')

SELECT * FROM Project
WHERE pname like 'a%'

SELECT * FROM Employee
WHERE dno = 30 AND salary BETWEEN 1000 AND 2000

select * from Works_for
SELECT fname
FROM Employee
JOIN Works_for on ssn = essn
JOIN project  on pnumber = pno
WHERE pname = 'Al Rawdah' and dno = 10 and hours = 10

SELECT e.fname
FROM Employee e
JOIN Employee s on s.ssn = e.superssn
WHERE s.fname = 'Kamel'

SELECT fname, pname
From Employee
JOIN Project on dno = dnum
ORDER BY pname 

SELECT p.pnumber, d.dname, e.lname, e.Address, e.bdate
FROM Departments d 
JOIN Project p on d.dnum = p.dnum
JOIN Employee e on d.Dnum = e.Dno
WHERE City = 'Cairo'

SELECT distinct s.*
FROM Employee e 
JOIN Employee s ON s.ssn = e.Superssn

SELECT *, *
FROM Employee
LEFT JOIN Dependent on ssn = ESSN

INSERT INTO Employee (Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno)
VALUES ('Israa', 'Khaled', 192672, 1998-12-05, 'Maadi, Cairo', 'F', 3000, 112233, 30);

INSERT INTO Employee (Fname, Lname, SSN, Bdate, Address, Sex, Salary, Superssn, Dno)
VALUES ('Shrouq', 'Medhat', 102660, 1998-12-05, 'Maadi, Cairo', 'F', null ,null , 30);

UPDATE employee
SET salary = salary*2.2
WHERE ssn = 192672
