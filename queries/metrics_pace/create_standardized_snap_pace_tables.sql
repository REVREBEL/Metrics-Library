-- BigQuery Standard SQL
-- Standardized snap pace table definitions for REVREBEL Metrics Library.
-- Replace PROJECT_ID.DATASET with the target BigQuery project and dataset.

CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.snap_pace_segment` (
  snap_date DATE OPTIONS(description="Date when the booking data snapshot was recorded."),
  date DATE OPTIONS(description="Stay date for which the booking, room, and revenue data applies."),
  property_code STRING OPTIONS(description="Unique property code used to join property-level facts, dimensions, and reporting tables."),
  property_name STRING OPTIONS(description="Name of the hotel property."),
  segment STRING OPTIONS(description="Market segment associated with the booking data."),

  rms_otb INT64 OPTIONS(description="Rooms on the books for the stay date as of the snapshot date."),
  rms_stly INT64 OPTIONS(description="Rooms on the books for the stay date at the same time last year."),
  rms_st2y INT64 OPTIONS(description="Rooms on the books for the stay date at the same time two years ago."),
  rms_ly INT64 OPTIONS(description="Actual rooms for the comparable prior-year stay date."),

  rev_otb FLOAT64 OPTIONS(description="Room revenue on the books for the stay date as of the snapshot date."),
  rev_stly FLOAT64 OPTIONS(description="Room revenue on the books for the stay date at the same time last year."),
  rev_st2y FLOAT64 OPTIONS(description="Room revenue on the books for the stay date at the same time two years ago."),
  rev_ly FLOAT64 OPTIONS(description="Actual room revenue for the comparable prior-year stay date."),

  rms_fct_rm INT64 OPTIONS(description="Rooms forecast from the revenue management system for the stay date."),
  rev_fct_rm FLOAT64 OPTIONS(description="Room revenue forecast from the revenue management system for the stay date."),
  rms_fct INT64 OPTIONS(description="Overall forecasted rooms for the stay date."),
  rev_fct FLOAT64 OPTIONS(description="Overall forecasted room revenue for the stay date."),
  rms_bgt INT64 OPTIONS(description="Budgeted rooms for the stay date."),
  rev_bgt FLOAT64 OPTIONS(description="Budgeted room revenue for the stay date."),

  cx_rms INT64 OPTIONS(description="Cancelled rooms for the stay date."),
  cx_rms_ly INT64 OPTIONS(description="Cancelled rooms for the comparable prior-year stay date."),
  ns_rms INT64 OPTIONS(description="No-show rooms for the stay date."),
  ns_rms_ly INT64 OPTIONS(description="No-show rooms for the comparable prior-year stay date.")
)
OPTIONS(
  description="Standardized segment-level pace snapshot table. Grain: property_code, snap_date, date, segment."
);


CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.snap_pace_roomtype` (
  property_code STRING OPTIONS(description="Unique property code used to join property-level facts, dimensions, and reporting tables."),
  property_name STRING OPTIONS(description="Name of the hotel property."),
  date DATE OPTIONS(description="Stay date for which the roomtype, room, and revenue data applies."),
  roomtype STRING OPTIONS(description="Specific room type being tracked."),
  roomclass STRING OPTIONS(description="Room class or category associated with the room type."),
  snap_date DATE OPTIONS(description="Date when the booking data snapshot was recorded."),

  available_rms INT64 OPTIONS(description="Available room inventory for the room type and stay date."),
  rms_otb INT64 OPTIONS(description="Rooms on the books for the stay date as of the snapshot date."),
  rms_stly INT64 OPTIONS(description="Rooms on the books for the stay date at the same time last year."),
  rms_st2y INT64 OPTIONS(description="Rooms on the books for the stay date at the same time two years ago."),
  rms_ly INT64 OPTIONS(description="Actual rooms for the comparable prior-year stay date."),
  rms_fct INT64 OPTIONS(description="Forecasted rooms for the stay date."),
  adr_fct FLOAT64 OPTIONS(description="Forecasted average daily rate for the stay date."),

  rev_otb FLOAT64 OPTIONS(description="Room revenue on the books for the stay date as of the snapshot date."),
  rev_stly FLOAT64 OPTIONS(description="Room revenue on the books for the stay date at the same time last year."),
  rev_st2y FLOAT64 OPTIONS(description="Room revenue on the books for the stay date at the same time two years ago."),
  rev_ly FLOAT64 OPTIONS(description="Actual room revenue for the comparable prior-year stay date."),
  rev_fct FLOAT64 OPTIONS(description="Forecasted room revenue for the stay date."),

  cx_rms INT64 OPTIONS(description="Cancelled rooms for the stay date."),
  cx_rms_ly INT64 OPTIONS(description="Cancelled rooms for the comparable prior-year stay date."),
  ns_rms INT64 OPTIONS(description="No-show rooms for the stay date."),
  ns_rms_ly INT64 OPTIONS(description="No-show rooms for the comparable prior-year stay date.")
)
OPTIONS(
  description="Standardized roomtype-level pace snapshot table. Grain: property_code, snap_date, date, roomtype."
);


CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.snap_pace_property` (
  property_code STRING OPTIONS(description="Unique property code used to join property-level facts, dimensions, and reporting tables."),
  property_name STRING OPTIONS(description="Name of the hotel property."),
  date DATE OPTIONS(description="Stay date for which the property-level demand, room, revenue, and pricing data applies."),
  special_events STRING OPTIONS(description="Special event notes or indicators for the stay date."),
  special_events_ly STRING OPTIONS(description="Special event notes or indicators for the comparable prior-year stay date."),

  available_rms INT64 OPTIONS(description="Available room inventory for the property and stay date."),
  available_rms_ly INT64 OPTIONS(description="Available room inventory for the comparable prior-year stay date."),

  demand_total INT64 OPTIONS(description="Total demand for the property and stay date."),
  demand_total_ly INT64 OPTIONS(description="Total demand for the comparable prior-year stay date."),
  demand_group INT64 OPTIONS(description="Group demand for the property and stay date."),
  demand_group_ly INT64 OPTIONS(description="Group demand for the comparable prior-year stay date."),
  demand_transient INT64 OPTIONS(description="Transient demand for the property and stay date."),
  demand_transient_ly INT64 OPTIONS(description="Transient demand for the comparable prior-year stay date."),

  lrv FLOAT64 OPTIONS(description="Last room value for the property and stay date."),
  wash_pct FLOAT64 OPTIONS(description="Wash percentage for the property and stay date."),
  wash_pct_ly FLOAT64 OPTIONS(description="Wash percentage for the comparable prior-year stay date."),
  bar_price FLOAT64 OPTIONS(description="Best available rate price for the property and stay date."),
  snap_date DATE OPTIONS(description="Date when the booking data snapshot was recorded.")
)
OPTIONS(
  description="Standardized property-level pace snapshot table. Grain: property_code, snap_date, date."
);
