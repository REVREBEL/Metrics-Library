CREATE OR REPLACE VIEW `aparium-dataflow.DemandData.DemandData_PropertyV` AS
  SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY stay_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.DemandData.DemandData_Property`
)
WHERE rn = 1;


CREATE OR REPLACE VIEW `aparium-dataflow.DemandData.DemandData_SegmentV` AS
  SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY stay_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.DemandData.DemandData_Segment`
)
WHERE rn = 1;


CREATE OR REPLACE VIEW `aparium-dataflow.DemandData.DemandData_ChannelV` AS
  SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY stay_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.DemandData.DemandData_Channel`
)
WHERE rn = 1