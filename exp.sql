-- quick export script
set echo off verify off feedback off linesize 3000 pagesize 0 term off feedback off heading off timing off

define SQL_EXPORT_FILE=%TEMP%\__export_query__.sql
spool &SQL_EXPORT_FILE

select 'select ''insert into ' || table_name || '(' || 
       listagg(column_name, ',') within group (order by column_id) || 
       ') values (''''''||' ||
       listagg(column_name, '||'''''',''''''||') within group (order by column_id) || 
       '||'''''');'' as script from '  || owner || '.' || table_name || ';' as vv_query
from all_tab_columns 
where owner || '.' || table_name in (upper('&1'), user || '.' || upper('&1'))
group by table_name, owner;

spool off

set verify on feedback on term on feedback on heading on timing on
@&SQL_EXPORT_FILE
$ del &SQL_EXPORT_FILE
undef SQL_EXPORT_FILE
