---
title: Roomtype Model
nav_order: 9
has_toc: true
permalink: /roomtype-model/
---

# Roomtype Model

Roomtype data looks simple until every PMS, RMS, CRS, and booking engine decides to describe the same physical room in a slightly different way. One system sees a room code. Another sees a sellable room name. Another groups rooms into pools. Another adds bed type, class, feature, and category in one free-text label and calls it a day. Very generous of them.

The Metrics roomtype model separates those concepts into controlled building blocks. Room category, room class, bed type, and room feature stay independent so they can be reused in different combinations across properties and systems. The standardized roomtype is then generated from those mapped attributes.

This keeps source-system messiness in the mapping layer and gives Metrics a stable roomtype structure for pace, actuals, pricing, demand, availability, room pools, and BI views.

## How We View Roomtype Data

Roomtype is not just a label. It is a structured commercial object.

A roomtype tells us what can be sold, how it should be grouped, how it behaves in pricing and demand analysis, and how it rolls into room pools or room classes. A standard roomtype needs enough structure to support rate strategy, inventory analysis, room mix reporting, price sensitivity, and demand calculations without forcing every property into the same naming pattern.

The model starts with independent lookup tables, maps source room values into those standard attributes, then builds `dim_roomtype` from the mapped components.

## Table Family

| Table | Purpose |
|---|---|
| `lkp_roomcategory` | Controlled list of broad room categories, such as Room or Suite. |
| `lkp_roomclass` | Controlled list of commercial room class levels, such as Standard, Upgrade, or Best. |
| `lkp_bedtype` | Controlled list of bed types, such as King, Queen, or Double. |
| `lkp_roomfeature` | Controlled list of room features, such as View, Balcony, Accessible, or Fireplace. |
| `map_roomtype` | Maps source-system roomtype values into standard room attributes. |
| `dim_roomtype` | Standard property-level roomtype dimension generated from mapped attributes. |
| `dim_roompool` | Standard roompool dimension used to group interchangeable or strategically related roomtypes. |
| `vw_roomtype` | Enriched view that joins the dimension to lookup labels and descriptions. |
| `vw_roompool` | Enriched view that expands roompool groupings into readable roomtype relationships. |

---

## Lookup Tables

Lookup tables define the controlled vocabulary. They should stay small, stable, and independent. The table name provides the context, so the columns can remain simple: `code`, `name`, and `description`.

### `lkp_roomcategory`

Room category defines the broad product type.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard room category code. Examples: `ROOM`, `SUITE`, `VILLA`, `OTHER`. |
| `name` | STRING | Display name for the room category. |
| `description` | STRING | Definition or usage notes for the room category. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the category is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

Example values:

| code | name | description |
|---|---|---|
| `ROOM` | Room | Standard hotel room or guestroom product. |
| `SUITE` | Suite | Larger or separated room product generally sold at a premium. |
| `VILLA` | Villa | Villa, residence, or standalone accommodation product. |
| `OTHER` | Other | Used when the product does not fit an existing category. |

### `lkp_roomclass`

Room class defines the commercial tier of the roomtype.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard room class code. Examples: `STD`, `UPGRADE`, `BEST`. |
| `name` | STRING | Display name for the room class. |
| `description` | STRING | Definition or usage notes for the room class. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the class is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

Example values:

| code | name | description |
|---|---|---|
| `STD` | Standard | Base or entry room class. |
| `UPGRADE` | Upgrade | Enhanced room class above base. |
| `BEST` | Best | Highest commercial room class or premium sellable tier. |

### `lkp_bedtype`

Bed type defines the primary bed configuration.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard bed type code. Examples: `KG`, `QN`, `DB`. |
| `name` | STRING | Display name for the bed type. |
| `description` | STRING | Definition or usage notes for the bed type. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the bed type is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

Example values:

