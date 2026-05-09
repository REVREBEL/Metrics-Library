DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'property_rpi_fairshare_goals';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    index INT64 OPTIONS(description='Standardized index.'),
    property_code STRING OPTIONS(description='Standardized property_code.'),
    metric STRING OPTIONS(description='Standardized metric.'),
    goal_year INT64 OPTIONS(description='Standardized goal_year.'),
    last_writeback_date DATE OPTIONS(description='Standardized last_writeback_date.'),
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
    annual NUMERIC OPTIONS(description='Standardized annual.'),
    insert_timestamp TIMESTAMP OPTIONS(description='Standardized insert_timestamp.')
  )
""", project_id, dataset_name, table_name);