CREATE TABLE `devrebel-big-query-database.dev_hotel_forecast.fact_segment_daily`
(
  hotel_id STRING,
  date DATE,
  status STRING,
  segment_class STRING,
  segment_id INT64,
  rooms INT64,
  revenue FLOAT64,
  updated_at TIMESTAMP
)
PARTITION BY date
CLUSTER BY hotel_id, status, segment_class;