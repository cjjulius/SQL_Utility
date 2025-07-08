---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Find All Heaps
---------------------


SELECT TOP 1000
        s.name
       ,o.name
       ,i.type_desc
       ,o.type_desc
       ,o.create_date
       ,o.modify_date
FROM    sys.indexes i
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.schemas AS s ( NOLOCK ) ON s.schema_id = o.schema_id
WHERE   o.type_desc = 'USER_TABLE'
        AND i.type_desc = 'HEAP'
ORDER BY s.name
       ,o.modify_date DESC;
GO