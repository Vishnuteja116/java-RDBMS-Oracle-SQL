--Table created without primary key column
CREATE TABLE customers
( customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50)
);

--Table created with primary key column
CREATE TABLE customers1
( customer_id number(10) NOT NULL,
  customer_name varchar2(50) NOT NULL,
  city varchar2(50),
  CONSTRAINT customers_pk PRIMARY KEY (customer_id)
);

--Employeebackup table has been created and copied all the records from employeebackup table
CREATE TABLE employeesbackup AS (SELECT * FROM training.employees);

--Employeebackup1 table has been created with selected colunms and copied selected records from employeebackup table
CREATE TABLE employeebackup1
  AS (SELECT employee_id, first_name,last_name, salary FROM training.employees WHERE employee_id < 100);

--Customer_name column has been added
ALTER TABLE employeesbackup  ADD customer_name varchar2(45);

--Customer_name,city  columns have been added
ALTER TABLE employeebackup1  ADD (customer_name varchar2(45),city varchar2(40));

--customer_name column of employeebackup1 table has been modified
ALTER TABLE employeebackup  MODIFY customer_name varchar2(100) not null;

--customer_name,city columns of employeebackup1 table have been modified
ALTER TABLE employeebackup1 MODIFY (customer_name varchar2(100) not null,city varchar2(75));

--remove customer_name column from employeebackup table
ALTER TABLE employeesbackup  DROP COLUMN customer_name;

--Column name has been changed from customer_name with cname
ALTER TABLE employeebackup1 RENAME COLUMN customer_name to cname;

--Table name name has been changed from employeebackup to employeesbackuptemp
ALTER TABLE employeesbackup  RENAME TO employeesbackuptemp;

--table has been removed
DROP TABLE employeesbackuptemp;

--table has been removed without store it in recycle bin so it cannot be recovered
DROP TABLE employeebackup1 PURGE;

CREATE TABLE employeebackup1
  AS (SELECT employee_id, first_name,last_name, salary FROM training.employees WHERE employee_id < 100);

--New record (Row) has been inserted
INSERT INTO employeebackup1 (employee_id,first_name,last_name, salary) VALUES (601, 'Jhon','steve','');
commit;

--selected rows from training.employee table are inserted into employeebackup1 table 
INSERT INTO employeebackup1 (employee_id,first_name,last_name, salary)
SELECT employee_id,first_name,last_name, salary FROM training.employees WHERE employee_id >150;
commit;

--Three rows are inserted using single query
INSERT ALL
  INTO employeebackup1 (employee_id,first_name,last_name, salary) VALUES (602, 'IBM','IT','')
  INTO employeebackup1 (employee_id,first_name,last_name, salary) VALUES (603, 'Microsoft','IT','')
  INTO employeebackup1 (employee_id,first_name,last_name, salary) VALUES (604, 'Google','IT','')
SELECT * FROM dual;
commit;

--Check the rows inserted in the employeebackup1
select * from employeebackup1;

--update the first name of the employee whose employee id is 602
UPDATE employeebackup1 SET first_name = 'Anderson' WHERE employee_id = 602;
commit;

--update the last name and salary of the employee whose employee id is 604
UPDATE employeebackup1 SET salary =50000, Last_name ='Anderson' WHERE employee_id =604;
commit;

--check the new values of employeebackup1 table
SELECT * FROM employeebackup1 WHERE employee_id in (602,604);

--delete employee's records from employeebackup1 table whose name is Anderson
DELETE FROM employeebackup1 WHERE last_name = 'Anderson';
commit;
--count the number of employees whose name is Anderson 
SELECT count(*) FROM employeebackup1 WHERE last_name = 'Anderson';


--Supplier table has been created with constraints
Create table supplier(
  supplier_id numeric(10) not null,
  supplier_name varchar2(50) not null,
  contact_name varchar2(50),
  --supplier_id should be unique and no null value
  CONSTRAINT supplier_pk PRIMARY KEY (supplier_id),
  --supplier_name should be unique and accept only one null value
  CONSTRAINT supplier_uq UNIQUE (supplier_name),
  --contact_name should begin with SN% 
  CONSTRAINT supplier_ck check (contact_name like ('SN:%'))
)

