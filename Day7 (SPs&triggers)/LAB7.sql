--Create a stored procedure to show the number of students per department.[use ITI DB]
CREATE PROC StudentsNumber
AS 
SELECT count(St_Id) as count 
FROM Student 
GROUP BY Dept_Id

EXEC StudentsNumber

/*Create a stored procedure that will check for the number of employees in the project 100 if they are more than 3 
print a message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user 
“'The following employees work for the project 100'” in addition to the first name and last name of each one. [Company DB] */

CREATE PROC CheckProjectEmployees
AS
DECLARE @empCountP100 INT;
SELECT @empCountP100 = count(ESSN)
FROM Works_for
WHERE Pno = 100
    IF (@empCountP100 >= 3)
        BEGIN
        SELECT 'The number of employees in project 100 is 3 or more' AS Message;
        END
    ELSE
        BEGIN 
        SELECT 'The following employees work for project 100' AS Message;
        SELECT fname, lname
        FROM Employee
        JOIN Works_for ON ssn = ESSn
        WHERE pno = 100;
        END

EXEC CheckProjectEmployees


--With exist Try it 
/* Create a stored procedure that will be used in case there is an old employee has left the project and a new one become instead of him. 
The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_for table. 
[Company DB] */

CREATE PROCEDURE UpdateWorksFor
    @oldEmpNumber INT,
    @newEmpNumber INT,
    @projectNumber INT
AS
BEGIN
    UPDATE works_for
    SET ESSn = @newEmpNumber
    WHERE ESSn = @oldEmpNumber
    AND Pno = @projectNumber
END;


/*Create an Audit table with the following structure
This table will be used to audit the update trials on the Hours column (works_for table, Company DB)
Example:
If a user updated the Hours column then the project number, the user name that made that update, 
the date of the modification and the value of the old and the new Hours will be inserted into the Audit table
Note: This process will take place only if the user updated the Hours column */

CREATE TABLE Audit (
    project_number INT,
    user_name VARCHAR(50),
    modification_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    old_hours DECIMAL(10,2),
    new_hours DECIMAL(10,2)
)

CREATE TRIGGER AuditHoursUpdate
ON works_for
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Hours)
    BEGIN
        INSERT INTO Audit (project_number, user_name, old_hours, new_hours)
        SELECT i.Pno, SYSTEM_USER, d.Hours, i.Hours
        FROM inserted i
        INNER JOIN deleted d ON i.Pno = d.Pno;
    END
END;

UPDATE works_for
SET Hours = 200
WHERE pno = 300

select * from audit


/* Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
Print a message for the user to tell him that he ‘can’t insert a new record in that table’ */
CREATE OR ALTER TRIGGER PreventInsert
ON Department
INSTEAD OF INSERT
AS
BEGIN
    PRINT 'Insertion not allowed';
END;

INSERT INTO Department (dept_id, dept_name)
VALUES (100, 'SCI');


--Create a trigger that prevents the insertion Process for the Employee table in May and test it  [Company DB].
CREATE TRIGGER PreventMayInsertion
ON Employee
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @tdate INT;
    SET @tdate = MONTH(GETDATE());
    IF @tdate = 5 
    BEGIN
        RAISERROR('Insertion in May is not allowed.', 16, 1);
    END
END;





/* Create a trigger that prevents users from altering any table in Company DB.
16: error severity
1: error status */

CREATE OR ALTER TRIGGER PreventAlter
ON DATABASE
FOR ALTER_TABLE
AS
BEGIN
    RAISERROR('Altering tables is not allowed in the Company database.', 16, 1);
END;

/* Create a trigger on student table after insert to add Row in a Student Audit table 
(Server User Name, Date, Note) where the note will be “[username] Insert New Row with 
ID =[Key Value] in table [table name]” */

CREATE TABLE Student_Audit (
    Server_Username VARCHAR(100),
    Date DATETIME,
    Note VARCHAR(255)
);

CREATE OR ALTER TRIGGER InsertStudentAudit
ON student
AFTER INSERT
AS
BEGIN
    DECLARE @Username VARCHAR(100);
    SET @Username = SYSTEM_USER;

    DECLARE @TableName VARCHAR(100);
    SET @TableName = 'student';

    DECLARE @ID INT;
    SELECT @ID = inserted.st_id FROM inserted;

    DECLARE @Note VARCHAR(255);
    SET @Note = '[' + @Username + '] Insert New Row with ID = ' + CAST(@ID AS VARCHAR(10)) + ' in table [' + @TableName + ']';

    INSERT INTO Student_Audit (Server_Username, Date, Note)
    VALUES (@Username, GETDATE(), @Note);
END;

INSERT INTO student (st_id, st_Fname, St_Lname)
VALUES (123789,'Israa','Khaled');

select * from Student_Audit