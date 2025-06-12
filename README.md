# SQL_Utility
Scripts and Related Items for Utility Purposes.
All of this is of course "At your own risk". Don't run code you haven't vetted. Even if it's from me.

##  BCPExportCSV.sql
Takes a table target and uses SQL Server BCP to export it to CSV directory.

##  Latches.sql
Shows all the latches that are waiting. Set the percentage threshold at the bottom based on preferences. 95% I feel is a pretty good number, though.

## States_Territories_US.sql
Creates a table and inserts US states and territories into it. I couldn't find anything that did exactly this with what I needed, so here it is.

## AllDatabases_and_Size.sql
Has a few different ways to display all databases on a SQL Server and their size. Will also report the resourcedb information as well.

## All_tables_without_indexes.sql
All the tables in a database that don't have an index.
