CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_Segment_060DayV` AS

WITH LatestSnapshot AS (
  SELECT 
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM `aparium-dataflow.PaceData.PaceData_Segment`
  GROUP BY property_code
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
    s.rms_cy,
    s.rev_cy
  FROM `aparium-dataflow.PaceData.PaceData_Segment` s
  INNER JOIN LatestSnapshot l
    ON s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date
),

PriorSnapshot_60d AS (
  SELECT 
    s.property_code,
    s.segment,
    s.stay_date,
    s.snapshot_date,
    s.rms_cy,
    s.rev_cy
  FROM `aparium-dataflow.PaceData.PaceData_Segment` s
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
  curr.rms_cy,
  curr.rev_cy,

  prior.snapshot_date AS pickup_reference_date_60d,
  curr.rms_cy - prior.rms_cy AS rms_cy_pickup_60d,
  curr.rev_cy - prior.rev_cy AS rev_cy_pickup_60d

FROM CurrentSnapshot curr

LEFT JOIN PriorSnapshot_60d prior
  ON curr.property_code = prior.property_code
  AND curr.segment = prior.segment
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 60 DAY)

ORDER BY
  curr.stay_date ASC