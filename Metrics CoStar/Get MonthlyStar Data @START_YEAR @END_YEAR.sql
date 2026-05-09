SELECT * 
FROM `aparium-dataflow.StarData.MonthlyStar`
WHERE cy BETWEEN @START_YEAR AND @END_YEAR;