---
title: Roomtype Model
nav_order: 9
has_toc: true
permalink: /roomtype-model/
---

# Roomtype Model

Roomtype data looks simple until every PMS, RMS, CRS, and booking engine decides to describe the same physical room in a slightly different way. One system sees a room code. Another sees a sellable room name. Another groups rooms into pools. Another adds bed type, class, feature, and category in one free-text label and calls it a day. Very generous of them.

The Metrics roomtype model separates those concepts into controlled building blocks. Room category, room class, bed type, and room feature stay independent so they can be reused in different combinations across properties and systems. The standardized roomtype is then generated from those mapped attributes.

This keeps source-system messiness in the mapping layer and gives Metrics a stable roomtype structure for pace, actuals, pricing, demand, availability, room pools, and reporting views.

## How We View Roomtype Data

Roomtype is not just a label. It is a structured commercial object.

A roomtype tells us what can be sold, how it should be grouped, how it behaves in pricing and demand analysis, and how it rolls into room pools or room classes. A standard roomtype needs enough structure to support rate strategy, inventory analysis, room mix reporting, price sensitivity, and demand calculations without forcing every property into the same naming pattern.

The model starts with independent lookup tables, maps source room values into standard attributes, and publishes `dim_roomtype` as the production reference used by ingestion and reporting.

## Table Family

| Table | Purpose |
|---|---|
| `lkp_roomcategory` | Controlled list of broad room categories, such as Room or Suite. |
| `lkp_roomclass` | Controlled list of commercial room class levels, such as Standard, Upgrade, or Best. |
| `lkp_bedtype` | Controlled list of bed types, such as King, Queen, or Double. |
| `lkp_roomfeature` | Controlled list of room features, such as View, Balcony, Accessible, or Fireplace. |
| `map_roomtype` | Source-to-standard mapping table used to classify source-system roomtype values. |
| `dim_roomtype` | Production roomtype reference used by ingestion, facts, snapshots, and reporting. |
| `dim_roompool` | Standard roompool dimension used to group interchangeable or strategically related roomtypes. |
| `vw_roomtype` | Enriched view that joins the dimension to lookup labels, descriptions, and sort order. |
| `vw_roompool` | Enriched view that expands roompool groupings into readable roomtype relationships and sort order. |

---

## Lookup Tables

Lookup tables define the controlled vocabulary. They should stay small, stable, and independent. The table name provides the context, so the columns can remain simple: `code`, `name`, and `description`.

### Shared Lookup Columns

Applies to:

```text
lkp_roomcategory
lkp_roomclass
lkp_bedtype
lkp_roomfeature
```

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard lookup code. |
| `name` | STRING | Display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the lookup value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Lookup Examples

#### `lkp_roomcategory`

| code | name | description |
|---|---|---|
| `ROOM` | Room | Standard hotel room or guestroom product. |
| `SUITE` | Suite | Larger or separated room product generally sold at a premium. |
| `VILLA` | Villa | Villa, residence, or standalone accommodation product. |
| `OTHER` | Other | Used when the product does not fit an existing category. |

#### `lkp_roomclass`

| code | name | description |
|---|---|---|
| `STD` | Standard | Base or entry room class. |
| `UPGRADE` | Upgrade | Enhanced room class above base. |
| `BEST` | Best | Highest commercial room class or premium sellable tier. |

#### `lkp_bedtype`

| code | name | description |
|---|---|---|
| `KG` | King | King bed configuration. |
| `QN` | Queen | Queen bed configuration. |
| `DB` | Double | Double bed configuration. |
| `TW` | Twin | Twin bed configuration. |

#### `lkp_roomfeature`

| code | name | description |
|---|---|---|
| `VIEW` | View | Room has a meaningful view premium. |
| `BALC` | Balcony | Room includes a balcony or terrace. |
| `ADA` | Accessible | Accessible room configuration. |
| `FIRE` | Fireplace | Room includes fireplace as a selling feature. |
| `NONE` | None | No primary feature assigned. |

