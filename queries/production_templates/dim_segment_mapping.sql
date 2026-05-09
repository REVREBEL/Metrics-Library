DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_segment_mapping';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    hotel_id STRING OPTIONS(description='Standardized hotel_id.'),
    pms_market_code STRING OPTIONS(description='Standardized pms_market_code.'),
    target_segment_class STRING OPTIONS(description='Standardized target_segment_class.'),
    target_segment_id INT64 OPTIONS(description='Standardized target_segment_id.'),
    description STRING OPTIONS(description='Standardized description.'),
    is_active BOOL OPTIONS(description='Standardized is_active.'),
    updated_at TIMESTAMP OPTIONS(description='Standardized updated_at.'),
    updated_by STRING OPTIONS(description='Standardized updated_by.')
  )
""", project_id, dataset_name, table_name);