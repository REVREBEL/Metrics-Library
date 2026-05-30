---
title: Source, Channel, and Rate Model
nav_order: 11
has_toc: true
permalink: /source-channel-rate-model/
---

# Source, Channel, and Rate Model

Source, channel, agency, company, consortia, and rate data sit at the messy intersection of distribution, sales, marketing, revenue strategy, and finance. Every hotel system has its own version of the truth. Sometimes it is a source. Sometimes it is a subsource. Sometimes it is a channel. Sometimes it is a rate code wearing a trench coat.

The Metrics model separates these concepts into controlled lookup tables, then uses mapping tables to translate source-system values into the standard structure. The goal is not to force every source system into the same shape. The goal is to give Metrics a clean, consistent reporting layer while preserving enough flexibility to handle systems that do not have every level of hierarchy.

## How We View Source and Rate Data

Source and channel data explain how demand enters the hotel. Rate and company data explain why the booking exists, how it should be priced, and how it should roll into commercial and finance reporting. Consortia and agency data add another layer of distribution context, especially for GDS and negotiated travel business.

These concepts overlap, but they should not be collapsed into one flat field. A booking can have a channel, source, subsource, rate type, rate code, company, agency, consortia, segment, and finance treatment. Each one answers a different business question.

Metrics keeps those relationships explicit so reporting can answer the practical questions: Where did the booking come from? What commercial bucket does it belong to? Which rate structure drove it? Which company or agency influenced it? And does finance agree, or are we having that meeting again?

## Table Family

| Table | Purpose |
|---|---|
| `lkp_consortia_category` | Controlled list of consortia categories. |
| `lkp_consortia_focus` | Controlled list of consortia focus areas. |
| `lkp_consortia` | Controlled consortia reference table. |
| `lkp_agency` | Agency and IATA reference table. |
| `lkp_industry` | Controlled industry category and industry table. |
| `lkp_company` | Company, corporate account, and profile reference table. |
| `lkp_source` | Controlled list of standard sources. |
| `lkp_subsource` | Controlled list of standard subsources. |
| `lkp_channel_group` | Controlled list of high-level channel groups. |
| `lkp_channel` | Controlled list of standard channels. |
| `lkp_ratetype` | Controlled list of rate types. |
| `lkp_rate` | Controlled list of standard rates and rate attributes. |
| `map_source` | Source-system source/subsource mapping table. |
| `map_rate` | Source-system rate mapping table. |
| `vw_source` | Enriched source/subsource/channel view for reporting. |
| `vw_rate` | Enriched rate view for reporting. |

---

## Consortia Lookup Tables

## `lkp_consortia_category`

Consortia category defines the broad type of consortia relationship.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard consortia category code. |
| `name` | STRING | Consortia category display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_consortia_focus`

Consortia focus defines the primary commercial focus or audience of the consortia relationship.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard consortia focus code. |
| `name` | STRING | Consortia focus display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_consortia`

`lkp_consortia` stores the standard consortia reference list.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard consortia code. |
| `name` | STRING | Full consortia name. |
| `short_name` | STRING | Short display name used in reporting. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `consortia_focus_code` | STRING | Standard consortia focus code. Joins to `lkp_consortia_focus.code`. |
| `consortia_category_code` | STRING | Standard consortia category code. Joins to `lkp_consortia_category.code`. |
| `is_active` | BOOL | Indicates whether the consortia value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## Agency, Industry, and Company Tables

## `lkp_agency`

`lkp_agency` stores agency and IATA reference values. This is especially useful for GDS, consortia, corporate, and negotiated production analysis.

| Column | Type | Definition |
|---|---|---|
| `iata` | STRING | IATA number or agency identifier. |
| `name` | STRING | Agency name. |
| `corp_profile` | STRING | Corporate profile or agency profile reference, when supplied. |
| `corporate_code` | STRING | Corporate code associated with the agency, when available. |
| `consortia_code` | STRING | Standard consortia code. Joins to `lkp_consortia.code`. |
| `consortia_short_name` | STRING | Short consortia name for easy display and source compatibility. |
| `rate_type` | STRING | Rate type or negotiated rate classification associated with the agency, when supplied. |
| `is_active` | BOOL | Indicates whether the agency record is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_industry`

`lkp_industry` defines controlled industry values used by company and account reporting.

| Column | Type | Definition |
|---|---|---|
| `category` | STRING | High-level industry category. |
| `industry` | STRING | Industry name. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the industry value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_company`

`lkp_company` stores company, corporate account, and profile reference values.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard company or account code. |
| `name` | STRING | Company or account name. |
| `description` | STRING | Company description or usage notes. |
| `category` | STRING | Company category. |
| `industry` | STRING | Industry value. Can join to `lkp_industry.industry` when standardized. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the company value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## Source and Channel Lookup Tables

## `lkp_source`

`lkp_source` defines the standard source value used by Metrics.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard source code. |
| `name` | STRING | Source display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `source` | STRING | Optional source family or legacy source label when a source needs to be grouped under a broader source value. |
| `is_active` | BOOL | Indicates whether the source value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_subsource`

`lkp_subsource` defines the standard subsource value used by Metrics when the source system supports a subsource level.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard subsource code. |
| `name` | STRING | Subsource display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the subsource value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_channel_group`

