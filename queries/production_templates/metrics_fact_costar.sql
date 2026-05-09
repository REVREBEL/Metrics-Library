DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'metrics_fact_costar';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    index INT64 OPTIONS(description='Standardized index.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    str_id INT64 OPTIONS(description='Standardized str_id.'),
    cs_no STRING OPTIONS(description='Standardized cs_no.'),
    cs_reference STRING OPTIONS(description='Standardized cs_reference.'),
    cs_id STRING OPTIONS(description='Standardized cs_id.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    property_shortname STRING OPTIONS(description='Standardized property_shortname.'),
    brand STRING OPTIONS(description='Standardized brand.'),
    city STRING OPTIONS(description='Standardized city.'),
    state STRING OPTIONS(description='Standardized state.'),
    country STRING OPTIONS(description='Standardized country.'),
    available_rms INT64 OPTIONS(description='Standardized available_rms.'),
    open_date DATE OPTIONS(description='Standardized open_date.'),
    cs_type STRING OPTIONS(description='Standardized cs_type.'),
    cs_owner STRING OPTIONS(description='Standardized cs_owner.'),
    compliance_status STRING OPTIONS(description='Standardized compliance_status.'),
    delete_on_date DATE OPTIONS(description='Standardized delete_on_date.'),
    cs_status STRING OPTIONS(description='Standardized cs_status.'),
    cs_str_id INT64 OPTIONS(description='Standardized cs_str_id.'),
    cs_property_name STRING OPTIONS(description='Standardized cs_property_name.'),
    cs_brand STRING OPTIONS(description='Standardized cs_brand.'),
    cs_city STRING OPTIONS(description='Standardized cs_city.'),
    cs_state STRING OPTIONS(description='Standardized cs_state.'),
    cs_country STRING OPTIONS(description='Standardized cs_country.'),
    cs_available_rms INT64 OPTIONS(description='Standardized cs_available_rms.'),
    cs_open_date DATE OPTIONS(description='Standardized cs_open_date.'),
    creation_date DATE OPTIONS(description='Standardized creation_date.'),
    legacy_position INT64 OPTIONS(description='Standardized legacy_position.')
  )
""", project_id, dataset_name, table_name);