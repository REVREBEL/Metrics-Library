CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.FilteredForecastDataV`
AS WITH
  RankedData AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY property_code, segment_name ORDER BY snapshot_date DESC) AS rn
  FROM
    `aparium-dataflow.FinanceData.FinanceForecast`
  WHERE
    segment_name IN ( 'Transient Rooms',
      'Transient Revenue',
      'Group Rooms',
      'Group Revenue',
      'Contract Rooms',
      'Contract Revenue',
      'Available Rooms',
      'Rooms Sold',
      'Occupied Rooms',
      'Rooms Revenue',
      'Other Rooms Revenue' ) )
SELECT
  *
FROM
  RankedData
WHERE
  rn = 1;