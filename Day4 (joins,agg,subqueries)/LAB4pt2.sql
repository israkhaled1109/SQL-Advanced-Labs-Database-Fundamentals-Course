--Simple Subquery: Write a query to find all courses with a duration longer than the average course duration.
SELECT Crs_name
FROM Course
WHERE Crs_Duration > (
    SELECT AVG(Crs_Duration)
    FROM Course 
    );

--Correlated Subquery: Find the names of students who are older than the average age of students in their department.
SELECT St_Fname, St_Lname
FROM Student s
WHERE St_Age > (
    SELECT AVG(St_Age)
    FROM Student s1
    WHERE s1.Dept_Id = s.Dept_Id
    );

--Subquery in FROM Clause: Create a list of departments and the number of instructors in each, using a subquery.
SELECT dept_name, 
    (SELECT count(ins_id)
        FROM Instructor
        WHERE Department.Dept_Id = Instructor.Dept_Id
    GROUP BY Dept_Id
    Having COUNT(Ins_Id) IS NOT NULL
    )
    AS COUNT
    FROM Department 

--Subquery in SELECT Clause: For each student, display their name and the number of courses they are enrolled in.
SELECT St_Fname, 
	(SELECT count(Stud_Course.Crs_Id) 
	 	FROM Stud_Course
	 	WHERE Stud_Course.St_Id = Student.St_Id
        GROUP BY Stud_Course.St_Id
    ) 
			AS count
	FROM Student
WHERE St_Fname IS NOT NULL

--Multiple Subqueries: Find the name and salary of the instructor who earns more than the average salary of their department.
SELECT ins_name, salary
FROM Instructor i
WHERE  Salary > (
    SELECT AVG(Salary)
    FROM Instructor i1
    WHERE i.Dept_Id = i1.Dept_Id
    );

--UNION: Combine the names of all students and instructors into a single list.
SELECT st_fname as std_names
FROM Student
UNION ALL
SELECT ins_name
FROM Instructor

--UNION with Condition: Create a list of courses that either have a duration longer than 50 hours or are taught by an instructor named 'Ahmed'.

SELECT crs_name FROM Course
WHERE Crs_Duration > 50
UNION
SELECT ins_name FROM Instructor
WHERE Ins_Name = 'Ahmed'

-- relate with table ins_cours

--Subquery with EXISTS: List all departments that have at least one course with a duration over 60 hours.	
SELECT dept_name
FROM Department
WHERE EXISTS (SELECT crs_duration FROM Course WHERE Crs_Duration > 60);
--relate

--TOP Clause: Select the top 5 highest-graded students in the 'SQL Server' course.

SELECT top 5 * from Student
WHERE st_id =
(SELECT st_id FROM Stud_Course WHERE crs_id = (SELECT crs_id from course where crs_name = 'SQL Server'))

--TOP with Ties: Show the top 3 departments with the most courses .

SELECT  TOP 3 WITH TIES
    I.Dept_Id,
    COUNT(c.crs_id) AS num_courses
FROM Instructor I
INNER JOIN Ins_Course c ON I.Ins_Id = c.Ins_id
GROUP BY I.Dept_Id
ORDER BY COUNT(I.dept_id) DESC, I.Dept_Id

-- added dept_id to avoid repitition

--Subquery with IN: Find all students who are enrolled in 'C Programming' or 'Java'.
SELECT st_id 
FROM Stud_Course 
WHERE crs_id IN (
    SELECT crs_id 
    FROM Course
    WHERE crs_name IN ('Java', 'C Programming')
);

select crs_id, st_id from Stud_Course

--Complex UNION: Create a list of all courses and instructors, showing course names and instructor names in separate columns.?

SELECT ins_name AS col1, NULL AS col2
FROM Instructor
UNION ALL
SELECT NULL AS col2, crs_name AS col1
FROM course;
----------------------------
SELECT 
    (CASE WHEN source = 'Instructor' THEN Ins_Name END) AS col1,
    (CASE WHEN source = 'Course' THEN column2 END) AS col2
FROM (
    SELECT 'Instructor' AS source, ins_name, NULL AS column2 FROM Instructor
    UNION ALL
    SELECT 'Course' AS source, NULL AS column1, crs_name FROM Course
) AS combined_data;


--Subquery in WHERE Clause: Identify students who are taking courses that are longer than the average duration of all courses.


SELECT distinct st_id
FROM Stud_Course sc
JOIN Course c ON sc.Crs_Id = c.Crs_Id 
WHERE c.Crs_Duration > 
        (Select AVG(Crs_Duration)
        FROM Course)


SELECT AVG(Crs_Duration)
FROM Course;

--Combining TOP and Subquery: Display the top 10% of courses based on the number of students enrolled.
SELECT TOP 10 PERCENT
    crs_name,
    num_students
FROM (
    SELECT 
        c.crs_name,
        COUNT(DISTINCT sc.st_id) AS num_students
    FROM course c
    INNER JOIN stud_course sc ON c.Crs_Id = sc.Crs_Id
    GROUP BY c.Crs_Name
) subquery_without_alias 
ORDER BY num_students DESC;