---

## `map_roomtype`

`map_roomtype` is the source-to-standard translation layer. It stores the roomtype value as it appears in a source system and maps it into the standard room attributes used to create `dim_roomtype`.

The mapping is universal by property and system. It is not tied to a specific ingestion report because the same source roomtype can appear across multiple files, tabs, exports, and workflows. The report that delivered the value belongs in ingestion/file metadata, not in the mapping table.

The source fields in this table use plain names because the table itself provides the context. Inside `map_roomtype`, `code`, `name`, and `description` mean the mapped source roomtype code, name, and description.

### Grain

```text
property_code + system + code
```

If a source system does not provide a reliable code, the effective grain may use:

```text
property_code + system + name
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `system` | STRING | Source system providing the roomtype value. |
| `code` | STRING | Source-system roomtype code. |
| `name` | STRING | Source-system roomtype name or label. |
| `description` | STRING | Source-system roomtype description, if supplied. |
| `no_beds` | INT64 | Number of beds represented by the mapped roomtype. |
| `roomcategory_code` | STRING | Standard room category code. Joins to `lkp_roomcategory.code`. |
| `roomclass_code` | STRING | Standard room class code. Joins to `lkp_roomclass.code`. |
| `bedtype_code` | STRING | Standard bed type code. Joins to `lkp_bedtype.code`. |
| `roomfeature_code` | STRING | Standard primary room feature code. Joins to `lkp_roomfeature.code`. |
| `roompool` | STRING | Optional roompool grouping label. Used to build `dim_roompool`. |
| `roomtype_code` | STRING | Generated standard roomtype code. This becomes `dim_roomtype.code`. |
| `is_active` | BOOL | Indicates whether the mapping is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

### Working Field Alignment

| Working Field | Standard Field | Notes |
|---|---|---|
| `code` | `code` | Source-system roomtype code. |
| `name` | `name` | Source-system roomtype name. |
| `description` | `description` | Source-system roomtype description. |
| `no_rooms` | `no_beds` | Rename if the value represents bed count. Use `no_rooms` only if it truly means room count. |
| `roomclass_code` | `roomclass_code` | Standard room class. |
| `bedtype_code` | `bedtype_code` | Standard bed type. |
| `roomfeature_code` | `roomfeature_code` | Standard room feature. |
| `roomcategory` | `roomcategory_code` | Store the code, not the label. |
| `roompool` | `roompool` | Used to group roomtypes into room pools. |

---

## `dim_roomtype`

`dim_roomtype` is the production roomtype reference table. It is generated from `map_roomtype`, but it should not carry every source field from the map table.

The dimension only needs the single mapped source lookup value required during processing:

```text
map_roomtype_code
```

That value connects incoming cleaned data back to the source roomtype code that was mapped, while keeping the dimension focused on the standardized roomtype attributes. This avoids the three-hop lookup problem without turning the dimension into a duplicate copy of the mapping table.

### Processing Logic

Incoming source files can resolve roomtypes directly through `dim_roomtype.map_roomtype_code`:

```sql
LEFT JOIN metrics_core.dim_roomtype rt
  ON incoming.property_code = rt.property_code
 AND incoming.roomtype_code = rt.map_roomtype_code
