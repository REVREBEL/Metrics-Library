CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.snap_pace_roomtype`
(
  property_code STRING OPTIONS(description="The unique identifier for a specific hotel property."),
  property_name STRING OPTIONS(description="The name of the hotel property."),
  stay_date DATE OPTIONS(description="The date for which the room and revenue data applies."),
  roomtype STRING OPTIONS(description="The specific type of room being tracked."),
  roomclass STRING OPTIONS(description="The classification or category of the room type."),
  snapshot_date DATE OPTIONS(description="The date when the data snapshot was taken."),
  available_rooms INT64 OPTIONS(description="The number of rooms currently available for booking."),
  rooms_otb INT64 OPTIONS(description="The number of rooms On The Books (booked) for the stay date."),
  rooms_stly INT64 OPTIONS(description="The number of rooms booked for the same stay date last year."),
  rooms_st2y INT64 OPTIONS(description="The number of rooms booked for the same stay date two years ago."),
  rooms_ly_actual INT64 OPTIONS(description="The actual number of rooms booked for the same stay date last year."),
  rooms_forecast INT64 OPTIONS(description="The forecasted number of rooms expected to be booked."),
  adr_forecast FLOAT64 OPTIONS(description="The forecasted Average Daily Rate (ADR) for the rooms."),
  rev_otb FLOAT64 OPTIONS(description="The revenue On The Books (booked) for the stay date."),
  rev_stly FLOAT64 OPTIONS(description="The revenue booked for the same stay date last year."),
  rev_st2y FLOAT64 OPTIONS(description="The revenue booked for the same stay date two years ago."),
  rev_ly_actual FLOAT64 OPTIONS(description="The actual revenue booked for the same stay date last year."),
  rev_forecast FLOAT64 OPTIONS(description="The forecasted revenue expected."),
  cancelled_rooms INT64 OPTIONS(description="The number of rooms that have been cancelled."),
  cancelled_rooms_ly_actual INT64 OPTIONS(description="The actual number of rooms cancelled for the same stay date last year."),
  noshow_rooms INT64 OPTIONS(description="The number of rooms for which guests did not arrive."),
  noshow_rooms_ly_actual INT64 OPTIONS(description="The actual number of no-show rooms for the same stay date last year.")
)
OPTIONS(
  description="This table captures daily snapshots of hotel room inventory and revenue pacing data. It provides historical and forecasted metrics for room availability, bookings, and financial performance. The data supports analysis of booking trends, revenue management, and operational planning for different room types. It enables tracking of performance against previous years and future projections.",
  labels=[("dataplex-data-documentation-published-location", "us-central1"), ("dataplex-data-documentation-published-project", "devrebel-big-query-database"), ("dataplex-data-documentation-published-scan", "a3421d9b0-481f-439a-887c-8d23471dd322")]
);