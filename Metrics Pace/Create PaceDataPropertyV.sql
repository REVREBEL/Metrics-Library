CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_PropertyV` AS
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY stay_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.PaceData.PaceData_Property`
)
WHERE rn = 1