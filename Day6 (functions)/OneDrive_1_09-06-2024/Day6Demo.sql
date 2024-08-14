-------------------------------Variables------------------------------
-------------------Declare variables---------------------  
--Declare then assign then select using select 
declare @x int 
select @x =10
select @x
 

--Declare then assign then select using set 
declare @z int 
set @z =10
select @z
 
--Delcare and initialize then select 
declare @y int =10
select @y as YVar



--Save student avg age in a variable 
declare @age int = (select avg(St_Age) from Student)
select @age


declare @m int , @name varchar(20)

select @m = st_age , @name = St_Fname 
from Student
where St_Id=6

select @m , @name




select * from Student
--Note 
--we use Select for select only or insert value in var only

--Save id and name for student number 7
declare @id int ,@name varchar(10)

select @id=St_Id , @name=St_Fname
from Student 
where St_Id=7

select @id , @name
----------------------Wrong select for both --------------------
declare @y int

select @y=St_Age , St_Fname
from Student 
where St_Id = 4

select @y

--use set for both 
--write a qurey that update student name take name and id from 
--user in run time and then select student name and it's 
--Deparment 

declare @name varchar(10)='Doaa' ,@dept int , @id int=3

update Student 
set St_Fname=@name , @dept = Dept_Id
where St_Id=@id

select  @dept

--Save tanta Student age in a variable





declare @m1 int 
select  st_age from Student where St_Address='alex'
select @m1






---------------------------Table variable------------------------------
--How to declare table and it's columns
declare @t table ( col1 int )

--Save age for alex student in a variable
declare @t1 table (x int , y varchar(20))

insert into @t1( y , x)
select  St_Fname , St_Age
from Student
where St_Address='alex' AND St_Age is not null

select * from  @t1
-----------------------Make top dynamic using var----------------------
--Find top n students 
declare @x int =12

select top(@x)*
from Student 
order by St_Age desc 

-----------------------------Dynamic query-----------------------------
DECLARE @col varchar(20) = 'Ins_Name' , @tab varchar(20) = 'instructor'
EXECUTE(' select '+ @col+' from '+ @tab)


declare @col varchar(10) ='Ins_Name' , @tab varchar(10)='instructor'
select @col from @tab


declare @col varchar(10) ='Ins_Name' , @tab varchar(10)='instructor'
execute('select '+@col+' from '+ @tab)

-----------------------------Globle var----------------------
select @@SERVERNAME
select @@VERSION

update Student 
set St_Age+=1
select @@ROWCOUNT

select @@ROWCOUNT

select * from stuhdkf
go 
select @@ERROR 





create table t1
(
id int identity (1 , 4),
name varchar(10)
)
insert into t1 values('DDDD')
select * from t1
select @@IDENTITY

-------------------------------Contarl flow ---------------------------
--if , else 
--begin end
--if exists , if not exists
--while , continue , break 
--case
--iif
--waitfor
--Choose 
------------------------IF , else-----------------------------
declare @x int 
update Student 
set St_Age+=1
select @x= @@ROWCOUNT
if (@x >0)
   begin 
   select 'multi rows affected'
   end
else 
    begin 
	select 'no rows affected'
	end 

------------------------------if exists-------------------------------

if NOT exists (select * from sys.tables where name='FFF')
       select 'Table exists'
else
create table FFF
(
id int
)





-------------------------while ---------------
declare @x int =10

while @x<=20
	begin  
	     set @x+=1
		 if(@x=14)
		  continue 
		  if(@x=16)
		  break

		  select @x
	end




--------------------------Case---------------------------
Case 
    when Cond  then Res
	when Cond2  then Res
	else Res
end




declare @x int , @id int =4 , @mes varchar(30)
select @x = St_age from Student where St_Id = @id

set @mes = case 
            when @x>20 and @x<=30 then 'you can apply'
            when @x >30 then 'Sorry you cannot apply'
            when @x<20 then 'wait until 20 '
            else 'not allowed'
        end
SELECT @mes as tttttt



-- x>20 ? 'true' : 'false'



