
--For each project, list the project name and the total hours per week (for all employees) spent on that project.

SELECT pname, sum(hours) as total_hours,pname
From Works_for 
JOIN Project ON Pnumber = Pno
GROUP BY pname


---Display the data of the department which has the smallest employee ID over all employees' ID.

SELECT * FROM Departments
where dnum =(
    select top 1 dno from Employee
    order by SSN
);

--For each department, retrieve the department name and the maximum, minimum and average salary of its employees.

SELECT dname, max(salary) as max, min(salary) as min
FROM Departments, Employee
WHERE dno = dnum
GROUP BY dname

---List the last name of all managers who have no dependents.

SELECT s.lname 
FROM Employee e
INNER JOIN Employee s on s.ssn = e.superssn
WHERE NOT EXISTS (
    SELECT* FROM DEPENDENT 
    WHERE s.ssn = essn
);

--For each department if its average salary is less than the average salary of all employees-- display its number, name and number of its employees.
SELECT dno, avg(salary) as avg, count(ssn) as count
FROM Employee
GROUP BY Dno
---not null cond

SELECT * FROM Employee


---Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name.
SELECT * from Employee
SELECT * From Project
SELECT fname, lname, pname, dno
FROM Employee, Project
ORDER BY Dno, fname, lname
---not null cond

---Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 

UPDATE employee
SET salary = salary*1.33
WHERE dno = (
    SELECT dnum FROM Project 
    WHERE pname = 'Al Rabwah'
)

---Display the employee number and name if at least one of them have dependents (use exists keyword) self-study.
SELECT ssn, fname
FROM Employee 
WHERE EXISTS (
    SELECT* FROM DEPENDENT 
    WHERE ssn = essn
);