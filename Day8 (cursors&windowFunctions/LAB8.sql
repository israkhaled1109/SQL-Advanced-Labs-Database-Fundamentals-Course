--Use Cursor For the following Problems 

/* Problem 1: Calculate Total Salary for Each Department
Description: Calculate the total salary for each department and display the department name along with the total salary */
DECLARE TotalSalary CURSOR 
FOR
    SELECT DISTINCT dname, SUM(salary)OVER(PARTITION BY dno) as [total salary]
    FROM Departments
    JOIN Employee ON dnum = dno
    WHERE dno IS NOT NULL
FOR READ ONLY

/* Problem 2: Update Employee Salaries Based on Department
Description: Update employee salaries by increasing them by a certain percentage for a specific department. */
DECLARE SalaryIncrease CURSOR 
FOR
    SELECT Dno
    FROM Employee 
    WHERE dno IS NOT NULL

FOR UPDATE
    DECLARE @dept INT
    OPEN SalaryIncrease
    FETCH NEXT FROM SalaryIncrease INTO @dept 
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
    IF (@dept = 10)
    BEGIN
    UPDATE Employee SET Salary = Salary * 1.2
    WHERE Current OF SalaryIncrease
    END 
    FETCH NEXT FROM SalaryIncrease INTO @dept;
    END
CLOSE SalaryIncrease
DEALLOCATE SalaryIncrease

select * from Employee


/* Problem 3: Calculate Average Project Hours per Employee
Description: Calculate the average number of hours each employee has worked on projects, 
and display their names along with the calculated average hours */
DECLARE AverageHours CURSOR 
FOR
    SELECT DISTINCT fname, lname, AVG(Hours)OVER(PARTITION BY Essn) as [Average Hours]
    FROM Employee
    JOIN Works_for ON SSN = ESSn
FOR READ ONLY

/* Problem 4:  in employee table Check if Gender='M' add 'Mr Before Employee name    
else if Gender='F' add Mrs Before Employee name  then display all names  
use cursor for update */

DECLARE Titles CURSOR FOR
    SELECT Fname , Sex
    FROM Employee 
FOR UPDATE
    DECLARE @gender VARCHAR(10);
    OPEN Titles;
    FETCH NEXT FROM Titles INTO @gender;
    WHILE @@FETCH_STATUS = 0 
    BEGIN 
    IF (@gender = 'F')
    BEGIN
    UPDATE Employee SET Fname = CONCAT('Mrs',Fname)
    WHERE Current OF Titles
    END 
    ELSE
    BEGIN
    UPDATE Employee SET Fname = CONCAT('Mr',Fname)
    WHERE Current OF Titles
    END
    FETCH NEXT FROM Titles INTO @gender
    END
CLOSE Titles
DEALLOCATE Titles



--Problem 5: Solve student task at day8 demo
DECLARE @AhmedCount INT = 0;
DECLARE @AmrCount INT = 0;

DECLARE AmrAfterAhmed CURSOR FOR
SELECT st_fname
FROM student
ORDER BY st_id;

DECLARE @name VARCHAR(50);
DECLARE @prevName VARCHAR(50) = '';

OPEN AmrAfterAhmed;

FETCH NEXT FROM AmrAfterAhmed INTO @name;

WHILE @@FETCH_STATUS = 0
BEGIN
    IF @prevName = 'Ahmed' AND @name = 'Amr'
        SET @AmrCount = @AmrCount + 1;

    IF @name = 'Ahmed'
        SET @AhmedCount = @AhmedCount + 1;

    SET @prevName = @name;
    FETCH NEXT FROM AmrAfterAhmed INTO @name;
END;

CLOSE AmrAfterAhmed;
DEALLOCATE AmrAfterAhmed;

SELECT @AmrCount AS AmrCount;





/*Window Function
1.	Identifying the Top Topics by the Number of Courses:
•	Use the "Topic" and "Course" tables to count the number of courses available for each topic.
•	Rank the topics based on the count of courses and identify the most popular topics with the highest number of courses.*/

select top_id, top_name,
numberOfCourses,
Dense_rank() over (order by numberOfCourses desc) as Rank
from 
(
select distinct t.Top_Id, t.Top_name, COUNT(c.crs_id)OVER(PARTITION BY c.top_id) as [numberOfCourses]
from Topic t join Course c on c.Top_Id = t.Top_Id
) as NewTable

/*2.	Finding Students with the Highest Overall Grades:
•	Use the "Stud_Course" table to calculate the total grades for each student across all courses.
•	Rank the students based on their total grades and identify the students with the highest overall grades. */

SELECT st_id,
       TotalGrades,
       RANK() OVER (ORDER BY TotalGrades DESC) AS Rank
FROM (
    SELECT DISTINCT
           st_id,
           SUM(grade) OVER(PARTITION BY st_id) AS TotalGrades
    FROM Stud_Course
) AS StudentTotalGrades;

--use row number, use order by sum
