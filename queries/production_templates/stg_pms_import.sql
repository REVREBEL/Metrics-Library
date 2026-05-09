DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'stg_pms_import';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    import_id STRING OPTIONS(description='Standardized import_id.'),
    hotel_id STRING OPTIONS(description='Standardized hotel_id.'),
    date DATE OPTIONS(description='Standardized date.'),
    pms_market_code STRING OPTIONS(description='Standardized pms_market_code.'),
    rms_sold INT64 OPTIONS(description='Standardized rms_sold.'),
    room_rev FLOAT64 OPTIONS(description='Standardized room_rev.'),
    food_bev_rev FLOAT64 OPTIONS(description='Standardized food_bev_rev.'),
    other_rev FLOAT64 OPTIONS(description='Standardized other_rev.'),
    imported_at TIMESTAMP OPTIONS(description='Standardized imported_at.')
  )
""", project_id, dataset_name, table_name);