use birdstrikes;
show tables;
describe birdstrikes.birdstrikes;

-- Copy table
CREATE TABLE new_birdstrikes LIKE birdstrikes;
SHOW TABLES;
DESCRIBE new_birdstrikes;
SELECT * FROM new_birdstrikes;
-- Delete table
DROP TABLE IF EXISTS new_birdstrikes;

-- Create table
CREATE TABLE employee (id INTEGER NOT NULL, employee_name VARCHAR(255) NOT NULL, PRIMARY KEY(id));
DESCRIBE employee;
SELECT * FROM employee;
describe employee;
-- Insert new rows (records)
SELECT * FROM employee;

INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
SELECT * FROM employee;
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
SELECT * FROM employee;
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');
SELECT * FROM employee;



INSERT INTO employee (id,employee_name) 
VALUES(3,'Student4');

-- Updating rows

UPDATE employee SET employee_name='Arnold Schwarzenegger' WHERE id = '1';
UPDATE employee SET employee_name='The Other Arnold' WHERE id = '2';
SELECT * FROM employee;

-- Deleting rows
DELETE FROM employee WHERE id = 3;
SELECT * FROM employee

-- Deleting rows
SELECT * FROM employee --  check it out here everything
TRUNCATE employee;
SELECT * FROM employee

-- Create a new column
show tables;
describe birdstrikes;

SELECT *, speed/2 FROM birdstrikes;
SELECT *, speed/2 AS halfspeed FROM birdstrikes;

SELECT * FROM birdstrikes LIMIT 10;
SELECT * FROM birdstrikes LIMIT 10,1;





-- Exercise1
-- What state figures in the 145th line of our database?
SELECT * FROM birdstrikes LIMIT 145;
SELECT * FROM birdstrikes LIMIT 144,1;

-- Exercise2
-- What is flight_date of the latest birstrike in this database?
SELECT flight_date FROM birdstrikes ORDER BY flight_date DESC;
SELECT distinct flight_date FROM birdstrikes ORDER BY flight_date DESC;

-- Exercise3
-- What was the cost of the 50th most expensive damage?
select distinct cost from birdstrikes order by cost Limit 49,1;
select distinct cost from birdstrikes order by cost Limit 50; -- last element

-- Exercise4
-- What state figures in the 2nd record, 
-- if you filter out all records which have no state and no bird_size specified?
select * from birdstrikes where state is not null and bird_size is not null;

-- Exercise5
-- How many days elapsed between the current date and the flights happening in week 52, 
-- for incidents from Colorado? (Hint: use NOW, DATEDIFF, WEEKOFYEAR)
select DATEDIFF(NOW(),flight_date) from birdstrikes Where WEEKOFYEAR(flight_date)=52 and state='Colorado';



select week(birdstrikes.flight_date) from birdstrikes;

select datediff(now(), flight_date) from birdstrikes 
where week(birdstrikes.flight_date) = 15
and birdstrikes.state like "Colorado";
order by flight_date 
limit 0,1;

select datediff(now(), flight_date) from birdstrikes where state= "Colorado";






