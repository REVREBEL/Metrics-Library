WITH column_data AS (
  SELECT
    table_schema,
    table_name,
    STRING_AGG(FORMAT("'%s'", column_name), ", " ORDER BY ordinal_position) AS cols_list
  FROM
    `devrebel-big-query-database`.`region-us-central1`.INFORMATION_SCHEMA.COLUMNS
  WHERE
    table_schema IN (
      'dev_hotel_analytics', 'dev_hotel_costar', 'dev_hotel_forecast', 
      'dev_hotel_g4a', 'dev_hotel_g4a_events', 'dev_hotel_sales', 
      'dev_hotel_settings', 'devrebel'
    )
  GROUP BY 1, 2
)
SELECT
  FORMAT("{ name: '%s', schema: '%s', cols: [%s] },", table_name, table_schema, cols_list) AS js_line
FROM
  column_data
ORDER BY table_schema, table_name;