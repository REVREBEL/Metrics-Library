CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.FilteredFinanceDataV`
AS SELECT
  index,
  snapshot_date,
  property_code,
  property_name,
  finance_property_name,
  available_rms,
  gl_code,
  account,
  segment_code,
  segment_name,
  metric,
  total_year,
  month_01,
  month_02,
  month_03,
  month_04,
  month_05,
  month_06,
  month_07,
  month_08,
  month_09,
  month_10,
  month_11,
  month_12,
  quarter_01,
  quarter_02,
  quarter_03,
  quarter_04,
  finance_period,
  rn,
  'Budget' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredBudgetDataV`
WHERE segment_name IN (
  'Transient Rooms', 'Transient Revenue', 'Group Rooms', 'Group Revenue',
  'Contract Rooms', 'Contract Revenue', 'Available Rooms', 'Rooms Sold',
  'Occupied Rooms', 'Rooms Revenue', 'Other Rooms Revenue'
)

UNION ALL

SELECT
  index,
  snapshot_date,
  property_code,
  property_name,
  finance_property_name,
  available_rms,
  gl_code,
  account,
  segment_code,
  segment_name,
  metric,
  total_year,
  month_01,
  month_02,
  month_03,
  month_04,
  month_05,
  month_06,
  month_07,
  month_08,
  month_09,
  month_10,
  month_11,
  month_12,
  quarter_01,
  quarter_02,
  quarter_03,
  quarter_04,
  finance_period,
  rn,
  'Forecast' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredForecastDataV`
WHERE segment_name IN (
  'Transient Rooms', 'Transient Revenue', 'Group Rooms', 'Group Revenue',
  'Contract Rooms', 'Contract Revenue', 'Available Rooms', 'Rooms Sold',
  'Occupied Rooms', 'Rooms Revenue', 'Other Rooms Revenue'
)

UNION ALL

SELECT
  index,
  snapshot_date,
  property_code,
  property_name,
  finance_property_name,
  available_rms,
  gl_code,
  account,
  segment_code,
  segment_name,
  metric,
  total_year,
  month_01,
  month_02,
  month_03,
  month_04,
  month_05,
  month_06,
  month_07,
  month_08,
  month_09,
  month_10,
  month_11,
  month_12,
  quarter_01,
  quarter_02,
  quarter_03,
  quarter_04,
  finance_period,
  rn,
  'Actuals' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredActualsDataV`
WHERE segment_name IN (
  'Transient Rooms', 'Transient Revenue', 'Group Rooms', 'Group Revenue',
  'Contract Rooms', 'Contract Revenue', 'Available Rooms', 'Rooms Sold',
  'Occupied Rooms', 'Rooms Revenue', 'Other Rooms Revenue'
);