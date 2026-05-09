DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'filteredbudgetsegmentv';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    rankeddata AS OPTIONS(description='Standardized rankeddata.'),
    where segment OPTIONS(description='Standardized where.'),
    rankeddata WHERE OPTIONS(description='Standardized rankeddata.')
  )
""", project_id, dataset_name, table_name);