# Events Table Model

## Metrics Platform

This document defines the event-modeling framework used throughout the Metrics Platform.

Events are modeled as a dedicated contextual intelligence layer rather than embedded as free-form text fields inside pace, actual, pickup, forecast, or pricing fact tables.

The objective is preserving reusable event context across:
- forecasting,
- demand analysis,
- compression tracking,
- pricing analysis,
- operational reporting,
- and BI workflows.

**Events influence hotel performance. They are not performance metrics themselves and that distinction drives how the warehouse models event data.**



# Event Modeling Philosophy

Hospitality demand does not exist in isolation.

Performance is constantly influenced by:
- conventions,
- concerts,
- citywide events,
- sporting events,
- holidays,
- weather events,
- renovations,
- closures,
- and market disruptions.

These conditions create operational context around:
- occupancy,
- pricing,
- booking pace,
- compression behavior,
- and market demand.

Because of this, the Metrics Platform models events as a reusable contextual layer that can integrate across multiple reporting datasets without duplicating event text across operational fact tables.

**The objective is not simply attaching notes to dates, the objective is preserving the market conditions surrounding hotel performance.**



# Event Architecture Structure

The event framework uses two core tables:

| Table | Purpose |
|---|---|
| `dim_event` | Master event calendar and standardized event metadata |
| `bridge_property_event_date` | Property/date-level event relationship layer |

This structure allows:
- one event to impact multiple properties,
- multiple events to affect the same date,
- market-wide event analysis,
- property-specific impact classification,
- and reusable event intelligence across reporting layers.



# Why Events Remain Separate

Events behave differently than transactional or additive operational metrics.

They are contextual drivers that explain changes in demand and performance behavior.

Separating events from operational fact tables preserves:
- reporting clarity,
- event reusability,
- historical context,
- and dimensional flexibility.

The structure supports:

1. One event affecting multiple properties and multiple dates
2. Multiple simultaneous events impacting the same market
3. Shared event intelligence across dashboards, forecasting, and pricing workflows
4. Start and end date ranges
5. Event categories and impact classifications
6. Property-specific event relationships
7. Market-wide compression analysis
8. Operational overlays such as closures and renovations

The warehouse keeps pace, actual, pickup, and pricing datasets focused on measurable operational performance while events provide the contextual layer around those metrics.



# `dim_event`

## Table Purpose

`dim_event` stores the centralized event calendar and standardized event metadata used throughout the Metrics Platform.

This table acts as the master event reference layer for:
- demand analysis,
- pricing analysis,
- compression tracking,
- forecasting,
- and BI reporting.



## Table Grain

One row per unique event.



## Core Event Fields

| Column | Type | Notes |
|---|---|---|
| `event_id` | STRING | Unique event identifier |
| `event` | STRING | Standardized event name |
| `event_category` | STRING | Standardized event classification |
| `event_impact` | STRING | Standardized event impact level |
| `event_start_date` | DATE | First event date |
| `event_end_date` | DATE | Last event date |
| `event_location` | STRING | Venue, neighborhood, district, or market location |
| `market` | STRING | Market impacted by the event |
| `city` | STRING | City impacted by the event |
| `state` | STRING | State or province |
| `country` | STRING | Country |
| `event_notes` | STRING | Supporting operational notes |
| `source_system` | STRING | Source system or imported source |
| `source_report` | STRING | Source report or feed |
| `source_file` | STRING | Imported source file reference |
| `insert_date` | DATE | Insert timestamp |
| `updated_date` | DATE | Last update timestamp |



# `bridge_property_event_date`

## Table Purpose

`bridge_property_event_date` connects events to specific properties and dates.

This bridge layer exists because events rarely affect every hotel equally.

A citywide convention may strongly impact one property while creating minimal demand movement for another depending on:
- location,
- segment mix,
- pricing strategy,
- brand positioning,
- and proximity to demand generators.

The bridge structure preserves those differences.



## Table Grain

One row per:

```text
property_code + date + event_id
```



