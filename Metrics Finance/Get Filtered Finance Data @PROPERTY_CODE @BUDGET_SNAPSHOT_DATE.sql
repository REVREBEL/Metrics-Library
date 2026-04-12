
SELECT * FROM `aparium-dataflow.FinanceData.FilteredFinanceDataV`
WHERE property_code = @PROPERTY_CODE 
AND snapshot_date = @BUDGET_SNAPSHOT_DATE;

