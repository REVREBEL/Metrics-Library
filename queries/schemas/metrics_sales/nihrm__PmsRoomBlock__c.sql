CREATE TABLE `devrebel-big-query-database.dev_hotel_sales.nihrm__PmsRoomBlock__c`
(
  Id STRING,
  OwnerId STRING,
  IsDeleted BOOL,
  Name STRING,
  CurrencyIsoCode STRING,
  CreatedDate TIMESTAMP,
  CreatedById STRING,
  LastModifiedDate TIMESTAMP,
  LastModifiedById STRING,
  SystemModstamp TIMESTAMP,
  LastActivityDate DATE,
  LastViewedDate TIMESTAMP,
  LastReferencedDate TIMESTAMP,
  nihrm__BlockedAverageDailyRate__c FLOAT64,
  nihrm__BlockedRevenueTotal__c FLOAT64,
  nihrm__BlockedRoomnightsTotal__c FLOAT64,
  nihrm__Booking__c STRING,
  nihrm__CutoffDate__c DATE,
  nihrm__EndDate__c DATE,
  nihrm__ExternalId__c STRING,
  nihrm__IsLinkSent__c BOOL,
  nihrm__Location__c STRING,
  nihrm__PickupAverageDailyRate__c FLOAT64,
  nihrm__PickupRevenueTotal__c FLOAT64,
  nihrm__PickupRoomnightsTotal__c FLOAT64,
  nihrm__PmsGroupId__c STRING,
  nihrm__RoomBlock__c STRING,
  nihrm__SourceSystemExternalId__c STRING,
  nihrm__StartDate__c DATE,
  nihrm__Status__c STRING,
  nihrm__UniqueExternalId__c STRING,
  nihrm__UpdatesTransientSold__c BOOL,
  nihrm__NIHRMMigrations_ExternalID__c STRING
)
OPTIONS(
  labels=[("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-project", "aparium-dataflow"), ("dataplex-data-documentation-published-scan", "a1f041bb2-378f-487e-913c-72d2bcb808e5"), ("dataplex-dp-published-project", "aparium-dataflow"), ("dataplex-dp-published-location", "us-central1"), ("dataplex-dp-published-scan", "adb27c32e-ac0d-4370-ac35-33ea5d74cef3")]
);