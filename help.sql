
prompt Command           Description
prompt ==============    ==============================================================
prompt @help             Displays this help screen
prompt @ascii            ASCII table for printable characters
prompt @d TABLENAME      Shortcut for describing table columns
prompt @date             Set date format to DD/MM/YYYY and show current date
prompt @datetime         Set date/time format to DD/MM/YYYY HH24:MI:SS and show current 
prompt @exp TABLENAME    Generate an export script with INSERT commands for a given table
prompt @lsind TABLENAME  List index and columns for a given table
prompt @me               Display some information for current user session
prompt @me2              Display more detailed information for current user session
prompt @obj PATTERN      Search database object names by a given pattern
prompt @pkreset          Shortcut for dbms_session.reset_package
prompt @prompt           Set SQL*Plus based on current user and connection
prompt @ptbr             Set codepage to Latin-1 (1252) and NLS settings for Brazilian Portuguese
prompt @s TABLENAME      Shortcut for "select * from TABLENAME order by 1"
prompt @sid TABLENAME ID Shortcut for "select * from TABLENAME where id_TABLENAME = 'ID' order by 1"
prompt @search PATTERN   Search source code for a given text pattern (case insensitive)
prompt @spon             Begin spooling output to a new text file at temporary directory
prompt @spoff            Stop spooling and open generated file on default viewer/editor
prompt @spredo           Restart spooling to same file if interrupted
prompt @tron             Enable autotrace, explain plan 
prompt @troff            Disable autotrace
prompt @warn             Enable PL/SQL warnings
prompt @warnoff          Disable PL/SQL warnings
prompt
prompt Edit these scripts for custom settings
prompt
prompt Scripts           Description
prompt ==============    ==============================================================
prompt default.sql       Set default value for SQL*Plus configuration
prompt login.sql         Script that runs automatically at login
prompt sid.sql           Edit if most of your tables use just ID or TABLENAME_ID as primary key
