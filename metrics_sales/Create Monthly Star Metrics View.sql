CREATE TABLE `aparium-dataflow.StarData.MonthlyStarV`
PARTITION BY period_date -- Partition by the new transformed column
CLUSTER BY property_code, `set` -- Cluster by property_code and set
AS
SELECT 
  property_code, 
  `set`, -- Enclose "set" in backticks since it's a reserved keyword
  -- Transform the period column into a DATE and set it to the first day of the month
  DATE(EXTRACT(YEAR FROM SAFE.PARSE_DATE('%b %y', period)), EXTRACT(MONTH FROM SAFE.PARSE_DATE('%b %y', period)), 1) AS period_date,
  occ, 
  comp_set_occ, 
  occ_pct_chg, 
  comp_set_occ_pct_chg, 
  occ_index, 
  comp_set_occ_pct_chg_ly, 
  adr_index,
  adr_index_ly,
  adr_index_pct_chg,
  adr_index_pct_chg_ly,
  adr_rank,
  adr_rank_ly,
  adr_pct_chg_rank,
  adr_pct_chg_rank_ly,
  revpar,
  revpar_ly,
  comp_set_revpar,
  comp_set_revpar_ly,
  revpar_pct_chg,
  revpar_pct_chg_ly,
  comp_set_revpar_pct_chg,
  comp_set_revpar_pct_chg_ly,
  revpar_index,
  revpar_index_ly,
  revpar_index_pct_chg,
  revpar_index_pct_chg_ly,
  revpar_rank,
  revpar_rank_ly
FROM `aparium-dataflow.StarData.MonthlyStar`
WHERE SAFE.PARSE_DATE('%b %y', stay_date) IS NOT NULL; -- Ensure only valid period values are included