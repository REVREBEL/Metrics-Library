SELECT 
    ARRAY_AGG(DISTINCT snapshot_date) AS unique_snapshot_dates,

    ARRAY_AGG(DISTINCT COALESCE( segment, 'Unknown')) AS unique_segments,

    MIN(stay_date) AS min_occ_date,
    MAX(stay_date) AS max_occ_date

FROM `aparium-dataflow.PaceData.PaceData_Segment`;