CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.FilteredBudgetDataV` AS
WITH RankedData AS (
    SELECT *,  
           ROW_NUMBER() OVER (PARTITION BY property_code, segment_name ORDER BY snapshot_date DESC) AS rn
    FROM `aparium-dataflow.FinanceData.FinanceBudget`
    WHERE segment_name IN (
        'Transient Rooms',
        'Group Rooms',
        'Contract Rooms',
        'Occupied Rooms',
        'Rooms Sold',
        'Transient Revenue',
        'Group Revenue',
        'Contract Revenue',
        'Rooms Revenue',
        'Other Rooms Revenue'
    )
)
SELECT *
FROM RankedData
WHERE rn = 1;