
------------------------------Window Functions--------------------------
-----------------------Types of Window functions------------------------
--1-Aggregate Window Functions
--SUM(), MAX(), MIN(), AVG(), COUNT()
--Window functions do not cause rows to become grouped into a single output row,
--the rows retain their separate identities and an aggregated value will be added to each row.




SELECT St_Id, St_Fname,AVG(St_Age)OVER(PARTITION BY St_Address) as [average ages per city] ,St_Address
FROM Student
where St_Address is not null












SELECT St_Id, St_Fname,count(St_Id)OVER(PARTITION BY St_Address) as [NumOfStd per city] ,St_Address
FROM Student






SELECT St_Id, St_Fname, St_Age,Min(St_Age)OVER(PARTITION BY St_Address) as [Min per city] ,St_Address
FROM Student

SELECT St_Id, St_Fname, St_Age ,Max(St_Age)OVER(PARTITION BY St_Address) as [Max per city] ,St_Address
FROM Student




--2-Ranking Window Functions
--RANK(), DENSE_RANK(), ROW_NUMBER(), NTILE()




select * , ROW_NUMBER() over (order by st_age desc) as RN
from Student 
WHERE St_Age is not null





select * , DENSE_RANK() over (order by st_age desc) as DR
from Student 
WHERE St_Age is not null




select * , RANK() over (order by st_age desc) as R
from Student 
WHERE St_Age is not null

select * , Ntile(3) over (order by st_age desc) as RN
from Student 

--Find Second aged Student in each department 










select * from 
(
	select * , Dense_rank() over (partition by Dept_id order by st_age desc) as DN
	from Student 
	where Dept_Id is not null

) as newTable
where DN = 2

--Find Second aged Student in each department with repeating

select * from 
(
	select * , Dense_rank() over (partition by Dept_id order by st_age desc) as DN
	from Student 
	where Dept_Id is not null

) as newTable
where DN = 2

--Find Second higets student in each course  


select * from (
SELECT s.St_Id , s.St_Fname , s.St_Address ,  sc.Crs_Id,sc.Grade , 
       Dense_rank() over (partition by sc.Crs_Id ORDER by sc.Grade desc) as R
from Student s, Stud_Course sc
where s.St_Id = sc.St_Id
) as newTab
where R = 2













select * from 
(
select s.St_Id , s.St_Fname , c.Crs_Name ,sc.Grade , 
        ROW_NUMBER() over (partition by c.Crs_Name  order by sc.Grade desc) as RN
from Student s , Stud_Course sc ,Course c
where s.St_Id = sc.St_Id and c.Crs_Id = sc.Crs_Id
) as NewTabl
where RN = 2




--3-Value Window Functions
--LAG(), LEAD(), FIRST_VALUE(), LAST_VALUE()





-----------------------------------CTE---------------------------------
--A Common Table Expression, also called as CTE in short form,
--is a temporary named result set that you can reference within 
--a SELECT, INSERT, UPDATE, or DELETE statement. The CTE can also 
--be used in a View.

-------------------------------CTE Synatx-------------------------------
--WITH expression_name[(column_name [,...])]
--AS
--    (CTE_definition)
--SQL_statement;


--WITH expression_name AS (CTE definition)

student

with cte 
as 
(
	 select st_fname ,st_age , St_Address
	 from Student
)
SELECT * from cte



DELETE from cte where st_fname = 'waefjh'




--Find Top 3 aged student in each each Department 


with tempdata 
as (
	  SELECT *, ROW_NUMBER() OVER(PARTITION BY dept_id ORDER BY st_age desc) AS rk
      FROM student
      ) 

select St_Fname , St_Age , rk
from tempdata 
where rk<=3




create table test2
(
ID int ,
NAME VARCHAR(10),
AGE INT
)
go
INSERT INTO test2 values (1,'Doaa' , 24),
						(1,'Doaa' , 24),
						(2,'ali' , 25),
                        (2,'ali' , 25)
---------------------------------CTE with insert-----------------------

WITH tab AS (
  select * from test2
)
INSERT INTO tab  
SELECT * FROM test2

select * from test2

















-----------------------------------------------------------------------------

--Find Duplicate in Test table 
WITH cte 
AS (
    SELECT   t.NAME , t.AGE , t.ID  , ROW_NUMBER() OVER (PARTITION BY t.ID 
            ORDER BY t.ID ) row_num
    FROM test2 t
) 
delete FROM cte 
WHERE row_num > 1;



------------------------------------------------------------



--------------------------Cursor----------------------------
 --Create cursor that view student info for alex student 




 declare c1 cursor 
 for
   select St_id , st_Fname 
   from Student
   where St_Address = 'alex'

   for read only 


declare @id int , @name varchar(10)

open c1

fetch c1 into @id , @name

while @@FETCH_STATUS=0
begin

select @id ,@name
fetch c1 into @id , @name

end 
close c1
deallocate c1 

-----------------------------------------------------
--Write cursor query that show student names in one cell

--[ahmed , amr , mona,.............]


declare c1 cursor
for 
    select ST_Fname 
	from Student
	where St_Fname is not null

for READ ONLY
declare @fname varchar(10) , @allnames varchar(500)=''
open c1

fetch c1 into @fname
while @@FETCH_STATUS=0
begin
if len(@allnames)= 0
set @allnames = @fname
else 
   set @allnames = @allnames + ' , ' + @fname
   fetch c1 into @fname
end
select @allnames
close c1
deallocate c1 

--Write a cursor that update instructors salary if salary >3000 
--increase it by 20%
--Else increase it by 10%
declare c1 cursor 
for
 select Salary 
 from instructor 
 where Salary is not NULL

 for UPDATE
 DECLARE @sal float 
 open c1 
 FETCH c1 into @sal 
 while @@FETCH_STATUS =0 
 begin 
  if @sal >=3000
  update Instructor set Salary = Salary*1.2
  WHERE Current of c1 
  else 
  update Instructor set Salary = Salary*1.1
  WHERE Current of c1 
 FETCH c1 into @sal 
 end 
 close c1 
 DEALLOCATE c1












declare c2 cursor 
for
   select Salary
   from Instructor
--for update 

declare @sal int 

open c2
fetch c2 into @sal

while @@FETCH_STATUS=0
begin 
    if (@sal >300)
	   update Instructor Set Salary= Salary *1.3
	   where current of c2 
     
	 else 
	    update Instructor Set Salary= Salary *1.1
		where current of c2 

		fetch c2 into @sal
end

close c2
deallocate c2 
-----------------------------Students Task----------------------------
--Count times that amr apper after ahmed in srudent table 
--ahmed then amr
Select * from student 
insert into student values (16 , 'Ahmed' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (17 , 'Amr' , 'Mohmaed' , 'Cairo' , 20 , 20 , NULL)
insert into student values (18 , 'Test' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)

insert into student values (18 , 'Ahmed' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (19 , 'Test' , 'Mohmaed' , 'Cairo' , 23 , 20 , NULL)
insert into student values (20 , 'Amr' , 'Mohmaed' , 'Cairo' , 20 , 20 , NULL)

