CREATE OR REPLACE VIEW `aparium-dataflow.SalesDataViews.SalesData_SalesInquiryV` AS
WITH date_filtered_inquiries AS (
  SELECT *
  FROM `aparium-dataflow.salesData.nihrm__Inquiry__c`
  WHERE
    nihrm__ArrivalDate__c BETWEEN
      DATE_SUB(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 12 MONTH)
      AND
      DATE_ADD(DATE_TRUNC(CURRENT_DATE(), MONTH), INTERVAL 12 MONTH)
)

SELECT
  i.Id AS booking_inq_id,
  i.Name AS grp_name,
  i.nihrm__ArrivalDate__c AS arrival_date,
  i.nihrm__BookingTypeName__c AS booking_type_name,
  i.nihrm__Account__c AS account,
  i.nihrm__LeadSourceName__c AS lead_source,
  i.nihrm__RevenueType__c AS revenue_type,
  i.nihrm__RfpChannel__c AS rfp_channel,
  i.nihrm__RfpMilestone__c AS rfp_milestone,
  i.nihrm__RfpStatus__c AS rfp_status,
  i.nihrm__Status__c AS booking_status,
  i.nihrm__Type__c AS booking_type,
  i.nihrm__MarketSegmentName__c AS segment,
  i.nihrm__LostBusinessReason__c AS lost_business_reason,
  l.Name AS property_name
FROM
  date_filtered_inquiries i
LEFT JOIN
  `aparium-dataflow.salesData.nihrm__Location__c` l
ON
  i.nihrm__Location__c = l.Id;
