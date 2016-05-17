-- ***************************************************************************
-- Loading Data:
-- create external table mapping for events.csv and mortality_events.csv

-- ***************************************************************************
-- create events table
DROP TABLE IF EXISTS events;
CREATE EXTERNAL TABLE events (
  patient_id STRING,
  event_id STRING,
  event_description STRING,
  time DATE,
  value DOUBLE)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/events';

-- create mortality events table
DROP TABLE IF EXISTS mortality;
CREATE EXTERNAL TABLE mortality (
  patient_id STRING,
  time DATE,
  label INT)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/input/mortality';

-- ******************************************************
-- Task 1:
-- By manipulating the above two tables,
-- generate two views for alive and dead patients' events
-- ******************************************************
-- find events for alive patients
DROP VIEW IF EXISTS alive_events;
CREATE VIEW alive_events
AS
SELECT events.patient_id, events.event_id, events.time

FROM events Left JOIN mortality ON (events.patient_id=mortality.patient_id)
WHERE mortality.patient_id is null;





-- find events for dead patients
DROP VIEW IF EXISTS dead_events;
CREATE VIEW dead_events
AS
SELECT events.patient_id, events.event_id, events.time

FROM events INNER JOIN mortality ON events.patient_id=mortality.patient_id;






-- ************************************************
-- Task 2: Event count metrics
-- Compute average, min and max of event counts
-- for alive and dead patients respectively
-- ************************************************
-- alive patients
SELECT avg(a.event_count), min(a.event_count), max(a.event_count)

FROM (SELECT COUNT(*) AS event_count FROM alive_events GROUP BY patient_id) a;




-- dead patients
SELECT avg(a.event_count), min(a.event_count), max(a.event_count)
-- ***** your code below *****
FROM (SELECT COUNT(*) AS event_count FROM dead_events GROUP BY patient_id) a;





-- ************************************************
-- Task 3: Encounter count metrics
-- Compute average, min and max of encounter counts
-- for alive and dead patients respectively
-- ************************************************
-- alive
SELECT avg(a.encounter_count), min(a.encounter_count), max(a.encounter_count)

FROM(SELECT COUNT(DISTINCT time) as encounter_count FROM alive_events GROUP BY patient_id) a;




-- dead
SELECT avg(a.encounter_count), min(a.encounter_count), max(a.encounter_count)

FROM(SELECT COUNT(*) as encounter_count FROM (SELECT DISTINCT time, patient_id FROM dead_events) b  GROUP BY patient_id) a;






-- ************************************************
-- Task 4: Record length metrics
-- Compute average, min and max of record lengths
-- for alive and dead patients respectively
-- ************************************************
-- alive
SELECT avg(record_length), min(record_length), max(record_length)

FROM(SELECT datediff(max(time),MIN(time)) AS record_length FROM alive_events GROUP BY patient_id) a;




-- dead
SELECT avg(record_length), min(record_length), max(record_length)

FROM(SELECT datediff(max(time),MIN(time)) AS record_length FROM dead_events GROUP BY patient_id) a;







-- *******************************************
-- Task 5: Common diag/lab/med
-- Compute the 5 most frequently occurring diag/lab/med
-- for alive and dead patients respectively
-- *******************************************
-- alive patients
---- diag
SELECT * FROM
(SELECT event_id, count(*) AS diag_count
FROM alive_events

WHERE event_id LIKE 'DIAG%' Group by event_id) a SORT BY diag_count DESC LIMIT 5;

---- lab
SELECT * FROM
(SELECT event_id, count(*) AS lab_count
FROM alive_events

WHERE event_id LIKE 'LAB%' Group by event_id) a SORT BY lab_count DESC LIMIT 5;

---- med
SELECT * FROM
(SELECT event_id, count(*) AS med_count
FROM alive_events

WHERE event_id LIKE 'DRUG%' Group by event_id) a SORT BY  med_count DESC LIMIT 5;



-- dead patients
---- diag
SELECT * FROM
(SELECT event_id, count(*) AS diag_count
FROM dead_events

WHERE event_id LIKE 'DIAG%' Group by event_id) a  SORT BY diag_count DESC LIMIT 5;

---- lab
SELECT * FROM
(SELECT event_id, count(*) AS lab_count
FROM dead_events

WHERE event_id LIKE 'LAB%' Group by event_id) a SORT BY lab_count DESC LIMIT 5;

---- med
SELECT * FROM
(SELECT event_id, count(*) AS med_count
FROM dead_events

WHERE event_id LIKE 'DRUG%' Group by event_id) a SORT BY med_count DESC LIMIT 5;
