

SELECT *
FROM `aparium-dataflow.financeData.BudgetData`
WHERE  property_code = @PROPERTY_CODE 
AND version = @BUDGET_SNAPSHOT_DATE
AND segment_name IN (
    'Total Group',
    'Total Transient',
    'Contract',
    'Total Occupied Rooms',
    'Total Room Sold',
    'Total Rooms Revenue',
    'Total Other Rooms Revenue'
);


