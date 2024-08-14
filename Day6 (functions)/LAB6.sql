--Create Scalar function name GetEmployeeSupervisor Type: Scalar Description: Returns the name of an employee's supervisor based on their SSN.

create function GetEmployeeSupervisor(@id int)
returns varchar(20)
  begin 
     declare @name varchar(20)
	 select @name = (SELECT s.fname FROM Employee e JOIN Employee s ON s.ssn = e.Superssn WHERE e.ssn = @id)

	 RETURN @name
  end 

--drop FUNCTION GetEmployeeSupervisor

 SELECT dbo.GetEmployeeSupervisor(112233)
 SELECT * FROM Employee



--Create Inline Table-Valued Function GetHighSalaryEmployees
--Description: Returns a table of employees with salaries higher than a specified amount.

create function GetHighSalaryEmployees()
returns table 
as 
return 
(
select fname , salary as above_avg_salary
from Employee
WHERE Salary > (select avg(salary) from Employee)
)
select * from GetHighSalaryEmployees()



--Multi-Statement Table-Valued Function - GetProjectAverageHours Type: Multi-Statement 
--Description: Returns the average hours worked by employees on a specific project as a table.

CREATE FUNCTION GetProjectAverageHours ()
RETURNS @avg_project_hrs TABLE 
(pno int, avg int)
AS
BEGIN
   INSERT INTO @avg_project_hrs
    select w.pno, avg(w.hours)
    from Works_for w
    group by pno
  
   RETURN
END

select * from GetProjectAverageHours()


--Create function with name GetTotalSalary Type: Scalar Function Description: Calculates and returns the total salary of all employees in the specified department.
create function GetTotalSalary()
RETURNS table
as 
return 
(
SELECT dno, sum(salary) as sum
FROM Employee
WHERE dno IS NOT NULL
GROUP BY dno
)
select * from GetTotalSalary()


--Create function with GetDepartmentManager Type: Inline Table-Valued Function Description: Returns the manager's name and details for a specific department.
create function GetDepartmentManager()
returns table 
as 
return 
(
select dname, dnum, fname as mgr_name
from Departments
JOIN Employee ON ssn = mgrssn
)
select * from GetDepartmentManager()


-------------------ITI DB--------------------
--Table-Valued Function - GetInstructorswithNullEvaluation: This function returns a table containing the details of instructors who have null evaluations for any course.
create function GetInstructorswithNullEvaluation()
returns table 
as 
return 
(
SELECT DISTINCT ins_id 
FROM Ins_Course
WHERE Evaluation IS NULL
)
select * from GetInstructorswithNullEvaluation()


--Table-Valued Function - Get Top Students: This function returns a table containing the top students based on their average grades.
create function GetTopStudents()
RETURNS table
as 
return 
(
select TOP 10 st_id, avg(grade) as AVG
from Stud_Course
group by st_id
order by avg desc
)

select * from GetTopStudents()

--Table-Valued Function - GetStudentswithoutCourses: This function returns a table containing details of students who are not registered for any course.

create function GetStudentswithoutCourses()
RETURNS table
as 
return 
(
SELECT s.st_id as stud_ID, St_Fname, St_Lname, St_Age, St_Address
FROM Student s
LEFT JOIN Stud_Course sc ON s.St_Id  = sc.St_Id
WHERE sc.Crs_Id IS NULL
)

select * from GetStudentswithoutCourses()

