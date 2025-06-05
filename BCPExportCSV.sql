---------------------
-- Charlton E Julius
-- Created: 2016-03-30
-- Purpose: Export table to CSV with BCP
---------------------

/*

Requirements:
	SQL Agent and SQL Service users will need full access to the directory.
	A SQL user wil be needed for authentication if not AD user
	xp_cmdshell will need to be enabled

Use the following for testing:
	EXEC master..xp_cmdshell 'DIR C:\'
	exec master..xp_fixeddrives
	PRINT @bcpCommand

Misc:
	-t, switch places a comman in between column output

*/


DECLARE @FileName VARCHAR(50)
   ,@bcpCommand VARCHAR(2000);
SET @FileName = REPLACE('c:\folder\file_' + CONVERT(CHAR(8), GETDATE(), 1)
                        + '.txt', '/', '-');
SET @bcpCommand = 'bcp "SELECT * FROM SOMETABLE" queryout "';
SET @bcpCommand = @bcpCommand + @FileName + '" -U username -P password -c -t,';
EXEC master..xp_cmdshell @bcpCommand