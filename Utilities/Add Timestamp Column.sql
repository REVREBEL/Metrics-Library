SELECT column_name, data_type
FROM `aparium-dataflow.StarData.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'DayStarDataLive';



ALTER TABLE `aparium-dataflow.StarData.MonthlyStar`
ADD COLUMN insert_timestamp TIMESTAMP;


UPDATE `aparium-dataflow.StarData.MonthlyStar`
SET insert_timestamp = CURRENT_TIMESTAMP()
WHERE insert_timestamp IS NULL;