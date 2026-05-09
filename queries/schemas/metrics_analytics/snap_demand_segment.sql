CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.snap_demand_segment`
(
  property_code STRING OPTIONS(description="Unique code for the hotel property."),
  snapshot_date DATE OPTIONS(description="The date when the report was generated or data was snapshotted."),
  stay_date DATE OPTIONS(description="The stay date or 'day' for which the metrics apply."),
  segment STRING OPTIONS(description="The market segment (e.g., Transient, Group, Contract)."),
  compset_no STRING OPTIONS(description="Competitive set number (e.g., 'Set1', 'Set2') derived from filename."),
  data_period STRING OPTIONS(description="Indicates if the data is 'current_year' or 'prior_year_inferred'."),
  property_available_rooms INT64 OPTIONS(description="Total available rooms for the hotel for the given date."),
  property_rooms INT64 OPTIONS(description="Number of rooms sold for the hotel."),
  property_rev NUMERIC OPTIONS(description="Total room revenue for the hotel."),
  compset_available_rooms INT64 OPTIONS(description="Total available rooms for the competitive set."),
  compset_rooms INT64 OPTIONS(description="Number of rooms sold for the competitive set."),
  compset_rev NUMERIC OPTIONS(description="Total room revenue for the competitive set."),
  property_rooms_wow INT64 OPTIONS(description="Property rooms sold Week-over-Week."),
  compset_rooms_wow INT64 OPTIONS(description="Compset rooms sold Week-over-Week."),
  property_rooms_yoy INT64 OPTIONS(description="Property rooms sold Year-over-Year."),
  compset_rooms_yoy INT64 OPTIONS(description="Compset rooms sold Year-over-Year."),
  occ_rank STRING OPTIONS(description="Occupancy Rank."),
  adr_rank STRING OPTIONS(description="Average Daily Rate Rank."),
  revpar_rank STRING OPTIONS(description="Revenue Per Available Room Rank.")
)
PARTITION BY snapshot_date
CLUSTER BY segment;