DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'fact_major_segment';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    special_events STRING OPTIONS(description='Standardized special_events.'),
    available_rms INT64 OPTIONS(description='Standardized available_rms.'),
    rms_act INT64 OPTIONS(description='Standardized rms_act.'),
    rev_act FLOAT64 OPTIONS(description='Standardized rev_act.'),
    transient_rms_act INT64 OPTIONS(description='Standardized transient_rms_act.'),
    transient_rev_act FLOAT64 OPTIONS(description='Standardized transient_rev_act.'),
    group_rms_act INT64 OPTIONS(description='Standardized group_rms_act.'),
    group_rev_act FLOAT64 OPTIONS(description='Standardized group_rev_act.'),
    ooo_rms INT64 OPTIONS(description='Standardized ooo_rms.'),
    wash_pct FLOAT64 OPTIONS(description='Standardized wash_pct.')
  )
""", project_id, dataset_name, table_name);