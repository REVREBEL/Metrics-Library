---
title: Events Table Model
nav_order: 5
has_toc: true
permalink: /events-table-model/
---

# Events Table Model

Events should be modeled as a dedicated contextual data source instead of being stored as free-form event columns inside pace, actual, pickup, or forecast fact tables.

The purpose of the events table is to provide a reusable event calendar that can be joined into property, market, pace, demand, pricing, and BI files without duplicating event text across multiple metric tables.

## Recommendation

Create a standalone event table:

```text
dim_event
```

Optionally create a property/date bridge table when event impact varies by property:

```text
bridge_property_event_date
```

## Why Events Should Be Separate

Events are not metrics. They are contextual drivers that explain or influence metric behavior.

A separate event table is better because it:

1. Allows one event to affect multiple properties and multiple dates.
2. Makes it easier to reuse the same event feed across BI dashboards, Excel files, forecasting models, and demand tools.
3. Avoids repeating event text in every fact table.
4. Supports multiple simultaneous events on the same date.
5. Allows events to have start/end dates, categories, impact levels, locations, and notes.
6. Keeps pace/actual/pickup tables focused on measurable hotel performance.

## Table List

| Table | Purpose |
|---|---|
| `dim_event` | Stores the master event calendar and event attributes. |
| `bridge_property_event_date` | Connects events to specific properties and dates when impact differs by property/location. |

## `dim_event`

### Grain

One row per unique event.

### Columns

| Column | Type | Notes |
|---|---|---|
| `event_id` | STRING | Unique event identifier. Recommended format: generated UUID or stable source ID. |
| `event` | STRING | Standard event name. |
| `event_category` | STRING | Standard event category. See allowed values below. |
| `event_impact` | STRING | Standard event impact. See allowed values below. |
| `event_start_date` | DATE | First date of the event. |
| `event_end_date` | DATE | Last date of the event. |
| `event_location` | STRING | Venue, neighborhood, city, market, or relevant location. |
| `market` | STRING | Market impacted by the event. |
| `city` | STRING | City impacted by the event. |
| `state` | STRING | State/province. |
| `country` | STRING | Country. |
| `event_notes` | STRING | Supporting notes. |
| `source_system` | STRING | Source system or manual source. |
| `source_report` | STRING | Source report or source feed name. |
| `source_file` | STRING | Source file path/name, if imported. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `bridge_property_event_date`

### Grain

One row per property, date, and event.

Use this bridge when an event does not affect every property in the same way, or when one event needs a property-specific impact classification.

### Columns

| Column | Type | Notes |
|---|---|---|
| `property_code` | STRING | Property impacted by the event. |
| `date` | DATE | Date impacted by the event. |
| `event_id` | STRING | Event identifier from `dim_event`. |
| `event` | STRING | Event name, repeated for BI convenience. |
| `event_category` | STRING | Event category, repeated for BI convenience. |
| `event_impact` | STRING | Property/date-specific event impact. |
| `event_distance_miles` | FLOAT64 | Optional distance from property to event location. |
| `is_primary_event` | BOOL | Flags the main event driving demand for the property/date. |
| `event_notes` | STRING | Property/date-specific notes. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## Standard Event Categories

Use the field:

```text
event_category
```

Allowed values:

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

## Standard Event Impact Values

Use the field:

```text
event_impact
```

Allowed values:

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

## How Events Join to Fact Tables

Do not store event names directly in every fact table as the primary model.

Instead, join events to fact tables by:

```text
property_code + date
```

or, when event impact is market-wide:

```text
market + date
```

Recommended dashboard join path:

```text
fact_pace_property.date
  -> bridge_property_event_date.date
  -> dim_event.event_id
```

For market-level reporting:

```text
fact_pace_property.date + dim_property.market
  -> dim_event.event_start_date / event_end_date + market
```

## What to Remove From Pace Tables

The following fields should not be primary event-storage fields in `fact_pace_property`:

```text
special_events
special_events_ly
```

Recommended replacement:

```text
primary_event
primary_event_category
primary_event_impact
```

These may be included in BI marts as convenience fields, but the source of truth should remain `dim_event` and `bridge_property_event_date`.

## BI Mart Convenience Fields

BI marts may include flattened event fields for ease of use:

| Column | Type | Notes |
|---|---|---|
| `primary_event` | STRING | Main event for the property/date. |
| `primary_event_category` | STRING | Category of the main event. |
| `primary_event_impact` | STRING | Impact of the main event. |
| `event_count` | INT64 | Number of events affecting the property/date. |
| `high_impact_event_count` | INT64 | Count of high-impact or stronger events. |
| `has_citywide_event` | BOOL | True when the property/date has a citywide event impact. |
| `has_property_disruption` | BOOL | True for property closure, renovation, or similar property-specific impacts. |

## Recommended Use in REVREBEL BI

Use events to support:

1. Demand explanations.
2. Forecast variance analysis.
3. Pace anomaly detection.
4. Compression night identification.
5. Pricing opportunity notes.
6. Roomtype demand analysis.
7. Group/convention impact review.
8. Property closure or renovation overlays.

## Example BigQuery DDL

```sql
CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.dim_event` (
  event_id STRING OPTIONS(description="Unique event identifier."),
  event STRING OPTIONS(description="Standard event name."),
  event_category STRING OPTIONS(description="Standard event category."),
  event_impact STRING OPTIONS(description="Standard event impact classification."),
  event_start_date DATE OPTIONS(description="First date of the event."),
  event_end_date DATE OPTIONS(description="Last date of the event."),
  event_location STRING OPTIONS(description="Venue, neighborhood, city, market, or relevant event location."),
  market STRING OPTIONS(description="Market impacted by the event."),
  city STRING OPTIONS(description="City impacted by the event."),
  state STRING OPTIONS(description="State or province impacted by the event."),
  country STRING OPTIONS(description="Country impacted by the event."),
  event_notes STRING OPTIONS(description="Supporting event notes."),
  source_system STRING OPTIONS(description="Source system or manual source."),
  source_report STRING OPTIONS(description="Source report or source feed name."),
  source_file STRING OPTIONS(description="Source file path or file name, if imported."),
  insert_date DATE OPTIONS(description="Date the event record was inserted."),
  updated_date DATE OPTIONS(description="Date the event record was last updated.")
)
OPTIONS(description="Master event calendar table used for demand, pricing, forecast, pace, and BI context.");

CREATE TABLE IF NOT EXISTS `PROJECT_ID.DATASET.bridge_property_event_date` (
  property_code STRING OPTIONS(description="Property impacted by the event."),
  date DATE OPTIONS(description="Date impacted by the event."),
  event_id STRING OPTIONS(description="Event identifier from dim_event."),
  event STRING OPTIONS(description="Event name, repeated for BI convenience."),
  event_category STRING OPTIONS(description="Event category, repeated for BI convenience."),
  event_impact STRING OPTIONS(description="Property/date-specific event impact classification."),
  event_distance_miles FLOAT64 OPTIONS(description="Optional distance from property to event location in miles."),
  is_primary_event BOOL OPTIONS(description="Flags the main event driving demand for the property/date."),
  event_notes STRING OPTIONS(description="Property/date-specific event notes."),
  insert_date DATE OPTIONS(description="Date the bridge record was inserted."),
  updated_date DATE OPTIONS(description="Date the bridge record was last updated.")
)
OPTIONS(description="Bridge table connecting properties, dates, and events for BI and demand analysis.");
```
