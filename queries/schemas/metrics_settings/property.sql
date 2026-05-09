CREATE TABLE `devrebel-big-query-database.Settings.Property`
(
  property_code STRING OPTIONS(description="Property Code"),
  pms_property_code STRING OPTIONS(description="PMS Property Code"),
  crs_hotel_code STRING OPTIONS(description="CRS Hotel Code"),
  property_name STRING OPTIONS(description="Property Name"),
  no_rms INT64 OPTIONS(description="Number of Rooms"),
  property_shortname STRING OPTIONS(description="Property Short Name"),
  property_city STRING OPTIONS(description="Property City"),
  insert_timestamp TIMESTAMP OPTIONS(description="Insert Timestamp")
);