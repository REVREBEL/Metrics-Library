CREATE OR REPLACE VIEW `aparium-dataflow.DemandData.DemandData_SegmentV` AS
SELECT *
FROM `aparium-dataflow.BookingData.DemandData_Segment`
WHERE stay_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1095 DAY)
  AND property_code IS NOT NULL
  AND stay_date IS NOT NULL