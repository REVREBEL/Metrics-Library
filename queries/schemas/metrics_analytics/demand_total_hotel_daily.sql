CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.demand_total_hotel_daily`
(
  market_segment STRING,
  segment STRING,
  month DATETIME,
  stay_date DATETIME,
  compset_rooms_sold FLOAT64,
  occ_index FLOAT64,
  occ_rank STRING,
  property_adr FLOAT64,
  compset_adr FLOAT64,
  adr_rank STRING,
  revpar_rank STRING,
  property_occ_yoy FLOAT64,
  compset_occ_yoy FLOAT64,
  occ_index_yoy FLOAT64,
  property_adr_yoy FLOAT64,
  compset_adr_yoy FLOAT64,
  snapshot_date DATETIME,
  property_code STRING,
  etl_date DATETIME
);