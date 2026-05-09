CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.fact_market_insights`
(
  property_code STRING,
  property_name STRING OPTIONS(description="The main property being shopped, derived from filename"),
  rateshop_date DATE OPTIONS(description="The date the data was pulled/shopped"),
  arrival_date DATE OPTIONS(description="The date of the actual stay"),
  flex_hotel FLOAT64,
  median_flex_compset FLOAT64,
  hotel_occ FLOAT64,
  market_demand FLOAT64,
  compset_price_rank STRING,
  booking_ranking STRING,
  holidays STRING,
  events STRING,
  is_sold_out BOOL OPTIONS(description="TRUE if Remark indicates Sold Out"),
  min_los INT64 OPTIONS(description="Minimum Length of Stay extracted from Remarks"),
  is_flexible BOOL OPTIONS(description="TRUE if rate allows cancellation/flexibility"),
  inserted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP() OPTIONS(description="Timestamp when the record was inserted into BigQuery")
)
PARTITION BY rateshop_date
CLUSTER BY property_name;