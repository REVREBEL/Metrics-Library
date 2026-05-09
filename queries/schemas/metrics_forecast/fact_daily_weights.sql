CREATE TABLE `devrebel-big-query-database.dev_hotel_forecast.fact_daily_weights`
(
  hotel_id STRING,
  date DATE,
  segment_class STRING,
  segment_id INT64,
  weight_type STRING,
  weight_value FLOAT64,
  last_computed TIMESTAMP
)
PARTITION BY date
CLUSTER BY hotel_id, segment_class, weight_type;