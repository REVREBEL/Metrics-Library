-- ----------------------------------------------------------------
-- MATERIALIZED VIEW: PaceData_SegmentFilteredRecordMV
-- ----------------------------------------------------------------
-- Identifies the latest ingested_timestamp for each snapshot record 
-- grouped by property_code, segment, stay_date, and snapshot_date

CREATE OR REPLACE MATERIALIZED VIEW `devrebel-big-query-database.Pace.Pace_SegmentFilteredRecordMV`
AS
SELECT
  property_code,
  segment,
  stay_date,
  snapshot_date,
  MAX(ingested_timestamp) AS latest_ingested_timestamp
FROM `devrebel-big-query-database.Pace.Pace_Segment`
GROUP BY property_code, segment, stay_date, snapshot_date;



-- ----------------------------------------------------------------
-- VIEW: PaceData_SegmentV
-- ----------------------------------------------------------------
-- Expands filtered materialized view by joining back to the full table,
-- restoring all columns but keeping only the most recently ingested rows per snapshot

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentV` AS
SELECT s.*
FROM `devrebel-big-query-database.Pace.Pace_Segment` AS s
JOIN `devrebel-big-query-database.Pace.Pace_SegmentFilteredRecordMV` AS mv
  ON s.property_code = mv.property_code
 AND s.segment = mv.segment
 AND s.stay_date = mv.stay_date
 AND s.snapshot_date = mv.snapshot_date
 AND s.ingested_timestamp = mv.latest_ingested_timestamp;



-- ----------------------------------------------------------------
-- VIEW: PaceData_SegmentV_LatestSnapshotV
-- ----------------------------------------------------------------
-- Returns only the latest snapshot_date per stay_date and property_code

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentV_LatestSnapshotV` AS
SELECT *
FROM `devrebel-big-query-database.Pace.Pace_SegmentV`
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY stay_date, property_code, segment
  ORDER BY snapshot_date DESC
) = 1;


-- ----------------------------------------------------------------
-- VIEW: PaceData_SegmentV_MonthlyV
-- ----------------------------------------------------------------
-- Create summuaried monthly-level table from the Pace_Segment data

CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentV_MonthlyV` AS
SELECT 
  *,
  DATE_TRUNC(stay_date, MONTH) AS stay_month
FROM `devrebel-big-query-database.Pace.Pace_SegmentV_LatestSnapshotV`;