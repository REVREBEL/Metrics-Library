CREATE TABLE `devrebel-big-query-database.dev_hotel_forecast.dim_hotel_config`
(
  hotel_id STRING,
  physical_capacity INT64,
  segment_class STRING,
  segment_id INT64,
  segment_label STRING,
  is_active BOOL,
  created_at TIMESTAMP
);