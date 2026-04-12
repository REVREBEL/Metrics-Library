CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_Segment_014DayV` AS

WITH LatestSnapshot AS (
  SELECT 
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM `aparium-dataflow.PaceData.PaceData_SegmentV`
  GROUP BY property_code
),

-- Get latest ingested_timestamp for each row on the latest snapshot date
FilteredLatestSnapshot AS (
  SELECT *
  FROM (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY property_code, snapshot_date, segment, stay_date
        ORDER BY ingested_timestamp DESC
      ) AS rn
    FROM `aparium-dataflow.PaceData.PaceData_SegmentV`
  )
  WHERE rn = 14
),

CurrentSnapshot AS (
  SELECT 
    s.property_code,
    s.segment,
    s.segment_sort,
    s.segment_group,
    s.segment_code,
    s.finance_segment,
    s.segment_group_code,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM FilteredLatestSnapshot s
  INNER JOIN LatestSnapshot l
    ON s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date
),

PriorSnapshot_14d AS (
  SELECT 
    *
  FROM (
    SELECT *,
      ROW_NUMBER() OVER (
        PARTITION BY property_code, snapshot_date, segment, stay_date
        ORDER BY ingested_timestamp DESC
      ) AS rn
    FROM `aparium-dataflow.PaceData.PaceData_Segment`
  )
  WHERE rn = 14
)

SELECT
  curr.property_code,
  curr.segment,
  curr.segment_sort,
  curr.segment_group,
  curr.segment_code,
  curr.finance_segment,
  curr.segment_group_code,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,

  prior.snapshot_date AS pickup_reference_date_14d,
  curr.rms - prior.rms AS rms_pickup_14d,
  curr.rev - prior.rev AS rev_pickup_14d

FROM CurrentSnapshot curr

LEFT JOIN PriorSnapshot_14d prior
  ON curr.property_code = prior.property_code
  AND curr.segment = prior.segment
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 14 DAY)

ORDER BY curr.stay_date ASC