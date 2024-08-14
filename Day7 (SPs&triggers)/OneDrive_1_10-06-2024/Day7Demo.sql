--Stored Proc Advantages
--1-It can be easily modified without need to redeploy app 
--2-Reduce Netowrk traffic
--3-Security
--4-Take params
--5-Increase Preformance 
--6-We can write any bussiness logic in it 
--7-Prevent Server Errors
--8-Hide Bussiness Rules

--Types of SP
--1) built in SP

sp_bindrule 
sp_unbindrule 
sp_helptext 'Vcairo'
sp_helpconstraint 'Student'







--2) User Defined SP

--Creat Proc that Display all Students

create proc StdInfo
as
select * from student




 execute StdInfo






--Call stored
--1-
StdInfo
--2-
 execute StdInfo


--Create Proc that Take address and return 
--Students Info in that address
create proc StdAddress @add VARCHAR(20)
as
SELECT * from Student
where St_Address = @add





StdAddress 'cairo'


create proc StdAddress @add varchar(10)
as 
select * from student 
where St_Address=@add

StdAddress 'alex'

StdAddress 'alex'



------------------------Stored With DML------------------------------
--Write Stored that Insert values in students table 
--Note Prevent server error that came from DML Queries









create or alter proc InsertSTDInfo @id int , @name varchar(10)
as
begin try 
insert into Student (St_id , st_Fname) values (@id  , @name)
end try

begin catch 
select 'Error '
end catch 

InsertSTDInfo 132, 'ali'



InsertSTDInfo 5465 , 'Doaa'







--Create Proc that take two int and print sum

create or alter proc SumXY @x int = 100 , @y int =50
as
 SELECT @x+@y


declare @a int = 4 , @b int = 5
EXECUTE SumXY @a ,@b 







 ---Pass parameter by position 
declare @x int  
EXECUTE @x = SumXY @x = 5
SELECT @x


declare @x int
execute @x= SumXY 3
select @x

 -- Pass parameter by Name



execute SumXY @y=54 , @x=54





--Write Proc that take two ages and return student info who's age
--Match that range
	create proc StdAges @age1 int , @age2 int 
	as
	select *
	from Student
	where St_Age between @age1 and @age2




StdAges 20 , 25




-----------------------------insert based on execute--------------------------
	alter proc StdAges @age1 int , @age2 int 
	as
	select St_Id , St_Fname , st_age
	from Student
	where St_Age between @age1 and @age2

DECLARE @t table (id int , name VARCHAR(20) , age int)
insert into @t 
EXECUTE StdAges 20 , 25 
SELECT * from @t



declare @t table(age int)

insert into @t
execute StdAges 20 ,30
select * from @t





------------------------------Stored with return------------------------------ 
---Proc takes id and return age 
create proc StdAge @id int 
as
declare @age int 
select @age = St_Age 
from Student
where St_Id = @id 

return @age





declare @a int 
execute  @a=  StdAge 1
select @a






-------------------Save Proc return value in var------------------------






--Create Proc that take student id Return Student name 
create proc StdName @id int 
as
declare @name varchar(10) 
select @name = St_Fname
from Student
where St_Id = @id 
return @name


declare @name varchar(10)
execute @name= StdName 7
select @name










--Create Proc that take student id Return Student name 
--Note stored has two types of parameters 
--Input 
--Output

alter proc StdName @id int , @name varchar(10) output 
as
select @name = St_Fname  
from Student
where St_Id = @id 








declare @n varchar(10)

execute StdName 10 , @n  OUTPUT
select @n






--Return more than one value using Output
--Create proc that take student id and return student name , age 








alter proc StdName @idAge int output, @name varchar(10) output
as
select @name = St_Fname ,@idAge =St_Age
from Student
where St_Id = @idAge

declare @n varchar(10) , @aId int = 6
execute StdName @aId OUTPUT , @n OUTPUT
select @aId ,@n 
  









-------------------------------------- Security -----------------------------------
sp_helptext 'StdName'

alter proc StdName @id int , @name varchar(10) output , @age int output
with encryption
as
select @name = St_Fname , @age =St_Age
from Student
where St_Id = @id 



------------------------------ Input / Output ----------------------------
--Create proc that take student id and return student name , age  

