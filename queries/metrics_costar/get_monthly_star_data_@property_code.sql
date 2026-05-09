
SELECT * 
FROM `aparium-dataflow`.`StarData`.`MonthlyStar`
WHERE property_code = @PROPERTY_CODE
ORDER BY property_code, stay_date, cs_no;