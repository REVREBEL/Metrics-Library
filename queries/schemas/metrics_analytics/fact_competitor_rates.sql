CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.fact_competitor_rates`
(
  property_code STRING,
  property_name STRING,
  hotel_id INT64,
  rateshop_date DATE OPTIONS(description="The date the data was pulled/shopped"),
  arrival_date DATE OPTIONS(description="The date of the actual stay"),
  competitor_id INT64,
  competitor_name STRING,
  rate FLOAT64 OPTIONS(description="The numeric price (NULL if Sold Out)"),
  currency STRING,
  los INT64,
  no_guests INT64,
  meal_type STRING,
  membership STRING,
  roomtype_name STRING,
  roomtype_label STRING OPTIONS(description="Source bucket: BAR, Lowest, or Lowest Flex"),
  channel_id STRING,
  requested_ratetype STRING,
  demand FLOAT64,
  is_sold_out BOOL OPTIONS(description="TRUE if Remark indicates Sold Out"),
  min_los INT64 OPTIONS(description="Minimum Length of Stay extracted from Remarks"),
  is_flexible BOOL OPTIONS(description="TRUE if rate allows cancellation/flexibility"),
  raw_rate_remark STRING,
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY arrival_date
CLUSTER BY competitor_name, rateshop_date;