## Core Bridge Fields

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property impacted by the event |
| `date` | DATE | Impacted reporting date |
| `event_id` | STRING | Linked event identifier |
| `event` | STRING | Event name for reporting convenience |
| `event_category` | STRING | Event category |
| `event_impact` | STRING | Property/date-specific impact classification |
| `event_distance_miles` | FLOAT64 | Optional distance from property to event |
| `is_primary_event` | BOOL | Primary demand-driving event flag |
| `event_notes` | STRING | Property/date operational notes |
| `insert_date` | DATE | Insert timestamp |
| `updated_date` | DATE | Last update timestamp |



# Standard Event Categories

Event categories use standardized classifications to maintain reporting consistency across operational systems and dashboards.

Use field:

```text
event_category
```

| Value |
|---|
| `Convention` |
| `Holiday` |
| `Observance` |
| `Concert` |
| `Sporting` |
| `Festival` |
| `Government` |
| `Marathon` |
| `Other` |
| `Property Closure` |
| `Renovation` |
| `Special Event` |
| `Natural Event` |



# Standard Event Impact Levels

Event impact classifications standardize operational demand expectations.

Use field:

```text
event_impact
```

| Value |
|---|
| `Citywide Sellout` |
| `Citywide Limited` |
| `High Impact` |
| `Medium Impact` |
| `Minimal Impact` |
| `Location Based Impact` |
| `Location Based Limited` |
| `No Impact` |
| `Note` |

These classifications support:
- forecast adjustments,
- compression analysis,
- pricing evaluation,
- and demand interpretation.



# Event Relationships to Fact Tables

Events are joined into operational datasets through standardized dimensional relationships.

## Property-Level Event Relationships

```text
property_code + date
```

## Market-Level Event Relationships

```text
market + date
```

Recommended reporting join path:

```text
fact_pace_property.date
  -> bridge_property_event_date.date
  -> dim_event.event_id
```

This structure keeps event intelligence reusable across:
- pace reporting,
- pricing analysis,
- forecasting,
- pickup analysis,
- and dashboard reporting.



# Pace Table Event Standards

The Metrics Platform intentionally avoids storing free-form event fields directly inside operational fact tables as the primary event model.

Legacy fields such as:

```text
special_events
special_events_ly
```

are replaced by standardized event relationships.

BI marts may still expose convenience fields such as:

```text
primary_event
primary_event_category
primary_event_impact
```

but the warehouse source of truth remains:

```text
dim_event
bridge_property_event_date
```

This preserves consistency across all downstream reporting layers.



# BI Mart Convenience Fields

BI marts may flatten event relationships into reporting-friendly fields for dashboard simplicity.

| Column | Type | Purpose |
|---|---|---|
| `primary_event` | STRING | Main event affecting the property/date |
| `primary_event_category` | STRING | Category of primary event |
| `primary_event_impact` | STRING | Primary event impact level |
| `event_count` | INT64 | Total number of impacting events |
| `high_impact_event_count` | INT64 | Count of high-impact or stronger events |
| `has_citywide_event` | BOOL | Citywide event impact flag |
| `has_property_disruption` | BOOL | Renovation or operational disruption flag |

These fields improve dashboard usability while preserving normalized warehouse relationships underneath.



# Operational Use Cases

The event framework supports:

1. Demand explanation analysis
2. Forecast variance interpretation
3. Pace anomaly detection
4. Compression night identification
5. Pricing opportunity analysis
6. Group and convention impact tracking
7. Property closure overlays
8. Renovation impact reporting
9. Market demand intelligence
10. Operational commentary workflows

**Because sometimes the answer is not “the forecast was wrong.” Sometimes Beyoncé announced a stadium tour.**



# Warehouse Design Philosophy

The Metrics Platform treats events as contextual market intelligence rather than operational production metrics.

This structure preserves:
- reusable event relationships,
- historical market context,
- property-specific impact behavior,
- and forecasting continuity.

**The objective is not simply storing event names the objective is preserving the operational story surrounding hotel performance.**


