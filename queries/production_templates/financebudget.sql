DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'financebudget';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    index STRING OPTIONS(description='Standardized index.'),
    snapshot_date DATE OPTIONS(description='Standardized snapshot_date.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    property_name STRING OPTIONS(description='Standardized property_name.'),
    finance_property_name STRING OPTIONS(description='Standardized finance_property_name.'),
    available_rms INT64 OPTIONS(description='Standardized available_rms.'),
    gl_code STRING OPTIONS(description='Standardized gl_code.'),
    account STRING OPTIONS(description='Standardized account.'),
    segment_code STRING OPTIONS(description='Standardized segment_code.'),
    segment_name STRING OPTIONS(description='Standardized segment_name.'),
    metric STRING OPTIONS(description='Standardized metric.'),
    total_year NUMERIC OPTIONS(description='Standardized total_year.'),
    month_001 NUMERIC OPTIONS(description='Standardized month_001.'),
    month_002 NUMERIC OPTIONS(description='Standardized month_002.'),
    month_003 NUMERIC OPTIONS(description='Standardized month_003.'),
    month_004 NUMERIC OPTIONS(description='Standardized month_004.'),
    month_005 NUMERIC OPTIONS(description='Standardized month_005.'),
    month_006 NUMERIC OPTIONS(description='Standardized month_006.'),
    month_007 NUMERIC OPTIONS(description='Standardized month_007.'),
    month_008 NUMERIC OPTIONS(description='Standardized month_008.'),
    month_009 NUMERIC OPTIONS(description='Standardized month_009.'),
    month_010 NUMERIC OPTIONS(description='Standardized month_010.'),
    month_011 NUMERIC OPTIONS(description='Standardized month_011.'),
    month_012 NUMERIC OPTIONS(description='Standardized month_012.'),
    quarter_001 NUMERIC OPTIONS(description='Standardized quarter_001.'),
    quarter_002 NUMERIC OPTIONS(description='Standardized quarter_002.'),
    quarter_003 NUMERIC OPTIONS(description='Standardized quarter_003.'),
    quarter_004 NUMERIC OPTIONS(description='Standardized quarter_004.'),
    finance_period STRING OPTIONS(description='Standardized finance_period.')
  )
""", project_id, dataset_name, table_name);