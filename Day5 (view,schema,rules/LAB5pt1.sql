--Create a view that shows the project number and name along with the total number of hours worked on each project.
CREATE VIEW project_details AS
SELECT pnumber, pname, sum(hours) as totalHours
FROM Project JOIN Works_for 
ON pnumber = pno
GROUP BY pnumber, pname

--Create a view that displays the project number and name along with the name of the department managing the project.
CREATE VIEW project_mgr_details AS
SELECT pnumber, pname, Dname
FROM Project
JOIN Departments ON Departments.dnum = Project.dnum

--Create a view that displays the names and salaries of employees who earn more than their managers.?????
CREATE VIEW emp_mgr_salary AS 
SELECT e.fname, e.salary 
FROM Employee e
JOIN Employee s on s.ssn = e.superssn
WHERE e.salary > s.salary

--Create a view that displays the department number, name, and the number of employees in each department.
CREATE VIEW dept_emp_count AS
SELECT dnum, dname, count(ssn) as count 
From Departments
JOIN Employee on dnum = dno
GROUP BY dnum, dname

--Create a view that lists the project name, location, and the name of the department managing the project, but exclude projects without a department.
CREATE VIEW dept_project AS
SELECT pname, plocation, dname
FROM Project
JOIN Departments ON Project.dnum = Departments.Dnum
WHERE Project.dnum IS NOT NULL

--Create a view that displays the average salary of employees in each department, along with the department name.
CREATE VIEW avg_sal_per_dept AS
SELECT dname, avg(salary) as avgSal
From Departments 
JOIN Employee ON dnum = Dno
GROUP BY Dname

--Create a view that displays the names of employees who have dependents, along with the number of dependents each employee has.
CREATE VIEW count_dependant AS
SELECT fname, count(dependent_name) as count
FROM Employee 
JOIN Dependent ON ssn=essn
GROUP BY fname

--Create a view that shows the project name and location along with the name of the department managing the project, ordered by project number.
CREATE or ALTER VIEW dept_project AS
SELECT pnumber, pname, plocation, dname
FROM Project
JOIN Departments ON Project.dnum = Departments.Dnum

select * from dept_project
ORDER BY Pnumber

--Create a view that displays the full name (first name and last name), salary,and the name of the department for employees working in the department with the highest average salary.
CREATE VIEW dept_highest_avg AS
SELECT CONCAT(e.fname,'',e.lname) AS FullName, e.Salary, dname
FROM Employee e
JOIN Departments d ON e.dno = d.Dnum
WHERE e.dno = (SELECT 
dno FROM
(SELECT TOP 1 dno, avg(salary) as avg
FROM Employee 
WHERE dno IS NOT NULL
GROUP BY Dno) as highest_avg );



--Create a view that lists the names and ages of employees and their dependents (if any) in a single result set. The age should be calculated based on the current date.
CREATE VIEW emp_dependent_age AS
SELECT fname, DATEDIFF(YEAR, Bdate, GETDATE()) AS Age
FROM Employee
UNION ALL
SELECT dependent_name, DATEDIFF(YEAR, Bdate, GETDATE()) AS Age
FROM dependent

--Create a view that shows the project number, name, location, and the number of employees working on each project, but exclude projects with no employees.
CREATE VIEW project_emp_count AS
SELECT pnumber, pname, plocation, count(ssn) as emp_count
FROM Project
JOIN Employee ON dnum = dno
WHERE dno IS NOT NULL
GROUP BY Pnumber, Pname, Plocation

select * from Employee
--Create a view that displays the names and salaries of employees who earn more than the average salary of their department.
CREATE VIEW emp_above_avg_salary AS
SELECT fname, salary 
FROM Employee e
WHERE Salary > (select avg(salary) from Employee e1 where e1.dno = e.dno)


--Create a view that displays the names and salaries of employees who have dependents, along with the number of dependents each employee has.
CREATE VIEW count_dependant_with_sal AS
SELECT fname,salary,count(dependent_name) as count
FROM Employee 
JOIN Dependent ON ssn=essn
GROUP BY fname, salary
