CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.CombinedReachCompV` AS
WITH
  -- Filtered source data by transient segments
  FilteredSegmentData AS (
    SELECT *
    FROM `aparium-dataflow.PaceData.PaceData_Segment`
    WHERE segment_group = 'Comp'
  ),

  -- Latest snapshot logic with filtered segment data
  LatestPaceData AS (
    SELECT
      property_code,
      stay_date,
      SUM(rev_cy) AS rev_cy,
      SUM(rms_cy) AS rms_cy,
      SUM(rms_stly) AS rms_stly,
      SUM(rms_st2y) AS rms_st2y,
      SUM(rms_py) AS rms_py,
      SUM(rev_stly) AS rev_stly,
      SUM(rev_st2y) AS rev_st2y,
      SUM(rev_py) AS rev_py,
      ROW_NUMBER() OVER (PARTITION BY property_code, stay_date ORDER BY snapshot_date DESC ) AS rn
    FROM FilteredSegmentData
    GROUP BY property_code, stay_date, snapshot_date
  ),

  -- Forecast Base
  Forecast AS (
    SELECT
      f.property_code,
      f.stay_date,
      f.transient_rev AS forecast_rev,
      f.available_rms AS forecast_available_rms,
      f.transient_rms AS forecast_rms
    FROM `aparium-dataflow.FinanceData.DailyForecastV` f
  ),

  -- Budget Base
  Budget AS (
    SELECT
      f.property_code,
      f.stay_date,
      f.transient_rev AS budget_rev,
      f.available_rms AS budget_available_rms,
      f.transient_rms AS budget_rms
    FROM `aparium-dataflow.FinanceData.DailyBudgetV` f
  ),

  -- Latest OTB snapshot
  OTB AS (
    SELECT
      property_code,
      stay_date,
      rev_cy AS otb_rev,
      rms_cy AS otb_rms,
      rms_stly AS otb_rms_stly,
      rms_st2y AS otb_rms_st2y,
      rms_py AS otb_rms_py,
      rev_stly AS otb_rev_stly,
      rev_st2y AS otb_rev_st2y,
      rev_py AS otb_rev_py
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
  o.otb_rms_stly,
  o.otb_rms_st2y,
  o.otb_rms_py,
  o.otb_rev_stly,
  o.otb_rev_st2y,
  o.otb_rev_py

FROM Forecast f
FULL OUTER JOIN Budget b
  ON f.property_code = b.property_code
  AND f.stay_date = b.stay_date
FULL OUTER JOIN OTB o
  ON COALESCE(f.property_code, b.property_code) = o.property_code
  AND COALESCE(f.stay_date, b.stay_date) = o.stay_date;