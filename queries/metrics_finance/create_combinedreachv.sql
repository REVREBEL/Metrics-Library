CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.CombinedReachV` AS
WITH LatestPaceData AS (
  SELECT
    property_code,
    stay_date,
    rev_cy,
    rms_cy,
    rev_py,
    rms_py,
    rms_stly,
    rev_stly,
    rms_st2y,
    rev_st2y,
    physical_capacity_cy,
    physical_capacity_py,
    ROW_NUMBER() OVER (
      PARTITION BY property_code, stay_date 
      ORDER BY snapshot_date DESC
    ) AS rn
  FROM `aparium-dataflow.PaceData.PaceData_Property`
),

-- Forecast Base
Forecast AS (
  SELECT
    f.property_code,
    f.stay_date,
    f.rev_otb AS forecast_rev,
    f.available_rms AS forecast_available_rms,
    f.rms_sold AS forecast_rms
  FROM `aparium-dataflow.FinanceData.DailyForecastMajorSegmentV` f
),

-- Budget Base
Budget AS (
  SELECT
    f.property_code,
    f.stay_date,
    f.rev_otb AS budget_rev,
    f.available_rms AS budget_available_rms,
    f.rms_sold AS budget_rms
  FROM `aparium-dataflow.FinanceData.DailyBudgetMajorSegmentV` f
),

-- Latest OTB snapshot
OTB AS (
  SELECT
    property_code,
    stay_date,
    rev_cy AS otb_rev,
    rms_cy AS otb_rms,
    rev_py AS otb_rev_py,
    rms_py AS otb_rms_py,
    rms_stly AS otb_rms_stly,
    rev_stly AS otb_rev_stly,
    rms_st2y AS otb_rms_st2y,
    rev_st2y AS otb_rev_st2y,
    physical_capacity_cy,
    physical_capacity_py
  FROM LatestPaceData
  WHERE rn = 1
)

-- Combine all sources
SELECT
  COALESCE(f.property_code, b.property_code, o.property_code) AS property_code,
  COALESCE(f.stay_date, b.stay_date, o.stay_date) AS stay_date,

  -- Forecast metrics
  f.forecast_rev,
  f.forecast_available_rms,
  f.forecast_rms,

  -- Budget metrics
  b.budget_rev,
  b.budget_available_rms,
  b.budget_rms,

  -- OTB metrics
  o.otb_rev,
  o.otb_rms,
  o.otb_rev_py,
  o.otb_rms_py,
  o.otb_rms_stly,
  o.otb_rev_stly,
  o.otb_rms_st2y,
  o.otb_rev_st2y,

  -- Physical capacity
  o.physical_capacity_cy,
  o.physical_capacity_py

FROM Forecast f
FULL OUTER JOIN Budget b
  ON f.property_code = b.property_code AND f.stay_date = b.stay_date
FULL OUTER JOIN OTB o
  ON COALESCE(f.property_code, b.property_code) = o.property_code
  AND COALESCE(f.stay_date, b.stay_date) = o.stay_date