CREATE OR REPLACE VIEW `aparium-dataflow.PaceData.PaceData_SegmentActualsV` AS  
SELECT  
    p.*,  -- Select all columns from PaceData_Segment  
    m.segment_sort,  
    m.segment_group,  
    m.segment_group_code,  
    m.finance_segment  
FROM `aparium-dataflow.PaceData.PaceData_SegmentActuals` p  
LEFT JOIN `aparium-dataflow.MappingTables.Segment` m  
    ON p.segment = m.segment  
--QUALIFY ROW_NUMBER() OVER (PARTITION BY p.stay_date, p.segment ORDER BY p.snapshot_date DESC) = 1;