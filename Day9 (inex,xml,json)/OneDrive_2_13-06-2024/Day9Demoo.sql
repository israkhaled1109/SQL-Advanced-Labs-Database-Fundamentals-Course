--------------------------------------Clustered Index-----------------------------------------
create table stud
(
id int,
sname nvarchar(50),
sal int,
age int
)

DROP TABLE Stud

--indexing affect with the existing data
insert into stud(id) values (4)
insert into stud(id) values (1)
insert into stud(id,sal) values (3,100)
insert into stud(id,sal) values (5,50)

select * into studNewTable
from stud

select * from studNewTable where id=3
select * from stud where id=3

--Create clustered on Sal in table Student 








create nonclustered index cindex1
	on stud(sal)
select * from stud  where sal =500






--Create nonclustered on Sal in table Student 
create nonclustered index cindex
	on stud(sal)

--Create uniqe index(nonClustered) not Unique is a constraint
--that executed in old and new data 
create unique index uni_index  
on stud(sal)

drop index stud.cindex







--------------------------Indexed View -----------------
alter view VCairo
with schemabinding
as
select  s.St_Fname ,St_Address
from dbo.Student s
where St_Address= 'cairo'

alter table Student alter column St_Fname varchar(60)

create  unique CLUSTERED index VCairoindex  
on VCairo(St_Fname)





SELECT * FROM VCairo v
WHERE v.St_Fname ='Amr'


drop table dbo.Student

select * from VCairo WITH (NOEXPAND) where St_Fname='Amr'
















------------------SQL sever profiler and tuning advisor---------------





-- MERGE statement in SQL Server, which is used to perform insert, update, and delete operations
--in a single statement. This can be particularly useful for synchronizing two tables.

MERGE INTO target_table AS target
USING source_table AS source
ON target.matching_column = source.matching_column
WHEN MATCHED THEN
    -- specify action to take when rows match (e.g., UPDATE)
WHEN NOT MATCHED BY TARGET THEN
    -- specify action to take when row exists in source but not in target (e.g., INSERT)
WHEN NOT MATCHED BY SOURCE THEN
    -- specify action to take when row exists in target but not in source (e.g., DELETE);



-- Create TargetTable
CREATE TABLE TargetTable (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Quantity INT
);

-- Insert data into TargetTable
INSERT INTO TargetTable (ID, Name, Quantity) VALUES (1, 'Apple', 10);
INSERT INTO TargetTable (ID, Name, Quantity) VALUES (2, 'Orange', 20);
INSERT INTO TargetTable (ID, Name, Quantity) VALUES (3, 'Banana', 30);

-- Create SourceTable
CREATE TABLE SourceTable (
    ID INT PRIMARY KEY,
    Name NVARCHAR(50),
    Quantity INT
);

-- Insert data into SourceTable
INSERT INTO SourceTable (ID, Name, Quantity) VALUES (2, 'Orange', 25);  -- Existing ID with updated Quantity
INSERT INTO SourceTable (ID, Name, Quantity) VALUES (3, 'Banana', 35);  -- Existing ID with updated Quantity
INSERT INTO SourceTable (ID, Name, Quantity) VALUES (4, 'Grapes', 40);  -- New ID to be inserted


--Using MERGE
--Scenario: Synchronizing TargetTable with SourceTable
--We want to:
--Update the Quantity for matching IDs.
--Insert new rows from SourceTable into TargetTable where IDs do not exist in TargetTable.
--Optionally, delete rows in TargetTable that are not in SourceTable.

MERGE INTO TargetTable AS target
USING SourceTable AS source
ON target.ID = source.ID
WHEN MATCHED THEN
    UPDATE SET target.Quantity = source.Quantity
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, Name, Quantity) VALUES (source.ID, source.Name, source.Quantity)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;

	SELECT * from TargetTable




--XML
--http://msdn.microsoft.com/en-us/library/ms190922.aspx
--The FOR XML clause is central to XML data retrieval in SQL Server 2005. This clause
--instructs the SQL Server query engine to return the data as an XML stream rather than
--as a rowset

--The FOR XML clause has four modes to control XML Formate:
--1)RAW
--Transforms each row in the result set into an XML element

select * from Student
for xml raw('Student')  , ELEMENTS  ,Root('BIStudents')

--Students per address

select St_Address,COUNT(st_id) NumOfStd 
from Student
where St_Address is not null
group by St_Address

for xml raw('Student'),ELEMENTS,ROOT('STUDENTS')





--u can only present data as elemets or attributes
--using For XML Path is the solution for representing mixed "elemets and attributes"
--for each separate row

