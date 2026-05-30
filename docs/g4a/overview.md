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