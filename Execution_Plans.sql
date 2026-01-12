---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Find Execution Plans and KeyLookups
---------------------


/*
    Look for Execution plans related to a specific object.
    Used a sproc here, but can be a table, udf column etc.
*/
SELECT UseCounts, Cacheobjtype, Objtype, TEXT, query_plan, text
FROM sys.dm_exec_cached_plans 
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
CROSS APPLY sys.dm_exec_query_plan(plan_handle)
WHERE TEXT LIKE '%SOMEPROC%'


/*
    Same as above but gets some stats.
    Again, can use other db objects
*/
SELECT   qs.sql_handle
        ,qs.creation_time
        ,qs.last_execution_time
        ,qp.dbid
        ,qs.execution_count
        ,qs.last_logical_reads
        ,qs.last_logical_writes
        ,qs.last_physical_reads
        ,st.text
FROM sys.dm_exec_query_stats AS qs
    CROSS APPLY
        sys.dm_exec_sql_text(qs.sql_handle)AS st
    CROSS APPLY
        sys.dm_exec_text_query_plan(qs.plan_handle,DEFAULT,DEFAULT) AS qp
WHERE st.text like '%pSOMEPROC%'---filter by name of object



/*
    Quick and dirty to identify some heavy users in a specific DB
*/
select   query_plan
        ,[text]
        ,total_worker_time 
from dbo.ScanInCacheFromDatabase('[SomeDB]')
order by [total_worker_time] DESC


/*
    Keylookups by query
    This MAXDOPs at 1 so it doesn't take down the server
    Recompile so it doesn't get cached plan
*/
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
 
WITH XMLNAMESPACES
   (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT
    n.value('(@StatementText)[1]', 'VARCHAR(4000)') AS sql_text,
    n.query('.'),
    i.value('(@PhysicalOp)[1]', 'VARCHAR(128)') AS PhysicalOp,
    i.value('(./IndexScan/Object/@Database)[1]', 'VARCHAR(128)') AS DatabaseName,
    i.value('(./IndexScan/Object/@Schema)[1]', 'VARCHAR(128)') AS SchemaName,
    i.value('(./IndexScan/Object/@Table)[1]', 'VARCHAR(128)') AS TableName,
    i.value('(./IndexScan/Object/@Index)[1]', 'VARCHAR(128)') as IndexName,
    i.query('.'),
    STUFF((SELECT DISTINCT ', ' + cg.value('(@Column)[1]', 'VARCHAR(128)')
       FROM i.nodes('./OutputList/ColumnReference') AS t(cg)
       FOR  XML PATH('')),1,2,'') AS output_columns,
    STUFF((SELECT DISTINCT ', ' + cg.value('(@Column)[1]', 'VARCHAR(128)')
       FROM i.nodes('./IndexScan/SeekPredicates/SeekPredicateNew//ColumnReference') AS t(cg)
       FOR  XML PATH('')),1,2,'') AS seek_columns,
    i.value('(./IndexScan/Predicate/ScalarOperator/@ScalarString)[1]', 'VARCHAR(4000)') as Predicate,
    cp.usecounts,
    query_plan
FROM (  SELECT plan_handle, query_plan
        FROM (  SELECT DISTINCT plan_handle
                FROM sys.dm_exec_query_stats WITH(NOLOCK)) AS qs
        OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) tp
      ) as tab (plan_handle, query_plan)
INNER JOIN sys.dm_exec_cached_plans AS cp 
    ON tab.plan_handle = cp.plan_handle
        CROSS APPLY query_plan.nodes('/ShowPlanXML/BatchSequence/Batch/Statements/*') AS q(n)
        CROSS APPLY n.nodes('.//RelOp[IndexScan[@Lookup="1"] and IndexScan/Object[@Schema!="[sys]"]]') as s(i)
ORDER BY cp.usecounts DESC
OPTION(RECOMPILE, MAXDOP 1);
