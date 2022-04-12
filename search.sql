SET DEFINE "&"
col owner format a20
col name format a30
col text format a100

SELECT owner, name, line, text 
  FROM all_source 
 WHERE UPPER(text) LIKE UPPER('%&1%') 
 ORDER BY owner, name, line;
PROMPT

UNDEF 1
col owner clear
col name clear
col text clear
