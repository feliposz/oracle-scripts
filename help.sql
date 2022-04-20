
prompt Command           Description
prompt ==============    ==============================================================
prompt @help             Displays this help screen
prompt @ascii            ASCII table for printable characters
prompt @d TABLENAME      Shortcut for describing table columns
prompt @ddl OBJECT       Export DDL source code to a script on temporary directory
prompt @date             Set date format to DD/MM/YYYY and show current date
prompt @datetime         Set date/time format to DD/MM/YYYY HH24:MI:SS and show current 
prompt @h                Display date/time information in several formats
prompt @exp TABLENAME    Generate an export script with INSERT commands for a given table
prompt @export TABLENAME Generate an export script for a given TABLENAME
prompt @export QUERY     Generate an export script for a given QUERY
prompt @lsind TABLENAME  List index and columns for a given table
prompt @me               Display some information for current user session
prompt @me2              Display more detailed information for current user session
prompt @obj PATTERN      Search database object names by a given pattern
prompt @pkreset          Shortcut for dbms_session.reset_package
prompt @prompt           Set SQL*Plus based on current user and connection
prompt @ptbr             Set codepage to Latin-1 (1252) and NLS settings for Brazilian Portuguese
prompt @nls              Display NLS information
prompt @detail QUERY     Execute QUERY and display columns as rows for easier visualization
prompt @s TABLENAME      Shortcut for "select * from TABLENAME order by 1"
prompt @sid TABLENAME ID Shortcut for "select * from TABLENAME where id_TABLENAME = 'ID' order by 1"
prompt @count TABLENAME  Shortcut for "select count(1) from TABLENAME"
prompt @search PATTERN   Search source code for a given text pattern (case insensitive)
prompt @spon             Begin spooling output to a new text file at temporary directory
prompt @spoff            Stop spooling and open generated file on default viewer/editor
prompt @spredo           Restart spooling to same file if interrupted
prompt @tab              List tables for current user
prompt @tron             Enable autotrace, explain plan 
prompt @troff            Disable autotrace
prompt @warn             Enable PL/SQL warnings
prompt @warnoff          Disable PL/SQL warnings
prompt @recomp PATTERN   Recompile invalid objects matching given PATTERN (use "" to recompile all)
prompt @set_save         Save current SQL*Plus settings to a temporary script
prompt @set_restore      Restore saved SQL*Plus settings
prompt @copy_grants A B  Generate a script to replicate the same grants from user A (grantor) to user B (grantee)
prompt @count_objects    Count objects by type
prompt @count_invalid    Count invalid objects by type
prompt @used_space       Estimate used disk space for all user tables
prompt @make_update      Generate a formatted UPDATE statement. (Run without arguments for usage information.)
prompt @make_insert      Generate a formatted INSERT statement. (...)
prompt @make_ins_block   Generate a formatted INSERT block.     (...)
prompt @make_ins_proc    Generate a generic INSERT procedure.   (...)
prompt @make_proc_doc    Generate some generic boilerplate comments to help document a procedure. (...)
prompt @make_named_call  Generate an anonymous block calling a procedure with named arguments.
prompt
prompt Edit these scripts for custom settings
prompt
prompt Scripts           Description
prompt ==============    ==============================================================
prompt default.sql       Set default value for SQL*Plus configuration
prompt login.sql         Script that runs automatically at login
prompt sid.sql           Edit if most of your tables use just ID or TABLENAME_ID as primary key
