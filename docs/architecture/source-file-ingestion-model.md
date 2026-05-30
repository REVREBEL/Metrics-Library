---
title: Source File Ingestion Model
nav_order: 8
has_toc: true
permalink: /source-file-ingestion-model/
---

# Source File Ingestion Model

## Metrics Platform

This document defines the file ingestion architecture used throughout the Metrics Platform. Hospitality data rarely arrives in a clean, consistent, warehouse-ready format.

**Source data may originate from:**

* PMS exports,
* RMS systems,
* CRS reports,
* Booking engines,
* OTA extranets,
* Rate shopping tools,
* Google Sheets,
* Finance systems,
* Manual operational files,
* or vendor-generated Excel workbooks that appear to have survived several ownership transitions.

The Metrics Platform standardizes these disconnected source files into a unified reporting framework used for:

* operational reporting,
* forecasting,
* pricing analysis,
* benchmark intelligence,
* automation workflows,
* and downstream analytics.

**The objective is not simply loading files into BigQuery, the objective is preserving operational meaning, source traceability, and reporting consistency throughout the ingestion pipeline.**



# Ingestion Architecture Philosophy

The Metrics Platform intentionally separates:

* file ingestion,
* raw source preservation,
* staging transformations,
* semantic standardization,
* and reporting-layer modeling

into independent architectural layers.

This separation preserves:

* source traceability,
* ingestion flexibility,
* warehouse stability,
* transformation reproducibility,
* and operational auditability.

Because hospitality source systems rarely agree on:

* naming conventions,
* reporting grains,
* date formats,
* metric structures,
* or whether “final_final_v2_USE_THIS.xlsx” was actually the final file.



# Core Ingestion Architecture

```text
Source CSV / Excel Files
        ↓
Landing Location
        ↓
Raw BigQuery Tables
        ↓
Staging & Standardization
        ↓
Dataform Transformations
        ↓
Standardized Metrics Tables
        ↓
BI Marts & Reporting Views
```

The architecture intentionally separates ingestion from transformation responsibilities.



# Core Principle

Dataform owns:

* warehouse structure,
* transformations,
* semantic modeling,
* standardized reporting layers,
* and downstream marts/views.

A separate ingestion process owns:

* file detection,
* CSV/XLSX parsing,
* workbook conversion,
* raw table loading,
* metadata preservation,
* and file-level processing workflows.

This separation keeps warehouse logic stable even as source systems evolve.



# Source File Landing Standards

Raw source files are stored in standardized landing locations before ingestion.

Supported landing patterns include:

```text
Google Drive / Shared Drive
Google Cloud Storage
Manual Upload Folder
SFTP Landing Folder
API Export Storage
```

Landing locations preserve original source files before transformation occurs.

Because once someone overwrites the “corrected final export,” archaeology becomes part of the analytics workflow.



# Source File Metadata Standards

Every ingested file preserves operational metadata for auditability and traceability.

| Metadata         | Purpose                                     |
|---|---|
| `source_file`    | Original filename or storage path           |
| `source_system`  | PMS, RMS, CRS, OTA, rate shop, manual, etc. |
| `source_report`  | Original report/export name                 |
| `property_code`  | Property associated with the file           |
| `extract_date`   | Date the report was generated/exported      |
| `load_ts`        | Timestamp loaded into the warehouse         |
| `source_file_id` | External file identifier (Drive/GCS/etc.)   |

This metadata layer preserves lineage throughout the ingestion and reporting pipeline.



# Raw & Staging Architecture

## Raw Layer Philosophy

Raw tables preserve source-system structures as closely as possible.

The raw layer acts as:

* an ingestion checkpoint,
* a recovery layer,
* and a source-of-truth archive for imported operational data.

Raw tables intentionally avoid aggressive transformation logic.



## Raw Table Standards

```text
raw_{source_system}_{source_report}
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



## Staging Layer Philosophy

Staging tables normalize:

* data types,
* date structures,
* metric formatting,
* source-system inconsistencies,
* and operational naming conventions

before transformation into standardized warehouse models.

Staging preserves enough source structure for traceability while making the data usable for semantic modeling.



# BigQuery Dataset Structure

The Metrics Platform separates datasets by operational domain and architectural responsibility.

| Dataset           | Purpose                                                |
|---|---|
| `raw`             | Raw source-loaded tables preserving original structure |
| `stg`             | Typed and normalized staging tables                    |
| `metrics_core`    | Shared dimensions, mappings, and reference tables      |
| `metrics_pace`    | Pace, pickup, forecast, and snapshot reporting         |
| `metrics_demand`  | Demand, benchmarking, comp-set, and index reporting    |
| `metrics_booking` | Booking engine, CRS, reservation, and pricing data     |
| `metrics_web`     | Web analytics, landing page, GA4, and search data      |
| `metrics_finance` | Financial reporting, payroll, budgets, and expenses    |
| `metrics_sales`   | Sales activity, RFPs, accounts, and lead tracking      |
| `metrics_social`  | Campaign, engagement, and social platform metrics      |

This separation keeps reporting domains organized while preserving warehouse scalability.



# CSV Handling Standards

CSV files may be loaded through:

* BigQuery UI uploads,
* `bq load`,
* Cloud Storage ingestion,
* Python loaders,
* n8n workflows,
* Apps Script integrations,
* or scheduled ingestion pipelines.

## Standard CSV Flow

```text
CSV File
  → Landing Location
  → Raw BigQuery Table
  → Staging Layer
  → Dataform Transformation
  → Standardized Metrics Tables
