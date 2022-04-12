SET VERIFY OFF;
col INDEX_OWNER     format a20
col INDEX_NAME      format a30
col TABLE_OWNER     format a20
col TABLE_NAME      format a30
col COLUMN_NAME     format a30
col DESCEND         format a10

SELECT table_owner,
       table_name,
       index_owner,
       index_name,
       column_position,
       column_name,
       column_length,
       char_length,
       descend
FROM all_ind_columns
WHERE table_name LIKE UPPER('%&1%')
ORDER BY
      table_owner,
      table_name,
      index_owner,
      index_name,
      column_position;

col INDEX_OWNER     clear
col INDEX_NAME      clear
col TABLE_OWNER     clear
col TABLE_NAME      clear
col COLUMN_NAME     clear
col DESCEND         clear
