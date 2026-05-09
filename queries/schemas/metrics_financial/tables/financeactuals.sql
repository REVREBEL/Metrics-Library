CREATE OR REPLACE TABLE `aparium-dataflow.FinanceData.FinanceActuals`
(
  row_id STRING OPTIONS(description="A unique identifier for each record in the table."),
  inserted_at TIMESTAMP OPTIONS(description="The timestamp when the record was inserted into the table."),
  index STRING OPTIONS(description="An identifier or categorization for the record."),
  snapshot_date DATE OPTIONS(description="The date when the financial data was captured."),
  property_code STRING OPTIONS(description="A unique code identifying a specific property."),
  property_name STRING OPTIONS(description="The name of the property."),
  finance_property_name STRING OPTIONS(description="The financial name associated with the property."),
  available_rms INT64 OPTIONS(description="The number of available rooms for a property."),
  gl_code STRING OPTIONS(description="The General Ledger code for a financial account."),
  account STRING OPTIONS(description="The name of the financial account."),
  segment_code STRING OPTIONS(description="A code identifying a specific financial segment."),
  segment_name STRING OPTIONS(description="The name of the financial segment."),
  metric STRING OPTIONS(description="The specific financial metric being reported."),
  total_year NUMERIC OPTIONS(description="The total financial value for the entire year."),
  month_01 NUMERIC OPTIONS(description="The financial value for the first month of the year."),
  month_02 NUMERIC OPTIONS(description="The financial value for the second month of the year."),
  month_03 NUMERIC OPTIONS(description="The financial value for the third month of the year."),
  month_04 NUMERIC OPTIONS(description="The financial value for the fourth month of the year."),
  month_05 NUMERIC OPTIONS(description="The financial value for the fifth month of the year."),
  month_06 NUMERIC OPTIONS(description="The financial value for the sixth month of the year."),
  month_07 NUMERIC OPTIONS(description="The financial value for the seventh month of the year."),
  month_08 NUMERIC OPTIONS(description="The financial value for the eighth month of the year."),
  month_09 NUMERIC OPTIONS(description="The financial value for the ninth month of the year."),
  month_10 NUMERIC OPTIONS(description="The financial value for the tenth month of the year."),
  month_11 NUMERIC OPTIONS(description="The financial value for the eleventh month of the year."),
  month_12 NUMERIC OPTIONS(description="The financial value for the twelfth month of the year."),
  quarter_01 NUMERIC OPTIONS(description="The financial value for the first quarter of the year."),
  quarter_02 NUMERIC OPTIONS(description="The financial value for the second quarter of the year."),
  quarter_03 NUMERIC OPTIONS(description="The financial value for the third quarter of the year."),
  quarter_04 NUMERIC OPTIONS(description="The financial value for the fourth quarter of the year."),
  finance_period STRING OPTIONS(description="The financial reporting period.")
)
OPTIONS(
  description="This table stores financial actuals data, providing a comprehensive view of financial performance. It captures detailed financial metrics across various properties and accounts. The table supports analysis of financial results over different time periods, including monthly, quarterly, and annual aggregations. It is used for tracking and reporting actual financial outcomes.",
  labels=[("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-project", "aparium-dataflow"), ("dataplex-data-documentation-published-scan", "a91afaa50-3fca-475e-87a5-a907a909b7a2")]
);