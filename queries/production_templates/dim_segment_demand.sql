DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_segment_demand';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    segment_key STRING OPTIONS(description='Standardized segment_key.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    segment_code STRING OPTIONS(description='Standardized segment_code.'),
    segment_sort INT64 OPTIONS(description='Standardized segment_sort.'),
    segment_group STRING OPTIONS(description='Standardized segment_group.'),
    segment_group_code STRING OPTIONS(description='Standardized segment_group_code.'),
    finance_segment STRING OPTIONS(description='Standardized finance_segment.')
  )
""", project_id, dataset_name, table_name);