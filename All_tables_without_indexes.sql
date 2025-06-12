---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: All Tables without Indexes
---------------------

SELECT  'Server.SOMEDB.' + s.name + '.' + o.name
FROM    sys.objects o
INNER JOIN sys.schemas AS s ON s.schema_id = o.schema_id
WHERE   type = 'U'
        AND object_id NOT IN ( SELECT   object_id
                               FROM     sys.indexes
                               WHERE    index_id = 1 )
ORDER BY s.name
       ,o.name;