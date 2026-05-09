DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'demand_segment';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    d360_segment STRING OPTIONS(description='Standardized d360_segment.'),
    cy INT64 OPTIONS(description='Standardized cy.'),
    weekday STRING OPTIONS(description='Standardized weekday.'),
    dow STRING OPTIONS(description='Standardized dow.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    occ FLOAT64 OPTIONS(description='Standardized occ.'),
    cs_occ FLOAT64 OPTIONS(description='Standardized cs_occ.'),
    occ_index FLOAT64 OPTIONS(description='Standardized occ_index.'),
    occ_rank STRING OPTIONS(description='Standardized occ_rank.'),
    occ_index_var_ly FLOAT64 OPTIONS(description='Standardized occ_index_var_ly.'),
    occ_index_chg_pw FLOAT64 OPTIONS(description='Standardized occ_index_chg_pw.'),
    rms INT64 OPTIONS(description='Standardized rms.'),
    rms_pct_var_ly FLOAT64 OPTIONS(description='Standardized rms_pct_var_ly.'),
    cs_rms_pct_var_ly FLOAT64 OPTIONS(description='Standardized cs_rms_pct_var_ly.'),
    rms_chg_pw FLOAT64 OPTIONS(description='Standardized rms_chg_pw.'),
    rms_pct_chg_pw FLOAT64 OPTIONS(description='Standardized rms_pct_chg_pw.'),
    cs_rms_pct_chg_pw FLOAT64 OPTIONS(description='Standardized cs_rms_pct_chg_pw.'),
    adr FLOAT64 OPTIONS(description='Standardized adr.'),
    adr_rank STRING OPTIONS(description='Standardized adr_rank.'),
    revpar FLOAT64 OPTIONS(description='Standardized revpar.'),
    month INT64 OPTIONS(description='Standardized month.'),
    revpar_rank STRING OPTIONS(description='Standardized revpar_rank.'),
    cs_set_id STRING OPTIONS(description='Standardized cs_set_id.'),
    physical_capacity INT64 OPTIONS(description='Standardized physical_capacity.'),
    cs_physical_capacity INT64 OPTIONS(description='Standardized cs_physical_capacity.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    segment_code STRING OPTIONS(description='Standardized segment_code.'),
    segment_sort INT64 OPTIONS(description='Standardized segment_sort.'),
    segment_group STRING OPTIONS(description='Standardized segment_group.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    property_shortname STRING OPTIONS(description='Standardized property_shortname.'),
    segment_group_code STRING OPTIONS(description='Standardized segment_group_code.'),
    finance_segment STRING OPTIONS(description='Standardized finance_segment.'),
    cs_demand_id STRING OPTIONS(description='Standardized cs_demand_id.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    ingested_timestamp TIMESTAMP OPTIONS(description='Standardized ingested_timestamp.'),
    sent_to_big_query BOOL OPTIONS(description='Standardized sent_to_big_query.'),
    date_sent_to_big_query TIMESTAMP OPTIONS(description='Standardized date_sent_to_big_query.')
  )
""", project_id, dataset_name, table_name);