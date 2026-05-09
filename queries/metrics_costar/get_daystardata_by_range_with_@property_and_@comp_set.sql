SELECT 
    property_code,
    cs_no,
    cy,
    stay_date,
    stay_date_py,
    rev, 
    rev_py,
    cs_rev,
    cs_rev_py
FROM `aparium-dataflow.StarData.DayStar`
WHERE 
    property_code = @PROPERTY_CODE 
    AND cs_no = @COMPSET_NO 
    AND cy = @CURRENT_YEAR 
    AND stay_date BETWEEN @START_DATE AND @END_DATE
ORDER BY week_no, stay_date;