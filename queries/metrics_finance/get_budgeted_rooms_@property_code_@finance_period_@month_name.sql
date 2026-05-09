SELECT *
FROM `aparium-dataflow.FinanceData.FilteredLookerBudgetV`
WHERE property_code = "DTWDFH"
  AND finance_period = "FY25"
  AND month_name = "month_03"

QUALIFY ROW_NUMBER() OVER (PARTITION BY property_code, finance_period, month_name, segment_name ORDER BY snapshot_date DESC) = 1;