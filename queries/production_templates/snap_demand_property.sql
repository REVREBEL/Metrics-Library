DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'snap_demand_property';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    cs_no STRING OPTIONS(description='Standardized cs_no.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    property_available_rms INT64 OPTIONS(description='Standardized property_available_rms.'),
    property_rms INT64 OPTIONS(description='Standardized property_rms.'),
    property_rev NUMERIC OPTIONS(description='Standardized property_rev.'),
    cs_available_rms INT64 OPTIONS(description='Standardized cs_available_rms.'),
    cs_rms INT64 OPTIONS(description='Standardized cs_rms.'),
    cs_rev NUMERIC OPTIONS(description='Standardized cs_rev.'),
    occ_rank STRING OPTIONS(description='Standardized occ_rank.'),
    adr_rank STRING OPTIONS(description='Standardized adr_rank.'),
    revpar_rank STRING OPTIONS(description='Standardized revpar_rank.'),
    adr_rank_ly STRING OPTIONS(description='Standardized adr_rank_ly.'),
    revpar_rank_ly STRING OPTIONS(description='Standardized revpar_rank_ly.')
  )
""", project_id, dataset_name, table_name);