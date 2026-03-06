/*==============================================================================
  Script Name:   missing_indexes.sql
  Description:   Reports missing indexes as suggested by the SQL Server query
                 optimizer, ranked by the estimated improvement impact.
                 Covers all user databases on the instance.  The impact score
                 is calculated from avg_user_impact * (user_seeks + user_scans).

  Usage:         Run as-is on the target SQL Server instance.  Review the
                 output and evaluate whether the suggested indexes are worth
                 creating.  For fragmentation details on existing indexes, see
                 index_fragmentation.sql.  Before creating indexes, check
                 identify_unused_indexes.sql to avoid adding redundant ones.

  SQL Versions:  SQL Server 2008 and later
  Author:        charlton-julius
  Date:          2025-10-14
==============================================================================*/

SELECT
    d.name                                                      AS DatabaseName,
    migs.avg_total_user_cost * (migs.avg_user_impact / 100.0)
        * (migs.user_seeks + migs.user_scans)                   AS ImpactScore,
    migs.avg_user_impact                                        AS AvgUserImpactPct,
    migs.user_seeks                                             AS UserSeeks,
    migs.user_scans                                             AS UserScans,
    mid.statement                                               AS TableName,
    mid.equality_columns                                        AS EqualityColumns,
    mid.inequality_columns                                      AS InequalityColumns,
    mid.included_columns                                        AS IncludedColumns,
    'CREATE INDEX [NCIX_' + OBJECT_NAME(mid.object_id, mid.database_id)
        + '_missing_' + CAST(migs.group_handle AS VARCHAR(10)) + '] ON '
        + mid.statement + ' ('
        + ISNULL(mid.equality_columns, '')
        + CASE
              WHEN mid.equality_columns IS NOT NULL
                   AND mid.inequality_columns IS NOT NULL THEN ','
              ELSE ''
          END
        + ISNULL(mid.inequality_columns, '')
        + ')'
        + CASE
              WHEN mid.included_columns IS NOT NULL
                  THEN ' INCLUDE (' + mid.included_columns + ')'
              ELSE ''
          END
        + ';'                                                    AS CreateIndexStatement
FROM sys.dm_db_missing_index_groups          AS mig
JOIN sys.dm_db_missing_index_group_stats     AS migs ON mig.index_group_handle = migs.group_handle
JOIN sys.dm_db_missing_index_details         AS mid  ON mig.index_handle       = mid.index_handle
JOIN sys.databases                           AS d    ON mid.database_id         = d.database_id
ORDER BY ImpactScore DESC;
