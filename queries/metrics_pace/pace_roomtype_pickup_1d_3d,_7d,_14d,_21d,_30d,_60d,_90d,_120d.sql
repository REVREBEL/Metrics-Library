

---------------------------------------
-- CREATE 001DAY PICKUP VIEW
---------------------------------------


CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_001DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_1d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_1d,
  curr.rms - prior.rms AS rms_pickup_1d,
  curr.rev - prior.rev AS rev_pickup_1d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_1d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 1 DAY)
ORDER BY
  curr.stay_date ASC; 



---------------------------------------
-- CREATE 003DAY PICKUP VIEW
---------------------------------------



CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_003DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_3d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_3d,
  curr.rms - prior.rms AS rms_pickup_3d,
  curr.rev - prior.rev AS rev_pickup_3d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_3d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 3 DAY)
ORDER BY
  curr.stay_date ASC; 



---------------------------------------
-- CREATE 007DAY PICKUP VIEW
---------------------------------------


CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_007DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_7d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_7d,
  curr.rms - prior.rms AS rms_pickup_7d,
  curr.rev - prior.rev AS rev_pickup_7d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_7d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 7 DAY)
ORDER BY
  curr.stay_date ASC;



---------------------------------------
-- CREATE 0014DAY PICKUP VIEW
---------------------------------------



CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_014DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_14d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_14d,
  curr.rms - prior.rms AS rms_pickup_14d,
  curr.rev - prior.rev AS rev_pickup_14d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_14d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 14 DAY)
ORDER BY
  curr.stay_date ASC; 



---------------------------------------
-- CREATE 021DAY PICKUP VIEW
---------------------------------------



CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_021DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_21d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_21d,
  curr.rms - prior.rms AS rms_pickup_21d,
  curr.rev - prior.rev AS rev_pickup_21d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_21d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 21 DAY)
ORDER BY
  curr.stay_date ASC;


---------------------------------------
-- CREATE 030DAY PICKUP VIEW
---------------------------------------


CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_030DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_30d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_30d,
  curr.rms - prior.rms AS rms_pickup_30d,
  curr.rev - prior.rev AS rev_pickup_30d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_30d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 30 DAY)
ORDER BY
  curr.stay_date ASC;


---------------------------------------
-- CREATE 060DAY PICKUP VIEW
---------------------------------------



  CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_060DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_60d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_60d,
  curr.rms - prior.rms AS rms_pickup_60d,
  curr.rev - prior.rev AS rev_pickup_60d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_60d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 60 DAY)
ORDER BY
  curr.stay_date ASC;



---------------------------------------
-- CREATE 090DAY PICKUP VIEW
---------------------------------------



CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType_090DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_90d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_90d,
  curr.rms - prior.rms AS rms_pickup_90d,
  curr.rev - prior.rev AS rev_pickup_90d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_90d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 90 DAY)
ORDER BY
  curr.stay_date ASC;



---------------------------------------
-- CREATE 120DAY PICKUP VIEW
---------------------------------------



CREATE OR REPLACE VIEW
  `aparium-dataflow.PaceData.PaceData_RoomType120DayV` AS
WITH
  LatestSnapshot AS (
  SELECT
    property_code,
    MAX(snapshot_date) AS latest_snapshot_date
  FROM
    `aparium-dataflow.PaceData.PaceData_RoomType`
  GROUP BY
    property_code ),
  -- Get latest ingested_timestamp for each row on the latest snapshot date
  FilteredLatestSnapshot AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date,roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 ),
  CurrentSnapshot AS (
  SELECT
    s.property_code,
    s.roomtype,
    s.roomtype_sort,
    s.roomtype_code,
    s.roomtype_category_code,
    s.roomtype_category,
    s.bar,
    s.capacity,
    s.roomtype_physical_capacity,
    s.stay_date,
    s.snapshot_date,
    s.rms,
    s.rev,
    s.ingested_timestamp
  FROM
    FilteredLatestSnapshot s
  INNER JOIN
    LatestSnapshot l
  ON
    s.property_code = l.property_code
    AND s.snapshot_date = l.latest_snapshot_date ),
  PriorSnapshot_120d AS (
  SELECT
    *
  FROM (
    SELECT
      *,
      ROW_NUMBER() OVER (PARTITION BY property_code, snapshot_date, roomtype, stay_date ORDER BY ingested_timestamp DESC ) AS rn
    FROM
      `aparium-dataflow.PaceData.PaceData_RoomType` )
  WHERE
    rn = 1 )
SELECT
  curr.property_code,
  curr.roomtype,
  curr.roomtype_sort,
  curr.roomtype_code,
  curr.roomtype_category_code,
  curr.roomtype_category,
  curr.bar,
  curr.capacity,
  curr.roomtype_physical_capacity,
  curr.stay_date,
  curr.snapshot_date AS current_snapshot_date,
  curr.ingested_timestamp AS current_ingested_timestamp,
  curr.rms,
  curr.rev,
  prior.snapshot_date AS pickup_reference_date_120d,
  curr.rms - prior.rms AS rms_pickup_120d,
  curr.rev - prior.rev AS rev_pickup_120d
FROM
  CurrentSnapshot curr
LEFT JOIN
  PriorSnapshot_120d prior
ON
  curr.property_code = prior.property_code
  AND curr.roomtype = prior.roomtype
  AND curr.stay_date = prior.stay_date
  AND prior.snapshot_date = DATE_SUB(curr.snapshot_date, INTERVAL 120 DAY)
ORDER BY
  curr.stay_date ASC;




