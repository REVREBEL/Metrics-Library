
title: Metrics Table Architecture
nav_order: 3
has_toc: true
permalink: /metrics-table-architecture/


# Metrics Table Architecture

## Metrics Platform

This document defines the canonical table structure used throughout the Metrics Platform.

The objective is to maintain a stable, predictable reporting framework across hospitality systems that rarely speak the same language.

PMS exports, CRS reports, RMS feeds, booking engine datasets, spreadsheets, and vendor reports all structure data differently. Some arrive wide. Some arrive sparse. Some arrive held together with merged Excel cells and optimism.

The Metrics Platform standardizes those inputs into a consistent warehouse architecture designed for:
- operational reporting,
- benchmarking,
- forecasting,
- dashboarding,
- automation workflows,
- and downstream analytics.

**The goal is not simply storing hotel data, the goal is creating a durable semantic layer where metrics remain interpretable regardless of source system.**



# Architecture Philosophy

The warehouse structure separates datasets by operational grain rather than forcing all reporting into a single generalized fact table.

Hospitality reporting behaves differently depending on:
- reporting cadence,
- snapshot behavior,
- dimensional complexity,
- pickup logic,
- and forecasting requirements.

Because of this, the Metrics Platform intentionally separates:
- pace reporting,
- actual production,
- pickup activity,
- pricing observations,
- benchmark intelligence,
- and planning data

into independent but interoperable reporting layers.

This preserves:
- reporting consistency,
- dimensional flexibility,
- historical continuity,
- and operational clarity.



# Core Design Principles

## Grain-First Architecture

Fact tables are separated by business grain:
- property,
- segment,
- source/channel,
- and roomtype.

This structure prevents unnecessary dimensional sparsity while preserving reporting flexibility.



## Wide Pace & Actual Tables

Core pace and actual tables remain intentionally wide.

Hospitality reporting frequently relies on:
- same-time-last-year comparisons,
- forecast overlays,
- budget variance,
- pickup analysis,
- and operational KPI calculations.

Wide structures simplify dashboard development, semantic modeling, and BI tool performance.



## Long Pickup Structures

Pickup datasets remain long/narrow because pickup windows and comparison periods expand rapidly.

This structure prevents schema explosion while preserving reporting flexibility across:
- rolling pickup windows,
- comparison periods,
- and dynamic pace analysis.



## Source Metrics vs Derived Metrics

Fact tables preserve additive and source-provided metrics.

Derived KPIs such as:
- ADR,
- OCC,
- RevPAR,
- indexes,
- and percentage changes

are calculated within marts or semantic reporting views when base metrics are available.

This preserves:
- calculation consistency,
- warehouse flexibility,
- and reporting reproducibility.



## Mapping & Normalization

Source systems rarely align on naming conventions.

The Metrics Platform uses mapping layers to normalize:
- segments,
- sources,
- roomtypes,
- channels,
- and raw metric structures.

This preserves source traceability while maintaining standardized reporting behavior downstream.



# Warehouse Table Structure

## Core Dimensions

Core dimensions establish the standardized operational reference layer used throughout the warehouse.

| Table | Purpose |
|---|---|
| `dim_property` | Standardized hotel and property reference layer |
| `dim_date` | Calendar and reporting date dimension |
| `dim_segment` | Standardized segment reference layer |
| `dim_source` | Standardized booking source and channel layer |
| `dim_roomtype` | Standardized roomtype and room classification layer |
| `dim_metric` | Centralized metric dictionary and calculation framework |
| `dim_source_report` | Source-report metadata and ingestion tracking |



## Mapping Tables

Mapping tables preserve source-system relationships while standardizing operational reporting structures.

| Table | Purpose |
|---|---|
| `map_segment` | Maps source segment values to standardized segment structures |
| `map_source` | Maps source/channel values to standardized channel structures |
| `map_roomtype` | Maps source roomtypes to standardized roomtype structures |
| `map_source_metric` | Maps raw report columns to standardized metric structures |

These layers allow inconsistent vendor exports and operational systems to resolve into a unified reporting framework.

Because hospitality systems have an almost artistic relationship with inconsistent naming conventions.



