CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.snap_demand_property_totals`
(
  snapshot_date DATETIME,
  property_code STRING,
  date DATETIME,
  month DATETIME,
  segment STRING,
  property_available_rooms INT64,
  property_rooms_sold FLOAT64,
  property_rev FLOAT64,
  compset_available_rooms INT64,
  compset_rooms_sold FLOAT64,
  compset_rev FLOAT64,
  occ_rank INT64,
  adr_rank INT64,
  revpar_rank INT64,
  adr_rank_prior_year INT64,
  revpar_rank_prior_year INT64
);