--JOIN problem

select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic ,Course 
where Topic.Top_Id=Course.Top_Id
order by topic.Top_Id
for xml raw ('topic'),ELEMENTS



--should be nested topic includes courses
--using For XML Auto is the solution for this problem

--2)AUTO
--http://msdn.microsoft.com/en-us/library/ms188273.aspx
--Returns query results in a simple, nested XML tree. Each table in the FROM clause 
--for which at least one column is listed in the SELECT clause is represented as an XML 
--element. The columns listed in the SELECT clause are mapped to the appropriate element attributes.

select Topic.Top_Id,Top_Name,Crs_Id,Crs_Name 
from Topic ,Course 
where topic.Top_Id=Course.Top_Id
order by topic.Top_Id
for xml auto,elements

--Benifets of For XML Auto
--1)Each row returned by the query is represented by an XML element with the same name
--2)the child elements are collated correctly with their parent
--3)Each column in the result set is represented by an attribute, unless the ELEMENTS option is specified
	
	select Topic.Top_Id,Topic.Top_Name,Crs_Id,Crs_Name 
	from Course ,Topic 
	where Topic.Top_Id=Course.Top_Id
	order by topic.Top_Id
	for xml auto,elements,root('Courses_Inside_Topics')

--4)Aggregated columns and GROUP BY clauses are not supported in AUTO mode
--queries (although you use an AUTO mode query to retrieve aggregated data
--from a view that uses a GROUP BY clause).



--3)PATH
--Provides a simpler way to mix elements and attributes, and to 
--introduce additional nesting for representing complex properties.
--Easier than Explicit mode

select st_id "@StudId",
		St_Age "@Age",
	   St_Fname+' '+ St_Lname  "StudentName",
	  -- St_Lname "StudentName/LastName",
	   St_Address "Address"	
	  
from Student
for xml path ('Student') , ROOT('AllStd')

select * from Student




select st_id "@st_id",
	   St_Fname "StudentName/@FirstName",
	   St_Lname "StudentName/@LastName",
	   St_Address "Address"	
from Student
for xml path('Student'),root('Students')




  --<Student StudentID="1">
  --  <StudentName FirstName="Ahmed" LastName="Hassan    " />
  --  <Address>Cairo</Address>
  --</Student>




select Topic.Top_Id "@TopicID",
	  Topic.Top_Name "Name",
	   course.Crs_Id "Course/CourseID",
	   course.Crs_Name "Course/CourseName" 
from Course,Topic 
where topic.Top_Id=Course.Top_Id
for xml PATH





--<row TopicID="3">
--  <Name>Web</Name>
--  <Course>
--    <CourseID>100</CourseID>
--    <CourseName>HTML</CourseName>
--  </Course>
--</row>

--The FOR XML clause has four modes and some options:
--1)ELEMENTS

--2)BINARY BASE64 option 
--Returns binary data fields, such as images, as base-64-encoded binary.
use NORTHWND 
go
select * from Categories
for xml raw('Catigory'),ELEMENTS,BINARY BASE64








-------------------------------------------------------------------------------------
--XML Shredding
--The process of transforming XML data to a rowset is known as �shredding� the XML data.

--Processing XML data as a rowset involves the following five steps:
--1)create proc processtree
declare @docs xml =
				'<Students>
				 <Student StudentID="1">
					<StudentName>
						<First>AHMED</First>
						<Second>ALI</Second>
					</StudentName>
					<Address>CAIRO</Address>
				</Student>
				<Student StudentID="2">
					<StudentName>
						<First>OMAR</First>
						<Second>SAAD</Second>
					</StudentName>
					<Address>ALEX</Address>
				</Student>
				</Students>'



--2)declare document handle (Refrence to root element in memory )
declare @hdocs INT  





--3)create memory tree
Exec sp_xml_preparedocument @hdocs output, @docs




--4)process document 'read tree from memory'
--OPENXML Creates Result set from XML Document
--create table NewStd as
--(
select * 
FROM OPENXML (@hdocs, '//Student')  --levels  XPATH Code
WITH (StudentID int '@StudentID',
	  Address varchar(10) 'Address', 
	  StudentFirst varchar(10) 'StudentName/First',
	  StudentSECOND varchar(10) 'StudentName/Second'
	  )
--)


--select * from NewTable
--5)remove memory tree
Exec sp_xml_removedocument @hdocs


