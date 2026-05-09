

CREATE OR REPLACE MATERIALIZED VIEW `aparium-dataflow.FinanceData.combinedFinanceDataMV` AS

SELECT 'Budget' AS data_type, * FROM `aparium-dataflow.FinanceData.FinanceBudget`
UNION ALL

SELECT 'Forecast' AS data_type, * FROM `aparium-dataflow.FinanceData.FinanceForcast`
UNION ALL

SELECT 'Actuals' AS data_type, * FROM `aparium-dataflow.FinanceData.FinanceActuals`;