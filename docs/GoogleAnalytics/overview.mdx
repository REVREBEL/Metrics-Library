---
title: "Google Analytics 4 Transformed Data"
sidebarTitle: "Overview"
description: "High-level architecture, pipeline mechanics, and structural schema of GA4 Report Transformation tables."
---

## Understanding Transformed GA4 Datasets

The transformed Google Analytics 4 (GA4) dataset in BigQuery is a highly structured, flattened relational model designed to mirror the native GA4 reporting interface.[1] Instead of storing telemetry as raw, nested, event-level streams, these tables represent pre-calculated, daily partitioned tables that isolate specific business dimensions and pair them with standard metrics.[1]

### Data Provenance & Pipelines

The transformed data is populated daily via the BigQuery Data Transfer Service.[1] This serverless process automatically takes the raw event export data and applies Google's standard processing rules—including session-stitching, cross-device deduplication, and channel grouping.[1] This automated ETL process eliminates the need for complex SQL scripts, ensuring consistent metrics across reporting platforms.[1]

### Schema Architecture
Unlike raw event streams, which use a nested structure of repeating keys, transformed tables are structured as flat tables with explicit columns.[1] Key structural adjustments in this pipeline include:

* **Removal of Nested Arrays:** Parameters like page title and page location are flattened into standard relational columns.[1]
* **Standardized Metric Naming:** Metrics like sessions, active users, and key events are pre-calculated and readily available.[1]
* **Key Events Alignment:** Following Google's schema updates, conversions have been renamed to key events, with column definitions updated to `keyEvents`.[1]
* **Table Correction:** Deprecated lowercase tables have been replaced with camel-case equivalents to ensure schema consistency.[1]

For detailed schemas and metrics of each table, select a page from the sidebar navigation.


# GA4 Data Overview

## The Source
GA4 data is ingested into BigQuery via the native **GA4-BigQuery Export**. This data arrives as a daily "sharded" stream, representing every interaction a user has with the digital property.

## The Raw Philosophy
In its raw form, GA4 data is **Event-Centric**. Unlike legacy analytics, every action (a page view, a scroll, a room selection) is an `event`. 

### The Challenge: Nested Real Estate
Raw GA4 data is heavily **nested**. High-value information such as "Room Type," "Promotion ID," and "Page Section" is stored within `REPEATED` record arrays (`event_params` and `items`).

### The Goal
This documentation serves as the baseline for our **Reorganization Layer**. We document the raw tables to understand how to flatten them into our "Real Estate Yield" model, where we can eventually calculate **Revenue per Impression (RPI)**.

## Available Tables
* [**Events Table (`metrics_ga4_events`)**](./table-events.md): The granular log of every click and interaction.
* [**Identity Table (`metrics_ga4`)**](./table-identity.md): The user and session-level metadata (Source, Device, Geo).