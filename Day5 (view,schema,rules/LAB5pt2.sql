--Make a rule that makes sure the value is less than 1000 then bind it on the Salary in Employee table.
CREATE RULE CheckSalaryRule 
AS 
    @Salary < 1000
GO
EXEC sp_bindrule 'CheckSalaryRule', 'Employee.Salary';

--Create a new user data type named loc with the following Criteria:
--•	nchar(2)
--•	default: NY 
--•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column
CREATE TYPE loc FROM NCHAR(2) NOT NULL
GO
CREATE DEFAULT def1 AS 'NY'
GO
CREATE RULE LocationValues
AS
    @Val IN ('NY','DS','KW')

--Create a New table Named newStudent, and use the new UDD on it you just have made and ID column and don’t make it identity.
CREATE TABLE newStudent (
    ID INT NOT NULL,
    location loc DEFAULT 'NY'
    )
--EXEC sp_binddefault def1, location??

--Create a new sequence for the ID values of the previous table.
CREATE SEQUENCE newStudent_ID_Seq
    START WITH 1 
    INCREMENT BY 3
    NO CYCLE; 
--drop SEQUENCE newStudent_ID_Seq
--Insert 3 records in the table using the sequence.
INSERT INTO newStudent (ID, location)
VALUES 
    (NEXT VALUE FOR newStudent_ID_Seq, 'DS'),
    (NEXT VALUE FOR newStudent_ID_Seq, 'KW'),
    (NEXT VALUE FOR newStudent_ID_Seq, 'NY');
SELECT * from newStudent
--Delete the second row of the table.
DELETE FROM newStudent WHERE location = 'KW'
--Insert 2 other records using the sequence.
INSERT INTO newStudent (ID, location)
VALUES 
    (NEXT VALUE FOR newStudent_ID_Seq, 'KW'),
    (NEXT VALUE FOR newStudent_ID_Seq, 'DS');
--Can you insert another record without using the sequence? Try it!
INSERT INTO newStudent (ID, location)
VALUES 
    (2, 'KW')
--Can you do the same if it was an identity column?
--yes, the db will generate one
INSERT INTO newStudent (location)
VALUES 
    ('KW')
--Can you edit the value if the ID column in any of the inserted records? Try it!
UPDATE newStudent
SET location = 'LA'
WHERE ID = 1
--Can you do the same if it was an identity column? No, there is a workaround but generally no
--Can you use the same sequence to insert in another table?
CREATE TABLE test_sequence (
    ID INT NOT NULL,
    College VARCHAR(20) NOT NULL
)
INSERT INTO test_sequence (ID, College)
VALUES 
    (NEXT VALUE FOR newStudent_ID_Seq, 'Engineering'),
    (NEXT VALUE FOR newStudent_ID_Seq, 'Medicine')