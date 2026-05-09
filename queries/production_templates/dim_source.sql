DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_source';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    key STRING OPTIONS(description='Standardized key.'),
    subsource_code STRING OPTIONS(description='Standardized subsource_code.'),
    subsource STRING OPTIONS(description='Standardized subsource.'),
    source_code STRING OPTIONS(description='Standardized source_code.'),
    source STRING OPTIONS(description='Standardized source.'),
    channel_code STRING OPTIONS(description='Standardized channel_code.'),
    channel STRING OPTIONS(description='Standardized channel.'),
    channel_group_code STRING OPTIONS(description='Standardized channel_group_code.'),
    channel_group STRING OPTIONS(description='Standardized channel_group.'),
    source_sort INT64 OPTIONS(description='Standardized source_sort.'),
    channel_sort INT64 OPTIONS(description='Standardized channel_sort.')
  )
""", project_id, dataset_name, table_name);