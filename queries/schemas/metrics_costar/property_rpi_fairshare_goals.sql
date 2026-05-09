CREATE TABLE `devrebel-big-query-database.dev_hotel_costar.Property_RPI_Fairshare_Goals`
(
  index INT64 OPTIONS(description="Unique Row Identifier"),
  property_code STRING OPTIONS(description="Internal Property Identifier"),
  metric STRING OPTIONS(description="Metric"),
  goal_year INT64 OPTIONS(description="Goal Year"),
  last_writeback_date DATE OPTIONS(description="Last Updated On"),
  month_01 NUMERIC OPTIONS(description="January"),
  month_02 NUMERIC OPTIONS(description="February"),
  month_03 NUMERIC OPTIONS(description="March"),
  month_04 NUMERIC OPTIONS(description="April"),
  month_05 NUMERIC OPTIONS(description="May"),
  month_06 NUMERIC OPTIONS(description="June"),
  month_07 NUMERIC OPTIONS(description="July"),
  month_08 NUMERIC OPTIONS(description="August"),
  month_09 NUMERIC OPTIONS(description="September"),
  month_10 NUMERIC OPTIONS(description="October"),
  month_11 NUMERIC OPTIONS(description="November"),
  month_12 NUMERIC OPTIONS(description="December"),
  annual NUMERIC OPTIONS(description="Annual"),
  insert_timestamp TIMESTAMP OPTIONS(description="Inserted Timestamp")
);