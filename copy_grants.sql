set termout off
set heading off
set feedback off
set timing off
rephead off
repfoot off
def vv_script=c:\temp\grants_&1._&2..sql
spool &vv_script

prompt set termout off

select 'GRANT ' || privilege || ' ON ' || table_name || ' TO ' || grantee || ';'
  from dba_tab_privs
 where grantor = upper('&1')
   and grantee = upper('&2');

prompt set termout on

spool off
set termout on
set heading on
set feedback on
set timing on
rephead on
repfoot on
prompt Generated script: &vv_script
undef vv_script