alter proc StdName @Ageid int output  , @name varchar(10) output 
with encryption
as
select @name = St_Fname , @Ageid =St_Age
from Student
where St_Id = @Ageid 

declare @n varchar(10) , @a int =10
execute StdName  @a output  ,  @n output 
select @a , @n





--IS it aviliable to write execute in functions ? 

EXECUTE('Select * from Student')









--Create Stored Procdure
--XXXXXXXXXXXXXXXXXXXX

create proc Test @col varchar(10) , @tab varchar(10)
as
execute ('select '+@col+' from  '+@tab)


Test 'St_Fnamecghuj' , 'Student'


------------------------Input/Output -------------




-------------------------------------------------------------------
--3)Trigger
----It's a special type or Sored Proc
--Can't call
--can't Send parameter
--triggers  on Table
--Listen to (insert update delete)

---------------------------------DML triggers-------------------------------- 
--Create Trigger that print welcome Message after insert in 
--student table
create TRIGGER t11 
on Student
after INSERT
as
SELECT 'Welome to our Website'

insert INTO Student(St_Id , St_Fname) VALUES(222, 'dddd')










create trigger t11
on Student 
after insert 
as
select 'Welcome to iti'



insert into Student(St_Id , St_Fname) values (345 , 'Test')








--Create trigger that Get date of update on course tabel 
create TRIGGER t12
on Course
AFTER UPDATE
AS
SELECT getdate()

UPDATE Course set [Crs_Name] = 'test' WHERE Crs_Id=800














create TRIGGER t2 
on Student
AFTER UPDATE
as 
SELECT getdate()

UPDATE Student set St_Fname ='kjj'
where St_Id = 2






create trigger t2
on student 
after update 
as
select getdate()


update student set St_Fname= 'Pla' where St_Id=6


--Trigger prevent users from delete from table student 
--and show massege not allowed for user + suser_name()

CREATE TRIGGER t13
on Student
INSTEAD OF DELETE
as 
SELECT 'not allowed for user' + suser_name()






DELETE from Student







create TRIGGER t3 
on Student
INSTEAD of DELETE
as
select 'not allowed for user' + suser_name()
DELETE from Student






create trigger t3
on Student 
instead of delete
as
select 'not allowed to '+suser_name()

delete from Student 

select * from student 




--How can i make table read only 
CREATE TRIGGER t14 
on Department 
INSTEAD of DELETE , INSERT , UPDATE
AS
SELECT 'this table is read only'


INSERT into Department(Dept_Id , Dept_Name) VALUES(22 , 'fff')

SELECT * from Department
































create or ALTER trigger t4
on student
instead of insert , update , delete 
as
select 'Not allowed'

insert into Student (ST_Id ) VALUES(33)





--Trigger autommatically take schema for Data base object
-- that Trigger created in it 

--Create trigger that say hi if any one update student Fname

 ALTER TRIGGER MySch.t15 
on MySch.Student
AFTER UPDATE
AS
if UPDATE(St_Fname)
SELECT 'Welcome ya client'





UPDATE Student set St_Lname ='ffffff' where St_Id = 1


CREATE SCHEMA MySch

alter SCHEMA MySch TRANSFER Student









create schema s1
go 
alter schema s1 transfer Student 

 alter trigger s1.t5 
on s1.student 
after update 
as 
select 'Say Hi for '+SUSER_NAME()

UPDATE s1.Student SET St_Fname ='dddd' where St_Id = 3
update s1.Student set st_Fname ='ghg' where St_id =1



















--How can we know data after delete it or update it





CREATE TRIGGER t16
on Instructor
after UPDATE
as
SELECT * from INSERTED
SELECT * FROM DELETED

UPDATE Instructor SET Salary = Salary*1.1 WHERE Ins_Id = 12











create TRIGGER t6 
on Department
after UPDATE
AS
SELECT * from INSERTED
SELECT * from DELETED

UPDATE Department
SET Dept_Name ='SDDDD'
WHERE Dept_Id = 10






alter  trigger t6
on [Department]
after delete , update 
as
select * from inserted 
select * from deleted

delete from Department where Dept_Id=80
update Department set Dept_Name='test' where Dept_Id =80





--Create Trigger that select course old and new data after update 
--any column in Course table 


CREATE TRIGGER t17 
on Course
AFTER INSERT
as
SELECT * from DELETED
SELECT * from INSERTED


