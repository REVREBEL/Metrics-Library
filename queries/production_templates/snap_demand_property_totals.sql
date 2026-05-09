DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'snap_demand_property_totals';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    snapshot_date DATETIME OPTIONS(description='Standardized snapshot_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    date DATETIME OPTIONS(description='Standardized date.'),
    month DATETIME OPTIONS(description='Standardized month.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    property_available_rms INT64 OPTIONS(description='Standardized property_available_rms.'),
    property_rms_sold FLOAT64 OPTIONS(description='Standardized property_rms_sold.'),
    property_rev FLOAT64 OPTIONS(description='Standardized property_rev.'),
    cs_available_rms INT64 OPTIONS(description='Standardized cs_available_rms.'),
    cs_rms_sold FLOAT64 OPTIONS(description='Standardized cs_rms_sold.'),
    cs_rev FLOAT64 OPTIONS(description='Standardized cs_rev.'),
    occ_rank INT64 OPTIONS(description='Standardized occ_rank.'),
    adr_rank INT64 OPTIONS(description='Standardized adr_rank.'),
    revpar_rank INT64 OPTIONS(description='Standardized revpar_rank.'),
    adr_rank_ly INT64 OPTIONS(description='Standardized adr_rank_ly.'),
    revpar_rank_ly INT64 OPTIONS(description='Standardized revpar_rank_ly.')
  )
""", project_id, dataset_name, table_name);