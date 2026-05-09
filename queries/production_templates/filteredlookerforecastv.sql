DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'filteredlookerforecastv';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    case WHEN OPTIONS(description='Standardized case.'),
    when month OPTIONS(description='Standardized when.'),
    when month OPTIONS(description='Standardized when.'),
    case WHEN OPTIONS(description='Standardized case.'),
    else NULL OPTIONS(description='Standardized else.'),
    end AS OPTIONS(description='Standardized end.'),
    value_column FOR OPTIONS(description='Standardized value_column.')
  )
""", project_id, dataset_name, table_name);