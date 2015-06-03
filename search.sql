SET DEFINE "&"
ACCEPT referenced_name PROMPT "Referenced name: "
ACCEPT text PROMPT "Search text: "

SELECT owner, name, line, text 
  FROM all_source 
 WHERE UPPER(text) LIKE UPPER('%&text%') 
   AND name IN ( SELECT name FROM all_dependencies WHERE referenced_name = UPPER('&referenced_name') )
 ORDER BY owner, name, line;
PROMPT

UNDEF referenced_name
UNDEF text
