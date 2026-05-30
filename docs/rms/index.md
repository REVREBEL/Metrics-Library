---
title: Source Files
has_toc: true
permalink: /source-files/
---

# Source Files

Source file documentation defines how each vendor export, workbook, CSV, or manually maintained file enters the Metrics Library and becomes a standardized reporting asset.

This section is organized by source system so the team can quickly answer four operational questions:

1. What raw files or workbook tabs are expected from the source system?
2. Which original source columns are preserved, renamed, normalized, or mapped into REVREBEL standards?
3. Which new columns, metadata fields, lookup placeholders, or amended values are added during processing?
4. What is the final transformed file or warehouse-ready table specification?

The goal is to make source-system behavior readable for operators, maintainable for engineering, and traceable from final metric back to source file.

## Documentation Pattern

Each source-system page should follow the same structure.

| Section | Purpose |
|---|---|
| Source system overview | Identifies the system, report family, grain, and business purpose. |
| Raw files / tabs | Lists the files, worksheets, or exports expected before transformation. |
| Source configuration | Captures settings that must be configured inside the source system before export. |
| Column mapping | Shows original column names or normalized source headers mapped to REVREBEL standard columns. |
| New / amended data | Documents metadata, lookup placeholders, derived fields, and amended logic added during processing. |
| Final transformed spec | Defines the final columns, grain, and target file/table for the standardized output. |

## Current Source Systems

| Source System | Documentation | Status |
|---|---|---|
| IDeaS | [IDeaS Pace](./ideas-pace) | Active pace ingestion documentation |

## Related Standards

| Related Standard | Why It Matters |
|---|---|
| Source File Ingestion Model | Defines raw, staging, metadata, and traceability principles. |
| Column Naming Standards | Defines canonical REVREBEL naming conventions. |
| Table Prefix Standards | Defines prefixes such as `raw_`, `stg_`, `snap_`, `fact_`, `dim_`, `map_`, and `lkp_`. |
| Table Architecture | Explains where source files land in the broader warehouse model. |
