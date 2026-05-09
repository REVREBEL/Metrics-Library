DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_hotel_config';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    hotel_id STRING OPTIONS(description='Standardized hotel_id.'),
    physical_capacity INT64 OPTIONS(description='Standardized physical_capacity.'),
    segment_class STRING OPTIONS(description='Standardized segment_class.'),
    segment_id INT64 OPTIONS(description='Standardized segment_id.'),
    segment_label STRING OPTIONS(description='Standardized segment_label.'),
    is_active BOOL OPTIONS(description='Standardized is_active.'),
    created_at TIMESTAMP OPTIONS(description='Standardized created_at.')
  )
""", project_id, dataset_name, table_name);