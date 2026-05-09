CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.snap_pace_property`
(
  property_code STRING,
  property_name STRING,
  stay_date DATE,
  special_events STRING,
  special_events_ly STRING,
  available_rooms INT64,
  available_rooms_ly INT64,
  total_demand_total INT64,
  total_demand_total_ly_actual INT64,
  total_demand_group INT64,
  total_demand_group_ly_actual INT64,
  total_demand_transient INT64,
  total_demand_transient_ly_actual INT64,
  lrv FLOAT64,
  wash_pct FLOAT64,
  wash_pct_ly_actual FLOAT64,
  bar_price FLOAT64,
  snapshot_date DATE
)
PARTITION BY snapshot_date
CLUSTER BY stay_date
OPTIONS(
  labels=[("dataplex-data-documentation-published-project", "devrebel-big-query-database"), ("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-scan", "ac7dee3b8-c892-4e29-b098-4b5581281a7f")]
);