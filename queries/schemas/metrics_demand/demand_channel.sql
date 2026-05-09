CREATE TABLE `devrebel-big-query-database.Demand.Demand_Channel`
(
  property_code STRING OPTIONS(description="Property code"),
  property_name STRING OPTIONS(description="Property name"),
  d360_channel STRING OPTIONS(description="Filters data for metrics like consumed revenue, room nights, and other key statistics based on the Demand360 Channel. A Channel represents a grouping of sources, providing a broader perspective, such as the GDS System, Online Travel Agents, or direct bookings at the hotel."),
  month_year STRING OPTIONS(description="Month and year"),
  cy INT64 OPTIONS(description="Current year"),
  weekday STRING OPTIONS(description="Weekday"),
  dow STRING OPTIONS(description="Day of week"),
  stay_date DATE OPTIONS(description="Filters the information and consumed revenue and other metrics based on the guest's stay dates."),
  occ FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  cs_occ FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  occ_index FLOAT64 OPTIONS(description="Occupancy index measures a hotel's occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  occ_rank STRING OPTIONS(description="Occupancy Rank, show the hotel's ranking position for Occupancy compared to its competitive set. A lower number (e.g., 1) indicates a higher ADR than peers."),
  occ_index_var_py FLOAT64 OPTIONS(description="Occupancy Index Varaince, shows the variance in the hotel's occupancy index which measures a occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  occ_index_chg_pw FLOAT64 OPTIONS(description="Occupancy Index Change from Prior Week, shows the change in the hotel's occupancy index from prior week which measures a occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  rms INT64 OPTIONS(description="Competitor number of rooms"),
  rms_pct_var_py FLOAT64 OPTIONS(description="Percentage change in the total number of rooms on the books"),
  cs_rms_pct_var_py FLOAT64 OPTIONS(description="Percentage change in the total number of rooms on the books"),
  rms_chg_pw FLOAT64 OPTIONS(description="Change in the total number of rooms on the books from the prior week."),
  rms_pct_chg_pw FLOAT64 OPTIONS(description="Percentage change in the total number of rooms on the books from the prior week."),
  cs_rms_pct_chg_pw FLOAT64 OPTIONS(description="Percentage change in the total number of rooms on the books from the prior week."),
  adr FLOAT64 OPTIONS(description="Average Dollar Rate (ADR) represents the average income generated per room sold during a given timeframe. It is determined by dividing the total room revenue by the number of rooms sold."),
  adr_rank STRING OPTIONS(description="ADR Rank shows the hotel's ranking position in terms of Average Daily Rate (ADR) compared to its competitive set. It reflects whether the hotel is securing a higher or lower position relative to its competitors"),
  month INT64 OPTIONS(description="Month of the year"),
  revpar FLOAT64 OPTIONS(description="Competitive set revenue per available room"),
  revpar_rank STRING OPTIONS(description="RevPAR Rank, show the hotel's ranking position for revpar compared to its competitive set. A lower number (e.g., 1) indicates a higher revpar than peers."),
  cs_set_id STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other metrics based on the Competitive Set Identifier."),
  physical_capacity INT64 OPTIONS(description="The total number of rooms available for sale represents the property's fixed maximum inventory. This count excludes any rooms that are out of order."),
  cs_physical_capacity INT64 OPTIONS(description="The total number of rooms available for sale represents the property's fixed maximum inventory. This count excludes any rooms that are out of order."),
  channel_group_code STRING OPTIONS(description="Filters data for metrics such as consumed revenue, room nights, and other essential statistics organized by Channel. A Channel group represents the primary classification of booking sources, categorized by business type, including CRS, PMS, or Group Sales."),
  channel_group STRING OPTIONS(description="Filters data for metrics such as consumed revenue, room nights, and other essential statistics organized by Channel. A Channel group represents the primary classification of booking sources, categorized by business type, including CRS, PMS, or Group Sales."),
  source_group_code STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other essential metrics based on the Source Group. Sources refer to the main channel, platform, or method used to make a hotel reservation."),
  source_group STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other essential metrics based on the Source Group. Sources refer to the main channel, platform, or method used to make a hotel reservation."),
  property_shortname STRING OPTIONS(description="Property names abbreviated within charts and graphs when space constraints prevent the display of longer names."),
  source_code STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other essential metrics based on the Source. Sources refer to the main channel, platform, or method used to make a hotel reservation."),
  source STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other essential metrics based on the Source. Sources refer to the main channel, platform, or method used to make a hotel reservation."),
  channel_sort INT64 OPTIONS(description="Used to control the sorting of dimensions within channels"),
  cs_demand_id STRING OPTIONS(description="Demand360 property id"),
  snapshot_date DATE OPTIONS(description="Filters the date in which the data was collected."),
  ingested_timestamp TIMESTAMP OPTIONS(description="Datetime of data ingestion"),
  sent_to_big_query BOOL OPTIONS(description="Sent to big query"),
  date_sent_to_big_query TIMESTAMP OPTIONS(description="Date when the data was sent to biq query")
)
PARTITION BY stay_date
CLUSTER BY property_code, snapshot_date
OPTIONS(
  partition_expiration_days=60.0
);