

----------------------------------------------------
-- CREATE Pace_Segment View Transient + Group
----------------------------------------------------


----------------------------------------------------
-- TRANSIENT
----------------------------------------------------


CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentTransientV` AS
WITH max_snapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS max_snapshot_date
  FROM `devrebel-big-query-database.Pace.Pace_Segment`
  WHERE segment_group = "Transient"
  GROUP BY property_code
),
filtered_data AS (
  SELECT *
  FROM `devrebel-big-query-database.Pace.Pace_Segment`
  WHERE segment_group = "Transient"
),
PropertyCapacity AS (
  SELECT
    property_code,
    stay_date,
    MAX(physical_capacity) AS physical_capacity
  FROM `devrebel-big-query-database.Pace.Pace_Property`
  GROUP BY property_code, stay_date
)

SELECT
  f.*,
  p.physical_capacity
FROM filtered_data f
JOIN max_snapshot m
  ON f.property_code = m.property_code
  AND f.snapshot_date = m.max_snapshot_date
LEFT JOIN PropertyCapacity p
  ON f.property_code = p.property_code
  AND f.stay_date = p.stay_date;
  
--WHERE f.stay_date BETWEEN "2025-03-01" AND "2025-03-31"
--  AND f.property_code = "DTWDFH";

--SELECT DISTINCT segment
--FROM `devrebel-big-query-database.Pace.Pace_Segment`
--ORDER BY segment



----------------------------------------------------
-- GROUP
----------------------------------------------------


CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentGroupV` AS
WITH max_snapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS max_snapshot_date
  FROM `devrebel-big-query-database.Pace.Pace_Segment`
  WHERE segment_group = "Group"
  GROUP BY property_code
),
filtered_data AS (
  SELECT *
  FROM `devrebel-big-query-database.Pace.Pace_Segment`
  WHERE segment_group = "Group"
),
PropertyCapacity AS (
  SELECT
    property_code,
    stay_date,
    MAX(physical_capacity) AS physical_capacity
  FROM `devrebel-big-query-database.Pace.Pace_Property`
  GROUP BY property_code, stay_date
)

SELECT
  f.*,
  p.physical_capacity
FROM filtered_data f
JOIN max_snapshot m
  ON f.property_code = m.property_code
  AND f.snapshot_date = m.max_snapshot_date
LEFT JOIN PropertyCapacity p
  ON f.property_code = p.property_code
  AND f.stay_date = p.stay_date;
  
--WHERE f.stay_date BETWEEN "2025-03-01" AND "2025-03-31"
--  AND f.property_code = "DTWDFH";

--SELECT DISTINCT segment
--FROM `devrebel-big-query-database.Pace.PaceData_Segment`
--ORDER BY segment