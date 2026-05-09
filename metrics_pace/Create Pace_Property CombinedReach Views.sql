-- ----------------------------------------------------------------
-- CREATE VIEW: Pace_PropertyV_Pace_PropertyV_CombinedReachV
-- ----------------------------------------------------------------
-- Latest OTB snapshot: now comes from the clean, deduped, latest snapshot view

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_PropertyV_CombinedReachV` AS
WITH OTB AS (
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
  FROM `devrebel-big-query-database.Pace.Pace_PropertyV_LatestSnapshotV`
),

-- Forecast Base
fct AS (
  SELECT
    property_code,
    stay_date,
    rev_otb AS fct_rev,
    available_rms AS fct_physical_capacity_rms,
    rms_sold AS fct_rms
  FROM `aparium-dataflow.FinanceData.DailyForecastMajorSegmentV`
),

-- Budget Base
bgt AS (
  SELECT
    property_code,
    stay_date,
    rev_otb AS bgt_rev,
    available_rms AS bgt_physical_capacity_rms,
    rms_sold AS bgt_rms
  FROM `aparium-dataflow.FinanceData.DailyBudgetMajorSegmentV`
)

-- Combine all sources
SELECT
  COALESCE(f.property_code, b.property_code, o.property_code) AS property_code,
  COALESCE(f.stay_date, b.stay_date, o.stay_date) AS stay_date,

  -- Forecast metrics
  f.fct_rev,
  f.fct_physical_capacity_rms,
  f.fct_rms,

  -- Budget metrics
  b.bgt_rev,
  b.bgt_physical_capacity_rms,
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

FROM fct f
FULL OUTER JOIN bgt b
  ON f.property_code = b.property_code AND f.stay_date = b.stay_date
FULL OUTER JOIN OTB o
  ON COALESCE(f.property_code, b.property_code) = o.property_code
  AND COALESCE(f.stay_date, b.stay_date) = o.stay_date;



-- ----------------------------------------------------------------
-- CREATE VIEW: Pace_PropertyV_CombinedReachTotalsV
-- ----------------------------------------------------------------

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_PropertyV_CombinedReachTotalsV` AS
WITH base_data AS (
  SELECT
    FORMAT('%d-Q%d', EXTRACT(YEAR FROM stay_date), EXTRACT(QUARTER FROM stay_date)) AS period_label,
    stay_date,
    property_code,

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

    SUM(bgt_physical_capacity_rms) AS bgt_physical_capacity_rms,
    SUM(fct_physical_capacity_rms) AS fct_physical_capacity_rms,

    SUM(physical_capacity) AS physical_capacity,
    SUM(physical_capacity_py) AS physical_capacity_py

  FROM `devrebel-big-query-database.Pace.Pace_PropertyV_CombinedReachV`
  WHERE stay_date IS NOT NULL AND property_code IS NOT NULL
  GROUP BY period_label, stay_date, property_code
),

grand_total AS (
  SELECT
    'TOTAL' AS period_label,
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

    SUM(bgt_physical_capacity_rms) AS bgt_physical_capacity_rms,
    SUM(fct_physical_capacity_rms) AS fct_physical_capacity_rms,

    SUM(physical_capacity) AS physical_capacity,
    SUM(physical_capacity_py) AS physical_capacity_py
    
  FROM base_data
)

-- Final Output
SELECT * FROM base_data
UNION ALL
SELECT * FROM grand_total;
