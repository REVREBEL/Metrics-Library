
CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_PropertyV` AS
SELECT *
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY stay_date, property_code ORDER BY snapshot_date DESC) AS rn
  FROM `devrebel-big-query-database.Pace.Pace_Property`
)
WHERE rn = 1;



CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_SegmentV` AS
SELECT *
FROM `devrebel-big-query-database.Pace.Pace_Segment` p
WHERE snapshot_date = (
  SELECT MAX(snapshot_date)
  FROM `devrebel-big-query-database.Pace.Pace_Segment` sub
  WHERE sub.property_code = p.property_code
);



CREATE OR REPLACE VIEW `devrebel-big-query-database.Pace.Pace_RoomTypeV` AS
SELECT *
FROM `devrebel-big-query-database.Pace.Pace_RoomType` p
WHERE snapshot_date = (
  SELECT MAX(snapshot_date)
  FROM `devrebel-big-query-database.Pace.Pace_RoomType` sub
  WHERE sub.property_code = p.property_code
);

