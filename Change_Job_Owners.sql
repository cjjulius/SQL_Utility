---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Find all non-sa jobs and rectify
---------------------


SELECT  s.name
       ,SUSER_SNAME(s.owner_sid) AS owner
       ,s.owner_sid
FROM    msdb..sysjobs s 
--WHERE SUSER_SNAME(s.owner_sid) <> 'sa'
ORDER BY name;


/*
--!NOTE!
-- Will change ALL job owners to 'sa'

DECLARE @name_holder VARCHAR(1000);
DECLARE My_Cursor CURSOR
FOR
    SELECT  [name]
    FROM    msdb..sysjobs; 
OPEN My_Cursor;
FETCH NEXT FROM My_Cursor INTO @name_holder;
WHILE ( @@FETCH_STATUS <> -1 )
    BEGIN
        --EXEC msdb..sp_update_job @job_name = @name_holder,
            @owner_login_name = 'sa';
        FETCH NEXT FROM My_Cursor INTO @name_holder;
    END; 
CLOSE My_Cursor;
DEALLOCATE My_Cursor;

*/
--**Changes the owner of the jobs to sa
