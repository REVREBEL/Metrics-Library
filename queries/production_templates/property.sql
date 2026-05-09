DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'property';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    pms_property_code STRING OPTIONS(description='Standardized pms_property_code.'),
    crs_hotel_code STRING OPTIONS(description='Standardized crs_hotel_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    no_rms INT64 OPTIONS(description='Standardized no_rms.'),
    property_shortname STRING OPTIONS(description='Standardized property_shortname.'),
    property_city STRING OPTIONS(description='Standardized property_city.'),
    insert_timestamp TIMESTAMP OPTIONS(description='Standardized insert_timestamp.')
  )
""", project_id, dataset_name, table_name);