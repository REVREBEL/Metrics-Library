CREATE OR REPLACE VIEW `aparium-dataflow.StarData.WeeklyStarGraphV` AS
WITH latest_week AS (
  SELECT
    MAX(DATE(cy, 1, (week_no - 1) * 7 + 1)) AS max_week_date
  FROM
    `aparium-dataflow.StarData.8_WeeksRollingMetricsV`
),
latest_data AS (
  SELECT *
  FROM `aparium-dataflow.StarData.8_WeeksRollingMetricsV` s
  JOIN latest_week lw
    ON DATE(s.cy, 1, (s.week_no - 1) * 7 + 1) = lw.max_week_date
)
SELECT 
  property_code,
  property_name,
  cs_no,
  cy,
  week_no,
  revpar_index_wk,
  revpar_index_pct_chg
  
FROM latest_data;