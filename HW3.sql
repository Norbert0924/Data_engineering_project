-- 05.10.2020 3.Class   
  
  CREATE SCHEMA birdstrikes;
USE birdstrikes;
CREATE TABLE birdstrikes 
(id INTEGER NOT NULL,
aircraft VARCHAR(32),
flight_date DATE NOT NULL,
damage VARCHAR(16) NOT NULL,
airline VARCHAR(255) NOT NULL,
state VARCHAR(255),
phase_of_flight VARCHAR(32),
reported_date DATE,
bird_size VARCHAR(16),
cost INTEGER NOT NULL,
speed INTEGER,PRIMARY KEY(id));


SHOW VARIABLES LIKE "secure_file_priv";
LOAD DATA INFILE 'C:/birdstrikesProgramData/MySQL/MySQL Server 8.0/Uploads/birdstrikes_small.csv'
INTO TABLE birdstrikes.birdstrikes
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 LINES 
(id, aircraft, flight_date, damage, airline, state, phase_of_flight, @v_reported_date, bird_size, cost, @v_speed)
SET
reported_date = nullif(@v_reported_date, ''),
speed = nullif(@v_speed, '');
  
  SELECT aircraft, airline, cost, 
    CASE 
        WHEN cost  = 0
            THEN 'NO COST'
        WHEN  cost >0 AND cost < 100000
            THEN 'MEDIUM COST'
        ELSE 
            'HIGH COST'
    END
    AS cost_category   
FROM  birdstrikes
ORDER BY cost_category;   

-- E1

select aircraft, airline, speed, If(speed is null, 'LOW SPEED', if(speed < 100, 'LOW SPEED', 'HIGH SPEED'
)) As speed_category from birdstrikes ORDER by speed_category;

-- E2
-- How many distinct 'aircraft' we have in the database?
SELECT count(distinct(aircraft)) from birdstrikes;

-- E3
-- What was the lowest speed of aircrafts starting with 'H'
select min(speed) as lowest_speed from birdstrikes where aircraft LIKE 'H%';

-- E4
-- Which phase_of_flight has the least of incidents?
select phase_of_flight, count(*) as count from birdstrikes group by phase_of_flight order by count;

-- E5
-- What is the rounded highest average cost by phase_of_flight?
select phase_of_flight, Round(avg(cost)) as avg_cost from birdstrikes group by phase_of_flight order by avg_cost DESC;

-- E6
-- What the highest AVG speed of the states with names less than 5 characters?
select phase_of_flight, round(avg(cost)) as avg_cost, MAX(cost) from birdstrikes group by
phase_of_flight order by avg_cost DESC;



