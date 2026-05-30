# User and Contact Column Standards

This document defines canonical user, audit, contact, and address column names for REVREBEL Metrics Library source documentation, app-owned Postgres schema, analytics warehouse tables, transformed source files, and agent-generated implementation work.

These standards extend the core column naming guidance in `docs/column-naming-standards.md`.

## Core Principles

All columns use lowercase `snake_case`.

Column names must describe the business meaning of the field, not just the storage type.

Avoid generic names such as `email`, `phone`, `address`, `created_at`, `updated_at`, and `created_by_user_id` when a more precise Metrics standard exists.

## Date Columns

The Metrics Library standard uses:

| Concept | Standard Column |
|---|---|
| Inserted Date | `insert_date` |
| Updated Date | `updated_date` |

Do not introduce `created_at`, `updated_at`, `created_date`, or `updated_timestamp` in Metrics-owned schemas or transformed files.

Use source-specific date fields only when preserving upstream system meaning, such as:

| Concept | Standard Column |
|---|---|
| Source Created Date | `source_created_date` |
| Source Updated Date | `source_updated_date` |

## User Reference Columns

Use `user_id` for references to `app_users.id` in app-owned relational schema.

Preferred user reference columns:

| Concept | Standard Column |
|---|---|
| User Identifier | `user_id` |
| User Who Inserted Row | `inserted_by_user_id` |
| User Who Updated Row | `updated_by_user_id` |
| User Assigned to Item | `assigned_to_user_id` |
| User Who Owns Item | `owned_by_user_id` |
| User Who Archived Item | `archived_by_user_id` |
| User Who Deleted Item | `deleted_by_user_id` |

Do not use `created_by_user_id`. Use `inserted_by_user_id` to stay aligned with `insert_date`.

## Email Columns

Avoid generic `email` unless the field is intentionally generic and documented.

Preferred email columns:

| Concept | Standard Column |
|---|---|
| Authentication / Login Email | `login_email` |
| Company / Work Email | `company_email` |
| Personal Email | `personal_email` |

Use `login_email` only for authentication identity or login workflows. Use `company_email` and `personal_email` for contact/profile information.

## Phone Columns

Avoid generic `phone`.

Preferred phone columns:

| Concept | Standard Column |
|---|---|
| Mobile Phone | `mobile` |
| Landline Phone | `landline` |
| Work Desk Phone | `workdesk_phone` |

`workdesk_phone` is preferred over `workdesk` because it clearly identifies the field as a phone value.

## Address Columns

Avoid generic `address` unless the field is intentionally generic and documented.

Preferred address columns:

| Concept | Standard Column |
|---|---|
| Company Address | `company_address` |
| Home Address | `home_address` |

If address fields are decomposed into structured components, prefix each component with the address context.

Examples:

```text
company_address_line_1
company_address_line_2
company_city
company_state
company_postal_code
company_country
home_address_line_1
home_address_line_2
home_city
home_state
home_postal_code
home_country
```

## Auth Provider Columns

When storing identity provider details, use:

| Concept | Standard Column |
|---|---|
| Auth Provider | `auth_provider` |
| Auth Provider User Identifier | `auth_provider_user_id` |

Avoid vendor-specific identifiers in canonical app columns unless the column is intentionally preserving a source-system value.

## Agent Enforcement Checklist

Before creating or modifying source schema, app schema, transformed files, or data documentation, agents must check for and correct non-standard user/contact fields.

Search for:

```text
created_at
updated_at
created_by_user_id
email
phone
address
workdesk
```

Replace with the canonical Metrics standards where appropriate:

```text
insert_date
updated_date
inserted_by_user_id
updated_by_user_id
login_email
company_email
personal_email
mobile
landline
workdesk_phone
company_address
home_address
```

Exceptions must be documented as upstream source-system fields or intentionally generic business fields.
