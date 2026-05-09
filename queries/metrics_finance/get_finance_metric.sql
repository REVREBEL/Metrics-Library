SELECT @MONTH_NUMBER, 'Budget' AS data_source 
FROM `aparium-dataflow.financeData.FilteredFinanceDataV`
WHERE segment_name IN (
    'Total Group',
    'Total Transient',
    'Contract',
    'Total Occupied Rooms',
    'Total Room Sold',
    'Total Rooms Revenue',
    'Total Other Rooms Revenue'
)
AND property_code = @PROPERTY_CODE 
AND version = (SELECT MAX(version) FROM `aparium-dataflow.financeData.FilteredBudgetDataV`)
AND finance_period = @FINANCE_PERIOD