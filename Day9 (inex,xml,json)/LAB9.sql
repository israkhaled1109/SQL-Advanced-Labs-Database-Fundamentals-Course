/*Part1:Index   
Use Company_SD*/

--Create an index on column (Hiredate) that allow u to cluster the data in the table Department. What will happen?  
--cannot create one unless we dropped the one on the PK
CREATE Clustered INDEX DeptDate
ON Departments([MGRStart Date])

--Create an index that allows you to enter unique ages in the student table. What will happen?
--cannot be created because of the duplicate values
CREATE UNIQUE INDEX UniqueAges
ON Student(St_Age)  

--Create a non-clustered index on column(Dept_Manager) that allows you to enter a unique instructor id in the table Department. 

/*ALTER TABLE Instructor
ADD CONSTRAINT Dept_Manager
FOREIGN KEY (ins_id)
REFERENCES Department(Dept_Manager);*/

CREATE UNIQUE NONCLUSTERED INDEX UniqueInstructor 
ON Department(Dept_Manager)


--Part 2: XML in SQL Server
/* Consider the following XML data representing sales:
Write a query to extract and display all sales from the above XML.
Write a query to extract the total sales amount from the above XML.*/


DECLARE @sales XML =
'<sales>
    <sale>
        <saleID>1</saleID>
        <saleDate>2023-01-01</saleDate>
        <region>North</region>
        <product>ProductA</product>
        <amount>100.00</amount>
    </sale>
    <sale>
        <saleID>2</saleID>
        <saleDate>2023-01-02</saleDate>
        <region>South</region>
        <product>ProductB</product>
        <amount>200.00</amount>
    </sale>
    <!-- More sales -->
</sales>'

declare @hsales INT  
Exec sp_xml_preparedocument @hsales output, @sales

SELECT * 
FROM OPENXML (@hsales, '//sales/sale') 
WITH (
    saleID INT 'saleID',
    saleDate DATE 'saleDate',
    region VARCHAR(10) 'region', 
    product VARCHAR(10) 'product',
    amount FLOAT 'amount'
);

SELECT sum(amount) as total_amount
FROM OPENXML (@hsales, '//sales/sale') 
WITH (
    amount FLOAT 'amount'
);
Exec sp_xml_removedocument @hsales


/* Part 3: JSON in SQL Server
Consider the following JSON data representing sales:
Write a query to extract and display all sales from the above JSON.
Write a query to extract the total sales amount from the above JSON. */
ALTER DATABASE iti_New  
SET COMPATIBILITY_LEVEL = 150;

DECLARE @json NVARCHAR(2048) = 
'{
    "sales": [
        {
            "saleID": 1,
            "saleDate": "2023-01-01",
            "region": "North",
            "product": "ProductA",
            "amount": 100.00
        },
        {
            "saleID": 2,
            "saleDate": "2023-01-02",
            "region": "South",
            "product": "ProductB",
            "amount": 200.00
        }
    ]
}'

SELECT * FROM OPENJSON(@json,'$.sales')
WITH (
    saleID INT '$.saleID',
    saleDate DATE '$.saleDate',
    region VARCHAR(50) '$.region',
    product NVARCHAR(50) '$.product',
    amount FLOAT '$.amount'
) 



