DECLARE project_id STRING DEFAULT 'your-production-project';
DECLARE dataset_name STRING DEFAULT 'prod_hotel_analytics';
DECLARE table_name STRING DEFAULT 'bookingdatacrs';

EXECUTE IMMEDIATE FORMAT("""
  CREATE OR REPLACE TABLE `%s.%s.%s` (
    crs_ratecode STRING OPTIONS(description='Standardized crs_ratecode.'),
    crs_ratecode_name STRING OPTIONS(description='Standardized crs_ratecode_name.'),
    crs_resv_id STRING OPTIONS(description='Standardized crs_resv_id.'),
    crs_rev_stay FLOAT64 OPTIONS(description='Standardized crs_rev_stay.'),
    crs_rev_room FLOAT64 OPTIONS(description='Standardized crs_rev_room.'),
    crs_rev_service FLOAT64 OPTIONS(description='Standardized crs_rev_service.'),
    crs_channel STRING OPTIONS(description='Standardized crs_channel.'),
    crs_subchannel STRING OPTIONS(description='Standardized crs_subchannel.'),
    ta_agency_name STRING OPTIONS(description='Standardized ta_agency_name.'),
    corp_profile_name STRING OPTIONS(description='Standardized corp_profile_name.'),
    corp_code STRING OPTIONS(description='Standardized corp_code.'),
    access_code STRING OPTIONS(description='Standardized access_code.'),
    discount_code STRING OPTIONS(description='Standardized discount_code.'),
    subsource_code_map STRING OPTIONS(description='Standardized subsource_code_map.'),
    subsource_map STRING OPTIONS(description='Standardized subsource_map.'),
    source_code_map STRING OPTIONS(description='Standardized source_code_map.'),
    source_map STRING OPTIONS(description='Standardized source_map.'),
    channel_map STRING OPTIONS(description='Standardized channel_map.'),
    source_sort_map FLOAT64 OPTIONS(description='Standardized source_sort_map.'),
    channel_sort_map FLOAT64 OPTIONS(description='Standardized channel_sort_map.'),
    crs_channel_code STRING OPTIONS(description='Standardized crs_channel_code.'),
    crs_source_code STRING OPTIONS(description='Standardized crs_source_code.')
  )
""", project_id, dataset_name, table_name);