| code | name | description |
|---|---|---|
| `KG` | King | King bed configuration. |
| `QN` | Queen | Queen bed configuration. |
| `DB` | Double | Double bed configuration. |
| `TW` | Twin | Twin bed configuration. |

### `lkp_roomfeature`

Room feature defines a primary differentiating feature. This should be used for features that materially affect pricing, demand, or room grouping.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard room feature code. Examples: `VIEW`, `BALC`, `ACC`, `FIRE`. |
| `name` | STRING | Display name for the feature. |
| `description` | STRING | Definition or usage notes for the feature. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the feature is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

Example values:

| code | name | description |
|---|---|---|
| `VIEW` | View | Room has a meaningful view premium. |
| `BALC` | Balcony | Room includes a balcony or terrace. |
| `ACC` | Accessible | Accessible room configuration. |
| `FIRE` | Fireplace | Room includes fireplace as a selling feature. |
| `NONE` | None | No primary feature assigned. |

---

## `map_roomtype`

`map_roomtype` is the source-to-standard translation layer. It stores the source-system room value and maps it into the standard roomtype attributes used to build the dimension.

This table should preserve source context without making the source system the standard. Source labels can be charmingly inconsistent. The mapped attributes are where the discipline lives.

### Grain

```text
property_code + source_system + source_report + source_code
```

If a source system does not provide a reliable source code, the effective grain may use:

