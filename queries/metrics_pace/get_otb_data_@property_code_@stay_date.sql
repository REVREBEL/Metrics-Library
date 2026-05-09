SELECT *  
FROM `aparium-dataflow.PaceData.PaceData_Property`  
WHERE stay_date BETWEEN '2025-03-01' AND '2025-03-31'  
  AND property_code = "DTWDFH"  
QUALIFY ROW_NUMBER() OVER (PARTITION BY stay_date ORDER BY snapshot_date DESC) = 1;