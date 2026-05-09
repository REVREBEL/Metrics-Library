CREATE OR REPLACE VIEW `aparium-dataflow.BookingData.BookingData_ChannelV` AS
SELECT *
FROM `aparium-dataflow.BookingData.BookingData_Channel`
WHERE book_date >= DATE_SUB(CURRENT_DATE(), INTERVAL 1095 DAY)
  AND property_code IS NOT NULL
  AND book_date IS NOT NULL