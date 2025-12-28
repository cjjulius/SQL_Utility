---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Differing Methods to Query CDC
---------------------

/*

METHOD 1 - Pull from SYSDATETIME()

*/

DECLARE 
  @s DATE = SYSDATETIME(),                  -- start today at midnight
  @e DATE = DATEADD(DAY, 1, SYSDATETIME()), -- end tomorrow at midnight
  @sl BINARY(10),                           -- start LSN 
  @el BINARY(10);                           -- end LSN

SELECT 
  @sl = sys.fn_cdc_map_time_to_lsn('smallest greater than or equal', @s),
  @el = sys.fn_cdc_map_time_to_lsn('largest less than',              @e);

SELECT @sl, @el; -- start LSN and end LSN within today

SELECT * 
FROM cdc.fn_cdc_get_all_changes_dbo_SomeTable(@sl, @el, 'all');


/*

METHOD 2 - SET DATE TIME

*/

DECLARE @begin_time datetime, @end_time datetime, @begin_lsn binary(10), @end_lsn binary(10);

SET @begin_time = '2016-01-11 11:00:00.000';
SET @end_time = '2016-01-11 11:15:00.000';

SELECT @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time);
SELECT @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);
SELECT * 
FROM cdc.fn_cdc_get_all_changes_dbo_SomeTable(@begin_lsn, @end_lsn, 'all');


/*

METHOD 3 - IF ERROR

*/


DECLARE @begin_time DATETIME, 
		@end_time DATETIME, 
		@begin_lsn BINARY(10), 
		@end_lsn BINARY(10), 
		@min_lsn BINARY(10), 
		@max_lsn BINARY(10);

SET @begin_time = '2015-03-23 00:00:00.000';
SET @end_time   = '2017-01-24 00:00:00.000';

SELECT @begin_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @begin_time);
SELECT @end_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @end_time);

SELECT @min_lsn = sys.fn_cdc_get_min_lsn('dbo_SomeTable')
SELECT @max_lsn = sys.fn_cdc_get_max_lsn()

IF @begin_lsn < @min_lsn BEGIN
  SELECT @begin_lsn = @min_lsn
END

IF @end_lsn > @max_lsn BEGIN
  SELECT @end_lsn = @max_lsn
END

SELECT dbo.UDF_Convert_Hex_to_Binary(cdc.[__$update_mask]), * 
FROM cdc.fn_cdc_get_all_changes_dbo_SomeTable(@begin_lsn, @end_lsn, 'all') AS cdc;


/*

METHOD 4 - ARE THE FIELDS UPDATED

*/



DECLARE @from_lsn binary (10) ,@to_lsn binary (10) 
DECLARE @LastModifiedUserPosition INT
	,@Position INT 
	,@IdPosition INT 
	,@MarksPosition INT 
	,@LocationPos INT 
	,@ValuePos INT 
SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_SomeTable') 
SET @to_lsn = sys.fn_cdc_get_max_lsn() 
SET @LastModifiedUser = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'LastModifiedUser') 
SET @Position = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'Scars') 
SET @IdPosition = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'RaceId') 
SET @Position = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'Marks') 
SET @LocationPos = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'PatientLocation') 
SET @ValuePos = sys.fn_cdc_get_column_ordinal('dbo_SomeTable', 'Value') 

SELECT	fn_cdc_get_all_changes_dbo_SomeTable.__$operation 
	,fn_cdc_get_all_changes_dbo_SomeTable.__$update_mask 
	,sys.fn_cdc_is_bit_set(@LastModifiedUserPosition, __$update_mask) as 'Updated_LastModifiedUser' 
	,sys.fn_cdc_is_bit_set(@Position, __$update_mask) as 'Updated_Position' 
	,sys.fn_cdc_is_bit_set(@IdPosition, __$update_mask) as 'Updated_Id' 
	,sys.fn_cdc_is_bit_set(@MarksPosition, __$update_mask) as 'Updated_Marks' 
	,sys.fn_cdc_is_bit_set(@LocationPos, __$update_mask) as 'Updated_Location' 
	,sys.fn_cdc_is_bit_set(@ValuePos, __$update_mask) as 'Updated_Value' 
FROM cdc.fn_cdc_get_all_changes_dbo_SomeTable(@from_lsn, @to_lsn, 'all') 
ORDER BY __$seqval


/*

Compare table with CDC

*/

SELECT  tettbs.Id
       ,tettbs.Scars
       ,CDCVer.[__$operation]
       ,CDCVer.IsActive AS 'CDC IsActive'
       ,tettbs.IsActive AS 'TETTBS IsActive'
INTO	Cleanup.ChangeTableTETTBS
FROM    dbo.tbl_dbo_LocationBySite tettbs
INNER JOIN ( SELECT [__$start_lsn]
                   ,[__$seqval]
                   ,[__$operation]
                   ,[__$update_mask]
                   ,Id
                   ,Scars
                   ,TreatmentTypeId
                   ,RequiresApproval
                   ,ApprovalLevelId
                   ,IsActive
                   ,RequiresRetrospectiveReview
                   ,LastModifiedDate
                   ,LastModifiedUser
             FROM   cdc.fn_cdc_get_all_changes_dbo_tbl_dbo_LocationBySite(@begin_lsn,
                                                              @end_lsn, 'all')
           ) AS CDCVer ON CDCVer.Id = tettbs.Id;

/*

CDC Notes

_$operation
	1 = delete, 
	2 = insert, 
	3 = value before update
	4 = value after update

_$update_mask
	1 = Column Changed
	0 = Coumn unchanged

*/