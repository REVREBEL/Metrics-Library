DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'fact_daily_weights';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    hotel_id STRING OPTIONS(description='Standardized hotel_id.'),
    date DATE OPTIONS(description='Standardized date.'),
    segment_class STRING OPTIONS(description='Standardized segment_class.'),
    segment_id INT64 OPTIONS(description='Standardized segment_id.'),
    weight_type STRING OPTIONS(description='Standardized weight_type.'),
    weight_value FLOAT64 OPTIONS(description='Standardized weight_value.'),
    last_computed TIMESTAMP OPTIONS(description='Standardized last_computed.')
  )
""", project_id, dataset_name, table_name);