# Pace Fact Tables

Pace tables store snapshot-based on-the-books performance data.

These datasets preserve booking-position behavior at a specific point in time.

Pace reporting supports:
- demand analysis,
- forecasting,
- pickup tracking,
- booking velocity,
- wash analysis,
- and operational pacing.

| Table | Purpose |
|---|---|
| `fact_pace_property` | Property-level pace snapshots |
| `fact_pace_segment` | Segment-level pace snapshots |
| `fact_pace_source` | Source/channel-level pace snapshots |
| `fact_pace_roomtype` | Roomtype-level pace snapshots |



# Actual Fact Tables

Actual tables store finalized operational production.

These datasets represent:
- realized room production,
- revenue production,
- occupancy,
- arrivals,
- cancellations,
- no-shows,
- and transactional operational behavior.

Actual datasets maintain the same dimensional grain as their matching pace tables while removing unnecessary snapshot behavior.

| Table | Purpose |
|---|---|
| `fact_actual_property` | Property-level actual performance |
| `fact_actual_segment` | Segment-level actual performance |
| `fact_actual_source` | Source/channel-level actual performance |
| `fact_actual_roomtype` | Roomtype-level actual performance |



# Pickup Fact Tables

Pickup reporting measures booking movement between reporting snapshots.

Pickup tables intentionally use a long-format structure because:
- pickup windows expand over time,
- comparison periods vary,
- and reporting flexibility matters more than fixed-schema simplicity.

| Table | Purpose |
|---|---|
| `fact_pickup_property` | Property-level pickup activity |
| `fact_pickup_segment` | Segment-level pickup activity |
| `fact_pickup_source` | Source/channel-level pickup activity |
| `fact_pickup_roomtype` | Roomtype-level pickup activity |

Pickup tables support:
- booking velocity analysis,
- trend monitoring,
- demand pacing,
- and forecast movement analysis.



# Flexible Metric Observation Layer

Some hospitality metrics behave inconsistently across systems.

Rather than forcing every irregular metric into standardized wide tables, the Metrics Platform uses a flexible observation framework.

| Table | Purpose |
|---|---|
| `fact_metric_observation` | Flexible storage layer for sparse, irregular, or evolving metrics |

This structure supports:
- experimental metrics,
- vendor-specific reporting,
- one-off operational metrics,
- dynamic benchmarking fields,
- and evolving reporting requirements.

The warehouse remains structured without becoming rigid.



# BI Marts & Semantic Views

BI marts provide dashboard-ready reporting layers derived from operational fact tables.

These views standardize:
- KPI calculations,
- comparison logic,
- reporting relationships,
- and dashboard consumption.

| View | Purpose |
|---|---|
| `mart_property_daily` | Property-level daily reporting mart |
| `mart_segment_daily` | Segment-level daily reporting mart |
| `mart_source_daily` | Source/channel daily reporting mart |
| `mart_roomtype_daily` | Roomtype-level daily reporting mart |

These marts calculate:
- ADR,
- OCC,
- RevPAR,
- variance metrics,
- pace comparisons,
- and percentage-change calculations.

The objective is creating stable reporting logic once — instead of rebuilding KPI calculations inside every dashboard.



# Shared Warehouse Standards

All warehouse objects follow:
- standardized lowercase `snake_case`,
- approved metric abbreviations,
- standardized dimensional relationships,
- and canonical semantic naming structures.

Reference:
- Database Column Naming Standards
- CoStar Processing Standards
- Forecast & Pricing Table Models



# Warehouse Design Philosophy

The Metrics Platform warehouse is intentionally structured around how hospitality reporting behaves operationally.

Different datasets:
- update differently,
- snapshot differently,
- aggregate differently,
- and support different business questions.

The warehouse architecture preserves those distinctions rather than flattening everything into a single reporting layer.

The objective is not simply organizing tables.

The objective is creating a reporting framework where:
- metrics remain interpretable,
- dashboards remain stable,
- benchmark logic remains trustworthy,
- and operational decisions remain grounded in consistent data behavior.

Because clean architecture matters.

Especially when the source file arrived named:

```text
final_v2_actual_USE_THIS_latest(3).xlsx
```


