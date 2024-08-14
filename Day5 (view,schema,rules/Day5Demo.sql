
-------------------------------------------------Schema------------------------------------

--what is Schema 
--it is Logical grouping for tables and data base objects
--Why we need Schema ?
--1-we can't make more than one object in Data base(table , view ,...) 
--with same name 
--2-Too Much Permission if we deal with each table indevidually
--3- We could give permision in schema 

------------------------Create Schema --------------------------
create schema Hr

create table [HR].[Departments](id int)
select * from HR.[Departments]


select * from [DESKTOP-22FGRI7].ITI_new.dbo.Student

select * from [DESKTOP-22FGRI7].[Company_SD].[dbo].[Dept]


alter schema Hr transfer [dbo].[emp3] 


select *
from serverName.DatabaseName.SchemaName.TableName

select *
from [DESKTOP-22FGRI7].ITI_new.dbo.Student

create schema HR

create schema sales

--to move an existing table to my new schema















alter schema HR transfer Student







alter schema dbo transfer [Hr].[Departments]








alter schema sales transfer department

create table Hr.stud
(
 id int,
 name varchar(20)
)

--Create table inside specific schema
create table sales.student
(
 id int,
 name varchar(20)
)

select * from Hr.Instructor

select * from hr.Instructor

select * from Instructor

select * from Student

select * from Hr.Student


-----------------Don't forget to change schema using wizerd---------------


------------------------synonym-----------------------------------------
--what is synonym ? Saved alias name 
create synonym  s1
for [dbo].[FactAdditionalInternationalProductDescription]


SELECT * from s1
SELECT * from  [dbo].[FactAdditionalInternationalProductDescription]
SELECT * from [Hr].[Departments]



create synonym
select * from s1

 

select s.St_Id
from Student s

create synonym HE
for HumanResources.EmployeeDepartmentHistory

select * from HE
------------------------------Views------------------------------------

/** Views **/
/*
IS A Saved select statment we can't write insert update delete in it .

Views Properties : 
�	No DML Queries inside view body 
�	Standered View may be Considered as Virtual table 
�	Has No Parms 

--Why and when we use it?
�	Simplify construction of complex queries
�	Specify user view
�	Limit access to data [grant revoke]
�	Hide names of database objects [table name and columns]
*/								


/** Creating Views **/








---Selecting data from View 

select * from Vstuds

---Alias name for view column 
--Create view that contain cairo strudent information

CREATE view Vcairo (Id , name , address)
as
SELECT St_Id  , St_Fname , St_Address
from  Student
where St_Address = 'cairo'


SELECT Id from Vcairo








SELECT * from Vcairo









select * from Vcairo
select name from Vcairo
--Create view that containt alex strudent information

create or alter view Valex(id,name,address)
with encryption
as
	Select st_id,st_fname,st_address
	from Student
	where st_address='alex'









select * from valex











sp_helptext 'Valex'
--Create view for cairo and alex students--
--View inside view 

create view Vall
as
select * from vcairo
union 
select * from valex


SELECT * from Vall



------------------------------------------

Create view Vjoin(sid,sname,did,dname)
with encryption
as
select st_id,st_fname,d.dept_id,dept_name
from student S inner join department d
	on d.dept_id=s.dept_id


select * from vjoin



select sname,dname from vjoin



-- view for sname,dname,grade
CREATE view vgrades
as 
select s.St_Fname as sname , d.Dept_Name dname  , sc.Grade garde 
from Student s, Department d, Stud_Course sc
where d.Dept_Id = s.Dept_Id and s.St_Id = sc.St_Id


SELECT * from vgrades









create view vgrades
as
select sname,dname,grade
from vjoin v inner join Stud_Course sc
	on v.sid=sc.St_Id

select * from grades

sp_helptext 'vjoin'
----------------------For view security------------------------------
create view vgrades
with encryption
as
select sname,dname,grade
from vjoin v inner join Stud_Course sc
	on v.sid=sc.St_Id










----------------------------------- View+DML -------------------------------------
-----View DML in One table
	
---------------------------1- Insert in one table--------------------------------- 
--1- Rest column in table that we toke view from should have one of the flowing
--(Defualt value , identity , allow null , derived)




insert into vcairo
values(3210,'ali','cairo')

SELECT * from Student
SELECT * from Vcairo
-------------------With Check options-------------------------
insert into vcairo
values(327,'ali','alex')

alter view Vcairo(sid,sname,sadd)
as
	Select st_id,st_fname,st_address
	from Student
	where st_address='cairo'
with check option


insert into vcairo
values(329,'ali','alex')

select * from vcairo


--------------------------------------Update-----------------------------
update  vcairo
set  sname ='Nour' where sid =1

--------------------------------------Delete -----------------------------
delete  from  vcairo
where  sid = 3210


-------------------DML with view that came from Multi tables-----------------------









alter view Vjoin(sid,sname , sdid ,did,dname)
with encryption
as
select st_id,st_fname , s.Dept_Id,d.dept_id,dept_name
from student S inner join department d
	on d.dept_id=s.dept_id



--Delete XXXXXXXXXXXXXXXX
--insert   update avilable with conditions
-----------1-insert and update must affect in one table 
insert into vjoin
values(21,'nada',700,'Cloud')





--insert in table 
insert into vjoin(sid,sname ,sdid)
values(23,'nada1' ,900)

insert into vjoin(did,dname)
values(900,'TestCloud1')


SELECT * from Vjoin

update vjoin 
set sname ='Doaa'
where  dname ='Testcloud' --XXXXXXXXXXXx



--indexed view --Continued--
--When we use it When you use the same complex query on many tables, multiple times.
--When new system need to read old table data, but doesn't watch to change their
--perceived schema.
create view vdata
with schemabinding
as
	select ins_name,salary
	from dbo.Instructor   --We have to write Schema name 
	where dept_id=10 

--Fist one will be altered
alter table instructor alter column ins_degree varchar(50)

--But this one will not altered because it's found in view 
--and view take phicycal copy from table 
alter table instructor alter column ins_name varchar(100)












-----------------------------
---------------------------------Data base intergrity---------------------------


---------------------------------------Conistraint-------------------------------------
--Set of conditions we apply it in columns 
--Constraint applied to new and old data so if old data dosen't match 
--Conistraint it won't Created 
create table Dept
(
 Dept_id int primary key,
 dname varchar(20)
)

select * from emp


create table emp
(
 eid int identity(1,4),                  
 ename varchar(20),                        --Domain integrity(Specify Rang of values)
 eadd varchar(20) default  'alex',         --Domain integrity 
 hiredate date default getdate(),          --Domain integrity
 sal int,								   --Domain integrity
 overtime int ,	
 
 
 
 --Domain integrity
 netsal as(isnull(sal,0)+isnull(overtime,0)) persisted, 






 BD date,
 age as(year(getdate())-year(BD)),
 gender varchar(1),
 hour_rate int not null,
 did int,

 constraint c11 primary key(eid,ename),  --Entity integrity(Row Uniqness)
 constraint c12 unique(sal)  ,
 constraint c13 unique(overtime),



 -- constraint c3 unique(sal , overtime),

 constraint c14 check(sal>1000),





 constraint c15 check(eadd in ('cairo','mansoura','alex')),


 constraint c16 check(gender='F' or gender='M'),



 constraint c17 check(overtime between 100 and 500),
 constraint c18 foreign key(did)  references Dept(Dept_id)
		
)




SELECT GETDATE()
2024-05-27 11:00:44.420

--Note Constraint on old and new data 
alter table emp add constraint c100 check(hour_rate>100)









--Drop Constraint 
alter table emp drop constraint c3


---------------------------------Sequence and Idintity------------------
--
--Create Sequence:object that generates a sequence of numbers according to 
--a specified specification
--To create a Sequence in SQL Server 2012 is very simple. You can
    -- create it with SQL Server Management Studio or T-SQL.
    --Create Sequence with SQL Server Management Studio
    --In Object Explorer window of SQL Server Management Studio, there is a Sequences node under Database -> [Database Name] -> Programmability. You can right click on it to bring up context menu, and then choose New Sequence� to open the New Sequence window. In New Sequence window, you can define the new Sequence, like Sequence Name, Sequence schema, Data type, Precision, Start value, Increment by, etc. After entering all the required information, click OK to save it. The new Sequence will show up in Sequences node.
    --Create Sequence with T-SQL
    --The following T-SQL script is used to create a new Sequence: 

-- Create seq progromatically:
CREATE SEQUENCE DemoSequence
START WITH 1
INCREMENT BY 1;

create sequence ss1
start with 1
increment by 1
minvalue 1
maxvalue 3
cycle



-- Use Sequence
----The new NEXT VALUE FOR T-SQL keyword is used to get the next 
-----sequential number from a Sequence.
SELECT NEXT VALUE FOR DemoSequence

create table [Customers]
(
[CustomerID] int,
[LName] nvarchar(22),
[FName] nvarchar(22)
)

--Use it for insert
insert into [dbo].[Customers] ([CustomerID],[LName],[FName]) 
values(1,'fff','rrr');

insert into [dbo].[Customers] ([CustomerID],[LName],[FName]) 
values(NEXT VALUE FOR DemoSequence,'fff','rrr');

select * from Customers

--column can be updated
update [dbo].[Customers]
set [CustomerID]=12
where [CustomerID]=11

-------------------------------------Rules----------------------------------------------

--what if we want to apply Constraint in new data only
--what if we want to write Constraint once and make it shaired on more than one column
--what if we want to Datatype and apply constraint and Rules on it 
--As Resualt for all of that their is a Rules that solve ali this problems
--XXXXX       Constraint   ---> New Data
--XXXXX       Constraint   --->shared 
--XXXXX       Datatype        Constraint    Default

alter table instructor add constraint c200 check(salary>1000)
  
---------------------------------------------------------------------
CREATE rule r1 as @y>100







sp_bindrule r1 , 'emp.hour_rate'






create rule r2 as @x>1000
go
sp_bindrule r2 , 'instructor.salary'
sp_bindrule  r2,'[dbo].[Instructor].[Dept_Id]'

--Rule
create rule r1 as @x>1000

sp_bindrule  r1,'Employee.salary'
sp_bindrule  r1,'[dbo].[Instructor].[Dept_Id]'

sp_unbindrule 'instructor.salary'
sp_unbindrule '[dbo].[Instructor].[Dept_Id]'

drop rule r2





create default def1 as 5000

sp_bindefault  def1,'Employee.salary'

sp_unbindefault 'Employee.salary'

drop default def1

------------------------------------User defined Data Types--------------------------------------------------



create table eee( col1 OverTimeValue)



--Create New Datatype  ----OverTimeValue  (int    >1000    default 5000)

---------------------------------------------------------------------------------------------------------
--Creating user defined data type

CREATE TYPE OverTimeValue FROM int NOT NULL;
--OR
--sp_addtype new_dtype,'nvarchar(50)','not null'
go
create rule greater_than1000 as @s >1000
go
create default def3 as 5000
go
sp_bindrule greater_than1000 , OverTimeValue
go
sp_bindefault def3 , OverTimeValue
--exists in Programmability=>Types=>User-Defined Data Types


			-----------------------
--Using new data type on a new table

create table emp4
(
IDNo int Primary key,
Name nvarchar(50),
overTime OverTimeValue
)
--Using new data type on a existing table table
--but that column must no have any data base objects related to it like
--(constraint ) 
go

alter table emp3
alter column overTime OverTimeValue


alter table emp3
alter column overTime int
--Removing user defined Data type
drop type IDNumber
--OR
sp_droptype OverTimeValue
		


-------------------------------------------------Schema------------------------------------

--what is Schema 
--it is Logical grouping for tables and data base objects
--Why we need Schema ?
--1-we can't make more than one object in Data base(table , view ,...) 
--with same name 
--2-Too Much Permission if we deal with each table indevidually
--3- We could give permision in schema 

------------------------Create Schema --------------------------
create schema Hr

create table [HR].[Departments](id int)
select * from HR.[Departments]



alter schema Hr transfer [dbo].[emp3] 


select *
from serverName.DatabaseName.SchemaName.TableName

select *
from [DESKTOP-22FGRI7].ITI_new.dbo.Student

create schema HR

create schema sales

--to move an existing table to my new schema

alter schema HR transfer Student

alter schema HR transfer Instructor

alter schema sales transfer department

create table Hr.stud
(
 id int,
 name varchar(20)
)

--Create table inside specific schema
create table sales.student
(
 id int,
 name varchar(20)
)

select * from Hr.Instructor

select * from hr.Instructor

select * from Instructor

select * from Student

select * from Hr.Student


-----------------Don't forget to change schema using wizerd---------------


------------------------synonym-----------------------------------------
--what is synonym ? Saved alias name 
create synonym  s1
for[Hr].[Departments]
SELECT * from s1
SELECT * from [Hr].[Departments]



create synonym
select * from s1

 

select s.St_Id
from Student s

create synonym HE
for HumanResources.EmployeeDepartmentHistory

select * from HE