```



# Excel Handling Standards

Excel files require conversion or custom parsing before warehouse ingestion.

The ingestion framework supports:

* workbook tab parsing,
* tab-level extraction,
* Google Sheets conversion,
* Python loaders,
* Apps Script workflows,
* and n8n ingestion pipelines.

## Standard Excel Flow

```text
Excel File
  → Workbook Parsing
  → Raw BigQuery Table
  → Staging Layer
  → Dataform Transformation
  → Standardized Metrics Tables
```

Alternative path:

```text
Excel File
  → Google Sheets Conversion
  → BigQuery External Table
  → Dataform Transformation
  → Standardized Metrics Tables
```

Because hospitality reporting still has an intense emotional attachment to Excel tabs named:

```text
OTB_FINAL_USE_THIS_v7
```



# Google Sheets Writeback Standards

Google Sheets may remain the user-facing planning layer for:

* forecasting,
* budgeting,
* overrides,
* targets,
* and operational planning workflows.

## Standard Flow

```text
Google Sheets
  → Apps Script / n8n / Connector
  → fact_manual_plan
  → Dataform Marts & Reporting Views
```

The planning framework preserves:

* user attribution,
* approval tracking,
* source sheet lineage,
* and planning auditability.



# Dataform Responsibilities

Dataform owns:

* standardized warehouse structures,
* transformations,
* semantic modeling,
* staging logic,
* dimensional mapping,
* mart creation,
* KPI standardization,
* and reporting-layer calculations.

Examples include:

* pace transformations,
* benchmark calculations,
* metric standardization,
* semantic reporting views,
* and BI marts.



# Ingestion Framework Responsibilities

The ingestion framework owns:

* file detection,
* workbook parsing,
* CSV/XLSX conversion,
* raw table loading,
* metadata preservation,
* malformed-row handling,
* processing workflows,
* and file archival management.

This separation keeps warehouse transformations stable regardless of source-file complexity.



# Automation Workflow Pattern

A standard automation workflow follows:

```text
Landing Folder / GCS / Drive Watcher
  → Ingestion Workflow
  → File Metadata Extraction
  → Workbook/CSV Parsing
  → Raw BigQuery Load
  → Dataform Execution
  → File Archival
  → Success / Failure Notification
```

The ingestion framework parses:

* property,
* source system,
* report type,
* extract date,
* and operational metadata

directly from filenames and workbook structures whenever possible.



# File Registry Framework

The Metrics Platform maintains a centralized file registry table:

```text
ctl_file_load
```

This table tracks:

* ingestion status,
* row counts,
* source lineage,
* load timestamps,
* processing outcomes,
* and archival references.



# `ctl_file_load`

| Column                | Type      | Notes                                         |
|---|---|---|
| `file_load_id`        | STRING    | Unique file load identifier                   |
| `source_file`         | STRING    | Original filename or storage path             |
| `source_file_id`      | STRING    | External Drive/GCS/file identifier            |
| `source_system`       | STRING    | PMS, RMS, CRS, OTA, etc.                      |
| `source_report`       | STRING    | Original report/export name                   |
| `property_code`       | STRING    | Associated property                           |
| `extract_date`        | DATE      | Report extraction date                        |
| `load_ts`             | TIMESTAMP | Warehouse load timestamp                      |
| `raw_table`           | STRING    | Raw table destination                         |
| `row_count`           | INT64     | Loaded row count                              |
| `load_status`         | STRING    | Pending, Loaded, Transformed, Error, Archived |
| `error_message`       | STRING    | Processing error details                      |
| `processed_file_path` | STRING    | Archived file location                        |
| `insert_date`         | DATE      | Insert timestamp                              |
| `updated_date`        | DATE      | Last update timestamp                         |



# Warehouse Design Philosophy

The Metrics Platform treats source ingestion as an operational intelligence pipeline rather than a simple file-upload process.

**The architecture intentionally separates:**

* ingestion,
* normalization,
* semantic transformation,
* benchmark logic,
* and reporting consumption

into independent but connected layers.

**This structure preserves:**

* operational traceability,
* warehouse stability,
* reporting consistency,
* source lineage,
* and analytical reproducibility.

**The goal is not simply loading files, the goal is creating a reliable operational reporting system from source data that was never designed to work together in the first place.**

