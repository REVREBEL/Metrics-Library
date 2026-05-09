---
title: Source File Ingestion Model
nav_order: 8
has_toc: true
permalink: /source-file-ingestion-model/
---

# Source File Ingestion Model

The source data for the REVREBEL BI Platform may arrive as actual files, including CSV and Excel workbooks exported from PMS, RMS, CRS, rate shopping tools, OTA scrapes, Google Sheets, and other hotel systems.

Dataform is the right tool for creating standardized BigQuery tables and running transformations, but Dataform is not the primary file-ingestion tool for arbitrary local CSV/XLSX files.

The recommended architecture is:

```text
Source CSV / Excel files
        ↓
File landing location
        ↓
Raw BigQuery staging tables or external tables
        ↓
Dataform transformations
        ↓
Standardized REVREBEL BI tables
```

## Key Principle

Dataform should own the database model and transformations.

A separate ingestion process should own file loading, file conversion, and raw table creation/loading.

## Recommended File Ingestion Flow

## 1. Land source files

Store raw files in a consistent location, such as:

```text
Google Drive / Shared Drive
Google Cloud Storage
Manual upload folder
SFTP landing folder
```

Recommended file metadata to preserve:

| Metadata | Purpose |
|---|---|
| `source_file` | Original file name or storage path. |
| `source_system` | PMS, RMS, CRS, OTA, rate shop, manual, etc. |
| `source_report` | Report/export name. |
| `property_code` | Property the file belongs to. |
| `extract_date` | Date the file was exported. |
| `load_ts` | Timestamp loaded into raw/staging. |

## 2. Convert Excel when needed

BigQuery does not natively load `.xlsx` files directly as standard table loads.

Recommended options:

1. Convert Excel tabs to CSV, then load CSV into BigQuery.
2. Convert Excel to Google Sheets and use a Google Sheets external table.
3. Use Python / Apps Script / n8n to read Excel and write rows to BigQuery.
4. Use a cloud function or scheduled loader to convert and load files.

## 3. Load raw/staging tables

Raw/staging tables should preserve source columns as closely as possible, but still include standard operational metadata.

Recommended raw table naming:

```text
raw_{source_system}_{source_report}
stg_{source_system}_{source_report}
```

Examples:

```text
raw_duetto_rms_otb_segment
raw_duetto_rms_pickup_roomtype
raw_costar_demand_segment
raw_costar_demand_channel
raw_bookingdotcom_bar_price_shop
raw_bookingdotcom_lowest_price_shop
```

## 4. Use Dataform to transform raw/staging into standardized tables

Dataform should read from raw/staging tables and populate standardized tables such as:

```text
fact_pace_segment
fact_pace_roomtype
fact_demand_segment
fact_demand_source
fact_price_shop
fact_manual_plan
```

Example Dataform transform pattern:

```sql
INSERT INTO `${dataform.projectConfig.defaultProject}.${dataform.projectConfig.defaultDataset}.fact_pace_segment` (
  property_code,
  property_name,
  snap_date,
  date,
  segment,
  segment_code,
  segment_map,
  segment_code_map,
  rms_otb,
  rev_otb,
  rms_stly,
  rev_stly,
  source_system,
  source_report,
  source_file,
  insert_date
)
SELECT
  property_code,
  hotel AS property_name,
  snapshot_date AS snap_date,
  SAFE.PARSE_DATE('%Y%m%d', stay_date) AS date,
  market_segment AS segment,
  market_code AS segment_code,
  market_segment AS segment_map,
  market_code AS segment_code_map,
  SAFE_CAST(today_rooms_commit AS INT64) AS rms_otb,
  SAFE_CAST(today_room_revenue_commit AS FLOAT64) AS rev_otb,
  SAFE_CAST(stly_date_rooms_commit AS INT64) AS rms_stly,
  SAFE_CAST(stly_date_room_revenue_commit AS FLOAT64) AS rev_stly,
  'Duetto' AS source_system,
  'rms-otb-segment' AS source_report,
  source_file,
  CURRENT_DATE() AS insert_date
FROM `${dataform.projectConfig.defaultProject}.raw.raw_duetto_rms_otb_segment`;
```

## Recommended BigQuery Dataset Layout

Use separate datasets for raw and standardized data.

```text
raw
stg
revrebel_metrics
```

| Dataset | Purpose |
|---|---|
| `raw` | Raw file-loaded tables. Preserve original file/source structure. |
| `stg` | Cleaned/typed staging tables with source columns normalized enough for transformations. |
| `revrebel_metrics` | Standardized REVREBEL BI tables created by Dataform. |

## CSV Handling

CSV files can be loaded into BigQuery using:

1. BigQuery UI upload.
2. `bq load` command.
3. Cloud Storage external tables.
4. Python / n8n / Apps Script loaders.
5. Scheduled transfer / ingestion workflow.