------------------------ iif ------------------
--iif(condition , value if true , value if false)
select s.St_Id , s.St_Fname, s.St_Age , iif(s.St_Age >20 , 'you can applay' , 'you can not applay') as res
from Student  s




------------------------------Wait for
-- Delay the process by 20 seconds:
WAITFOR DELAY '00:00:20';
GO
select * from student



-- Delay the process until 6:15 PM
WAITFOR TIME '11:07:00';
Go
select * from student
---------------------------------------------------------------
--Batch
select * from Student 
select * from Student where St_Id=35234525


--Script 

create rule r5 as @x>100
go
sp_bindrule r5 , 'instructor.Salary'







select * from Student
insert INTO Student(St_Id  , St_Fname) VALUES(45, 'ddd') ,(33 , 'ggggg' ), (5 , 'tttt')


insert INTO Student(St_Id  , St_Fname) VALUES(45, 'ddd') ,(33 , 'ggggg' ), (66 , 'tttt')

--Transaction
select 
update
delete 


Create table parent1 (pid int primary key)
Create table Child1 (cid int foreign key references parent1(pid))

insert into parent1 values(1)
insert into parent1 values(2)
insert into parent1 values(3)
insert into parent1 values(4)


insert into Child1 values(1)
insert into Child1 values(2)
insert into Child1 values(3)
insert into Child1 values(11)


begin try
 begin transaction
   insert into Child1 values(1)
   insert into Child1 values(2)
   insert into Child1 values(3)
   insert into Child1 values(4777)
  commit 
end try

begin catch
select ERROR_NUMBER() AS ErrorNumber,
       ERROR_STATE() AS ErrorState,
       ERROR_LINE() AS ErrorLine,
       ERROR_MESSAGE() AS ErrorMessage;
rollback
end catch

select * from Child1

truncate table Child1




insert into Child1 values(1),(2),(77)

update student 
set St_Age=1

------------------
select isnull(s.St_Fname , 'nnnnnnnnnnnnnnnnnnn')
from Student s

select * from Student
select nullif('ss','Hello')

select Coalesce( s.St_Fname , s.St_lname , 'ffffff')
from Student s
select len('iiii')

select max(len( St_Fname))
from Student

select power(Salary,2)
from Instructor

select top(1) St_Fname 
from Student
order by len(st_fname) desc

select upper(St_fname) , lower(St_Lname)
from student

select convert (varchar(20) , getdate() ,109 )




select format (getdate(), 'dd:MM-yyyy hh:mm:ss')


select DB_NAME() , SUSER_NAME()
----------------------------Custom Functions--------------------------------
--Notes
--1- Any function has retrun 
--2- we write select only inside it 


-------------------------------Scaler----------------------------
--Make a function that take student id and return name 
--string GetStudentName (int)

create function GetStudentName(@id int)
returns varchar(20)
  begin 
     declare @name varchar(20)
	 select @name = St_Fname
	 from Student
	 where St_Id = @id 

	 RETURN @name
  end 

 select dbo.GetStudentName(2)


  select dbo.GetStudentName(3)

----------------------------------inline-------------------------------
--Return Table 
--We us it if function body selects only  

--Write a function that take department id and retrun
--Department instrctors name and their anniual salary





create function GetinsInfo( @did int)
returns table 
as 
return 
(
select Ins_Name , Salary *12 as AnnSal
from Instructor
where Dept_Id = @did
)

select * from GetinsInfo(20)

-----------------------------------multi ------------------------------
--Return table 
--We us it if function body selects + if , while or any logic 

--Write function that take formate from user
--If format= 'first' select id and Fname 
--If format ='last' select id and Lname
--If format ='full' select id and Fname + Lname 
create function GetStudents(@format varchar(10))
returns @t table (id int , ename varchar(30))
as
 begin 
     if (@format = 'first')
	 begin
		 insert into @t 
		 select St_Id , sT_Fname
		 from Student
	 end 
	else if (@format = 'last')
	 begin
		 insert into @t 
		 select St_Id , sT_Lname
		 from Student
	 end 
	 else if (@format = 'full')
	 begin
		 insert into @t 
		 select St_Id , sT_Fname + ' '+sT_Lname
		 from Student
	 end 
	  return
 end




 select * from GetStudents('last')