select * from testtable
-----------------------------------------------Json-------------------------------------
--What is JSON?
--JSON (Java Script Object Notation) is a lightweight text-based data format 
--that helps to interchange data easily between modern applications.
--is used by the NoSQL (Microsoft Azure , Cosmos DB, CouchDB, etc.) databases to store the unstructured data.

--advantages
--1-The JSON data structure is easily readable by humans and machines
--2-JSON has a compact data structure and it does not include unnecessary data notations
--3-JSON has extensive usage. All modern programming languages and application platforms support working with JSON
--4-JSON has a straightforward syntax
--5-JSON supports the following data types :

--string
--number
--boolean
--null
--object {Id}
--array


{
"owner": "Doaa",
"brand": "BMW",
"year": 2020,
"status": false,
"color": [
    "red",
    "white",
    "yellow"
],
"Model": {
    "name": "BMW M4",
    "Fuel Type": "Petrol",
    "TransmissionType": "Automatic",
    "Turbo Charger": "true",
    "Number of Cylinder": 4
}
}




DECLARE @json NVarChar(2048) = N'{
  "owner": null,
  "brand": "BMW",
  "year": 2020,
  "status": false,
  "color": [ "red", "white", "yellow" ],
  "Model": {
    "name": "BMW M4",
    "Fuel Type": "Petrol",
    "TransmissionType": "Automatic",
    "Turbo Charger": "true",
    "Number of Cylinder": 4
 
  }
}';
 
SELECT * FROM OpenJson(@json)



--If OpenJson not working 

ALTER DATABASE iti_New  
SET COMPATIBILITY_LEVEL = 150;

--Type column JSON data type
--0 , null
--1 , string
--2 , int
--3 , true/false
--4 , array
--5, object





DECLARE @json VarChar(2048) = '{
"brand": "BMW",
"year": 2019,
"price": 1234.6,
"color": "red",
"owner": null
}'
 
SELECT * FROM OpenJson(@json)
WITH (CarBrand VARCHAR(100) '$.brand',
CarModel INT '$.year',
CarPrice MONEY '$.price',
CarColor VARCHAR(100) '$.color',
CarOwner NVARCHAR(200) '$.owner'
);



DECLARE @json NVarChar(2048) = N'{
"brand": "BMW",
"year": 2019,
"price": 1234.6,
"color": "red",
"owner": null
}'
 
SELECT * FROM OpenJson(@json)
WITH (CarBrand VARCHAR(100) '$.brand',
CarModel INT '$.year',
CarPrice MONEY '$.price',
CarColor VARCHAR(100) '$.color',
CarOwner NVARCHAR(200) '$.owner'
);




------------------------------------------------Sql Clr----------------------------------------------------
--The common language runtime (CLR) is the heart of the Microsoft .NET Framework
--and provides the execution environment for all .NET Framework code.
--Code that runs within the CLR is referred to as managed code. 
--The CLR provides various functions and services required for program execution
--, including just-in-time (JIT) compilation, allocating and managing memory,
-- enforcing type safety, exception handling, thread management, and security.

-- We use it to create functions 
-- User defined data types

sp_configure 'clr_enable' , 1
RECONFIGURE

sp_add_trusted_assembly

CREATE ASSEMBLY SQLCLRTest  
FROM 'F:\My_Courses\UnitTestingWorkShop\Database1'  
WITH PERMISSION_SET = SAFE;

SELECT name,
CAST(value as int) as value_configured,
CAST(value_in_use as int) as value_in_use
FROM sys.configurations
WHERE name ='clr enabled';

--Fail in publish solution 
--1-
use master 
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;

--2-
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END

--User Defined Function Found in Scaler Functions
select [dbo].SqlFunction1(2,3)

select [dbo].SqlFunction1(s.St_Id , s.St_Id)
from Student s

--User defined datatype 
create table Shapes
(
id  int ,
_Desc varchar(15),
Coordinates SqlUserDefinedType1
)
    --public static Circle Parse(SqlString recivedCircleFromSql)
    --{
    --    if (recivedCircleFromSql.IsNull)
    --        return Null;
    --    Circle circle = new Circle();
    --    string[] myData = recivedCircleFromSql.Value.Split(',');
    --     circle.x = int.Parse(myData[0]);
    --     circle.y = int.Parse(myData[1]);
    --    circle.radius = int.Parse(myData[2]);
    --    return circle;
    --}



	




create table test(
id int)


insert into test VALUES(1) ,(2)
select * from Test


create table #test(
id int)

insert into #test VALUES(1) ,(2)

select * from #test

--Globale table
create table ##test(
id int
)

insert into ##test VALUES(1) ,(2)
select * from ##test




