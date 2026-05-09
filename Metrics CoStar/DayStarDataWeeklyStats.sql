CREATE OR REPLACE TABLE `aparium-dataflow.starData.WeeklyCompsetRevenue` AS
SELECT 
    EXTRACT(WEEK FROM t0.period) AS week_number,
    cset.compset_no,
    cset.property_code,

    -- 🆕 Compute weekly total rooms sold
    SUM(ROUND(cset.total_rooms * (t0.occ / 100))) AS weekly_total_rooms_sold,
    SUM(ROUND(cset.total_compset_rooms * (t0.compset_occ / 100))) AS weekly_total_compset_rooms_sold,

    -- 🆕 Compute weekly total revenue
    SUM(ROUND((cset.total_rooms * (t0.occ / 100)) * t0.adr)) AS weekly_total_revenue,
    SUM(ROUND((cset.total_compset_rooms * (t0.compset_occ / 100)) * t0.compset_adr)) AS weekly_total_compset_revenue

FROM `aparium-dataflow.starData.DayStarDataLive` AS t0
LEFT JOIN `aparium-dataflow.starData.CompSetDataMV` AS cset 
    ON t0.compset_no = cset.compset_no 
    AND t0.property_code = cset.property_code
GROUP BY week_number, cset.compset_no, cset.property_code;