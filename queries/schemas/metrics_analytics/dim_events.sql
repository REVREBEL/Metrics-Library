CREATE TABLE `devrebel-big-query-database.dev_hotel_analytics.dim_events`
(
  master_event_id STRING NOT NULL OPTIONS(description="Unique ID for the event type (e.g., 'ANNUAL_JAZZ_FEST'). Used to link year-over-year impact."),
  event_name STRING NOT NULL,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  property_code STRING NOT NULL OPTIONS(description="Hotel ID or 'ALL'"),
  category STRING NOT NULL,
  impact_level STRING NOT NULL,
  is_recurring BOOL DEFAULT TRUE,
  CONSTRAINT fk_cat FOREIGN KEY (category) REFERENCES `devrebel-big-query-database.dev_hotel_settings.lkp_events_category`(events_category) NOT ENFORCED,
  CONSTRAINT fk_imp FOREIGN KEY (impact_level) REFERENCES `devrebel-big-query-database.dev_hotel_settings.lkp_events_impact`(events_impact) NOT ENFORCED
);