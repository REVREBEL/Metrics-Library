CREATE TABLE `devrebel-big-query-database.Demand.Demand_Property`
(
  property_code STRING OPTIONS(description="Property code"),
  property_name STRING OPTIONS(description="Property name"),
  property_shortname STRING OPTIONS(description="Property names abbreviated within charts and graphs when space constraints prevent the display of longer names."),
  cs_set_id STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other metrics based on the Competitive Set Identifier."),
  stay_date DATE OPTIONS(description="Filters the information and consumed revenue and other metrics based on the guest's stay dates."),
  segment STRING OPTIONS(description="Filters values for consumed revenue, room nights, and other metrics based on the Market Segment. These segments are categorized by shared characteristics such as the type of rate, room type, and the booking channel used by the guest."),
  occ FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  occ_chg_pw FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  occ_var_py FLOAT64 OPTIONS(description="Occupancy Variance, a comparison of the percentage of available rooms sold during a specific timeframe, based on the chosen comparison metric"),
  cs_occ FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  cs_occ_chg_pw FLOAT64 OPTIONS(description="Total Occupancy, showing the percentage of available rooms that have been sold during a specific timeframe."),
  cs_occ_var_py FLOAT64 OPTIONS(description="Occupancy Variance, a comparison of the percentage of available rooms sold during a specific timeframe, based on the chosen comparison metric"),
  occ_index FLOAT64 OPTIONS(description="Occupancy index measures a hotel's occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  occ_index_chg_pw FLOAT64 OPTIONS(description="Occupancy Index Change from Prior Week, shows the change in the hotel's occupancy index from prior week which measures a occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  occ_index_var_py FLOAT64 OPTIONS(description="Occupancy Index Varaince, shows the variance in the hotel's occupancy index which measures a occupancy performance relative to its competitive set. It shows whether a hotel is achieving a higher or lower average rate compared to its peers."),
  occ_rank STRING OPTIONS(description="Occupancy Rank, show the hotel's ranking position for Occupancy compared to its competitive set. A lower number (e.g., 1) indicates a higher ADR than peers."),
  adr FLOAT64 OPTIONS(description="ADR represents the average income generated per room sold during a given timeframe. It is determined by dividing the total room revenue by the number of rooms sold."),
  adr_var_py FLOAT64 OPTIONS(description="ADR variance prior year: the variance in the average dollar rate compared to the prior year."),
  cs_adr FLOAT64 OPTIONS(description="ADR represents the average income generated per room sold during a given timeframe. It is determined by dividing the total room revenue by the number of rooms sold."),
  cs_adr_var_py FLOAT64 OPTIONS(description="ADR variance prior year: the variance in the average dollar rate compared to the prior year."),
  adr_rank STRING OPTIONS(description="ADR Rank shows the hotel's ranking position in terms of Average Daily Rate (ADR) compared to its competitive set. It reflects whether the hotel is securing a higher or lower position relative to its competitors"),
  adr_rank_py STRING OPTIONS(description="ADR Rank shows the hotel's ranking position in terms of Average Daily Rate (ADR) compared to its competitive set. It reflects whether the hotel is securing a higher or lower position relative to its competitors"),
  revpar_rank STRING OPTIONS(description="RevPAR Rank, show the hotel's ranking position for revpar compared to its competitive set. A lower number (e.g., 1) indicates a higher revpar than peers."),
  revpar_rank_py STRING OPTIONS(description="RevPAR Rank, show the hotel's ranking position for revpar compared to its competitive set. A lower number (e.g., 1) indicates a higher revpar than peers."),
  physical_capacity INT64 OPTIONS(description="The total number of rooms available for sale represents the property's fixed maximum inventory. This count excludes any rooms that are out of order."),
  cs_physical_capacity INT64 OPTIONS(description="The total number of rooms available for sale represents the property's fixed maximum inventory. This count excludes any rooms that are out of order."),
  month INT64 OPTIONS(description="Month of the year"),
  month_year STRING OPTIONS(description="Month and year"),
  cy INT64 OPTIONS(description="Current year"),
  weekday STRING OPTIONS(description="Weekday"),
  dow STRING OPTIONS(description="Day of week"),
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