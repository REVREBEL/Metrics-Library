

CREATE OR REPLACE VIEW  `aparium-dataflow.StarData.8_WeeksRollingMetricsV` AS

WITH WeeklyAggregatedData AS (
    -- ✅ Aggregate weekly totals from `DayStar` using Sunday-Saturday weeks
    SELECT 
        cy,
        cs_no,
        property_code,
        week_no,

        -- ✅ Calculate the calendar week starting on Sunday
        DATE_TRUNC(stay_date, WEEK(SUNDAY)) AS week_start_date,  -- First day (Sunday)
        DATE_ADD(DATE_TRUNC(stay_date, WEEK(SUNDAY)), INTERVAL 6 DAY) AS week_end_date,  -- Last day (Saturday)

        -- ✅ Weekly Totals
        SUM(rms_sold) AS rms_sold_wk,
        SUM(rms_sold_py) AS rms_sold_py_wk,
        SUM(available_rms_day) AS available_rms_wk,
        SUM(cs_rms_sold) AS cs_rms_sold_wk,
        SUM(cs_rms_sold_py) AS cs_rms_sold_py_wk,
        SUM(cs_available_rms_day) AS cs_available_rms_wk,
        SUM(rev) AS rms_rev_wk,
        SUM(rev_py) AS rms_rev_py_wk,
        SUM(cs_rev) AS cs_rev_wk,
        SUM(cs_rev_py) AS cs_rev_py_wk,
        MIN(py) AS py,

        -- ✅ ADR (Average Daily Rate)
        SAFE_DIVIDE(SUM(rev), SUM(rms_sold)) AS adr_wk,
        SAFE_DIVIDE(SUM(rev_py), SUM(rms_sold_py)) AS adr_py_wk,

        -- ✅ Competitor Set ADR
        SAFE_DIVIDE(SUM(cs_rev), SUM(cs_rms_sold)) AS cs_adr_wk,
        SAFE_DIVIDE(SUM(cs_rev_py), SUM(cs_rms_sold_py)) AS cs_adr_py_wk,

        -- ✅ Occupancy Rate
        SAFE_DIVIDE(SUM(rms_sold), SUM(available_rms_day)) AS occ_wk,
        SAFE_DIVIDE(SUM(rms_sold_py), SUM(available_rms_day)) AS occ_py_wk,

        -- ✅ Competitor Set Occupancy
        SAFE_DIVIDE(SUM(cs_rms_sold), SUM(cs_available_rms_day)) AS cs_occ_wk,
        SAFE_DIVIDE(SUM(cs_rms_sold_py), SUM(cs_available_rms_day)) AS cs_occ_py_wk,

        -- ✅ RevPAR (Revenue Per Available Room)
        SAFE_DIVIDE(SUM(rev), SUM(available_rms_day)) AS revpar_wk,
        SAFE_DIVIDE(SUM(rev_py), SUM(available_rms_day)) AS revpar_py_wk,

        -- ✅ Competitor Set RevPAR
        SAFE_DIVIDE(SUM(cs_rev), SUM(cs_available_rms_day)) AS cs_revpar_wk,
        SAFE_DIVIDE(SUM(cs_rev_py), SUM(cs_available_rms_day)) AS cs_revpar_py_wk

    FROM `aparium-dataflow.StarData.DayStar`
    GROUP BY property_code, cs_no, cy, week_no, week_start_date, week_end_date
),

RecentSaturday AS (
    -- ✅ Find the most recent Saturday in the dataset
    SELECT MAX(stay_date) AS recent_saturday
    FROM `aparium-dataflow.StarData.DayStar`
    WHERE EXTRACT(DAYOFWEEK FROM stay_date) = 7  -- Ensures it's a Saturday
),

FilteredWeeklyRoomSupply AS (
    -- ✅ Filter the last 8 full Sunday-Saturday weeks
    SELECT w.*
    FROM WeeklyAggregatedData w
    JOIN RecentSaturday rs
    ON w.week_end_date BETWEEN DATE_SUB(rs.recent_saturday, INTERVAL 8 WEEK) 
                          AND rs.recent_saturday
),

FinalMetrics AS (
    -- ✅ Compute Performance Indexes before applying percentage change
SELECT
    w.*,  -- ✅ This already includes week_no

    -- ✅ Performance Indexes
    SAFE_DIVIDE(w.occ_wk, w.cs_occ_wk) AS occ_index_wk,
    SAFE_DIVIDE(w.adr_wk, w.cs_adr_wk) AS adr_index_wk,
    SAFE_DIVIDE(w.revpar_wk, w.cs_revpar_wk) AS revpar_index_wk,

    SAFE_DIVIDE(w.occ_py_wk, w.cs_occ_py_wk) AS occ_index_py_wk,
    SAFE_DIVIDE(w.adr_py_wk, w.cs_adr_py_wk) AS adr_index_py_wk,
    SAFE_DIVIDE(w.revpar_py_wk, w.cs_revpar_py_wk) AS revpar_index_py_wk

FROM FilteredWeeklyRoomSupply w
)

-- ✅ Final SELECT with Percentage Change Calculations
SELECT 
    f.*,

    -- ✅ Percentage Change in Occupancy Index
    CASE 
        WHEN f.occ_index_py_wk IS NULL OR f.occ_index_py_wk = 0 THEN NULL 
        ELSE SAFE_DIVIDE(f.occ_index_wk - f.occ_index_py_wk, f.occ_index_py_wk) 
    END AS occ_index_pct_chg,

    -- ✅ Percentage Change in ADR Index
    CASE 
        WHEN f.adr_index_py_wk IS NULL OR f.adr_index_py_wk = 0 THEN NULL 
        ELSE SAFE_DIVIDE(f.adr_index_wk - f.adr_index_py_wk, f.adr_index_py_wk) 
    END AS adr_index_pct_chg,

    -- ✅ Percentage Change in RevPAR Index
    CASE 
        WHEN f.revpar_index_py_wk IS NULL OR f.revpar_index_py_wk = 0 THEN NULL  
        ELSE SAFE_DIVIDE(f.revpar_index_wk - f.revpar_index_py_wk, f.revpar_index_py_wk) 
    END AS revpar_index_pct_chg

FROM FinalMetrics f;