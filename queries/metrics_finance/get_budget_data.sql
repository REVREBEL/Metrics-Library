SELECT *, 'Budget' AS data_source 
FROM `aparium-dataflow.FinanceData.FilteredBudgetDataV`
WHERE property_code = 'MCICRH' AND finance_period = 'FY25'  AND segment_name IN (
    'Group Rooms',
    'Transient Rooms',
    'Contract Rooms',
    'Occupied Rooms',
    'Room Sold',
    'Rooms Revenue',
    'Other Rooms Revenue'
)

UNION ALL

SELECT *, 'Forecast' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredBudgetDataV`
WHERE property_code = 'MCICRH' AND finance_period = 'FY25' AND segment_name IN (
    'Group Rooms',
    'Transient Rooms',
    'Contract Rooms',
    'Occupied Rooms',
    'Room Sold',
    'Rooms Revenue',
    'Other Rooms Revenue'
) AND property_code = 'MCICRH'

UNION ALL

SELECT *, 'Actuals' AS data_source
FROM `aparium-dataflow.FinanceData.FilteredActualsDataV`
WHERE property_code = 'MCICRH' AND finance_period = 'FY25' AND segment_name IN (
    'Group Rooms',
    'Transient Rooms',
    'Contract Rooms',
    'Occupied Rooms',
    'Room Sold',
    'Rooms Revenue',
    'Other Rooms Revenue'
) 