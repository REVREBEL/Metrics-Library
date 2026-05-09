CREATE TABLE `devrebel-big-query-database.dev_hotel_sales.nihrm__EventPackageRevenueBreakdown__c`
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
  nihrm__BookingPackageEvent__c STRING,
  nihrm__AdminCharge__c FLOAT64,
  nihrm__Gratuity__c FLOAT64,
  nihrm__Location__c STRING,
  nihrm__RevenueClassification__c STRING,
  nihrm__UnitPrice__c FLOAT64,
  nihrm__AdminIsIncludedInInclusivePrice__c BOOL,
  nihrm__GratuityIsIncludedInInclusivePrice__c BOOL,
  nihrm__InclusiveUnitPrice__c FLOAT64,
  nihrm__NIHRMMigrations_ExternalID__c STRING,
  nihrm__PreDiscountUnitPrice__c FLOAT64
);