Recommended CSV load path:

```text
CSV file
  → Google Cloud Storage
  → BigQuery raw table
  → Dataform transform
  → standardized fact table
```

## Excel Handling

Excel files require conversion or a custom loader.

Recommended Excel load path:

```text
Excel file
  → Python / Apps Script / n8n reads workbook tabs
  → BigQuery raw table
  → Dataform transform
  → standardized fact table
```

Alternative path:

```text
Excel file
  → Google Sheets conversion
  → BigQuery external table over Google Sheet
  → Dataform transform
  → standardized fact table
```

## Google Sheets Writeback Handling

For manual forecast and budget data, Google Sheets may remain the user-facing input layer.

Recommended flow:

```text
Google Sheet forecast/budget template
  → Apps Script / n8n / BigQuery connector
  → fact_manual_plan
  → Dataform marts/views
```

`fact_manual_plan` should preserve Sheet metadata:

```text
source_sheet_id
source_sheet_name
source_cell
submitted_by
submitted_at
approved_by
approved_at
```

## Dataform Responsibilities

Dataform should handle:

1. Creating standardized tables.
2. Creating staging views or transformation tables.
3. Mapping raw source columns to standardized names.
4. Casting values to standard types.
5. Populating fact and dimension tables.
6. Building mart and semantic views.
7. Testing table quality and required fields.

## Non-Dataform Responsibilities

Another ingestion process should handle:

1. Detecting new files.
2. Reading CSV and Excel files.
3. Converting Excel tabs to tabular rows.
4. Loading raw files into BigQuery raw tables.
5. Preserving file metadata.
6. Handling malformed rows and file-level errors.
7. Moving files to processed/error folders.

## Recommended Automation Pattern

A practical automation pattern:

```text
Google Drive / GCS watch folder
  → n8n / Python loader
  → Parse file name for property, source system, report, extract date
  → Read CSV/XLSX
  → Load raw table in BigQuery
  → Trigger Dataform workflow
  → Move file to processed folder
  → Notify success/failure
```

## File Metadata Table

Create a file registry table to track every loaded file.

Recommended table:

```text
ctl_file_load
```

### `ctl_file_load`

| Column | Type | Notes |
|---|---|---|
| `file_load_id` | STRING | Unique file load identifier. |
| `source_file` | STRING | File name or storage path. |
| `source_file_id` | STRING | Drive/GCS/file system identifier. |
| `source_system` | STRING | PMS, RMS, CRS, OTA, rate shop, manual, etc. |
| `source_report` | STRING | Report/export name. |
| `property_code` | STRING | Property code. |
| `extract_date` | DATE | Date the file was extracted/generated. |
| `load_ts` | TIMESTAMP | Timestamp the file was loaded. |
| `raw_table` | STRING | Raw BigQuery table loaded. |
| `row_count` | INT64 | Loaded row count. |
| `load_status` | STRING | Pending, Loaded, Transformed, Error, Archived. |
| `error_message` | STRING | Error message, if applicable. |
| `processed_file_path` | STRING | Processed/archive file path. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## Example Dataform DDL for File Registry

```sql
CREATE TABLE IF NOT EXISTS `${dataform.projectConfig.defaultProject}.${dataform.projectConfig.defaultDataset}.ctl_file_load` (
  file_load_id STRING OPTIONS(description="Unique file load identifier."),
  source_file STRING OPTIONS(description="File name or storage path."),
  source_file_id STRING OPTIONS(description="Drive, GCS, or file system identifier."),
  source_system STRING OPTIONS(description="Source system such as PMS, RMS, CRS, OTA, rate shop, or manual."),
  source_report STRING OPTIONS(description="Report or export name."),
  property_code STRING OPTIONS(description="Property code."),
  extract_date DATE OPTIONS(description="Date the file was extracted or generated."),
  load_ts TIMESTAMP OPTIONS(description="Timestamp the file was loaded."),
  raw_table STRING OPTIONS(description="Raw BigQuery table loaded."),
  row_count INT64 OPTIONS(description="Loaded row count."),
  load_status STRING OPTIONS(description="Pending, Loaded, Transformed, Error, or Archived."),
  error_message STRING OPTIONS(description="Error message, if applicable."),
  processed_file_path STRING OPTIONS(description="Processed or archived file path."),
  insert_date DATE OPTIONS(description="Insert date."),
  updated_date DATE OPTIONS(description="Updated date.")
)
OPTIONS(description="Control table tracking CSV, Excel, Google Sheet, and other source file loads.");
```

## Bottom Line

Dataform should not be treated as the direct CSV/XLSX loader.

Use Dataform to create and transform the database model after files have been loaded to BigQuery raw or staging tables.

Recommended pattern:

```text
Files in Drive/GCS
  → Loader writes raw BigQuery tables
  → Dataform standardizes into REVREBEL BI tables
```
