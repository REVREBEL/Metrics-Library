SELECT * 
FROM `aparium-dataflow.FinanceData.FilteredFinanceDataV`
WHERE property_code = @PROPERTY_CODE
AND finance_period = @FINANCE_PERIOD
AND DATE(snapshot_date) = (
    SELECT MAX(DATE(snapshot_date)) 
    FROM `aparium-dataflow.FinanceData.FilteredFinanceDataV`
    WHERE property_code = @PROPERTY_CODE
    AND finance_period = @FINANCE_PERIOD
);
