CREATE TABLE `devrebel-big-query-database.dev_hotel_forecast.dim_segment_mapping`
(
  hotel_id STRING,
  pms_market_code STRING,
  target_segment_class STRING,
  target_segment_id INT64,
  description STRING,
  is_active BOOL,
  updated_at TIMESTAMP,
  updated_by STRING
);