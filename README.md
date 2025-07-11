# SQL_Utility
Scripts and Related Items for Utility Purposes. SQL Server 2016+
All of this is of course "At your own risk". Don't run code you haven't vetted. Even if it's from me.

## AllDatabases_and_Size.sql
Has a few different ways to display all databases on a SQL Server and their size. Will also report the resourcedb information as well.

## All_tables_without_indexes.sql
All the tables in a database that don't have an index.

## BCPExportCSV.sql
Takes a table target and uses SQL Server BCP to export it to CSV directory.

## Check_Index_Frag.sql
Shows fragmentation of all indexes. used 50% as a fragmentation limit to start. Second script to target a single table object.

## Create_Deadlock.sql
Creates a Deadlock in SQL Server Using defult Read Committed Isolation mode. For testing alterting or just for fun. ¯\_(ツ)_/¯

## Database_Stats.sql
Some basic database file stats. Sizes and location

## Find_TempTables.sql
Shows all temp tables in SQL Server along with information about them.

## Latches.sql
Shows all the latches that are waiting. Set the percentage threshold at the bottom based on preferences. 95% I feel is a pretty good number, though.
Check_Index_Frag.sql

## States_Territories_US.sql
Creates a table and inserts US states and territories into it. I couldn't find anything that did exactly this with what I needed, so here it is.

## Tables_Heaps.sql
Shows all tables that are heaps in the current database.

## Check_Index_Frag.sql
Shows fragmentation of all indexes. used 50% as a fragmentation limit to start. Second script to target a single table object.