`lkp_channel_group` defines the high-level channel grouping used by reporting.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard channel group code. |
| `name` | STRING | Channel group display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the channel group is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_channel`

`lkp_channel` defines the standard channel used by Metrics.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard channel code. |
| `name` | STRING | Channel display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `channel_group_code` | STRING | Standard channel group code. Joins to `lkp_channel_group.code`. |
| `is_active` | BOOL | Indicates whether the channel value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## Rate Lookup Tables

## `lkp_ratetype`

`lkp_ratetype` defines the standard rate type used by Metrics.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard rate type code. |
| `name` | STRING | Rate type display name. |
| `description` | STRING | Definition or usage notes. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the rate type is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

## `lkp_rate`

`lkp_rate` defines standard rate codes and their related commercial attributes.

| Column | Type | Definition |
|---|---|---|
| `code` | STRING | Standard rate code. |
| `name` | STRING | Rate display name. |
| `description` | STRING | Rate description or usage notes. |
| `ratetype_code` | STRING | Standard rate type code. Joins to `lkp_ratetype.code`. |
| `company_code` | STRING | Standard company code, when the rate is associated with a company. Joins to `lkp_company.code`. |
| `segment_code` | STRING | Standard segment code. Joins to `lkp_segment.code`. |
| `channel_code` | STRING | Standard channel code. Joins to `lkp_channel.code`. |
| `source_code` | STRING | Standard source code. Joins to `lkp_source.code`. |
| `subsource_code` | STRING | Standard subsource code, when applicable. Joins to `lkp_subsource.code`. |
| `consortia_code` | STRING | Standard consortia code, when applicable. Joins to `lkp_consortia.code`. |
| `sort` | INT64 | Display order for reporting. |
| `is_active` | BOOL | Indicates whether the rate value is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `map_source`

`map_source` is the source-to-standard translation table for source and subsource values.

The mapping is universal by property and system. It is not tied to a specific ingestion report because the same source or subsource code can appear across many reports and workflows.

### Why `code_reference` Exists

Some hotel systems provide both source and subsource. Others only provide one code. Metrics needs to map both patterns without inventing a fake hierarchy.

`code_reference` tells the pipeline what the incoming source-system `code` represents:

| code_reference | Meaning |
|---|---|
| `source_code` | The source-system code maps to the standard `source_code`. |
| `subsource_code` | The source-system code maps to the standard `subsource_code`. |

When a system does not provide a true subsource, the target fact or snapshot table should populate:

```text
subsource_code = source_code
```

That keeps fact tables structurally consistent while making it clear that no separate subsource was supplied. It is better than nulls everywhere, and much better than pretending the PMS had nuance it absolutely did not have.

### Grain

```text
property_code + system + code
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `system` | STRING | Source system providing the source/subsource value. |
| `code` | STRING | Source-system source or subsource code. |
| `name` | STRING | Source-system source or subsource name. |
| `description` | STRING | Source-system source or subsource description, if supplied. |
| `code_reference` | STRING | Indicates whether `code` maps to `source_code` or `subsource_code`. Allowed values: `source_code`, `subsource_code`. |
| `source_code` | STRING | Standard source code. Joins to `lkp_source.code`. |
| `subsource_code` | STRING | Standard subsource code. Joins to `lkp_subsource.code`. If the source system does not have subsource, this may be filled with `source_code` in target fact tables. |
| `channel_code` | STRING | Standard channel code. Joins to `lkp_channel.code`. |
| `is_active` | BOOL | Indicates whether the mapping is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## `map_rate`

`map_rate` is the source-to-standard translation table for rate codes.

Rate mapping does more than rename a rate. It connects the source-system rate code to rate type, company, segment, channel, source, subsource, and consortia context where available.

### Grain

```text
property_code + system + code
```

### Columns

| Column | Type | Definition |
|---|---|---|
| `property_code` | STRING | Property code. |
| `system` | STRING | Source system providing the rate value. |
| `code` | STRING | Source-system rate code. |
| `name` | STRING | Source-system rate name. |
| `description` | STRING | Source-system rate description, if supplied. |
| `ratetype_code` | STRING | Standard rate type code. Joins to `lkp_ratetype.code`. |
| `company_code` | STRING | Standard company code. Joins to `lkp_company.code`. |
| `segment_code` | STRING | Standard segment code. Joins to `lkp_segment.code`. |
| `channel_code` | STRING | Standard channel code. Joins to `lkp_channel.code`. |
| `source_code` | STRING | Standard source code. Joins to `lkp_source.code`. |
| `subsource_code` | STRING | Standard subsource code, when applicable. Joins to `lkp_subsource.code`. |
| `consortia_code` | STRING | Standard consortia code, when applicable. Joins to `lkp_consortia.code`. |
| `is_active` | BOOL | Indicates whether the mapping is active. |
| `insert_date` | DATE | Insert date. |
| `updated_date` | DATE | Updated date. |

---

## Enriched Views

