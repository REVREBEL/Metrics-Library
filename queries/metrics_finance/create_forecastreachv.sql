CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.ForecastReachV` AS
WITH
  LatestPaceData AS (
  SELECT
    property_code,
    stay_date,
    rev_cy,
    rms_cy,
    ROW_NUMBER() OVER (PARTITION BY property_code, stay_date ORDER BY snapshot_date DESC ) AS rn
  FROM
    `aparium-dataflow.PaceData.PaceData_Property` )
SELECT
  f.property_code,
  f.stay_date,
  -- Columns from DailyBudgetMajorSegmentV
  f.rooms_revenue AS forecast_rev,
  f.available_rooms AS forecast_available_rms,
  f.rooms_sold AS forecast_rms,
  -- Latest Snapshot of rev_cy from PaceData_Property
  p.rev_cy AS otb_rev,
  p.rms_cy AS otb_rms
FROM
  `aparium-dataflow.FinanceData.DailyForecastMajorSegmentV` f
LEFT JOIN
  LatestPaceData p
ON
  f.property_code = p.property_code
  AND f.stay_date = p.stay_date
  AND p.rn = 1;  -- Ensures only the latest snapshot per property + stay_date is used