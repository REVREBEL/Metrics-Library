CREATE OR REPLACE VIEW `aparium-dataflow.StarData.MonthlyStarGraphV` AS
WITH latest_date AS (
  SELECT
    MAX(DATE(cy, month, 1)) AS max_date
  FROM
    `aparium-dataflow.StarData.MonthlyStar`
),
latest_data AS (
  SELECT *
  FROM `aparium-dataflow.StarData.MonthlyStar` s
  JOIN latest_date d
    ON DATE(s.cy, s.month, 1) = d.max_date
)
SELECT 
  property_code,
  property_name,
  cs_no,
  cy,
  month,
  -- All YTD columns explicitly listed:
  revpar_index,
  revpar_index_pct_chg
FROM latest_data;