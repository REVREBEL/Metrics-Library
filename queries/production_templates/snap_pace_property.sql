DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'snap_pace_property';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    special_events STRING OPTIONS(description='Standardized special_events.'),
    special_events_ly STRING OPTIONS(description='Standardized special_events_ly.'),
    available_rms INT64 OPTIONS(description='Standardized available_rms.'),
    available_rms_ly INT64 OPTIONS(description='Standardized available_rms_ly.'),
    total_demand_total INT64 OPTIONS(description='Standardized total_demand_total.'),
    total_demand_total_ly_act INT64 OPTIONS(description='Standardized total_demand_total_ly_act.'),
    total_demand_group INT64 OPTIONS(description='Standardized total_demand_group.'),
    total_demand_group_ly_act INT64 OPTIONS(description='Standardized total_demand_group_ly_act.'),
    total_demand_transient INT64 OPTIONS(description='Standardized total_demand_transient.'),
    total_demand_transient_ly_act INT64 OPTIONS(description='Standardized total_demand_transient_ly_act.'),
    lrv FLOAT64 OPTIONS(description='Standardized lrv.'),
    wash_pct FLOAT64 OPTIONS(description='Standardized wash_pct.'),
    wash_pct_ly_act FLOAT64 OPTIONS(description='Standardized wash_pct_ly_act.'),
    bar_price FLOAT64 OPTIONS(description='Standardized bar_price.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.')
  )
""", project_id, dataset_name, table_name);