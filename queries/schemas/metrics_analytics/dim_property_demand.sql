CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.dim_property_demand`
(
  demand_compset_key STRING,
  property_name STRING,
  property_code STRING,
  compset_no STRING,
  cs_demand_id STRING,
  property_available_rooms STRING,
  compset_available_rooms STRING,
  compset_start_date STRING,
  compset_end_date STRING
)
OPTIONS(
  description="Dimension table for hotel properties and their competitive set configurations. Updated from Google Sheets."
);