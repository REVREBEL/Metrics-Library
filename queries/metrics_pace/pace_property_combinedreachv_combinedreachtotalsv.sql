


----------------------------------------------------
-- CREATE Combined Reach + Combined Reach TOtals
----------------------------------------------------


----------------------------------------------------
-- COMBINED REACH
----------------------------------------------------


CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.CombinedReachV` AS
WITH LatestPaceData AS (
  SELECT
    property_code,
    stay_date,
    rev,
    rms,
    rev_py,
    rms_py,
    rms_stly,
    rev_stly,
    rms_st2y,
    rev_st2y,
    physical_capacity,
    physical_capacity_py,
    ROW_NUMBER() OVER (
      PARTITION BY property_code, stay_date 
      ORDER BY snapshot_date DESC
    ) AS rn
  FROM `devrebel-big-query-database.Pace.Pace_Property`
),

-- Forecast Base
Forecast AS (
  SELECT
    f.property_code,
    f.stay_date,
    f.rev_otb AS fct_rev,
    f.available_rms AS fct_available_rms,
    f.rms_sold AS fct_rms
  FROM `devrebel-big-query-database.Finance.Forecast_MajorSegmentDailyV` f
),

-- Budget Base
Budget AS (
  SELECT
    f.property_code,
    f.stay_date,
    f.rev_otb AS bgt_rev,
    f.available_rms AS bgt_available_rms,
    f.rms_sold AS bgt_rms
  FROM `devrebel-big-query-database.Finance.Budget_MajorSegmentDailyV` f
),

-- Latest OTB snapshot
OTB AS (
  SELECT
    property_code,
    stay_date,
    rev AS rev,
    rms AS rms,
    rev_py AS rev_py,
    rms_py AS rms_py,
    rms_stly AS rms_stly,
    rev_stly AS rev_stly,
    rms_st2y AS rms_st2y,
    rev_st2y AS rev_st2y,
    physical_capacity,
    physical_capacity_py
  FROM LatestPaceData
  WHERE rn = 1
)

-- Combine all sources
SELECT
  COALESCE(f.property_code, b.property_code, o.property_code) AS property_code,
  COALESCE(f.stay_date, b.stay_date, o.stay_date) AS stay_date,

  -- Forecast metrics
  f.fct_rev,
  f.fct_available_rms,
  f.fct_rms,

  -- Budget metrics
  b.bgt_rev,
  b.bgt_available_rms,
  b.bgt_rms,

  -- OTB metrics
  o.rev,
  o.rms,
  o.rev_py,
  o.rms_py,
  o.rms_stly,
  o.rev_stly,
  o.rms_st2y,
  o.rev_st2y,

  -- Physical capacity
  o.physical_capacity,
  o.physical_capacity_py

FROM Forecast f
FULL OUTER JOIN Budget b
  ON f.property_code = b.property_code AND f.stay_date = b.stay_date
FULL OUTER JOIN OTB o
  ON COALESCE(f.property_code, b.property_code) = o.property_code
  AND COALESCE(f.stay_date, b.stay_date) = o.stay_date;


----------------------------------------------------
-- COMBINED REACH TOTALS
----------------------------------------------------


CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.CombinedReachTotalsV` AS
WITH base_data AS (
  SELECT
    FORMAT('%d-Q%d', EXTRACT(YEAR FROM stay_date), EXTRACT(QUARTER FROM stay_date)) AS period_label,
    EXTRACT(YEAR FROM stay_date) AS stay_year,
    stay_date,
    property_code,

    SUM(rms) AS rms,
    SUM(rms_py) AS rms_py,
    SUM(ms_stly) AS rms_stly,
    SUM(rms_st2y) AS rms_st2y,
    SUM(bgt_rms) AS bgt_rms,
    SUM(fct_rms) AS fct_rms,

    SUM(rev) AS rev,
    SUM(rev_py) AS rev_py,
    SUM(rev_stly) AS rev_stly,
    SUM(rev_st2y) AS rev_st2y,
    SUM(bgt_rev) AS bgt_rev,
    SUM(fct_rev) AS fct_rev,

    SUM(bgt_available_rms) AS bgt_available_rms,
    SUM(fct_available_rms) AS fct_available_rms,

    SUM(physical_capacity) AS physical_capacity,
    SUM(physical_capacity_py) AS physical_capacity_py
  FROM `devrebel-big-query-database.Pace.CombinedReachV`
  WHERE stay_date IS NOT NULL
    AND property_code IS NOT NULL
  GROUP BY period_label, stay_year, stay_date, property_code
),

quarterly_data AS (
  SELECT * EXCEPT(stay_year) FROM base_data
),

annual_data AS (
  SELECT
    FORMAT('%d-TOTAL', stay_year) AS period_label,
    CAST(NULL AS DATE) AS stay_date,
    CAST(NULL AS STRING) AS property_code,

    SUM(rms) AS rms,
    SUM(rms_py) AS rms_py,
    SUM(rms_stly) AS rms_stly,
    SUM(rms_st2y) AS rms_st2y,
    SUM(bgt_rms) AS bgt_rms,
    SUM(fct_rms) AS fct_rms,

    SUM(rev) AS rev,
    SUM(rev_py) AS rev_py,
    SUM(rev_stly) AS rev_stly,
    SUM(rev_st2y) AS rev_st2y,
    SUM(bgt_rev) AS bgt_rev,
    SUM(fct_rev) AS fct_rev,

    SUM(bgt_available_rms) AS bdt_available_rms,
    SUM(fct_available_rms) AS fct_available_rms,

    SUM(physical_capacity) AS physical_capacity,
    SUM(physical_capacity_py) AS physical_capacity_py
  FROM base_data
  GROUP BY stay_year
),

grand_total AS (
  SELECT
    'TOTAL' AS period_label,
    CAST(NULL AS DATE) AS stay_date,
    CAST(NULL AS STRING) AS property_code,

    SUM(rms),
    SUM(rms_py),
    SUM(rms_stly),
    SUM(rms_st2y),
    SUM(bgt_rms),
    SUM(fct_rms),

    SUM(rev),
    SUM(rev_py),
    SUM(rev_stly),
    SUM(rev_st2y),
    SUM(bgt_rev),
    SUM(fct_rev),

    SUM(bgt_available_rms),
    SUM(fct_available_rms),

    SUM(physical_capacity),
    SUM(physical_capacity_py)
  FROM base_data
)

-- UNION of all views
SELECT * FROM quarterly_data
UNION ALL
SELECT * FROM annual_data
UNION ALL
SELECT * FROM grand_total;



