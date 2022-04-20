# Oracle Scripts

A collection of some useful SQL and PL/SQL Oracle scripts for everyday use on SQL*Plus or SQL Developer.

Uma coleção de alguns scripts úteis para Oracle em SQL e PL/SQL para uso diário no SQL*Plus ou SQL Developer.

## Installation

* SQL*Plus:
    * On the command prompt do: `set SQLPATH=C:\path\to\scripts\`
    * Or set the environment variables at control panel on Windows

* SQL Developer:
    * Go to menu *Tools > Preferences*, select *Database > Worksheet*, in *Select default path to look for scripts* enter: `C:\path\to\scripts\`

## Help

```
Command           Description
==============    ==============================================================
@help             Displays this help screen
@ascii            ASCII table for printable characters
@d TABLENAME      Shortcut for describing table columns
@ddl OBJECT       Export DDL source code to a script on temporary directory
@date             Set date format to DD/MM/YYYY and show current date
@datetime         Set date/time format to DD/MM/YYYY HH24:MI:SS and show current
@h                Display date/time information in several formats
@exp TABLENAME    Generate an export script with INSERT commands for a given table
@export TABLENAME Generate an export script for a given TABLENAME
@export QUERY     Generate an export script for a given QUERY
@lsind TABLENAME  List index and columns for a given table
@me               Display some information for current user session
@me2              Display more detailed information for current user session
@obj PATTERN      Search database object names by a given pattern
@pkreset          Shortcut for dbms_session.reset_package
@prompt           Set SQL*Plus based on current user and connection
@ptbr             Set codepage to Latin-1 (1252) and NLS settings for Brazilian Portuguese
@nls              Display NLS information
@detail QUERY     Execute QUERY and display columns as rows for easier visualization
@s TABLENAME      Shortcut for "select * from TABLENAME order by 1"
@sid TABLENAME ID Shortcut for "select * from TABLENAME where id_TABLENAME = 'ID' order by 1"
@count TABLENAME  Shortcut for "select count(1) from TABLENAME"
@search PATTERN   Search source code for a given text pattern (case insensitive)
@spon             Begin spooling output to a new text file at temporary directory
@spoff            Stop spooling and open generated file on default viewer/editor
@spredo           Restart spooling to same file if interrupted
@tab              List tables for current user
@tron             Enable autotrace, explain plan
@troff            Disable autotrace
@warn             Enable PL/SQL warnings
@warnoff          Disable PL/SQL warnings
@recomp PATTERN   Recompile invalid objects matching given PATTERN (use "" to recompile all)
@set_save         Save current SQL*Plus settings to a temporary script
@set_restore      Restore saved SQL*Plus settings
@copy_grants A B  Generate a script to replicate the same grants from user A (grantor) to user B (grantee)
@count_objects    Count objects by type
@count_invalid    Count invalid objects by type
@used_space       Estimate used disk space for all user tables
@make_update      Generate a formatted UPDATE statement. (Run without arguments for usage information.)
@make_insert      Generate a formatted INSERT statement. (...)
@make_ins_block   Generate a formatted INSERT block.     (...)
@make_ins_proc    Generate a generic INSERT procedure.   (...)
@make_proc_doc    Generate some generic boilerplate comments to help document a procedure. (...)
@make_named_call  Generate an anonymous block calling a procedure with named arguments.

Edit these scripts for custom settings

Scripts           Description
==============    ==============================================================
default.sql       Set default value for SQL*Plus configuration
login.sql         Script that runs automatically at login
sid.sql           Edit if most of your tables use just ID or TABLENAME_ID as primary key
```
