CREATE OR REPLACE TABLE `aparium-dataflow.HotelData.DailySnapshots`
PARTITION BY snapshot_date_fixed  -- ✅ Partition by a DATE column
CLUSTER BY property_code, stay_date
AS
SELECT 
    *, 
    DATE(TIMESTAMP_MICROS(snapshot_date)) AS snapshot_date_fixed  -- ✅ Convert INT64 → TIMESTAMP → DATE
FROM `aparium-dataflow.PaceData.PaceSegmentData`;