SET VERIFY OFF;
col owner format a30
col object_name format a30
col object_type format a30
SELECT owner, object_name, object_type
FROM all_objects
WHERE object_name LIKE UPPER('%&&1%')
ORDER BY owner, object_type, object_name;
col owner clear
col object_name clear
col object_type clear