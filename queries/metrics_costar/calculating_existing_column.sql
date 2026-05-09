

CREATE OR REPLACE TABLE `aparium-dataflow.starData.DayStarDataLive_Temp` AS
SELECT 
    *,
    ROUND(total_rooms * (occ_py / 100), 0) AS rooms_sold_py_wk
FROM `aparium-dataflow.starData.DayStarDataLive`;


DROP TABLE `aparium-dataflow.starData.DayStarDataLive_new`;

ALTER TABLE `aparium-dataflow.starData.DayStarDataLive_Temp`
RENAME TO `DayStarDataLive`;