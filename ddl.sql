SET DEFINE "&"
SET TRIMSPOOL ON
COLUMN TEXT FORMAT A2000
COLUMN fs_spoolpath NEW_VALUE v_fs_spoolpath
SET HEADING OFF TIMING OFF FEEDBACK OFF
$"mkdir C:\TEMP\SRC\ 2>NUL"
SELECT 'C:\TEMP\SRC\&&1' || '.' || TO_CHAR(SYSDATE, 'YYYYMMDD_HH24MISS') || '.SQL' AS fs_spoolpath FROM DUAL;
SET WRAP ON
SET LONG 1000000
COLUMN ddl_text FORMAT A3000 WRAP
SPOOL '&v_fs_spoolpath'
SELECT dbms_metadata.get_ddl(object_type, object_name, owner) AS ddl_text
FROM all_objects
WHERE object_type NOT IN ('SYNONYM', 'PACKAGE BODY')
  AND (
        owner || '.' || object_name = UPPER('&&1')  
        OR (
             object_name = UPPER('&&1') 
             AND owner = COALESCE( ( SELECT MIN(owner) FROM all_objects WHERE object_name = UPPER('&&1') AND owner = USER )
                                 , ( SELECT MIN(owner) FROM all_objects WHERE object_name = UPPER('&&1') AND owner = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') )
                                 , ( SELECT MIN(owner) FROM all_objects WHERE object_name = UPPER('&&1') AND object_type <> 'SYNONYM' )
                                 )
           )
      );
SPOOL OFF
$ start &v_fs_spoolpath
UNDEF 1
SET HEADING ON TIMING ON FEEDBACK ON
