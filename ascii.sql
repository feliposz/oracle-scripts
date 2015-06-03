select listagg( to_char(num, '000') || ' ' || decode(num, 7, ' ', 8, ' ', 10, ' ', chr(num))) within group (order by num) as ascii_tab
from (
  select level-1 as num
  from dual 
  connect by level <= 256
)
group by trunc(num/10);

select listagg( decode(num, 7, ' ', 8, ' ', 10, ' ', chr(num)), '') within group (order by num) as ascii_chars
from (
  select level-1 as num
  from dual 
  connect by level <= 256
)
group by trunc(num/64);
