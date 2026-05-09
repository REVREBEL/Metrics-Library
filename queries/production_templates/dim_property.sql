DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_property';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    property_shortname STRING OPTIONS(description='Standardized property_shortname.'),
    management_company STRING OPTIONS(description='Standardized management_company.'),
    location STRING OPTIONS(description='Standardized location.'),
    property_available_rms INT64 OPTIONS(description='Standardized property_available_rms.'),
    crs_id STRING OPTIONS(description='Standardized crs_id.'),
    pms_id STRING OPTIONS(description='Standardized pms_id.'),
    rateshop_id STRING OPTIONS(description='Standardized rateshop_id.')
  )
""", project_id, dataset_name, table_name);