INSERT INTO Course(Crs_Id , Crs_Name) VALUES(22222 , 'test')









CREATE TRIGGER t7
on Course
AFTER UPDATE
as 
SELECT Crs_Name as NewCoures  from INSERTED
SELECT Crs_Name as OldCoures  from DELETED



UPDATE Course 
SET Crs_Name ='DB'
where Crs_Id =100



alter trigger t7
on Course 
after update 
as
select i.Crs_Name , d.Crs_Name
from inserted i , deleted d 




update Course set Crs_Name='hkbilj.j' where Crs_Id=100



--Create trigger that print student name that you deleted

CREATE TRIGGER t18
on MySch.Student
AFTER DELETE
as 
SELECT St_Fname from DELETED

DELETE from MySch.Student WHERE St_Id = 404




















--Create trigger that prevent user from delete any course in wednesday
--and show user that tried to update

create or alter TRIGGER t8 
on Course
after DELETE
as 
if FORMAT (getdate() , 'dddd') = 'wednesday'
BEGIN
SELECT 'Delete Nor allowed in wednesday'
insert INTO Course
SELECT * from DELETED
END

DELETE FROM Course 
where Crs_Id =1300







alter TRIGGER t20
on Instructor
after DELETE
AS
if FORMAT(GETDATE() , 'dddd') = 'monday'
BEGIN 
--INSERT into Instructor
--SELECT * from DELETED
ROLLBACK
END


DELETE from Instructor where Ins_Id = 16















alter trigger t9
on Course 
after delete
as
if format(getdate() , 'dddd')='wednesday'
begin 
insert into Course
select * from deleted 
select 'Not allowed for '+SUSER_NAME()
end 




delete from Course where Crs_Id=40000

select * from Course





----------------------------Audit tables -------------------------------







--Create trigger that audit name for user excute update on 
--On top_id  and date of execution , old and new value 












create table history 
(
OldId int ,
_NewId int ,
name varchar(50),
date date
)

CREATE TRIGGER t19
on Topic
AFTER UPDATE
as 
DECLARE @newid int , @oldid INT
select @oldid = Top_Id from DELETED
select @newid = Top_Id from INSERTED
INSERT INTO history VALUES(@oldid , @newid , SUSER_NAME() , getdate())

UPDATE Topic set Top_Id =10  where Top_Id = 6

SELECT * from history








create or alter trigger t10 
on topic
after update
as
if update(top_id)
begin
declare @oldid int , @newid int
select @newid =top_id from inserted
select  @oldid = top_id from deleted

select  top_id from deleted

insert into history values (@oldid , @newid , SUSER_NAME() , GETDATE())
end



UPDATE Topic SET Top_Id=8  where Top_Id = 6
SELECT * from history


insert into Topic
select * from deleted
end

update topic set Top_Id = 254 , Top_Name = 'tttt' where Top_Id=6

select * from history

update topic set Top_Name = 'sfkf,n'  where Top_Id=6









---------------------------disable/enable Trigger------------------------
alter table department disable trigger t4
alter table department enable trigger t4
-------------------------------Drop DML trigger---------------------------

drop trigger t5

---------------------------------  DDL  -------------------------------
create trigger t15
on database
for create_table 
as 
--select'wlcome'
rollback

create table emp(id int)
drop table history

select * from history

select * from emp

------------------------------enable / disable Trigger-----------------------
ENABLE TRIGGER t5 ON DATABASE
GO
DISABLE TRIGGER t5 ON DATABASE
GO
----------------------enable / disable all Triggers in table------------------
ENABLE TRIGGER ALL ON TableName
DISABLE TRIGGER ALL ON topic

--------------------------------Drop DDL trigger------------------------------

DROP TRIGGER t5 ON DATABASE






-------------------------output Runtime trigger-------------------











insert into MySch.Student(St_Id , st_Fname)
--OUTPUT 'welcome ya '+ INSERTED.st_Fname
values(5546 , 'waefjh')












update MySch.Student 
set st_Fname ='PLLLLLLLLLLLLa'
OUTPUT DELETED.St_Fname
where st_id =5541





delete from Student 
output 'you deleted Student '+ DELETED.St_Fname +' at ' + CONVERT(VARCHAR(50) , GETDATE())
where st_id = 5541



