CREATE OR REPLACE VIEW
  `aparium-dataflow.FinanceData.FilteredFinanceV` AS
SELECT
  *,
  'Budget' AS data_source
FROM
  `aparium-dataflow.FinanceData.FilteredBudgetDataV`
WHERE
    segment_name IN ( 
      'Transient Rooms',
      'Transient Revenue',
      'Group Rooms',
      'Group Revenue',
      'Contract Rooms',
      'Contract Revenue',
      'Available Rooms',
      'Rooms Sold',
      'Occupied Rooms',
      'Rooms Revenue',
      'Other Rooms Revenue' ) 
UNION ALL

SELECT
  *,
  'Forecast' AS data_source
FROM
  `aparium-dataflow.FinanceData.FilteredForecastDataV`
WHERE
    segment_name IN ( 
      'Transient Rooms',
      'Transient Revenue',
      'Group Rooms',
      'Group Revenue',
      'Contract Rooms',
      'Contract Revenue',
      'Available Rooms',
      'Rooms Sold',
      'Occupied Rooms',
      'Rooms Revenue',
      'Other Rooms Revenue' ) 
UNION ALL

SELECT
  *,
  'Actuals' AS data_source
FROM
  `aparium-dataflow.FinanceData.FilteredActualsDataV`
WHERE
    segment_name IN ( 
      'Transient Rooms',
      'Transient Revenue',
      'Group Rooms',
      'Group Revenue',
      'Contract Rooms',
      'Contract Revenue',
      'Available Rooms',
      'Rooms Sold',
      'Occupied Rooms',
      'Rooms Revenue',
      'Other Rooms Revenue' )



