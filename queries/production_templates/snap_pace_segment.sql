DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'snap_pace_segment';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    rms_otb INT64 OPTIONS(description='Standardized rms_otb.'),
    rms_stly INT64 OPTIONS(description='Standardized rms_stly.'),
    rms_st2y INT64 OPTIONS(description='Standardized rms_st2y.'),
    rms_ly_act INT64 OPTIONS(description='Standardized rms_ly_act.'),
    rev_otb FLOAT64 OPTIONS(description='Standardized rev_otb.'),
    rev_stly FLOAT64 OPTIONS(description='Standardized rev_stly.'),
    rev_st2y FLOAT64 OPTIONS(description='Standardized rev_st2y.'),
    rev_ly_act FLOAT64 OPTIONS(description='Standardized rev_ly_act.'),
    rms_rms_fct INT64 OPTIONS(description='Standardized rms_rms_fct.'),
    rms_rev_fct FLOAT64 OPTIONS(description='Standardized rms_rev_fct.'),
    rms_fct INT64 OPTIONS(description='Standardized rms_fct.'),
    rev_fct FLOAT64 OPTIONS(description='Standardized rev_fct.'),
    rms_bgt INT64 OPTIONS(description='Standardized rms_bgt.'),
    rev_bgt FLOAT64 OPTIONS(description='Standardized rev_bgt.'),
    cancelled_rms INT64 OPTIONS(description='Standardized cancelled_rms.'),
    cancelled_rms_ly_act INT64 OPTIONS(description='Standardized cancelled_rms_ly_act.'),
    noshow_rms INT64 OPTIONS(description='Standardized noshow_rms.'),
    noshow_rms_ly_act INT64 OPTIONS(description='Standardized noshow_rms_ly_act.')
  )
""", project_id, dataset_name, table_name);