DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'dim_property_demand';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    demand_cs_key STRING OPTIONS(description='Standardized demand_cs_key.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    cs_no STRING OPTIONS(description='Standardized cs_no.'),
    cs_demand_id STRING OPTIONS(description='Standardized cs_demand_id.'),
    property_available_rms STRING OPTIONS(description='Standardized property_available_rms.'),
    cs_available_rms STRING OPTIONS(description='Standardized cs_available_rms.'),
    cs_start_date STRING OPTIONS(description='Standardized cs_start_date.'),
    cs_end_date STRING OPTIONS(description='Standardized cs_end_date.')
  )
""", project_id, dataset_name, table_name);