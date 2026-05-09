WITH deduplicated_data AS (
    SELECT DISTINCT
        stay_date,
        property_code,
        segment,
        rms_fct_py, rms_fct_cy,
        rev_fct_cy, rev_fct_py,
        rms_cy, rms_py, rms_stly, rms_st2y, rms_st19,
        rev_cy, rev_py, rev_stly, rev_st2y, rev_st19
    FROM `aparium-dataflow.PaceData.PaceData_Segment`
    WHERE snapshot_date = @SNAPSHOT_DATE
)

SELECT 
    DATE_TRUNC(stay_date, MONTH) AS month_year,  
    property_code,  
    CASE 
        WHEN segment IN ("Transient Wholesale", "Transient Promotion", "Transient",
                         "Transient Retail", "Transient Packages", "Transient Government", 
                         "Transient Consortia", "Transient Opaque", "Transient Negotiated", 
                         "Transient Package", "Transient Qualified", "Transient Unqualified") 
        THEN "Transient"
        WHEN segment IN ("Group Corporate", "Group", "Group Wedding", "Group Corporate",
                         "Group Citywide", "Group SMERF", "Group Social", "Group Entertainment",
                         "Group Tour", "Group Group SMERF", "Group Association", "Group Government") 
        THEN "Group"
        ELSE "Other"  
    END AS segment_category,

    -- Metrics Aggregation
    SUM(rms_fct_py) AS rms_fct_py,
    SUM(rms_fct_cy) AS rms_fct_cy,

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
    SUM(rev_st19) AS rev_st19

FROM deduplicated_data
GROUP BY month_year, property_code, segment_category
ORDER BY month_year DESC, property_code;