CREATE OR REPLACE VIEW `aparium-dataflow.DemandData.DemandData_ChannelV` AS
SELECT *
FROM `aparium-dataflow.DemandData.DemandData_Channel`
WHERE stay_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1095 DAY)
  AND property_code IS NOT NULL
  AND stay_date IS NOT NULL