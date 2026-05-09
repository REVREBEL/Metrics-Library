SELECT
  table_name,
  FORMAT(
    """config { 
  type: "declaration", 
  database: "%s", 
  schema: "%s", 
  name: "%s", 
  columns: {
%s
  }
}""",
    table_catalog,
    table_schema,
    table_name,
    column_list
  ) AS sqlx_definition
FROM (
  SELECT
    table_catalog,
    table_schema,
    table_name,
    STRING_AGG(FORMAT("    %s: \"\"", column_name), ",\n" ORDER BY ordinal_position) AS column_list
  FROM
    `devrebel-big-query-database`.dev_hotel_analytics.INFORMATION_SCHEMA.COLUMNS
  GROUP BY
    table_catalog, table_schema, table_name
)
ORDER BY table_name;