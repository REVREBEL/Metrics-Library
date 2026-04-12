-- BudgetTools V5 Cloud Migration - BigQuery Schema DDL

-- 1. Daily Segment Data (Transient, Base, COO)
CREATE OR REPLACE TABLE `budget_tools_v5.fact_segment_daily` (
    hotel_id STRING OPTIONS(description="Unique identifier for the property"),
    date DATE OPTIONS(description="Calendar date of occupancy"),
    status STRING OPTIONS(description="Data type: Actual, Budget, Forecast"),
    
    -- Transient Segments (1-12)
    transient_rms_1 INT64, transient_rev_1 FLOAT64,
    transient_rms_2 INT64, transient_rev_2 FLOAT64,
    transient_rms_3 INT64, transient_rev_3 FLOAT64,
    transient_rms_4 INT64, transient_rev_4 FLOAT64,
    transient_rms_5 INT64, transient_rev_5 FLOAT64,
    transient_rms_6 INT64, transient_rev_6 FLOAT64,
    transient_rms_7 INT64, transient_rev_7 FLOAT64,
    transient_rms_8 INT64, transient_rev_8 FLOAT64,
    transient_rms_9 INT64, transient_rev_9 FLOAT64,
    transient_rms_10 INT64, transient_rev_10 FLOAT64,
    transient_rms_11 INT64, transient_rev_11 FLOAT64,
    transient_rms_12 INT64, transient_rev_12 FLOAT64,

    -- Base Segments (Air/Perm)
    base_rms_1 INT64, base_rev_1 FLOAT64,
    base_rms_2 INT64, base_rev_2 FLOAT64,

    -- Extra Revenue Segments (F&B, Misc, etc.)
    extra_rev_1 FLOAT64,
    extra_rev_2 FLOAT64,
    extra_rev_3 FLOAT64,
    extra_rev_4 FLOAT64,

    -- Inventory Blocks
    comp_rms INT64,
    ooo_rms INT64,
    offmkt_rms INT64,

    -- Totals (Calculated or Stored)
    total_rms INT64,
    total_rev FLOAT64,
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
) 
PARTITION BY date
CLUSTER BY hotel_id, status;

-- 2. Group Detail Data (1-6 Segments)
CREATE OR REPLACE TABLE `budget_tools_v5.fact_group_detail` (
    hotel_id STRING,
    date DATE,
    status STRING,
    
    -- Group Segments (1-6)
    group_rms_1 INT64, group_rev_1 FLOAT64,
    group_rms_2 INT64, group_rev_2 FLOAT64,
    group_rms_3 INT64, group_rev_3 FLOAT64,
    group_rms_4 INT64, group_rev_4 FLOAT64,
    group_rms_5 INT64, group_rev_5 FLOAT64,
    group_rms_6 INT64, group_rev_6 FLOAT64,

    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
)
PARTITION BY date
CLUSTER BY hotel_id, status;

-- 3. Hotel Configuration (Segment Labels & Mappings)
CREATE OR REPLACE TABLE `budget_tools_v5.dim_hotel_config` (
    hotel_id STRING,
    segment_type STRING, -- 'Transient', 'Group', 'Base', 'ExRev'
    segment_id INT64,
    segment_label STRING,
    is_active BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP()
);
