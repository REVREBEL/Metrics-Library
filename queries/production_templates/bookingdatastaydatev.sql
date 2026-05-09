DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'bookingdatastaydatev';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    case property OPTIONS(description='Standardized case.'),
    else NULL OPTIONS(description='Standardized else.'),
    end AS OPTIONS(description='Standardized end.'),
    case property OPTIONS(description='Standardized case.'),
    else NULL OPTIONS(description='Standardized else.'),
    end AS OPTIONS(description='Standardized end.'),
    and property OPTIONS(description='Standardized and.'),
    and arrival OPTIONS(description='Standardized and.')
  )
""", project_id, dataset_name, table_name);