CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_Segment_MonthlyV` AS
WITH latest_snapshot AS (
  SELECT *
  FROM `aparium-dataflow.PaceData.PaceData_Segment`
  WHERE snapshot_date = (
    SELECT MAX(snapshot_date)
    FROM `aparium-dataflow.PaceData.PaceData_Segment`
  )
),
grouped AS (
  SELECT
    property_code,
    DATE_TRUNC(stay_date, MONTH) AS stay_month,

    CASE 
      WHEN segment IN (
        'Transient', 'Transient Consortia', 'Transient Government', 'Transient Negotiated',
        'Transient Opaque', 'Transient Package', 'Transient Packages', 'Transient Promotion',
        'Transient Qualified', 'Transient Retail', 'Transient Unqualified', 'Transient Wholesale'
      ) THEN 'Transient'
      
      WHEN segment IN (
        'Group', 'Group Association', 'Group Citywide', 'Group Corporate', 'Group Entertainment',
        'Group Government', 'Group SMERF', 'Group Social', 'Group Tour', 'Group Wedding'
      ) THEN 'Group'
      
      WHEN segment = 'Complimentary' THEN 'Complimentary'
      
      ELSE 'Other'
    END AS segment_group,

    rms_fct_cy,
    rms_fct_py,
    rev_fct_cy,
    rev_fct_py,
    rms_cy,
    rms_py,
    rms_stly,
    rms_st2y,
    rms_st19,
    rev_cy,
    rev_py,
    rev_stly,
    rev_st2y,
    rev_st19,
    bgt_rms_cy,
    bgt_rms_py,
    bgt_rev_cy,
    bgt_rev_py

  FROM latest_snapshot
)

SELECT
  property_code,
  stay_month,
  segment_group,

  SUM(rms_fct_cy) AS rms_fct_cy,
  SUM(rms_fct_py) AS rms_fct_py,
  SUM(rev_fct_cy) AS rev_fct_cy,
  SUM(rev_fct_py) AS rev_fct_py,

  SUM(rms_cy) AS rms_cy,
  SUM(rms_py) AS rms_py,
  SUM(rms_stly) AS rms_stly,
  SUM(rms_st2y) AS rms_st2y,
  SUM(rms_st19) AS rms_st19,

  SUM(rev_cy) AS rev_cy,
  SUM(rev_py) AS rev_py,
  SUM(rev_stly) AS rev_stly,
  SUM(rev_st2y) AS rev_st2y,
  SUM(rev_st19) AS rev_st19,

  SUM(bgt_rms_cy) AS bgt_rms_cy,
  SUM(bgt_rms_py) AS bgt_rms_py,
  SUM(bgt_rev_cy) AS bgt_rev_cy,
  SUM(bgt_rev_py) AS bgt_rev_py

FROM grouped

GROUP BY property_code, stay_month, segment_group
ORDER BY property_code, stay_month, segment_group;