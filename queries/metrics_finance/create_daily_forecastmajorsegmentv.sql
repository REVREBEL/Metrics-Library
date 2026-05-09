CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.DailyForecastMajorSegmentV` AS
WITH RankedData AS (
  -- Get the latest snapshot per property & segment
  SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY property_code, segment_name ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.FinanceData.FinanceForecast`
  WHERE segment_name IN ( 'Transient Rooms', 'Transient Revenue', 'Group Rooms', 
                          'Group Revenue', 'Contract Rooms', 'Contract Revenue', 
                          'Available Rooms', 'Rooms Sold', 'Occupied Rooms', 
                          'Rooms Revenue', 'Other Rooms Revenue' )
), 
FilteredData AS (
  -- Keep only the latest snapshot per property and segment
  SELECT * FROM RankedData WHERE rn = 1
), 
Unpivoted AS (
  -- Convert month columns into a row-based format
  SELECT 
    property_code,
    segment_name,
    CAST(SUBSTR(finance_period, 3, 2) AS INT64) + 2000 AS fiscal_year,
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
    value AS month_total
  FROM FilteredData
  UNPIVOT (
    value FOR month IN (
      month_01, month_02, month_03, month_04, month_05, month_06, 
      month_07, month_08, month_09, month_10, month_11, month_12
    )
  )
),
DaysInMonth AS (
  -- Assign correct number of days per month
  SELECT 
    *,
    CASE 
      WHEN month_number IN (1, 3, 5, 7, 8, 10, 12) THEN 31
      WHEN month_number IN (4, 6, 9, 11) THEN 30
      WHEN month_number = 2 THEN 28
    END AS days_in_month
  FROM Unpivoted
),
DailyBreakdown AS (
  -- Distribute values evenly across all days in the month
  SELECT 
    property_code,
    segment_name,
    fiscal_year,
    month_number,
    month_total,
    days_in_month,
    DATE(fiscal_year, month_number, day_offset + 1) AS stay_date,
    CASE 
      WHEN segment_name IN ('Rooms Sold', 'Group Rooms', 'Transient Rooms')
      THEN SAFE_CAST(FLOOR(month_total / days_in_month) AS INT64) -- Ensure whole number distribution
      ELSE month_total / days_in_month
    END AS daily_value
  FROM DaysInMonth,
  UNNEST(GENERATE_ARRAY(0, days_in_month - 1)) AS day_offset
),
Adjustment AS (
  -- Compute adjustments for multiple segments
  SELECT 
    property_code, 
    segment_name,
    fiscal_year,
    month_number,
    MAX(stay_date) AS last_stay_date, -- Identify the last date of each month
    SUM(daily_value) AS allocated_total,
    MAX(month_total) AS original_total,
    MAX(month_total) - SUM(daily_value) AS adjustment
  FROM DailyBreakdown
  WHERE segment_name IN ('Rooms Sold', 'Group Rooms', 'Transient Rooms') -- Apply fix to these
  GROUP BY property_code, segment_name, fiscal_year, month_number
),
FinalData AS (
  -- Apply adjustments on the last day of the month
  SELECT 
    db.property_code, 
    db.stay_date, 
    db.segment_name, 
    CASE 
      WHEN db.segment_name IN ('Rooms Sold', 'Group Rooms', 'Transient Rooms')
       AND db.stay_date = adj.last_stay_date 
       AND db.fiscal_year = adj.fiscal_year 
       AND db.month_number = adj.month_number
      THEN SAFE_CAST(db.daily_value + adj.adjustment AS INT64) -- Ensure correct rounding
      ELSE db.daily_value
    END AS final_daily_value
  FROM DailyBreakdown db
  LEFT JOIN Adjustment adj
    ON db.property_code = adj.property_code 
    AND db.segment_name = adj.segment_name
    AND db.fiscal_year = adj.fiscal_year
    AND db.month_number = adj.month_number
)
-- Pivot segment names into columns
SELECT 
  property_code, 
  stay_date, 

  -- PIVOTED COLUMNS
  SUM(CASE WHEN segment_name = 'Available Rooms' THEN final_daily_value ELSE 0 END) AS available_rms,
  SUM(CASE WHEN segment_name = 'Contract Rooms' THEN final_daily_value ELSE 0 END) AS contract_rms,
  SUM(CASE WHEN segment_name = 'Group Revenue' THEN final_daily_value ELSE 0 END) AS group_rev,
  SUM(CASE WHEN segment_name = 'Group Rooms' THEN final_daily_value ELSE 0 END) AS group_rms,
  SUM(CASE WHEN segment_name = 'Occupied Rooms' THEN final_daily_value ELSE 0 END) AS rms_occupied,
  SUM(CASE WHEN segment_name = 'Other Rooms Revenue' THEN final_daily_value ELSE 0 END) AS other_rev,
  SUM(CASE WHEN segment_name = 'Rooms Revenue' THEN final_daily_value ELSE 0 END) AS rev_otb,
  SUM(CASE WHEN segment_name = 'Rooms Sold' THEN final_daily_value ELSE 0 END) AS rms_sold,
  SUM(CASE WHEN segment_name = 'Transient Revenue' THEN final_daily_value ELSE 0 END) AS transient_rev,
  SUM(CASE WHEN segment_name = 'Transient Rooms' THEN final_daily_value ELSE 0 END) AS transient_rms

FROM FinalData
GROUP BY property_code, stay_date
ORDER BY property_code, stay_date;