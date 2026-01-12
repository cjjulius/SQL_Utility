# SQL_Utility
Scripts and Related Items for Utility Purposes. SQL Server 2016+
All of this is of course "At your own risk". Don't run code you haven't vetted. Even if it's from me.
<br />

## Server

### Encrypt_DB.sql
The basic process of encrypting a database and verifying that it is encrypted properly in SQL Server.

### Execution_Plans.sql
Gets execultion plans in a variety of ways to troubleshoot a misbehaving procedure. Best whe used in tandem with query store.

### Latches.sql
Shows all the latches that are waiting. Set the percentage threshold at the bottom based on preferences. 95% I feel is a pretty good number, though.

### Change_Job_Owners.sql
Shows you all the jobs on a server not owned by an account and then lets you change them all to that owner. 'sa' is the default, but you can set it to anyone.
<br />

## Database

### AllDatabases_and_Size.sql
Has a few different ways to display all databases on a SQL Server and their size. Will also report the resourcedb information as well.

### Backup_History.sql
Displays all the databases that haven't been backed up in a given amount out time.

### Database_Stats.sql
Some basic database file stats. Sizes and location

### Extended_Properties.sql
Show all the extended properties in the database.

### Restore_Progress.sql
Database Restore progress as completion percentage and estimates time to complete.
<br />

## Table/Index

### All_tables_without_indexes.sql
All the tables in a database that don't have an index.

### BCPExportCSV.sql
Takes a table target and uses SQL Server BCP to export it to CSV directory.

### Check_Index_Frag.sql
Shows fragmentation of all indexes. used 50% as a fragmentation limit to start. Second script to target a single table object.

### Find_TempTables.sql
Shows all temp tables in SQL Server along with information about them.

### Tables_Heaps.sql
Shows all tables that are heaps in the current database.
 <br />
 
## Misc

### CDC_Query.sql
Various methods to query CDC. Join with changes on a table, or see within a timerange.

### Create_Deadlock.sql
Creates a Deadlock in SQL Server Using defult Read Committed Isolation mode. For testing alterting or just for fun. ¯\_(ツ)_/¯

### States_Territories_US.sql
Creates a table and inserts US states and territories into it. I couldn't find anything that did exactly this with what I needed, so here it is.