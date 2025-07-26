---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Show all Extended Properties in Current DB
---------------------

SELECT  p.name
       ,p.value
       ,t.name AS TableName
       ,c.name AS ColumnName
FROM    sys.tables t
JOIN    sys.columns c ON t.object_id = c.object_id
LEFT JOIN sys.extended_properties p ON p.major_id = t.object_id
ORDER BY t.name DESC
       ,c.name DESC;
       