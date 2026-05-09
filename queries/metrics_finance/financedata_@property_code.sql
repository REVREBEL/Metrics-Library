WITH LatestSnapshot AS (
  SELECT 
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM `aparium-dataflow.FinanceData.FilteredFinanceDataV`
  WHERE property_code = CAST(@PROPERTY_CODE AS STRING)
  GROUP BY property_code
)

SELECT f.*
FROM `aparium-dataflow.FinanceData.FilteredFinanceDataV` f
JOIN LatestSnapshot ls
  ON f.property_code = ls.property_code
  AND f.snapshot_date = ls.latest_snapshot_date
WHERE f.property_code = CAST(@PROPERTY_CODE AS STRING);