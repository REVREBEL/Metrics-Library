

WITH WeeklyAggregatedData AS (
    SELECT 
        cy,
        week_no,
        property_code,

        SUM(total_rms) AS available_rooms_wk,
        SUM(rev) AS rooms_revenue_wk,
        SUM(rev_py) AS rooms_revenue_py_wk,

        7 AS days_in_week

    FROM `aparium-dataflow.StarData.DayStar`
    GROUP BY property_code, compset_no, cy, week_no
),

WeeklyRoomSupply AS (
    SELECT
        w.cy,
        w.week_no,
        w.property_code,
        w.rooms_revenue_wk,
        w.rooms_revenue_py_wk,
        w.available_rooms_wk,

        SAFE_DIVIDE(w.rooms_revenue_wk, w.available_rooms_wk) AS revpar_wk,
        SAFE_DIVIDE(w.rooms_revenue_py_wk, w.available_rooms_wk) AS revpar_py_wk,

    FROM WeeklyAggregatedData w 
)

SELECT
    w.cy,
    w.week_no,
    w.property_code,
    w.available_rooms_wk,
    w.rooms_revenue_wk,
    w.rooms_revenue_py_wk,

    w.revpar_wk,
    w.revpar_py_wk, 

FROM WeeklyRoomSupply w;



    SELECT 
        cy,
        week_no,
        property_code,

        SUM(revenue_py) AS rooms_revenue_py_wk,

        7 AS days_in_week

    FROM `aparium-dataflow.StarData.DayStar`
    -- ✅ Use derived values in GROUP BY (not `period`)
    WHERE property_code = "DENCHM" AND compset_no = "Set1"
    GROUP BY property_code, compset_no, cy, week_no;