--Products table has been created with constraints
CREATE TABLE products
( 
  --column level constraints are created here
  product_id numeric(10) primary key,
  supplier_id numeric(10) not null,
  --table level constraints are created here
  --suppier_ids those are present in the supplier table, only they can be inserted in the supplier_id of products table
  CONSTRAINT fk_supplier   FOREIGN KEY (supplier_id)   REFERENCES supplier(supplier_id)
);

--insert successfully
insert into supplier values (101,'ABC','SN:12345');
--insert successfully
insert into supplier values (102,'ABCD','SN:12346');
--insert successfully
insert into supplier values (103,'XY','SN:12347');
--insert successfully
insert into supplier values (104,'XYZ','SN:12348');
--insert failure because duplicate suppier id
insert into supplier values (101,'E','SN:12349');
--insert failure because duplicate suppier name
insert into supplier values (105,'F','SN:12349');
--insert failure because contact name should begin SN:
insert into supplier values (106,'G','SF:12350');
--insert successfully
insert into supplier values (107,'KN','SN:12347');
--insert successfully
insert into supplier values (108,'KNM','SN:12347');
--insert successfully
insert into supplier values (109,'LMN','SN:12347');
commit;
--Check the records from Supplier
select * from supplier;

--insert successfully
insert into products values (1001,101);
--insert successfully
insert into products values (1002,101);
--insert successfully
insert into products values (1003,102);
--insert failure because supplier id 107 does exist in the supplier id column (parent table column) of supplier table
insert into products values (1004,107);
--insert successfully
insert into products values (1005,103);
--insert successfully
insert into products values (1006,103);
commit;
--Check the records
select * from products;
--this can be deleted because child table products does not have this supplier id 105
delete from supplier where supplier_id=105;
select * from supplier;
--this cannot be deleted because child table products have this supplier id 102
delete from supplier where supplier_id=102;
select * from supplier;

--remove constraints from table
ALTER TABLE products
DROP CONSTRAINT fk_supplier;

--add constraints to table and delete cascase can delete records from both parent and child
ALTER TABLE products
ADD CONSTRAINT fk_supplier   FOREIGN KEY (supplier_id)   REFERENCES supplier(supplier_id)
ON DELETE CASCADE;

--this can delete records from both supplier and products table becasue of on DELETE CASCADE
delete from supplier where supplier_id=102;
commit;
--check records after delete
select * from supplier;
select * from products;

--remove constraint from Table
ALTER TABLE products
DROP CONSTRAINT fk_supplier;

--Add Constraints to Table
ALTER TABLE products
ADD CONSTRAINT fk_supplier   FOREIGN KEY (supplier_id)   REFERENCES supplier(supplier_id)
ON DELETE SET NULL;

--Modify column 
ALTER TABLE products MODIFY supplier_id numeric(10) NULL;

--this can delete records only from supplier and products table set with NULL values to corresponding supplier id column
delete from supplier where supplier_id=101;
commit;
--check record after delete
select * from supplier;
select * from products;

--Disable constraints
ALTER TABLE products
DISABLE CONSTRAINT fk_supplier;

--Enable constraints
ALTER TABLE products
ENABLE CONSTRAINT fk_supplier;

--Fetch all rows and columns from Supplier table
SELECT * FROM supplier
--Fetch all rows and columns from Products table
SELECT * FROM products

--Fetch all rows and supplier_id,supplier_name columns from supplier table
SELECT supplier_id,supplier_name FROM supplier

--Fetch if row match the condition and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_id=101;
SELECT supplier_id,supplier_name from supplier where supplier_id=103;

--Fetch rows those have supplier name is null and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_name is null;
--Fetch rows those have supplier name is not null and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_name is not null;

--Fetch rows those are having supplier ids 101,102,103,104 and supplier_id,supplier_name columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_id in (101,102,103,104);

--Fetch rows those are not having supplier ids 101,102,103,104 and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_id in (101,102,103,104);

--Fetch rows those are having supplier ids from 101 to 104 and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_id between 101 and 104;

--Fetch rows those are not having supplier ids from 101 to 104 and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_id not between 101 and 104;

--Fetch rows their supplier_names begin with K and supplier_id,supplier_nam columns from supplier table
SELECT supplier_id,supplier_name from supplier where supplier_name like 'K%';

--Fetch rows their supplier_names do not begin with K and supplier_id,supplier_nam columns from Products table
SELECT supplier_id,supplier_name from supplier where supplier_name not like 'K%';

