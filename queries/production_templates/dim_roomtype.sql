DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_roomtype';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    roomtype_key STRING OPTIONS(description='Standardized roomtype_key.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    roomtype_code STRING OPTIONS(description='Standardized roomtype_code.'),
    roomtype STRING OPTIONS(description='Standardized roomtype.'),
    roomtype_class STRING OPTIONS(description='Standardized roomtype_class.'),
    roomtype_category_code STRING OPTIONS(description='Standardized roomtype_category_code.'),
    roomtype_category_base STRING OPTIONS(description='Standardized roomtype_category_base.'),
    roomtype_category STRING OPTIONS(description='Standardized roomtype_category.'),
    roomtype_available_rms INT64 OPTIONS(description='Standardized roomtype_available_rms.'),
    roomtype_sort INT64 OPTIONS(description='Standardized roomtype_sort.')
  )
""", project_id, dataset_name, table_name);