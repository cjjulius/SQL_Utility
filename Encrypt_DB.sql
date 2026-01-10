---------------------
-- Charlton E Julius
-- Created: 2016-03-22
-- Purpose: Encrypt Database with Cert
---------------------

/*
Create Master Key with Password
*/

USE [master]
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD ='PASSWORD'
GO

/*
Create Certificate
*/

CREATE CERTIFICATE SOMESERVERCert 
WITH SUBJECT = 'SOMESERVER Certificate';
GO


/*
Backup Certificate
ZIP together in folder SOMESERVERCert_Certificate_Backup.zip
*/
 
USE [master];
BACKUP CERTIFICATE SOMESERVERCert
TO FILE = 'SOMESERVERCert_Export.cert'
WITH PRIVATE KEY (
FILE = 'PrivateKeyFile_SOMESERVERCert.pvk',
ENCRYPTION BY PASSWORD = 'CERTPASSWORD'
);
GO


/*
Encrypt Database
*/

USE [SOMEDATABASE]
GO

CREATE DATABASE ENCRYPTION KEY 
	WITH ALGORITHM = AES_256 
	ENCRYPTION BY SERVER CERTIFICATE SOMESERVERCert
GO

 ALTER DATABASE [SOMEDATABASE]
SET ENCRYPTION ON
GO

 
 /*
 Verify Encryption
 */

 SELECT d.name,
	d.database_id,
	CASE dek.encryption_state 
		WHEN 0 THEN 'None'
		WHEN 1 THEN 'Unencrypted'
		WHEN 2 THEN 'Encryption In Progress'
		WHEN 3 THEN 'Encrypted'
		WHEN 4 THEN 'Encryption Key Changes In Progress'
		WHEN 5 THEN 'Decryption In Progress'
	END AS 'State'	
FROM sys.databases d
INNER JOIN sys.dm_database_encryption_keys dek
ON dek.database_id = d.database_id

/*

Find Keys and Thumbprints

*/

SELECT	[name]
	   ,[pvt_key_encryption_type_desc]
	   ,[issuer_name]
	   ,[subject]
	   ,[thumbprint]
FROM	[sys].[certificates] AS [c];