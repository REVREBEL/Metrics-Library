DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'fact_segment_daily';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    hotel_id STRING OPTIONS(description='Standardized hotel_id.'),
    date DATE OPTIONS(description='Standardized date.'),
    status STRING OPTIONS(description='Standardized status.'),
    segment_class STRING OPTIONS(description='Standardized segment_class.'),
    segment_id INT64 OPTIONS(description='Standardized segment_id.'),
    rms INT64 OPTIONS(description='Standardized rms.'),
    rev FLOAT64 OPTIONS(description='Standardized rev.'),
    updated_at TIMESTAMP OPTIONS(description='Standardized updated_at.')
  )
""", project_id, dataset_name, table_name);