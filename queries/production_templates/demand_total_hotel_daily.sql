DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'demand_total_hotel_daily';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    market_segment STRING OPTIONS(description='Standardized market_segment.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    month DATETIME OPTIONS(description='Standardized month.'),
    stay_date DATETIME OPTIONS(description='Standardized stay_date.'),
    cs_rms_sold FLOAT64 OPTIONS(description='Standardized cs_rms_sold.'),
    occ_index FLOAT64 OPTIONS(description='Standardized occ_index.'),
    occ_rank STRING OPTIONS(description='Standardized occ_rank.'),
    property_adr FLOAT64 OPTIONS(description='Standardized property_adr.'),
    cs_adr FLOAT64 OPTIONS(description='Standardized cs_adr.'),
    adr_rank STRING OPTIONS(description='Standardized adr_rank.'),
    revpar_rank STRING OPTIONS(description='Standardized revpar_rank.'),
    property_occ_yoy FLOAT64 OPTIONS(description='Standardized property_occ_yoy.'),
    cs_occ_yoy FLOAT64 OPTIONS(description='Standardized cs_occ_yoy.'),
    occ_index_yoy FLOAT64 OPTIONS(description='Standardized occ_index_yoy.'),
    property_adr_yoy FLOAT64 OPTIONS(description='Standardized property_adr_yoy.'),
    cs_adr_yoy FLOAT64 OPTIONS(description='Standardized cs_adr_yoy.'),
    snapshot_date DATETIME OPTIONS(description='Standardized snapshot_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    etl_date DATETIME OPTIONS(description='Standardized etl_date.')
  )
""", project_id, dataset_name, table_name);