--Fetch rows their supplier_names end with N and supplier_id,supplier_nam columns from Products table
SELECT supplier_id,supplier_name from supplier where supplier_name like '%N';

--Fetch rows their supplier_names do not end with N and supplier_id,supplier_nam columns from Products table
SELECT supplier_id,supplier_name from supplier where supplier_name not like '%N';

--Fetch rows their supplier_names start with K and end with N supplier_id,supplier_nam columns from Products table
SELECT supplier_id,supplier_name from supplier where supplier_name like 'K%N';

--Fetch rows their supplier_names have three letters and middle letters N and supplier_id,supplier_nam columns from Products table
SELECT supplier_id,supplier_name from supplier where supplier_name like '_N_';

--Fetch supplier ids from products table without duplications.
SELECT distinct supplier_id from products;

--Fetch rows those are not having supplier ids 101,102,103,104 and 
--supplier_id,supplier_nam columns from supplier table and order them by name
SELECT supplier_id,supplier_name from supplier where supplier_id between 101 and 107 order by supplier_name;

--Fetch rows those are not having supplier ids 101,102,103,104 and 
--supplier_id,supplier_nam columns from supplier table and order them by name descending 
SELECT supplier_id,supplier_name from supplier where supplier_id between 101 and 107 order by supplier_name desc;

--Fetch rows from products table and order them product_id 
--by ascending order, supplier_id by discending order
SELECT supplier_id,supplier_name from supplier where supplier_id between 101 and 107 order by supplier_name desc;

--Aggregate functions
select count(supplier_id) from supplier;
select max(supplier_id) from supplier;
select min(supplier_id) from supplier;
select avg(supplier_id) from supplier;
select sum(supplier_id) from supplier;

--display how many products each suppliers supply
select supplier_id,count(product_id) from products group by supplier_id;

--display how many suppliers supply more than two products
select supplier_id,count(product_id) from products group by supplier_id having count(product_id)>=3;

--Join suppier and products table to fetch Supplier Id, Supplier Name and Product ID supplied by them
select s.supplier_id,s.supplier_name,p.product_id from supplier s join products p on s.supplier_id=p.supplier_id;

--Display all rows from Supplier and only matching rows from product
select s.supplier_id,s.supplier_name,p.product_id from supplier s left outer join products p on s.supplier_id=p.supplier_id;

--Display only matching rows from Supplier and all rows from Supplier
select s.supplier_id,s.supplier_name,p.product_id from supplier s right outer join products p on s.supplier_id=p.supplier_id;


--Display all frows from both Products and supplier tables
select s.supplier_id,s.supplier_name,p.product_id from supplier s full outer join products p on s.supplier_id=p.supplier_id;

--copy records into suppiertemp table
create table suppliertemp as select * from supplier where supplier_id between 101 and 108;

--insert successfully
insert into supplier values (110,'LMNK','SN:12348');
--insert successfully
insert into supplier values (111,'LNK','SN:12349');

--display same records exist in the supplier and suppliertemp tables
select supplier_id,supplier_name from supplier 
intersect 
select supplier_id,supplier_name from suppliertemp

--display records only exist in the supplier and does not exist in the suppliertemp table
select supplier_id,supplier_name from supplier 
minus 
select supplier_id,supplier_name from suppliertemp

--display all records exist in the supplier and suppliertemp tables without duplication
select supplier_id,supplier_name from supplier 
union 
select supplier_id,supplier_name from suppliertemp;


--display all records exist in the supplier and suppliertemp tables with duplication
select supplier_id,supplier_name from supplier 
union all
select supplier_id,supplier_name from suppliertemp;

--display prodcuts ids supplied by supplier name is C
select supplier_id,product_id from products where supplier_id=(select supplier_id from supplier where supplier_name='C');

insert into products values (1010,104);
commit;
--display prodcuts ids supplied by supplier name is C,D Multi Rows Sub Query 
select supplier_id,product_id from products where supplier_id in(select supplier_id from supplier where supplier_name in ('C','D'));

--display prodcuts ids supplied by supplier name is C,D Multi column Sub Query
select supplier_id,product_id from products where (supplier_id,product_id) in(select 
supplier_id,product_id from supplier where supplier_name in ('C','D'));

