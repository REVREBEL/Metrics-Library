CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.FilteredBudgetSegmentV`
AS WITH
  RankedData AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY property_code ORDER BY snapshot_date DESC ) AS rn
  FROM
    `aparium-dataflow.FinanceData.FinanceBudget`
  WHERE
    segment_name IN ( 'Transient Retail',
      'Transient Consortia',
      'Transient Negotiated',
      'Transient Package',
      'Transient Qualified',
      'Transient Discount',
      'Transient Wholesale',
      'Transient Other',
      'Transient Rooms',
      'Transient Revenue',
      'Group Association',
      'Group Corporate',
      'Group Government',
      'Group SMERF',
      'Group Tour',
      'Group Wholesale',
      'Group Other',
      'Group Rooms',
      'Group Revenue',
      'Contract Rooms',
      'Contract Revenue',
      'Rooms Sold',
      'Rooms Revenue',
      'Other Rooms Revenue',
      'Available Rooms' ) )
SELECT
  *
FROM
  RankedData
WHERE
  rn = 1;