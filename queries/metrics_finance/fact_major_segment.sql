-- CREATE PROPERTY ACTUALS SOURCE TABLE

CREATE OR REPLACE TABLE `revrebel-metrics.metrics_actual.fact_major_segment`(
  property_code STRING OPTIONS(description="A unique identifier for each property."),
  property_name STRING OPTIONS(description="The name of the property."),
  stay_date DATE OPTIONS(description="The specific date for which the metrics are recorded."),
  special_events STRING OPTIONS(description="Information about special events occurring on the stay date."),
  available_rooms INT64 OPTIONS(description="The total number of rooms that were available for booking."),
 
  rooms_actual INT64 OPTIONS(description="The actualized number of rooms for the stay date."),
  rev_actual FLOAT64 OPTIONS(description="The actualized room revenue for the stay date."),

  transient_rooms_actual INT64 OPTIONS(description="The actualized number of transient rooms for the stay date."),
  transient_rev_actual FLOAT64 OPTIONS(description="The actualized transient revenue for the stay date."),
 
  group_rooms_actual INT64 OPTIONS(description="The actualized number of group rooms for the stay date."),
  group_rev_actual FLOAT64 OPTIONS(description="The actualized group revenue for the stay date."),

  ooo_rooms INT64 OPTIONS(description="The number of out-of-order rooms for the stay date."),

  wash_pct FLOAT64 OPTIONS(description="The percentage of rooms that washed for the stay date.."),
)
PARTITION BY stay_date
OPTIONS(
  description="This table captures final daily operational metrics for the property. It provides an actualized value for final room availability, rooms booked, and revenue figures. The data supports analysis of the hotels performance for a given stay date, aiding in forecasting and strategic decision-making based on historical performance for individual properties."
);