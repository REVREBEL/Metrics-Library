
CREATE OR REPLACE VIEW `aparium-dataflow.starData.DayStarDataLiveView` AS
SELECT
    t0.compset_no,
    t0.period,
    t0.property_code,
    t0.occ,
    t0.adr,
    t0.compset_occ,
    t0.compset_adr,
    cset.total_compset_rooms,
    cset.total_rooms,

    -- Compute week number from the period
    EXTRACT(WEEK FROM t0.period) AS week_number,

    -- Compute total rooms sold (rounded)
    ROUND(cset.total_rooms * (t0.occ / 100)) AS total_rooms_sold,
    ROUND(cset.total_compset_rooms * (t0.compset_occ / 100)) AS total_compset_rooms_sold,

    -- Compute total revenue
    ROUND((cset.total_rooms * (t0.occ / 100)) * t0.adr) AS total_revenue,
    ROUND((cset.total_compset_rooms * (t0.compset_occ / 100)) * t0.compset_adr) AS total_compset_revenue

FROM `aparium-dataflow.starData.DayStarDataLive` AS t0
LEFT JOIN `aparium-dataflow.starData.CompSetDataMV` AS cset 
    ON t0.compset_no = cset.compset_no 
    AND t0.property_code = cset.property_code;