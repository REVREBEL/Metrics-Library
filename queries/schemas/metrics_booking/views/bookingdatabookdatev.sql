CREATE OR REPLACE VIEW `aparium-dataflow.BookingData.BookingDataBookDateV`
AS SELECT
  *,
  CASE property_code
    WHEN 'DENCHM' THEN 63
    WHEN 'MCICRH' THEN 131
    WHEN 'DTWDFH' THEN 100
    WHEN 'PDXTHH' THEN 151
    WHEN 'MSPHEH' THEN 124
    WHEN 'ATLGRA' THEN 103
    WHEN 'TPAHAY' THEN 178
    WHEN 'AEXHER' THEN 134
    WHEN 'MEMHUH' THEN 110
    WHEN 'FARJAS' THEN 125
    WHEN 'DENPOP' THEN 265
    WHEN 'DSMSUR' THEN 137
    WHEN 'SEAPOP' THEN 120
    WHEN 'XXXXXX' THEN 000
    ELSE NULL
  END AS physical_capacity,

  CASE property_code
    WHEN 'DENCHM' THEN 'Clayton Hotel & Members Club'
    WHEN 'MCICRH' THEN 'Crossroads Hotel'
    WHEN 'DTWDFH' THEN 'Detroit Foundation Hotel'
    WHEN 'PDXTHH' THEN 'Heathman Hotel'
    WHEN 'MSPHEH' THEN 'Hewing Hotel'
    WHEN 'ATLGRA' THEN 'Hotel Granada Midtown'
    WHEN 'TPAHAY' THEN 'Hotel Haya'
    WHEN 'AEXHER' THEN 'Hotel Heron'
    WHEN 'MEMHUH' THEN 'Hu. Hotel'
    WHEN 'FARJAS' THEN 'Jasper Hotel'
    WHEN 'DENPOP' THEN 'Populus Denver'
    WHEN 'DSMSUR' THEN 'Surety Hotel'
    WHEN 'SEAPOP' THEN 'Populus Seattle'
    WHEN 'XXXXXX' THEN 'Unknown'  -- fallback example
    ELSE NULL
  END AS property_name

FROM `aparium-dataflow.BookingData.BookingData`
WHERE DATE(book_date) >= DATE_SUB(CURRENT_DATE(), INTERVAL 1095 DAY)
  AND property_code IS NOT NULL
  AND book_date IS NOT NULL;