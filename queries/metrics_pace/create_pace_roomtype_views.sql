-- ----------------------------------------------------------------
-- MATERIALIZED VIEW: PaceData_RoomTypeFilteredRecordMV
-- ----------------------------------------------------------------
-- Identifies the latest ingested_timestamp for each snapshot record 
-- grouped by property_code, roomtype, stay_date, and snapshot_date

CREATE OR REPLACE MATERIALIZED VIEW `devrebel-big-query-database.Pace.Pace_RoomTypeFilteredRecordMV`
AS
SELECT
  property_code,
  roomtype,
  stay_date,
  snapshot_date,
  MAX(ingested_timestamp) AS latest_ingested_timestamp
FROM `devrebel-big-query-database.Pace.Pace_RoomType`
GROUP BY property_code, roomtype, stay_date, snapshot_date;



-- ----------------------------------------------------------------
-- VIEW: PaceData_RoomTypeV
-- ----------------------------------------------------------------
-- Expands filtered materialized view by joining back to the full table,
-- restoring all columns but keeping only the most recently ingested rows per snapshot

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_RoomTypeV` AS
SELECT s.*
FROM `devrebel-big-query-database.Pace.Pace_RoomType` AS s
JOIN `devrebel-big-query-database.Pace.Pace_RoomTypeFilteredRecordMV` AS mv
  ON s.property_code = mv.property_code
 AND s.roomtype = mv.roomtype
 AND s.stay_date = mv.stay_date
 AND s.snapshot_date = mv.snapshot_date
 AND s.ingested_timestamp = mv.latest_ingested_timestamp;



-- ----------------------------------------------------------------
-- VIEW: PaceData_RoomTypeV_LatestSnapshotV
-- ----------------------------------------------------------------
-- Returns only the latest snapshot_date per stay_date and property_code

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_RoomTypeV_LatestSnapshotV` AS
SELECT *
FROM `devrebel-big-query-database.Pace.Pace_RoomTypeV`
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY stay_date, property_code, roomtype
  ORDER BY snapshot_date DESC
) = 1;


-- ----------------------------------------------------------------
-- VIEW: PaceData_RoomTypeV_MonthlyV
-- ----------------------------------------------------------------
-- Create summuaried monthly-level table from the Pace_roomtype data

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_RoomTypeV_MonthlyV` AS
SELECT 
  *,
  DATE_TRUNC(stay_date, MONTH) AS stay_month
FROM `devrebel-big-query-database.Pace.Pace_RoomTypeV_LatestSnapshotV`;