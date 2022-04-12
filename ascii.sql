set linesize 200
select listagg( to_char(num, '000') || ' ' || decode(num, 7, ' ', 8, ' ', 9, ' ', 10, ' ', 27, ' ', chr(num))) within group (order by num) as ascii_tab
from (
  select level-1 as num
  from dual 
  connect by level <= 128
)
group by trunc(num/8);

select listagg( decode(num, 7, ' ', 8, ' ', 10, ' ', 27, ' ', chr(num)), '') within group (order by num) as ascii_chars
from (
  select level-1 as num
  from dual 
  connect by level <= 127
)
group by trunc(num/32);
