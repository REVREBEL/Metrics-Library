DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_events';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    master_event_id STRING OPTIONS(description='Standardized master_event_id.'),
    event_name STRING OPTIONS(description='Standardized event_name.'),
    start_date DATE OPTIONS(description='Standardized start_date.'),
    end_date DATE OPTIONS(description='Standardized end_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    category STRING OPTIONS(description='Standardized category.'),
    impact_level STRING OPTIONS(description='Standardized impact_level.'),
    is_recurring BOOL OPTIONS(description='Standardized is_recurring.'),
    constraint fk OPTIONS(description='Standardized constraint.'),
    constraint fk OPTIONS(description='Standardized constraint.')
  )
""", project_id, dataset_name, table_name);