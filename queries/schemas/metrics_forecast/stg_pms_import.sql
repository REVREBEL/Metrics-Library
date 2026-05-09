CREATE TABLE `devrebel-big-query-database.dev_hotel_forecast.stg_pms_import`
(
  import_id STRING,
  hotel_id STRING,
  date DATE,
  pms_market_code STRING,
  rooms_sold INT64,
  room_revenue FLOAT64,
  food_bev_revenue FLOAT64,
  other_revenue FLOAT64,
  imported_at TIMESTAMP
)
PARTITION BY date
CLUSTER BY hotel_id, pms_market_code;