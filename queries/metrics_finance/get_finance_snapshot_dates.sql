-- GET FORECAST AND BUDGET AVAILABLE SNAPSHOT DATES


WITH budget_versions AS (
    SELECT DISTINCT snapshot_date AS budget_snapshot_date FROM `aparium-dataflow.FinanceData.FinanceBudget`
), 
forecast_versions AS (
    SELECT DISTINCT snapshot_date AS forecast_snapshot_date FROM `aparium-dataflow.FinanceData.FinanceForecast`
), 
numbered_budget AS (
    SELECT budget_snapshot_date, ROW_NUMBER() OVER () AS row_num FROM budget_versions
), 
numbered_forecast AS (
    SELECT forecast_snapshot_date, ROW_NUMBER() OVER () AS row_num FROM forecast_versions
)
SELECT 
    nb.budget_snapshot_date, 
    nf.forecast_snapshot_date
FROM numbered_budget nb
FULL OUTER JOIN numbered_forecast nf
ON nb.row_num = nf.row_num
ORDER BY 1, 2;