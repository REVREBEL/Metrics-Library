DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'lkp_events_impact';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    events_impact STRING OPTIONS(description='Standardized events_impact.'),
    insert_timestamp STRING OPTIONS(description='Standardized insert_timestamp.'),
    primary KEY OPTIONS(description='Standardized primary.')
  )
""", project_id, dataset_name, table_name);