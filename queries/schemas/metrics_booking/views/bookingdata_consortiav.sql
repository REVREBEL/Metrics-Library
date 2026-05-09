CREATE OR REPLACE VIEW `aparium-dataflow.BookingData.BookingData_ConsortiaV`
AS SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY book_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `aparium-dataflow.BookingData.BookingData_Consortia`
)
WHERE rn = 1;