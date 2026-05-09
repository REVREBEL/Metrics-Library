DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_channel_demand';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    channel_key STRING OPTIONS(description='Standardized channel_key.'),
    channel_group_code STRING OPTIONS(description='Standardized channel_group_code.'),
    channel_group STRING OPTIONS(description='Standardized channel_group.'),
    source_group_code STRING OPTIONS(description='Standardized source_group_code.'),
    source_group STRING OPTIONS(description='Standardized source_group.'),
    source_code STRING OPTIONS(description='Standardized source_code.'),
    source STRING OPTIONS(description='Standardized source.'),
    channel_sort STRING OPTIONS(description='Standardized channel_sort.')
  )
""", project_id, dataset_name, table_name);