```text
property_code + source_system + source_report + source_name
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `source_system` | STRING | Source system providing the roomtype value. |
| `source_report` | STRING | Source report or feed where the roomtype appeared. |
| `source_code` | STRING | Source-system roomtype code. |
| `source_name` | STRING | Source-system roomtype name or label. |
| `source_description` | STRING | Source-system roomtype description, if supplied. |
| `no_beds` | INT64 | Number of beds represented by the mapped roomtype. |
| `roomcategory_code` | STRING | Standard room category code. Joins to `lkp_roomcategory.code`. |
| `roomclass_code` | STRING | Standard room class code. Joins to `lkp_roomclass.code`. |
| `bedtype_code` | STRING | Standard bed type code. Joins to `lkp_bedtype.code`. |
| `roomfeature_code` | STRING | Standard primary room feature code. Joins to `lkp_roomfeature.code`. |
| `roompool` | STRING | Optional source or standard roompool grouping label. Used to build `dim_roompool`. |
| `is_active` | BOOL | Indicates whether the mapping is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Source Fields from the User Notes

The original working fields map into the standard model this way:

| Working Field | Standard Field | Notes |
|---|---|---|
| `code` | `source_code` | Source-system roomtype code. |
| `name` | `source_name` | Source-system roomtype name. |
| `description` | `source_description` | Source-system roomtype description. |
| `no_rooms` | `no_beds` | Rename if the value represents bed count. Use `no_rooms` only if it truly means room count. |
| `roomclass_code` | `roomclass_code` | Standard room class. |
| `bedtype_code` | `bedtype_code` | Standard bed type. |
| `roomfeature_code` | `roomfeature_code` | Standard room feature. |
| `roomcategory` | `roomcategory_code` | Store the code, not the label. |
| `roompool` | `roompool` | Used to group roomtypes into room pools. |

---

## `dim_roomtype`

`dim_roomtype` is the standardized property-level roomtype dimension. It is generated from the mapped roomtype attributes in `map_roomtype`.

The roomtype code is deterministic. It is built from the commercial components that define the roomtype:

```text
CONCAT(no_beds, bedtype_code, roomclass_code, roomfeature_code, roomcategory_code)
```

If `roomfeature_code` is null or not meaningful, use `NONE` or omit it only if the code-generation standard explicitly allows that. The important part is consistency. The system should not generate three versions of the same room because one source forgot to say “none.”

### Code Examples

| no_beds | bedtype_code | roomclass_code | roomfeature_code | roomcategory_code | Generated roomtype code |
|---:|---|---|---|---|---|
| 1 | `KG` | `STD` | `NONE` | `SUITE` | `1KGSTDNONESUITE` |
| 2 | `QN` | `UPGRADE` | `NONE` | `ROOM` | `2QNUPGRADENONEROOM` |
| 1 | `KG` | `BEST` | `VIEW` | `ROOM` | `1KGBESTVIEWROOM` |

If the library decides to omit `NONE` from generated codes, the same examples become:

| no_beds | bedtype_code | roomclass_code | roomfeature_code | roomcategory_code | Generated roomtype code |
|---:|---|---|---|---|---|
| 1 | `KG` | `STD` | `NONE` | `SUITE` | `1KGSTDSUITE` |
| 2 | `QN` | `UPGRADE` | `NONE` | `ROOM` | `2QNUPGRADEROOM` |

The shorter format is easier to read. The stricter format is easier to audit. Pick one and make it boringly consistent.

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `code` | STRING | Standard roomtype code generated from mapped attributes. |
| `name` | STRING | Standard roomtype display name. |
| `description` | STRING | Standard roomtype description. |
| `roomtype_code` | STRING | Alias of `code` used in downstream fact/snapshot tables when explicit context is preferred. |
| `no_beds` | INT64 | Number of beds represented by the roomtype. |
| `roomcategory_code` | STRING | Standard room category code. |
| `roomclass_code` | STRING | Standard room class code. |
| `bedtype_code` | STRING | Standard bed type code. |
| `roomfeature_code` | STRING | Standard primary room feature code. |
| `available_rms` | INT64 | Room inventory for the roomtype, when stable and known. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the roomtype is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Build Logic

The standard build logic is:

```sql
CONCAT(
  CAST(no_beds AS STRING),
  bedtype_code,
  roomclass_code,
  roomfeature_code,
  roomcategory_code
) AS code
```

If the approved standard omits `NONE` room features:

```sql
CONCAT(
  CAST(no_beds AS STRING),
  bedtype_code,
  roomclass_code,
  IF(roomfeature_code = 'NONE', '', roomfeature_code),
  roomcategory_code
) AS code
```

---

## `dim_roompool`

Room pools group related roomtypes that can be treated together for pricing, demand, inventory, or operational analysis.

A room pool can represent interchangeable roomtypes, a strategic grouping, or a source-system room pool. The roompool model should preserve which roomtypes are included, but it should not replace the roomtype dimension. Room pools are groupings. Roomtypes are the sellable product.

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `code` | STRING | Standard roompool code. Built from the included roomtype codes. |
| `name` | STRING | Roompool display name. |
| `description` | STRING | Roompool description or usage notes. |
| `related_roomtypes` | STRING | Comma-separated list of roomtype codes included in the pool. |
| `roompool_source` | STRING | Optional source roompool label from `map_roomtype.roompool`. |
| `sort_order` | INT64 | Optional display order. |
| `is_active` | BOOL | Indicates whether the roompool is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Build Logic

From the working notes:

```text
map_roomtype.roompool = group 1, group 2, group 3
```

Each roompool can be built from the mapped roomtype codes included in that group.

Roompool code:

```text
CONCAT(roomtype_code + roomtype_code + roomtype_code)
```

Related roomtypes:

```text
roomtype_code, roomtype_code, roomtype_code
```

In BigQuery, the roompool code should be generated from sorted roomtype codes so the same pool does not get different codes because rows arrived in a different order. Order should not be allowed to create chaos. We have enough of that from source systems.

Example:

```sql
STRING_AGG(roomtype_code, '' ORDER BY roomtype_code) AS code,
STRING_AGG(roomtype_code, ',' ORDER BY roomtype_code) AS related_roomtypes
```

Example output:

| roompool_source | Included roomtype codes | dim_roompool.code | dim_roompool.related_roomtypes |
|---|---|---|---|
| `group 1` | `1KGSTDSUITE`, `2QNUPGRADEROOM` | `1KGSTDSUITE2QNUPGRADEROOM` | `1KGSTDSUITE,2QNUPGRADEROOM` |
| `group 2` | `1KGBESTVIEWROOM`, `2QNUPGRADEROOM` | `1KGBESTVIEWROOM2QNUPGRADEROOM` | `1KGBESTVIEWROOM,2QNUPGRADEROOM` |

---

## Enriched Views

### `vw_roomtype`

`vw_roomtype` joins the standard roomtype dimension to lookup labels and descriptions.

| Column | Source | Definition |
|---|---|---|
| `property_code` | `dim_roomtype` | Property code. |
| `roomtype_code` | `dim_roomtype.code` | Standard roomtype code. |
| `roomtype` | `dim_roomtype.name` | Standard roomtype name. |
| `roomtype_description` | `dim_roomtype.description` | Standard roomtype description. |
| `no_beds` | `dim_roomtype.no_beds` | Number of beds. |
| `roomcategory_code` | `dim_roomtype.roomcategory_code` | Standard room category code. |
| `roomcategory` | `lkp_roomcategory.name` | Standard room category name. |
| `roomcategory_description` | `lkp_roomcategory.description` | Room category description. |
| `roomclass_code` | `dim_roomtype.roomclass_code` | Standard room class code. |
| `roomclass` | `lkp_roomclass.name` | Standard room class name. |
| `roomclass_description` | `lkp_roomclass.description` | Room class description. |
| `bedtype_code` | `dim_roomtype.bedtype_code` | Standard bed type code. |
| `bedtype` | `lkp_bedtype.name` | Standard bed type name. |
| `bedtype_description` | `lkp_bedtype.description` | Bed type description. |
| `roomfeature_code` | `dim_roomtype.roomfeature_code` | Standard room feature code. |
| `roomfeature` | `lkp_roomfeature.name` | Standard room feature name. |
| `roomfeature_description` | `lkp_roomfeature.description` | Room feature description. |
| `available_rms` | `dim_roomtype.available_rms` | Roomtype inventory. |
| `is_active` | `dim_roomtype.is_active` | Active flag. |

### `vw_roompool`

`vw_roompool` exposes the roompool groupings in a readable format.

| Column | Source | Definition |
|---|---|---|
| `property_code` | `dim_roompool` | Property code. |
| `roompool_code` | `dim_roompool.code` | Standard roompool code. |
| `roompool` | `dim_roompool.name` | Roompool name. |
| `roompool_description` | `dim_roompool.description` | Roompool description. |
| `related_roomtypes` | `dim_roompool.related_roomtypes` | Comma-separated roomtype codes in the pool. |
| `roompool_source` | `dim_roompool.roompool_source` | Source or mapped roompool grouping label. |
| `is_active` | `dim_roompool.is_active` | Active flag. |

---

## Relationship to Pace, Actuals, Pricing, and Demand

Roomtype-level tables should store the standard roomtype code, not every descriptive attribute.

For example:

```text
snap_pace_roomtype.roomtype_code
fact_actual_roomtype.roomtype_code
fact_price_shop.roomtype_code
snap_demand_roomtype.roomtype_code
```

The reporting layer can join to `vw_roomtype` to bring in room category, room class, bed type, and feature labels.

That keeps the metric tables focused on metrics and keeps descriptive room logic in the dimension layer, where it belongs.

## Operating Notes

1. `lkp_` tables define controlled values. They do not know anything about a specific property.
2. `map_roomtype` translates source-system room values into the standard room attributes.
3. `dim_roomtype` is generated from the mapped attributes and should be property-specific.
4. `dim_roompool` groups roomtype codes into strategic or interchangeable room pools.
5. `vw_roomtype` and `vw_roompool` provide the readable version for dashboards, QA, and exports.
6. Use `roomcategory_code`, not `roomcategory`, in modeled tables. Labels belong in lookup joins and views.
7. Use `no_beds`, not `no_rooms`, when the value means bed count.
8. Generated codes should be deterministic. Same attributes in, same code out. Always.
