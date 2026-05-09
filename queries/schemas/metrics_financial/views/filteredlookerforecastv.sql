CREATE OR REPLACE VIEW `aparium-dataflow.FinanceData.FilteredLookerForecastV`
AS SELECT 
    snapshot_date,
    property_code,
    property_name,
    finance_period,
    segment_code,
    segment_name,
    metric,
    'Forecast' AS data_source,  -- Explicitly setting data_source
    available_rms,
    
    -- Unpivoted month column names
    month_name,

    -- Value from each month column
    value_column,

    -- Calculate total available rooms dynamically
    available_rms * 
    CASE 
        WHEN month_name IN ('month_01', 'month_03', 'month_05', 'month_07', 'month_08', 'month_10', 'month_12') THEN 31
        WHEN month_name IN ('month_04', 'month_06', 'month_09', 'month_11') THEN 30
        WHEN month_name = 'month_02' THEN 
            CASE WHEN MOD(EXTRACT(YEAR FROM snapshot_date), 4) = 0 THEN 29 ELSE 28 END
        ELSE NULL 
    END AS total_available_rms

FROM `aparium-dataflow.FinanceData.FinanceForecast`

-- Unpivot (Melt) the data: Convert month columns into rows
UNPIVOT (
    value_column FOR month_name IN (
        month_01, month_02, month_03, month_04, month_05, month_06, 
        month_07, month_08, month_09, month_10, month_11, month_12
    )
);