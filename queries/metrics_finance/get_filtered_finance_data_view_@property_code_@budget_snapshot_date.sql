
SELECT *, 'Budget' AS data_source 
FROM `aparium-dataflow.FinanceData.FilteredBudgetDataV`
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
AND snapshot_date = @BUDGET_SNAPSHOT_DATE

UNION ALL

SELECT *, 'Forecast' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredForecastDataV`
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
AND snapshot_date = @FORECAST_SNAPSHOT_DATE

UNION ALL

SELECT *, 'Actuals' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredActualsDataV`
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
AND snapshot_date = @ACTUALS_SNAPSHOT_DATE;