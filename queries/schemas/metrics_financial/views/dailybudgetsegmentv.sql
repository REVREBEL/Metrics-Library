CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.DailyBudgetSegmentV`
AS WITH MappedData AS (
  -- Step 1: Map account to new segment names, and include 'Available Rooms'
  SELECT 
    property_code,
    snapshot_date,
    finance_period,
    account,
    month_01, month_02, month_03, month_04, month_05, month_06,
    month_07, month_08, month_09, month_10, month_11, month_12,
    CASE account
      -- Transient Rooms
      WHEN 'Transient - Retail RN' THEN 'Transient Retail Rooms'
      WHEN 'Transient - Discount RN' THEN 'Transient Unqualified Rooms'
      WHEN 'Transient - Negotiated RN' THEN 'Transient Negotiated Rooms'
      WHEN 'Transient - Consortia RN' THEN 'Transient Consortia Rooms'
      WHEN 'Transient - Qualified RN' THEN 'Transient Qualified Rooms'
      WHEN 'Transient - Wholesale RN' THEN 'Transient Wholesale Rooms'

      -- Group Rooms
      WHEN 'Group - Corporate RN' THEN 'Group Corporate Rooms'
      WHEN 'Group - SMERF RN' THEN 'Group SMERF Rooms'
      WHEN 'Group - Tour/Wholesalers RN' THEN 'Group Tour Rooms'
      WHEN 'Group - Association/Convention RN' THEN 'Group Association Rooms'
      WHEN 'Group - Government RN' THEN 'Group Government Rooms'

      -- Transient Revenue
      WHEN 'Transient - Retail' THEN 'Transient Retail Revenue'
      WHEN 'Transient - Discount' THEN 'Transient Unqualified Revenue'
      WHEN 'Transient - Negotiated' THEN 'Transient Negotiated Revenue'
      WHEN 'Transient - Consortia' THEN 'Transient Consortia Revenue'
      WHEN 'Transient - Qualified' THEN 'Transient Qualified Revenue'
      WHEN 'Transient - Wholesale' THEN 'Transient Wholesale Revenue'

      -- Group Revenue
      WHEN 'Group - Corporate' THEN 'Group Corporate Revenue'
      WHEN 'Group - SMERF' THEN 'Group SMERF Revenue'
      WHEN 'Group - Tour/Wholesalers' THEN 'Group Tour Revenue'
      WHEN 'Group - Association/Convention' THEN 'Group Association Revenue'
      WHEN 'Group - Government' THEN 'Group Government Revenue'

      -- Available Rooms
      WHEN 'Available Rooms' THEN 'Available Rooms'
    END AS segment_name
  FROM `aparium-dataflow.FinanceData.FinanceBudget`
  WHERE account IN (
    'Transient - Retail RN', 'Transient - Discount RN', 'Transient - Negotiated RN',
    'Transient - Consortia RN', 'Transient - Qualified RN', 'Transient - Wholesale RN',
    'Group - Corporate RN', 'Group - SMERF RN', 'Group - Tour/Wholesalers RN',
    'Group - Association/Convention RN', 'Group - Government RN',
    'Transient - Retail', 'Transient - Discount', 'Transient - Negotiated',
    'Transient - Consortia', 'Transient - Qualified', 'Transient - Wholesale',
    'Group - Corporate', 'Group - SMERF', 'Group - Tour/Wholesalers',
    'Group - Association/Convention', 'Group - Government',
    'Available Rooms'
  )
),
RankedData AS (
  SELECT 
    *, 
    ROW_NUMBER() OVER (PARTITION BY property_code, segment_name ORDER BY snapshot_date DESC) AS rn
  FROM MappedData
),
FilteredData AS (
  SELECT * FROM RankedData WHERE rn = 1
), 
Unpivoted AS (
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
  SELECT 
    property_code,
    segment_name,
    fiscal_year,
    month_number,
    month_total,
    days_in_month,
    DATE(fiscal_year, month_number, day_offset + 1) AS stay_date,
    CASE 
      WHEN segment_name LIKE '%Rooms' THEN SAFE_CAST(FLOOR(month_total / days_in_month) AS INT64)
      ELSE month_total / days_in_month
    END AS daily_value
  FROM DaysInMonth,
  UNNEST(GENERATE_ARRAY(0, days_in_month - 1)) AS day_offset
),
Adjustment AS (
  SELECT 
    property_code, 
    segment_name,
    fiscal_year,
    month_number,
    MAX(stay_date) AS last_stay_date,
    SUM(daily_value) AS allocated_total,
    MAX(month_total) AS original_total,
    MAX(month_total) - SUM(daily_value) AS adjustment
  FROM DailyBreakdown
  WHERE segment_name LIKE '%Rooms'
  GROUP BY property_code, segment_name, fiscal_year, month_number
),
FinalData AS (
  SELECT 
    db.property_code, 
    db.stay_date, 
    db.segment_name, 
    CASE 
      WHEN db.segment_name LIKE '%Rooms'
       AND db.stay_date = adj.last_stay_date 
       AND db.fiscal_year = adj.fiscal_year 
       AND db.month_number = adj.month_number
      THEN SAFE_CAST(db.daily_value + adj.adjustment AS INT64)
      ELSE db.daily_value
    END AS final_daily_value
  FROM DailyBreakdown db
  LEFT JOIN Adjustment adj
    ON db.property_code = adj.property_code 
    AND db.segment_name = adj.segment_name
    AND db.fiscal_year = adj.fiscal_year
    AND db.month_number = adj.month_number
)
-- Final Pivoted Output
SELECT 
  property_code, 
  stay_date,

  -- PIVOTED COLUMNS
  SUM(CASE WHEN segment_name = 'Available Rooms' THEN final_daily_value ELSE 0 END) AS available_rooms,
  SUM(CASE WHEN segment_name = 'Transient Retail Rooms' THEN final_daily_value ELSE 0 END) AS transient_retail_rooms,
  SUM(CASE WHEN segment_name = 'Transient Unqualified Rooms' THEN final_daily_value ELSE 0 END) AS transient_unqualified_rooms,
  SUM(CASE WHEN segment_name = 'Transient Negotiated Rooms' THEN final_daily_value ELSE 0 END) AS transient_negotiated_rooms,
  SUM(CASE WHEN segment_name = 'Transient Consortia Rooms' THEN final_daily_value ELSE 0 END) AS transient_consortia_rooms,
  SUM(CASE WHEN segment_name = 'Transient Qualified Rooms' THEN final_daily_value ELSE 0 END) AS transient_qualified_rooms,
  SUM(CASE WHEN segment_name = 'Transient Wholesale Rooms' THEN final_daily_value ELSE 0 END) AS transient_wholesale_rooms,
  SUM(CASE WHEN segment_name = 'Group Corporate Rooms' THEN final_daily_value ELSE 0 END) AS group_corporate_rooms,
  SUM(CASE WHEN segment_name = 'Group SMERF Rooms' THEN final_daily_value ELSE 0 END) AS group_smerf_rooms,
  SUM(CASE WHEN segment_name = 'Group Tour Rooms' THEN final_daily_value ELSE 0 END) AS group_tour_rooms,
  SUM(CASE WHEN segment_name = 'Group Association Rooms' THEN final_daily_value ELSE 0 END) AS group_association_rooms,
  SUM(CASE WHEN segment_name = 'Group Government Rooms' THEN final_daily_value ELSE 0 END) AS group_government_rooms,

  SUM(CASE WHEN segment_name = 'Transient Retail Revenue' THEN final_daily_value ELSE 0 END) AS transient_retail_revenue,
  SUM(CASE WHEN segment_name = 'Transient Unqualified Revenue' THEN final_daily_value ELSE 0 END) AS transient_unqualified_revenue,
  SUM(CASE WHEN segment_name = 'Transient Negotiated Revenue' THEN final_daily_value ELSE 0 END) AS transient_negotiated_revenue,
  SUM(CASE WHEN segment_name = 'Transient Consortia Revenue' THEN final_daily_value ELSE 0 END) AS transient_consortia_revenue,
  SUM(CASE WHEN segment_name = 'Transient Qualified Revenue' THEN final_daily_value ELSE 0 END) AS transient_qualified_revenue,
  SUM(CASE WHEN segment_name = 'Transient Wholesale Revenue' THEN final_daily_value ELSE 0 END) AS transient_wholesale_revenue,
  SUM(CASE WHEN segment_name = 'Group Corporate Revenue' THEN final_daily_value ELSE 0 END) AS group_corporate_revenue,
  SUM(CASE WHEN segment_name = 'Group SMERF Revenue' THEN final_daily_value ELSE 0 END) AS group_smerf_revenue,
  SUM(CASE WHEN segment_name = 'Group Tour Revenue' THEN final_daily_value ELSE 0 END) AS group_tour_revenue,
  SUM(CASE WHEN segment_name = 'Group Association Revenue' THEN final_daily_value ELSE 0 END) AS group_association_revenue,
  SUM(CASE WHEN segment_name = 'Group Government Revenue' THEN final_daily_value ELSE 0 END) AS group_government_revenue

FROM FinalData
GROUP BY property_code, stay_date
ORDER BY property_code, stay_date;