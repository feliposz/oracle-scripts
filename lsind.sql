SET VERIFY OFF;
UNDEF table_name

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
WHERE table_name LIKE UPPER('%&table_name%')
ORDER BY
      table_owner,
      table_name,
      index_owner,
      index_name,
      column_position;

UNDEF table_name
