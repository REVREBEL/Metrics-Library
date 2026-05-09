WITH data AS (
    SELECT property_code,
           cs_no,
           property_name,
           available_rms,
           cs_property_name,
           cs_brand,
           cs_city,
           cs_available_rms,
           cs_open_date
    FROM `aparium-dataflow.StarData.CompsetData`
    WHERE property_code = @PROPERTY_CODE and cs_no = @CS_NO
)
SELECT *
FROM data
ORDER BY cs_property_name DESC;