```

Once resolved, the pipeline writes the standard code to the target table:

```text
incoming source roomtype code → dim_roomtype.map_roomtype_code → dim_roomtype.code → target.roomtype_code
```

The full source context remains in `map_roomtype`:

```text
map_roomtype.system
map_roomtype.code
map_roomtype.name
map_roomtype.description
```

### Code Generation

The standard roomtype code is deterministic. It is built from the commercial components that define the roomtype:

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
| `map_roomtype_code` | STRING | Source roomtype code from `map_roomtype.code`. Used to resolve incoming source data. |
| `code` | STRING | Standard roomtype code generated from mapped attributes. This is the value written to target tables as `roomtype_code`. |
| `name` | STRING | Standard roomtype display name. |
| `description` | STRING | Standard roomtype description. |
| `no_beds` | INT64 | Number of beds represented by the roomtype. |
| `roomcategory_code` | STRING | Standard room category code. |
| `roomclass_code` | STRING | Standard room class code. |
| `bedtype_code` | STRING | Standard bed type code. |
| `roomfeature_code` | STRING | Standard primary room feature code. |
| `roompool` | STRING | Optional roompool grouping label. |
| `available_rms` | INT64 | Room inventory for the roomtype, when stable and known. |
| `sort` | INT64 | Display order for reporting. |
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
| `roompool` | STRING | Source or mapped roompool grouping label. |
| `sort` | INT64 | Display order for reporting. |
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

| roompool | Included roomtype codes | dim_roompool.code | dim_roompool.related_roomtypes |
|---|---|---|---|
| `group 1` | `1KGSTDSUITE`, `2QNUPGRADEROOM` | `1KGSTDSUITE2QNUPGRADEROOM` | `1KGSTDSUITE,2QNUPGRADEROOM` |
| `group 2` | `1KGBESTVIEWROOM`, `2QNUPGRADEROOM` | `1KGBESTVIEWROOM2QNUPGRADEROOM` | `1KGBESTVIEWROOM,2QNUPGRADEROOM` |

---

## Enriched Views

Views expose sort fields so BI tools can display roomtypes, room pools, and lookup labels in the intended operating order instead of alphabetizing everything into polite nonsense.

### `vw_roomtype`

`vw_roomtype` joins the standard roomtype dimension to lookup labels and descriptions.

| Column | Source | Definition |
|---|---|---|
| `property_code` | `dim_roomtype` | Property code. |
| `map_roomtype_code` | `dim_roomtype` | Source roomtype code used for ingestion lookup. |
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
| `roompool` | `dim_roomtype.roompool` | Roompool grouping label. |
| `available_rms` | `dim_roomtype.available_rms` | Roomtype inventory. |
| `sort` | `dim_roomtype.sort` | Display order for BI/reporting. |
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
| `sort` | `dim_roompool.sort` | Display order for BI/reporting. |
| `is_active` | `dim_roompool.is_active` | Active flag. |

---

## Relationship to Pace, Actuals, Pricing, and Demand

Roomtype-level source files should resolve against `dim_roomtype` during processing. The target metric table should store the standard roomtype code, not every descriptive attribute.

For example:

```text
source file roomtype code
  → dim_roomtype.map_roomtype_code
  → dim_roomtype.code
  → snap_pace_roomtype.roomtype_code
```

Target tables then use:

```text
snap_pace_roomtype.roomtype_code
fact_actual_roomtype.roomtype_code
fact_price_shop.roomtype_code
snap_demand_roomtype.roomtype_code
```

The reporting layer can join to `vw_roomtype` to bring in room category, room class, bed type, feature labels, sort order, and the mapped roomtype lookup code.

## Operating Notes

1. `lkp_` tables define controlled values. They do not know anything about a specific property.
2. `map_roomtype` translates and governs source-system room values before they are published into the production dimension.
3. `map_roomtype` uses `system`, `code`, `name`, and `description`; it does not use the `source_` prefix because the table context already makes those fields source-oriented.
4. Mapping tables do not include `report`; source reports belong in ingestion metadata because the same mapping may support multiple ingestion files.
5. `dim_roomtype` carries `map_roomtype_code` as the single lookup back to the mapped source roomtype code.
6. `dim_roompool` groups roomtype codes into strategic or interchangeable room pools.
7. `vw_roomtype` and `vw_roompool` expose sort fields so reporting tools display values in the intended order.
8. Use `roomcategory_code`, not `roomcategory`, in modeled tables. Labels belong in lookup joins and views.
9. Use `no_beds`, not `no_rooms`, when the value means bed count.
10. Generated codes should be deterministic. Same attributes in, same code out. Always.
