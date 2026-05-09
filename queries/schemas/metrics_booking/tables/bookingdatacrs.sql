CREATE OR REPLACE TABLE `aparium-dataflow.BookingData.BookingDataCRS`
(
  crs_ratecode STRING,
  crs_ratecode_name STRING,
  crs_resv_id STRING,
  crs_rev_stay FLOAT64,
  crs_rev_room FLOAT64,
  crs_rev_service FLOAT64,
  crs_channel STRING,
  crs_subchannel STRING,
  ta_agency_name STRING,
  corp_profile_name STRING,
  corp_code STRING,
  access_code STRING,
  discount_code STRING,
  subsource_code_map STRING,
  subsource_map STRING,
  source_code_map STRING,
  source_map STRING,
  channel_map STRING,
  source_sort_map FLOAT64,
  channel_sort_map FLOAT64,
  crs_channel_code STRING,
  crs_source_code STRING
)
OPTIONS(
  labels=[("dataplex-data-documentation-published-project", "aparium-dataflow"), ("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-scan", "aae9187dd-f612-4768-bf64-96d33af737f0")]
);