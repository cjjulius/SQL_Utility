---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Index Fragmentation
---------------------

/*

----------ALL INDEXES---------

*/

SELECT  OBJECT_NAME(ind.object_id) AS TableName
       ,ind.name AS IndexName
       ,indexstats.index_type_desc AS IndexType
       ,indexstats.avg_fragmentation_in_percent
	   ,indexstats.page_count
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats
INNER JOIN sys.indexes ind ON ind.object_id = indexstats.object_id
                              AND ind.index_id = indexstats.index_id
WHERE   indexstats.avg_fragmentation_in_percent > 50
ORDER BY indexstats.avg_fragmentation_in_percent DESC, indexstats.page_count DESC;




/*
--------SINGLE OBJECT---------
*/

SELECT [database_id]
        ,ind.[object_id]
        ,ind.[index_id]
        ,[partition_number]
        ,[index_type_desc]
        ,[index_depth]
        ,[index_level]
        ,[avg_fragmentation_in_percent]
        ,[fragment_count]
        ,[avg_fragment_size_in_pages]
        ,[page_count]
        ,ind.name
 FROM sys.dm_db_index_physical_stats(DB_ID(N'SomeDB'), OBJECT_ID(N'dbo.fSomeTable'), NULL, NULL , 'LIMITED')
	INNER JOIN sys.indexes ind ON ind.object_id = dm_db_index_physical_stats.object_id
                                AND ind.index_id = dm_db_index_physical_stats.index_id;
--WHERE   [avg_fragmentation_in_percent] > 10.0
--		AND [index_id] > 0
--		AND [page_count] > 100
