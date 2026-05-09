CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.DailyBudgetV` AS
WITH base AS (
  -- Extract fiscal year from finance_period (e.g., FY25 → 2025)
  SELECT 
    *,
    CAST(SUBSTR(finance_period, 3, 2) AS INT64) + 2000 AS fiscal_year
  FROM `aparium-dataflow.FinanceData.FilteredBudgetDataV`
), 
latest_snapshot AS (
  -- Get the latest snapshot date per property_code
  SELECT *
  FROM (
    SELECT 
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code ORDER BY snapshot_date DESC) AS row_num
    FROM base
  )
  WHERE row_num = 1  -- Keep only the latest snapshot per property_code
),
leap_check AS (
  -- Determine if the fiscal year is a leap year
  SELECT 
    *,
    IF(MOD(fiscal_year, 4) = 0 AND (MOD(fiscal_year, 100) != 0 OR MOD(fiscal_year, 400) = 0), 1, 0) AS is_leap_year
  FROM latest_snapshot
),
unpivoted AS (
  -- Convert month columns into row-based format
  SELECT 
    property_code,
    segment_name,
    CASE 
      WHEN month = 'month_01' THEN 1 
      WHEN month = 'month_02' THEN 2 
      WHEN month = 'month_03' THEN 3 
      WHEN month = 'month_04' THEN 4 
      WHEN month = 'month_05' THEN 5 
      WHEN month = 'month_06' THEN 6 
      WHEN month = 'month_07' THEN 7 
      WHEN month = 'month_08' THEN 8 
      WHEN month = 'month_09' THEN 9 
      WHEN month = 'month_10' THEN 10 
      WHEN month = 'month_11' THEN 11 
      WHEN month = 'month_12' THEN 12 
    END AS month_number,
    value AS month_total,
    fiscal_year,
    is_leap_year
  FROM leap_check
  UNPIVOT (
    value FOR month IN (
      month_01, month_02, month_03, month_04, month_05, month_06, 
      month_07, month_08, month_09, month_10, month_11, month_12
    )
  )
),
month_days AS (
  -- Assign the correct number of days to each month (handling leap years)
  SELECT 
    *,
    CASE 
      WHEN month_number IN (1, 3, 5, 7, 8, 10, 12) THEN 31
      WHEN month_number IN (4, 6, 9, 11) THEN 30
      WHEN month_number = 2 AND is_leap_year = 1 THEN 29
      WHEN month_number = 2 THEN 28
    END AS days_in_month
  FROM unpivoted
),
daily_spread AS (
  -- Generate daily breakdown
  SELECT 
    property_code,
    segment_name,
    DATE_FROM_UNIX_DATE(UNIX_DATE(DATE(fiscal_year, month_number, 1)) + day_offset) AS stay_date,
    month_total / days_in_month AS daily_value
  FROM month_days,
  UNNEST(GENERATE_ARRAY(0, days_in_month - 1)) AS day_offset
),
dates AS (
  -- Generate a list of unique stay_date values
  SELECT DISTINCT stay_date FROM daily_spread
),
properties AS (
  -- Generate a list of unique property_code values
  SELECT DISTINCT property_code FROM daily_spread
),
segments AS (
  -- Generate a list of unique segment_name values
  SELECT DISTINCT segment_name FROM daily_spread
),
full_grid AS (
  -- Create a full set of property_code, stay_date, and segment_name
  SELECT p.property_code, d.stay_date, s.segment_name
  FROM properties p
  CROSS JOIN dates d
  CROSS JOIN segments s
),
filled_data AS (
  -- Left join actual daily values to ensure every property + stay_date has all segments
  SELECT 
    fg.property_code, 
    fg.stay_date, 
    fg.segment_name, 
    COALESCE(ds.daily_value, 0) AS daily_value
  FROM full_grid fg
  LEFT JOIN daily_spread ds 
    ON fg.property_code = ds.property_code 
    AND fg.stay_date = ds.stay_date 
    AND fg.segment_name = ds.segment_name
)
SELECT 
  property_code, 
  stay_date, 

  -- PIVOTED COLUMNS
  SUM(CASE WHEN segment_name = 'Available Rooms' THEN daily_value ELSE 0 END) AS available_rms,
  SUM(CASE WHEN segment_name = 'Contract Rooms' THEN daily_value ELSE 0 END) AS contract_rms,
  SUM(CASE WHEN segment_name = 'Group Revenue' THEN daily_value ELSE 0 END) AS group_rev,
  SUM(CASE WHEN segment_name = 'Group Rooms' THEN daily_value ELSE 0 END) AS group_rms,
  SUM(CASE WHEN segment_name = 'Occupied Rooms' THEN daily_value ELSE 0 END) AS rms_occupied,
  SUM(CASE WHEN segment_name = 'Other Rooms Revenue' THEN daily_value ELSE 0 END) AS other_rev,
  SUM(CASE WHEN segment_name = 'Rooms Revenue' THEN daily_value ELSE 0 END) AS rev_otb,
  SUM(CASE WHEN segment_name = 'Rooms Sold' THEN daily_value ELSE 0 END) AS rms_sold,
  SUM(CASE WHEN segment_name = 'Transient Revenue' THEN daily_value ELSE 0 END) AS transient_rev,
  SUM(CASE WHEN segment_name = 'Transient Rooms' THEN daily_value ELSE 0 END) AS transient_rms

FROM filled_data
GROUP BY property_code, stay_date
ORDER BY property_code, stay_date




