COLUMN fs_spoolpath NEW_VALUE v_fs_spoolpath
SELECT 'C:\TEMP\SPOOL_' || TO_CHAR(SYSDATE, 'YYYY-MM-DD_HH24-MI-SS') || '.TXT' AS fs_spoolpath FROM DUAL;
SPOOL '&v_fs_spoolpath'

