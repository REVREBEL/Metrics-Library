DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'fact_market_insights';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    rateshop_date DATE OPTIONS(description='Standardized rateshop_date.'),
    arrival_date DATE OPTIONS(description='Standardized arrival_date.'),
    flex_hotel FLOAT64 OPTIONS(description='Standardized flex_hotel.'),
    median_flex_cs FLOAT64 OPTIONS(description='Standardized median_flex_cs.'),
    hotel_occ FLOAT64 OPTIONS(description='Standardized hotel_occ.'),
    market_demand FLOAT64 OPTIONS(description='Standardized market_demand.'),
    cs_price_rank STRING OPTIONS(description='Standardized cs_price_rank.'),
    booking_ranking STRING OPTIONS(description='Standardized booking_ranking.'),
    holidays STRING OPTIONS(description='Standardized holidays.'),
    events STRING OPTIONS(description='Standardized events.'),
    is_sold_out BOOL OPTIONS(description='Standardized is_sold_out.'),
    min_los INT64 OPTIONS(description='Standardized min_los.'),
    is_flexible BOOL OPTIONS(description='Standardized is_flexible.'),
    inserted_at TIMESTAMP OPTIONS(description='Standardized inserted_at.')
  )
""", project_id, dataset_name, table_name);