--Create an new user name is Trainer
CREATE USER Trainer
  IDENTIFIED BY Syntel123;
  
--Create an new user name is Trainer1
CREATE USER Trainer1
  IDENTIFIED BY Syntel123;

--Change the password of user Trainer  
ALTER USER Trainer IDENTIFIED BY Password123;

--Drop only User from DB 
DROP USER Trainer1;

--Drop User from DB and along with all objects created under that schema
DROP USER Trainer CASCADE;

--Create an new user name is Trainer
CREATE USER Trainer IDENTIFIED BY Syntel123;
  
--Trainer have SELECT, INSERT, UPDATE, DELETE privileges on training.employees table
GRANT SELECT, INSERT, UPDATE, DELETE ON training.employees TO Trainer;

--Trainer have all privileges on training.employees table
GRANT ALL ON training.departments TO Trainer;

--Apply only SELECT privilege on training.jobs table for All the Users
GRANT SELECT ON training.jobs TO public;

--Trainer get administrator privileges
GRANT DBA TO Trainer;

--Trainer dont have privilege to delete records from training.employees
REVOKE DELETE ON training.employees FROM Trainer;

--Trainer dont have privilege to delete records from training.employees
REVOKE SELECT ON training.jobs FROM public;

--Trainer lost administrator priviledge 
REVOKE DBA FROM Trainer;

--Trainer can login
GRANT CREATE SESSION TO Trainer;

--Trainer get administrator privileges
GRANT DBA TO Trainer;

--Trainer can login
GRANT CREATE SESSION TO Trainer;--Trainer can create table
GRANT CREATE TABLE  TO Trainer;
--Trainer can create view
GRANT CREATE VIEW TO Trainer;
--Trainer can create trigger
GRANT CREATE ANY TRIGGER TO Trainer;
--Trainer can create procedure
GRANT CREATE ANY PROCEDURE TO Trainer;
--Trainer can create sequence
GRANT CREATE SEQUENCE TO Trainer;
--Trainer can create synonym
GRANT CREATE SYNONYM TO Trainer;

-- Execute This Query at end of the session
Drop User Trainer CASCADE;