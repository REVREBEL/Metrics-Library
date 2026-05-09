DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_cs_demand';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    cs_no STRING OPTIONS(description='Standardized cs_no.'),
    cs_demand_id STRING OPTIONS(description='Standardized cs_demand_id.'),
    cs_start_date DATETIME OPTIONS(description='Standardized cs_start_date.'),
    cs_name STRING OPTIONS(description='Standardized cs_name.'),
    cs_propername STRING OPTIONS(description='Standardized cs_propername.'),
    cs_shortname STRING OPTIONS(description='Standardized cs_shortname.'),
    cs_brand STRING OPTIONS(description='Standardized cs_brand.'),
    cs_chain STRING OPTIONS(description='Standardized cs_chain.'),
    cs_chain_code STRING OPTIONS(description='Standardized cs_chain_code.'),
    cs_geo_code STRING OPTIONS(description='Standardized cs_geo_code.'),
    cs_available_rms_string STRING OPTIONS(description='Standardized cs_available_rms_string.'),
    cs_available_rms INT64 OPTIONS(description='Standardized cs_available_rms.'),
    cs_pct_share FLOAT64 OPTIONS(description='Standardized cs_pct_share.'),
    cs_distance_string STRING OPTIONS(description='Standardized cs_distance_string.'),
    cs_phone STRING OPTIONS(description='Standardized cs_phone.'),
    cs_address STRING OPTIONS(description='Standardized cs_address.')
  )
""", project_id, dataset_name, table_name);