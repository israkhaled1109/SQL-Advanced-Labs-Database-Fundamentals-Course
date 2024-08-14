

----------------------------Joins with DML----------------------------
--Joins with Update
--Increase grade 10 marks for cairo students
select * from Student
select * from Course
select * from Stud_Course


UPDATE sc
SET Grade +=10
FROM Student s , Stud_Course sc
WHERE s.St_Id = sc.St_Id AND s.St_Address  = 'cairo'







--Joins with Insert





--Write query that insert student Id , Std_Name , Grade in 
--Top student table For top student 
create table TopStudent
(
Id int ,
Std_Name varchar(20),
Grade int
)
INSERT INTO TopStudent






insert into TopStudent (Id , Std_Name , Grade) 
SELECT  s.St_Id , s.St_Fname , sc.Grade
FROM Student s , Stud_Course sc
WHERE s.St_Id = sc.St_Id AND sc.Grade >90

SELECT * from TopStudent



SELECT * FROM TopStudent ts




----------------------------Joins with DML----------------------------
--Joins with Update
--Increase grade 10 marks for cairo students






update Stud_Course 
set Grade +=10
from Student s , Stud_Course sc 
where s.St_Id = sc.St_Id and s.St_Address='cairo'

select * from Student
select * from Course
select * from Stud_Course
--------------------------Rewrite Queries----------------
--Joins with Insert
create table TopStudent
(
Std_Name varchar(20),
Id int ,

Grade int
)

INSERT INTO TopStudent (ID  , Std_Name ,  Grade) 
SELECT  s.St_Id , s.St_Fname , sc.Grade
FROM Student s , Stud_Course sc
where s.St_Id = sc.St_Id and sc.Grade > 80

select * from TopStudent
select * from Stud_Course

--Joins with Delete







DELETE  s
FROM Student s , Stud_Course sc 
WHERE s.St_Id = sc.St_Id AND sc.Grade <75




SELECT * FROM Stud_Course


-------------------Talk about PK_FK moodes and constraint-------------

----------------------------Aggrigate Functions-----------------------------

select salary
from Instructor

--Find Sum of instructors salary
select Sum(salary)
from Instructor

--Find Max and Min Salary for instructor 
select Min(Salary) as Min_Val,Max(Salary) as Max_val
from Instructor

--Count Students
select count(*),count(st_id),count(st_lname),count(st_age)
from Student

select *
from Student

select avg(st_age)
from Student

select sum(st_age)/count(*)
from Student



select avg(isnull(st_age,0))
from Student



select sum(st_age)/count(*)
from Student







select sum(salary),Department.dept_id , Dept_Name
from Instructor , Department
where Department.Dept_Id = Instructor.Dept_Id
group by Department.dept_id , Dept_Name






select sum(salary),d.dept_id,dept_name
from Instructor i inner join Department d
on d.Dept_Id=i.Dept_Id
group by d.dept_id,dept_name




select avg(st_age),st_address,dept_id
from Student
group by st_address,dept_id
order BY St_Address






select sum(salary),dept_id
from Instructor
where salary>1000
group by dept_id







select sum(salary),dept_id
from Instructor
group by dept_id



select sum(salary),dept_id
from Instructor
group by dept_id
having sum(salary)>10000









select sum(salary),dept_id
from Instructor
group by dept_id
having Count(ins_id)<6






select sum(salary),dept_id
from Instructor
where salary>1000
group by dept_id
having Count(ins_id)<6








--------------------------------Subqueries-----------------------------
select * 
From Student
where St_Age > (SELECT  Avg(St_Age) from Student)



select *
from Student
where st_age<(select avg(st_age) from student)

select st_id,(Select Count(St_id) from Student)
from student


select dept_name
from Department
where dept_id in (SELECT DISTINCT Dept_id from Student where Dept_Id  is not null)







select distinct dept_name
from Student s inner join Department d
	on d.Dept_Id =s.Dept_Id

-------------------------Subquery  +  DML----------------------------
delete
from Stud_Course
where st_id=1



delete
from Stud_Course
where st_id in (select st_id from Student where St_Address='cairo')






UPDATE Stud_Course
set Grade+=10 
where St_Id in (select st_id from Student where St_Address='cairo')
 
















------------------------------Corrlated -------------------------

--Find the names of students who are older than the average age of students
--in their department.




SELECT St_Fname, St_Lname -- , S.St_Age , S.Dept_Id
FROM Student S
WHERE St_Age > (
    SELECT AVG(St_Age)
    FROM Student S2
    WHERE S2.Dept_Id = S.Dept_Id
);

-- Find the names of departments that have more than one student.

SELECT Dept_Name , D.Dept_Id 
FROM Department D
WHERE (SELECT COUNT(St_ID) 
       FROM Student S 
       WHERE S.Dept_Id = D.Dept_Id) > 1;


--SELECT Dept_Name
--FROM Department  , Student
--where Department.Dept_Id = Student.Dept_Id
--GROUP BY 
--HAVING COUNT(Student.Dept_Id) >1




---------------------------union family-------------------------------
--union all    union    intersect   except

select st_fname as names , St_Id
from Student
union all
select ins_name , Ins_Id
from Instructor

select st_fname,st_id
from Student
union all
select ins_name,ins_id
from Instructor

select st_id
from Student
union all
select ins_name
from Instructor


select st_fname
from Student
union all
select ins_name
from Instructor

select st_fname
from Student
union 
select ins_name
from Instructor






select st_fname
from Student
intersect 
select ins_name
from Instructor




select st_fname
from Student
except 
select ins_name
from Instructor


select st_fname,st_id
from Student
intersect 
select ins_name,ins_id
from Instructor
