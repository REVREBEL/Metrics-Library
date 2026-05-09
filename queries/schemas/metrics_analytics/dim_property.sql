CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.dim_property`
(
  property_code STRING,
  property_name STRING,
  property_shortname STRING,
  management_company STRING,
  location STRING,
  property_available_rooms INT64,
  crs_id STRING,
  pms_id STRING,
  rateshop_id STRING
)
OPTIONS(
  description="Dimension table for hotel details. Updated from Google Sheets."
);