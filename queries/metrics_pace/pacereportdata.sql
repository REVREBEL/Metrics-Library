WITH LatestData AS (
    SELECT 
        cr825_property_code,
        cr825_business_view,
        cr825_occ_date,
        cr825_snapshot_date,
        createdon,
        EXTRACT(YEAR FROM cr825_occ_date) AS year,
        EXTRACT(MONTH FROM cr825_occ_date) AS month,
        cr825_booked_rm_rev_cy,
        cr825_booked_rm_rev_stly,
        cr825_booked_rm_rev_py_act,
        cr825_occ_otb_cy,
        cr825_occ_otb_stly,
        cr825_occ_otb_py_act,
        cr825_occ_fct_cy,
        cr825_fcted_rm_rev_cy,
        ROW_NUMBER() OVER (PARTITION BY cr825_property_code, cr825_business_view ORDER BY createdon DESC) AS rn
    FROM `aparium-dataflow.paceData.paceDataBusinessView`
)

SELECT  
    cr825_property_code,
    cr825_business_view,
    cr825_occ_date,
    MIN(cr825_snapshot_date) AS snapshot_date,
    year,
    month,
    SUM(cr825_booked_rm_rev_cy) AS total_booked_revenue_cy,
    SUM(cr825_booked_rm_rev_stly) AS total_booked_revenue_stly,
    SUM(cr825_booked_rm_rev_py_act) AS total_booked_revenue_py_act,
    SUM(cr825_occ_otb_cy) AS total_rooms_otb_cy,
    SUM(cr825_occ_otb_stly) AS total_rooms_otb_stly,
    SUM(cr825_occ_otb_py_act) AS total_rooms_otb_py_act,
    SUM(cr825_occ_fct_cy) AS total_fcted_rooms_cy,
    SUM(cr825_fcted_rm_rev_cy) AS total_fcted_revenue_cy
FROM LatestData
WHERE rn = 1  -- Select only the most recent createdon record for each property
GROUP BY 
    cr825_property_code, 
    cr825_business_view, 
    cr825_occ_date,
    year, 
    month
ORDER BY 
    cr825_property_code, 
    year DESC, 
    month DESC;