SELECT
  `month_01`,
  `month_02`,
  `month_03`,
  `month_04`,
  `month_05`,
  `month_06`,
  `month_07`,
  `month_08`,
  `month_09`,
  `month_10`,
  `month_11`,
  `month_12`,
FROM
  `aparium-dataflow.financeData.FilteredFinanceDataV`
WHERE
  property_code = @PROPERTY_CODE
  AND version = @SNAPSHOT_DATE
  AND finance_period = @FINANCE_PERIOD
  AND data_source = 'Budget'
  AND (`account` IN ( 'Total Rooms Revenue',
      'Group Rooms',
      'Transient Rooms',
      'Contract Rooms',
      'Occupied Rooms',
      'Room Sold',
      'Rooms Revenue',
      'Other Rooms Revenue' ))