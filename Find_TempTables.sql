---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Find Temp Table Information
---------------------


USE tempdb;
GO

--ALL Temp Tables

SELECT  name
       ,object_id
       ,principal_id
       ,schema_id
       ,parent_object_id
       ,type
       ,type_desc
       ,create_date
       ,modify_date
       ,is_ms_shipped
       ,is_published
       ,is_schema_published
FROM    tempdb.sys.objects
WHERE   name LIKE '#%';

--All User Temp tables

SELECT  LEFT(name, CHARINDEX('_', name) - 1)
FROM    tempdb..sysobjects
WHERE   CHARINDEX('_', name) > 0
        AND xtype = 'u'
        AND NOT OBJECT_ID('tempdb..' + name) IS NULL;