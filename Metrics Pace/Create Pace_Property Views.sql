-- ----------------------------------------------------------------
-- MATERIALIZED VIEW: Pace_PropertyFilteredRecordMV
-- ----------------------------------------------------------------

CREATE OR REPLACE MATERIALIZED VIEW `devrebel-big-query-database.Pace.Pace_PropertyFilteredRecordMV`
AS
SELECT
  property_code,
  stay_date,
  snapshot_date,
  MAX(ingested_timestamp) AS latest_ingested_timestamp
FROM `devrebel-big-query-database.Pace.Pace_Property`
GROUP BY property_code, stay_date, snapshot_date;



-- ----------------------------------------------------------------
-- VIEW: Pace_PropertyV
-- ----------------------------------------------------------------

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_PropertyV` AS
SELECT s.*
FROM `devrebel-big-query-database.Pace.Pace_Property` AS s
JOIN `devrebel-big-query-database.Pace.Pace_PropertyFilteredRecordMV` AS mv
  ON s.property_code = mv.property_code
 AND s.stay_date = mv.stay_date
 AND s.snapshot_date = mv.snapshot_date
 AND s.ingested_timestamp = mv.latest_ingested_timestamp;



-- ----------------------------------------------------------------
-- VIEW: Pace_PropertyV_LatestSnapshotV
-- ----------------------------------------------------------------

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_PropertyV_LatestSnapshotV` AS
SELECT *
FROM `devrebel-big-query-database.Pace.Pace_PropertyV`
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY stay_date, property_code
  ORDER BY snapshot_date DESC
) = 1;
