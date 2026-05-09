CREATE TABLE `devrebel-big-query-database.dev_hotel_sales.nihrm__BookingContact__c`
(
  Id STRING,
  IsDeleted BOOL,
  Name STRING,
  CurrencyIsoCode STRING,
  CreatedDate TIMESTAMP,
  CreatedById STRING,
  LastModifiedDate TIMESTAMP,
  LastModifiedById STRING,
  SystemModstamp TIMESTAMP,
  nihrm__Booking__c STRING,
  nihrm__Contact__c STRING,
  nihrm__ExternalId__c STRING,
  nihrm__SourceSystemExternalId__c STRING,
  nihrm__UniqueExternalId__c STRING,
  nihrm__NIHRMMigrations_ExternalID__c STRING
)
OPTIONS(
  labels=[("dataplex-data-documentation-published-project", "aparium-dataflow"), ("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-scan", "aa4db2465-aa96-438b-8dd4-8b42cd5a88fe")]
);