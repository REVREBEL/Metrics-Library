CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.dim_compset_demand`
(
  property_code STRING,
  compset_no STRING,
  compset_demand_id STRING,
  compset_start_date DATETIME,
  compset_name STRING,
  compset_propername STRING,
  compset_shortname STRING,
  compset_brand STRING,
  compset_chain STRING,
  compset_chain_code STRING,
  compset_geo_code STRING,
  compset_available_rooms_string STRING,
  compset_available_rooms INT64,
  compset_pct_share FLOAT64,
  compset_distance_string STRING,
  compset_phone STRING,
  compset_address STRING
)
OPTIONS(
  description="Dimension table for competitive set details. Updated from Google Sheets."
);