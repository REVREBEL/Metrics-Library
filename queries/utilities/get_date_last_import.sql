SELECT *
FROM `aparium-dataflow.starData.DayStarDataLive`
WHERE Period = (SELECT MAX(Period) FROM `aparium-dataflow.starData.DayStarDataLive`);