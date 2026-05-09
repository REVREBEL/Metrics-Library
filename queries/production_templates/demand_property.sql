DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'demand_property';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    property_shortname STRING OPTIONS(description='Standardized property_shortname.'),
    cs_set_id STRING OPTIONS(description='Standardized cs_set_id.'),
    stay_date DATE OPTIONS(description='Standardized stay_date.'),
    segment STRING OPTIONS(description='Standardized segment.'),
    occ FLOAT64 OPTIONS(description='Standardized occ.'),
    occ_chg_pw FLOAT64 OPTIONS(description='Standardized occ_chg_pw.'),
    occ_var_ly FLOAT64 OPTIONS(description='Standardized occ_var_ly.'),
    cs_occ FLOAT64 OPTIONS(description='Standardized cs_occ.'),
    cs_occ_chg_pw FLOAT64 OPTIONS(description='Standardized cs_occ_chg_pw.'),
    cs_occ_var_ly FLOAT64 OPTIONS(description='Standardized cs_occ_var_ly.'),
    occ_index FLOAT64 OPTIONS(description='Standardized occ_index.'),
    occ_index_chg_pw FLOAT64 OPTIONS(description='Standardized occ_index_chg_pw.'),
    occ_index_var_ly FLOAT64 OPTIONS(description='Standardized occ_index_var_ly.'),
    occ_rank STRING OPTIONS(description='Standardized occ_rank.'),
    adr FLOAT64 OPTIONS(description='Standardized adr.'),
    adr_var_ly FLOAT64 OPTIONS(description='Standardized adr_var_ly.'),
    cs_adr FLOAT64 OPTIONS(description='Standardized cs_adr.'),
    cs_adr_var_ly FLOAT64 OPTIONS(description='Standardized cs_adr_var_ly.'),
    adr_rank STRING OPTIONS(description='Standardized adr_rank.'),
    adr_rank_ly STRING OPTIONS(description='Standardized adr_rank_ly.'),
    revpar_rank STRING OPTIONS(description='Standardized revpar_rank.'),
    revpar_rank_ly STRING OPTIONS(description='Standardized revpar_rank_ly.'),
    physical_capacity INT64 OPTIONS(description='Standardized physical_capacity.'),
    cs_physical_capacity INT64 OPTIONS(description='Standardized cs_physical_capacity.'),
    month INT64 OPTIONS(description='Standardized month.'),
    month_year STRING OPTIONS(description='Standardized month_year.'),
    cy INT64 OPTIONS(description='Standardized cy.'),
    weekday STRING OPTIONS(description='Standardized weekday.'),
    dow STRING OPTIONS(description='Standardized dow.'),
    cs_demand_id STRING OPTIONS(description='Standardized cs_demand_id.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    ingested_timestamp TIMESTAMP OPTIONS(description='Standardized ingested_timestamp.'),
    sent_to_big_query BOOL OPTIONS(description='Standardized sent_to_big_query.'),
    date_sent_to_big_query TIMESTAMP OPTIONS(description='Standardized date_sent_to_big_query.')
  )
""", project_id, dataset_name, table_name);