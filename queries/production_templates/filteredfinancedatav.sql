DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'filteredfinancedatav';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    union ALL OPTIONS(description='Standardized union.'),
    select index OPTIONS(description='Standardized select.'),
    union ALL OPTIONS(description='Standardized union.'),
    select index OPTIONS(description='Standardized select.')
  )
""", project_id, dataset_name, table_name);