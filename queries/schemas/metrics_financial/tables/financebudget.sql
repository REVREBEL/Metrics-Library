CREATE OR REPLACE TABLE `aparium-dataflow.FinanceData.FinanceBudget`
(
  index STRING OPTIONS(description="Unique Row Identifier"),
  snapshot_date DATE OPTIONS(description="Date in Time of Capture"),
  property_code STRING OPTIONS(description="Internal Property Identifier"),
  property_name STRING OPTIONS(description="Property Name"),
  finance_property_name STRING OPTIONS(description="Property Name"),
  available_rms INT64 OPTIONS(description="Total Available Rooms / Room Supply"),
  gl_code STRING OPTIONS(description="Finance GL Ledger Code"),
  account STRING OPTIONS(description="GL Account Name"),
  segment_code STRING OPTIONS(description="Market Segment Code"),
  segment_name STRING OPTIONS(description="Market Segment Name"),
  metric STRING OPTIONS(description="Metric"),
  total_year NUMERIC OPTIONS(description="Annual Total"),
  month_01 NUMERIC OPTIONS(description="January Rooms Revenue"),
  month_02 NUMERIC OPTIONS(description="February Rooms Revenue"),
  month_03 NUMERIC OPTIONS(description="March Rooms Revenue"),
  month_04 NUMERIC OPTIONS(description="April Room Revenue"),
  month_05 NUMERIC OPTIONS(description="May Rooms Revenue"),
  month_06 NUMERIC OPTIONS(description="June Rooms Revenue"),
  month_07 NUMERIC OPTIONS(description="July Rooms Revenue"),
  month_08 NUMERIC OPTIONS(description="August Rooms Revenue"),
  month_09 NUMERIC OPTIONS(description="September Rooms Revenue"),
  month_10 NUMERIC OPTIONS(description="October Rooms Revenue"),
  month_11 NUMERIC OPTIONS(description="November Rooms Revenue"),
  month_12 NUMERIC OPTIONS(description="December Rooms Revenue"),
  quarter_01 NUMERIC OPTIONS(description="Quarter 1 Total"),
  quarter_02 NUMERIC OPTIONS(description="Quarter 2 Total"),
  quarter_03 NUMERIC OPTIONS(description="Quarter 3 Total"),
  quarter_04 NUMERIC OPTIONS(description="Quarter 4 Total"),
  finance_period STRING OPTIONS(description="Financial period for the data")
)
OPTIONS(
  description="This table stores financial budget data for various properties. It captures budget allocations and actuals over time, broken down by financial accounts and market segments. The table supports detailed financial analysis, performance tracking, and budget versus actual comparisons. It provides a comprehensive view of financial planning and execution for properties.",
  labels=[("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-project", "aparium-dataflow"), ("dataplex-data-documentation-published-scan", "a8bae3a31-ed86-4ee9-a52b-26a682ea1908")]
);