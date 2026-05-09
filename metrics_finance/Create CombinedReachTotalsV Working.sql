
CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.CombinedReachTotalsV` AS
WITH base_data AS (
  SELECT
    FORMAT('%d-Q%d', EXTRACT(YEAR FROM stay_date), EXTRACT(QUARTER FROM stay_date)) AS period_label,
    stay_date,
    property_code,

    SUM(otb_rms) AS otb_rms,
    SUM(otb_rms_py) AS otb_rms_py,
    SUM(otb_rms_stly) AS otb_rms_stly,
    SUM(otb_rms_st2y) AS otb_rms_st2y,
    SUM(budget_rms) AS budget_rms,
    SUM(forecast_rms) AS forecast_rms,

    SUM(otb_rev) AS otb_rev,
    SUM(otb_rev_py) AS otb_rev_py,
    SUM(otb_rev_stly) AS otb_rev_stly,
    SUM(otb_rev_st2y) AS otb_rev_st2y,
    SUM(budget_rev) AS budget_rev,
    SUM(forecast_rev) AS forecast_rev,

    SUM(budget_available_rms) AS budget_available_rms,
    SUM(forecast_available_rms) AS forecast_available_rms,

    SUM(physical_capacity_cy) AS physical_capacity_cy,
    SUM(physical_capacity_py) AS physical_capacity_py

  FROM `aparium-dataflow.PaceData.CombinedReachV`
  WHERE stay_date IS NOT NULL
    AND property_code IS NOT NULL
  GROUP BY period_label, stay_date, property_code
)

SELECT * FROM base_data

UNION ALL

SELECT
  'TOTAL' AS period_label,
  NULL AS stay_date,
  NULL AS property_code,

  SUM(otb_rms),
  SUM(otb_rms_py),
  SUM(otb_rms_stly),
  SUM(otb_rms_st2y),
  SUM(budget_rms),
  SUM(forecast_rms),

  SUM(otb_rev),
  SUM(otb_rev_py),
  SUM(otb_rev_stly),
  SUM(otb_rev_st2y),
  SUM(budget_rev),
  SUM(forecast_rev),

  SUM(budget_available_rms),
  SUM(forecast_available_rms),

  SUM(physical_capacity_cy),
  SUM(physical_capacity_py)
FROM `aparium-dataflow.PaceData.CombinedReachV`
WHERE stay_date IS NOT NULL
  AND property_code IS NOT NULL