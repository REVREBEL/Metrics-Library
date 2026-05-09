CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_Segment_GroupV` AS
WITH max_snapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS max_snapshot_date
  FROM `aparium-dataflow.PaceData.PaceData_Segment`
  WHERE segment_group = "Group"
  GROUP BY property_code
),
filtered_data AS (
  SELECT *
  FROM `aparium-dataflow.PaceData.PaceData_Segment`
  WHERE segment_group = "Group"
),
PropertyCapacity AS (
  SELECT
    property_code,
    stay_date,
    MAX(physical_capacity_cy) AS physical_capacity_cy
  FROM `aparium-dataflow.PaceData.PaceData_Property`
  GROUP BY property_code, stay_date
)

SELECT
  f.*,
  p.physical_capacity_cy
FROM filtered_data f
JOIN max_snapshot m
  ON f.property_code = m.property_code
  AND f.snapshot_date = m.max_snapshot_date
LEFT JOIN PropertyCapacity p
  ON f.property_code = p.property_code
  AND f.stay_date = p.stay_date
  
--WHERE f.stay_date BETWEEN "2025-03-01" AND "2025-03-31"
--  AND f.property_code = "DTWDFH";

--SELECT DISTINCT segment
--FROM `aparium-dataflow.PaceData.PaceData_Segment`
--ORDER BY segment