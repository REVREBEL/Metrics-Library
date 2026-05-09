DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'filteredfinancev';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    segment_name IN OPTIONS(description='Standardized segment_name.'),
    segment_name IN OPTIONS(description='Standardized segment_name.'),
    segment_name IN OPTIONS(description='Standardized segment_name.')
  )
""", project_id, dataset_name, table_name);