
SELECT index, stay_date, ROW_NUMBER() OVER (ORDER BY stay_date) AS new_index
FROM `aparium-dataflow.StarData.DayStr`
WHERE index IS NULL
ORDER BY stay_date
LIMIT 10;


MERGE INTO `aparium-dataflow.StarData.DayStr` AS target
USING (
  SELECT 
         index,  -- Include `index` to ensure uniqueness
         ROW_NUMBER() OVER (PARTITION BY index ORDER BY stay_date) AS row_num 
  FROM `aparium-dataflow.StarData.DayStr`
  WHERE index IS NULL 
) AS source
ON target.index IS NULL  
AND target.index = source.index  
WHEN MATCHED THEN 
  UPDATE SET target.index = source.row_num; 



UPDATE `aparium-dataflow.StarData.DayStr` AS target
SET index = source.row_num
FROM (
  SELECT 
         index, 
         ROW_NUMBER() OVER (ORDER BY stay_date) AS row_num 
  FROM `aparium-dataflow.StarData.DayStr`
  WHERE index IS NULL
) AS source
WHERE target.index IS NULL 
AND target.index = source.index; 





UPDATE `aparium-dataflow.StarData.DayStr`
SET index = (
  SELECT SAFE_CAST(ROW_NUMBER() OVER (ORDER BY stay_date) AS INT64) 
  FROM `aparium-dataflow.StarData.DayStr`AS source
  WHERE source.index IS NULL
  LIMIT 1
)
WHERE index IS NULL;