--Dual is a temporaty table
select sysdate from dual;
--Convertion Functions
select to_char(sysdate,'YYYY-MM-DD') from dual;
select to_date('2017-03-29','YYYY-MM-DD') from dual;

--Numeric Functions
Select ABS(1) from DUAL;
Select ABS(-1)from DUAL;
Select CEIL(2.83) from DUAL;
Select CEIL(2.49) from DUAL;
Select CEIL(-1.6)from DUAL;
Select FLOOR(2.83) from DUAL;
Select FLOOR(2.49) from DUAL;
Select FLOOR(-1.6)from DUAL;
Select ROUND(125.456, 1) from DUAL;
Select ROUND(125.456, 0) from DUAL;
Select ROUND(124.456, -1)from DUAL;
Select TRUNC(140.234, 2) from DUAL;
Select TRUNC(-54, 1) from DUAL;
Select TRUNC(5.7) from DUAL;
Select TRUNC(142, -1)from DUAL;

--Varchar(String) Functions
Select LOWER('Good Morning') from DUAL;
Select UPPER('Good Morning') from DUAL;
Select INITCAP('GOOD MORNING') from DUAL;
Select LTRIM ('Good Morning', 'Good') from DUAL;
Select RTRIM ('Good Morning', ' Morning') from DUAL;
Select TRIM ('o' FROM 'Good Morning')from DUAL;
Select SUBSTR ('Good Morning', 6, 7) from DUAL;
Select LENGTH ('Good Morning') from DUAL;
Select LPAD ('Good', 6, '*') from DUAL;
Select RPAD ('Good', 6, '*')from DUAL;

--Date Functions Functions
Select ADD_MONTHS ('16-Sep-81', 3) from DUAL;
Select MONTHS_BETWEEN ('16-Sep-81', '16-Dec-81') from DUAL;
Select NEXT_DAY ('01-Jun-08', 'Wednesday') from DUAL;
Select LAST_DAY ('01-Jun-08')from DUAL;



CREATE TABLE employee10
( employee_id number(10) NOT NULL,
  employee_name varchar2(50) NOT NULL,
  city varchar2(50)
);
select * from employee10;

CREATE TABLE employee11
( employee_id number(10) NOT NULL,
  employee_name varchar2(50) NOT NULL,
  city varchar2(50),
  CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);

INSERT ALL
  INTO employee10 (employee_id,employee_name,city) VALUES (602, 'megha','patna')
  INTO employee10 (employee_id,employee_name,city) VALUES (603, 'dhana','bangalore')
  INTO employee10 (employee_id,employee_name,city) VALUES (604, 'likhita','hydrabad')
SELECT * FROM dual;
commit;

INSERT ALL
  INTO employee11 (employee_id,employee_name,city) VALUES (602, 'megha','patna')
  INTO employee11 (employee_id,employee_name,city) VALUES (603, 'dhana','bangalore')
  INTO employee11 (employee_id,employee_name,city) VALUES (604, 'likhita','hydrabad')
SELECT * FROM dual;
commit;


--Disable constraints
ALTER TABLE employee11
DISABLE CONSTRAINT employee_pk;

--Enable constraints
ALTER TABLE employee11
ENABLE CONSTRAINT employee_pk;

select e.employee_id,e.employee_name,e.city from employee10 e join employee11 e1 on e1.employee_id=e.employee_id;

select e.employee_id,e.employee_name,e.city from employee10 e left outer join employee11 e1 on e1.employee_id=e.employee_id;
select e.employee_id,e.employee_name,e.city from employee10 e right outer join employee11 e1 on e1.employee_id=e.employee_id;
select e.employee_id,e.employee_name,e.city from employee10 e full outer join employee11 e1 on e1.employee_id=e.employee_id;
--Display all rows from Supplier and only matching rows from product
select s.supplier_id,s.supplier_name,p.product_id from supplier s left outer join products p on s.supplier_id=p.supplier_id;

--Display only matching rows from Supplier and all rows from Supplier
select s.supplier_id,s.supplier_name,p.product_id from supplier s right outer join products p on s.supplier_id=p.supplier_id;


--Display all frows from both Products and supplier tables
select s.supplier_id,s.supplier_name,p.product_id from supplier s full outer join products p on s.supplier_id=p.supplier_id;

--copy records into suppiertemp table









