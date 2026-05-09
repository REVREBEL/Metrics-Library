DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'fact_competitor_rates';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    hotel_id INT64 OPTIONS(description='Standardized hotel_id.'),
    rateshop_date DATE OPTIONS(description='Standardized rateshop_date.'),
    arrival_date DATE OPTIONS(description='Standardized arrival_date.'),
    competitor_id INT64 OPTIONS(description='Standardized competitor_id.'),
    competitor_name STRING OPTIONS(description='Standardized competitor_name.'),
    rate FLOAT64 OPTIONS(description='Standardized rate.'),
    currency STRING OPTIONS(description='Standardized currency.'),
    los INT64 OPTIONS(description='Standardized los.'),
    no_guests INT64 OPTIONS(description='Standardized no_guests.'),
    meal_type STRING OPTIONS(description='Standardized meal_type.'),
    membership STRING OPTIONS(description='Standardized membership.'),
    roomtype_name STRING OPTIONS(description='Standardized roomtype_name.'),
    roomtype_label STRING OPTIONS(description='Standardized roomtype_label.'),
    channel_id STRING OPTIONS(description='Standardized channel_id.'),
    requested_ratetype STRING OPTIONS(description='Standardized requested_ratetype.'),
    demand FLOAT64 OPTIONS(description='Standardized demand.'),
    is_sold_out BOOL OPTIONS(description='Standardized is_sold_out.'),
    min_los INT64 OPTIONS(description='Standardized min_los.'),
    is_flexible BOOL OPTIONS(description='Standardized is_flexible.'),
    raw_rate_remark STRING OPTIONS(description='Standardized raw_rate_remark.'),
    inserted_at TIMESTAMP OPTIONS(description='Standardized inserted_at.')
  )
""", project_id, dataset_name, table_name);