Views expose readable labels and `sort` fields so reporting tools display sources, channels, rates, companies, and consortia in the intended operating order instead of alphabetizing a commercial strategy into nonsense.

## `vw_source`

`vw_source` joins mapped source/subsource values to source, subsource, channel, and channel group labels.

| Column | Source | Definition |
|---|---|---|
| `property_code` | `map_source` | Property code. |
| `system` | `map_source` | Source system. |
| `map_source_code` | `map_source.code` | Source-system source/subsource code. |
| `map_source_name` | `map_source.name` | Source-system source/subsource name. |
| `code_reference` | `map_source` | Indicates whether the mapped code resolves to source or subsource. |
| `source_code` | `map_source` | Standard source code. |
| `source` | `lkp_source.name` | Standard source name. |
| `source_description` | `lkp_source.description` | Source description. |
| `source_sort` | `lkp_source.sort` | Source display order. |
| `subsource_code` | `map_source` | Standard subsource code. |
| `subsource` | `lkp_subsource.name` | Standard subsource name. |
| `subsource_description` | `lkp_subsource.description` | Subsource description. |
| `subsource_sort` | `lkp_subsource.sort` | Subsource display order. |
| `channel_code` | `map_source` | Standard channel code. |
| `channel` | `lkp_channel.name` | Standard channel name. |
| `channel_sort` | `lkp_channel.sort` | Channel display order. |
| `channel_group_code` | `lkp_channel.channel_group_code` | Standard channel group code. |
| `channel_group` | `lkp_channel_group.name` | Standard channel group name. |
| `channel_group_sort` | `lkp_channel_group.sort` | Channel group display order. |
| `is_active` | `map_source` | Active mapping flag. |

## `vw_rate`

`vw_rate` joins mapped rate values to rate type, company, segment, channel, source, subsource, and consortia labels.

| Column | Source | Definition |
|---|---|---|
| `property_code` | `map_rate` | Property code. |
| `system` | `map_rate` | Source system. |
| `map_rate_code` | `map_rate.code` | Source-system rate code. |
| `map_rate_name` | `map_rate.name` | Source-system rate name. |
| `ratetype_code` | `map_rate` | Standard rate type code. |
| `ratetype` | `lkp_ratetype.name` | Standard rate type name. |
| `ratetype_sort` | `lkp_ratetype.sort` | Rate type display order. |
| `company_code` | `map_rate` | Standard company code. |
| `company` | `lkp_company.name` | Company name. |
| `company_category` | `lkp_company.category` | Company category. |
| `industry` | `lkp_company.industry` | Company industry. |
| `segment_code` | `map_rate` | Standard segment code. |
| `segment` | `lkp_segment.name` | Standard segment name. |
| `segment_sort` | `lkp_segment.sort` | Segment display order. |
| `channel_code` | `map_rate` | Standard channel code. |
| `channel` | `lkp_channel.name` | Standard channel name. |
| `channel_sort` | `lkp_channel.sort` | Channel display order. |
| `source_code` | `map_rate` | Standard source code. |
| `source` | `lkp_source.name` | Standard source name. |
| `source_sort` | `lkp_source.sort` | Source display order. |
| `subsource_code` | `map_rate` | Standard subsource code. |
| `subsource` | `lkp_subsource.name` | Standard subsource name. |
| `subsource_sort` | `lkp_subsource.sort` | Subsource display order. |
| `consortia_code` | `map_rate` | Standard consortia code. |
| `consortia` | `lkp_consortia.name` | Consortia name. |
| `consortia_short_name` | `lkp_consortia.short_name` | Consortia short name. |
| `consortia_sort` | `lkp_consortia.sort` | Consortia display order. |
| `is_active` | `map_rate` | Active mapping flag. |

---

## Relationship to Booking, Pace, Actuals, and Pricing

Source and rate mappings are used during ingestion to resolve source-system values into standard reporting codes.

Example source resolution:

```text
source file source/subsource code
  → map_source.code + map_source.code_reference
  → source_code / subsource_code / channel_code
  → target table source_code, subsource_code, channel_code
```

Example rate resolution:

```text
source file rate code
  → map_rate.code
  → ratetype_code / company_code / segment_code / channel_code / source_code / subsource_code / consortia_code
  → target table rate and commercial attributes
```

Target tables may use these fields depending on grain and source availability:

```text
source_code
subsource_code
channel_code
channel_group_code
rate_code
ratetype_code
company_code
segment_code
consortia_code
iata
```

## Operating Notes

1. Use `lkp_`, not `lpk_`, for lookup tables.
2. Mapping tables are universal by `property_code + system + code`; they do not include report-level grain.
3. Source reports belong in ingestion metadata, not source or rate mapping tables.
4. `code_reference` is required in `map_source` because some systems map source and subsource differently, and some do not provide subsource at all.
5. When no subsource exists, target fact/snapshot tables may set `subsource_code = source_code` to keep the model structurally consistent.
6. Views should expose sort fields from lookup tables so Metrics can display values in the intended order.
7. Keep agency, company, consortia, source, channel, and rate separate. They answer different questions, even when a source system tries to stuff them into one field.
