USE airline_company_DB;

CREATE TABLE airline (
    c_number int,
    a_id int NOT NULL,
    PRIMARY KEY (a_id),
    address VARCHAR (100)
);

create TABLE employees (
    e_id int PRIMARY KEY, 
    name VARCHAR(50), 
    emp_address VARCHAR(50), 
    gender VARCHAR(10), 
    position VARCHAR (20), 
    year int, 
    month int, 
    day int, 
    a_id int
    FOREIGN KEY (a_id) REFERENCES airline (a_id)
);


create TABLE employee_qual (
    e_id int,
    FOREIGN KEY (e_id) REFERENCES employees(e_id),
    qual VARCHAR(100)
    PRIMARY KEY (e_id,qual)
    --with the help of Column EMP_ID and DEPT_ID
);


create TABLE airline_phone (
    a_id int 
    FOREIGN KEY (a_id) REFERENCES airline(a_id),
    phone_num int
    PRIMARY KEY (a_id,phone_num)
);

create TABLE aircraft (
    ac_id int PRIMARY KEY,
    capacity VARCHAR(50),
    model VARCHAR(20),
    a_id int 
    FOREIGN KEY (a_id) REFERENCES airline(a_id),
    major VARCHAR(50),
    assistant VARCHAR (50),
    hostess1 VARCHAR (20),
    hostess2 VARCHAR (20)
);

create TABLE routes (
    dist_class int,
    or_dist VARCHAR(50),
    r_id int PRIMARY KEY
);

create table a_transaction (
    a_id int,
    t_id int,
    date date,
    t_desc VARCHAR(50),
    money int,
    PRIMARY KEY (a_id,t_id)
);

create table assign (
    ac_id int,
    r_id int,
    pass int,
    price int, 
    a_date date,
    d_date date,
    timing TIME
    PRIMARY KEY (ac_id,r_id)
);

