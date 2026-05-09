DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'snap_pace_roomtype';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    roomtype STRING OPTIONS(description='Standardized roomtype.'),
    roomclass STRING OPTIONS(description='Standardized roomclass.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    available_rms INT64 OPTIONS(description='Standardized available_rms.'),
    rms_otb INT64 OPTIONS(description='Standardized rms_otb.'),
    rms_stly INT64 OPTIONS(description='Standardized rms_stly.'),
    rms_st2y INT64 OPTIONS(description='Standardized rms_st2y.'),
    rms_ly_act INT64 OPTIONS(description='Standardized rms_ly_act.'),
    rms_fct INT64 OPTIONS(description='Standardized rms_fct.'),
    adr_fct FLOAT64 OPTIONS(description='Standardized adr_fct.'),
    rev_otb FLOAT64 OPTIONS(description='Standardized rev_otb.'),
    rev_stly FLOAT64 OPTIONS(description='Standardized rev_stly.'),
    rev_st2y FLOAT64 OPTIONS(description='Standardized rev_st2y.'),
    rev_ly_act FLOAT64 OPTIONS(description='Standardized rev_ly_act.'),
    rev_fct FLOAT64 OPTIONS(description='Standardized rev_fct.'),
    cancelled_rms INT64 OPTIONS(description='Standardized cancelled_rms.'),
    cancelled_rms_ly_act INT64 OPTIONS(description='Standardized cancelled_rms_ly_act.'),
    noshow_rms INT64 OPTIONS(description='Standardized noshow_rms.'),
    noshow_rms_ly_act INT64 OPTIONS(description='Standardized noshow_rms_ly_act.')
  )
""", project_id, dataset_name, table_name);