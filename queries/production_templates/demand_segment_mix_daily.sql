DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'demand_segment_mix_daily';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    month STRING OPTIONS(description='Standardized month.'),
    date DATETIME OPTIONS(description='Standardized date.'),
    occ FLOAT64 OPTIONS(description='Standardized occ.'),
    cs_occ FLOAT64 OPTIONS(description='Standardized cs_occ.'),
    occ_index FLOAT64 OPTIONS(description='Standardized occ_index.'),
    occ_rank STRING OPTIONS(description='Standardized occ_rank.'),
    occ_index_vs_ly_pct FLOAT64 OPTIONS(description='Standardized occ_index_vs_ly_pct.'),
    occ_index_chg_vs_prior_week_pct FLOAT64 OPTIONS(description='Standardized occ_index_chg_vs_prior_week_pct.'),
    room_nights_current_my_hotel_totals INT64 OPTIONS(description='Standardized room_nights_current_my_hotel_totals.'),
    room_nights_chg_from_last_wk_my_hotel_totals INT64 OPTIONS(description='Standardized room_nights_chg_from_last_wk_my_hotel_totals.'),
    room_nights_var_pct_to_last_yr_my_hotel_totals FLOAT64 OPTIONS(description='Standardized room_nights_var_pct_to_last_yr_my_hotel_totals.'),
    room_nights_var_pct_to_last_yr_market_excl_totals FLOAT64 OPTIONS(description='Standardized room_nights_var_pct_to_last_yr_market_excl_totals.'),
    room_nights_chg_pct_from_last_wk_my_hotel_totals FLOAT64 OPTIONS(description='Standardized room_nights_chg_pct_from_last_wk_my_hotel_totals.'),
    room_nights_chg_pct_from_last_wk_market_excl_totals FLOAT64 OPTIONS(description='Standardized room_nights_chg_pct_from_last_wk_market_excl_totals.'),
    adr FLOAT64 OPTIONS(description='Standardized adr.'),
    adr_rank FLOAT64 OPTIONS(description='Standardized adr_rank.'),
    revpar FLOAT64 OPTIONS(description='Standardized revpar.'),
    revpar_rank FLOAT64 OPTIONS(description='Standardized revpar_rank.'),
    market_segment STRING OPTIONS(description='Standardized market_segment.'),
    detail STRING OPTIONS(description='Standardized detail.'),
    cs_no INT64 OPTIONS(description='Standardized cs_no.'),
    snapshot_date DATETIME OPTIONS(description='Standardized snapshot_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.')
  )
""", project_id, dataset_name, table_name);