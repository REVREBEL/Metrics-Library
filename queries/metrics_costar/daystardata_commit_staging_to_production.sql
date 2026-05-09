
-- COMMIT STAGING TABLE TO PRODUCTION

-- Step 1: Clear the production table
TRUNCATE TABLE`aparium-dataflow.starData.DayStarDataLive`;

-- Step 2: Copy data from staging to production
INSERT INTO `aparium-dataflow.starData.DayStarDataLive`
SELECT * FROM `aparium-dataflow.starData.DayStarDataStaging`;

-- Step 3: Clear the staging table
TRUNCATE TABLE `aparium-dataflow.starData.DayStarDataStaging`;