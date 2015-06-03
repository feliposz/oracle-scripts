SET VERIFY OFF;
SELECT owner, object_name, object_type
FROM all_objects
WHERE object_name LIKE UPPER('%&&object_name%')
ORDER BY owner, object_type, object_name;
