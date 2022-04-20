set verify off
set define on

set serveroutput on format wrapped
declare
  p_query varchar2(3000) := '&1';

  ---
  
  c_tp_varchar2      constant number := 1;
  c_tp_number        constant number := 2;
  c_tp_date          constant number := 12;
  
  v_sql              varchar2(32767) := p_query;
  v_cursor           number;          

  v_col_count        integer;
  v_val_number       number;          
  v_val_text         varchar2(2000);  
  v_val_datetime     date;            

  v_desc_tab         dbms_sql.desc_tab;
  v_ret              number;            

  TYPE typ_detail IS RECORD
  (
    info          VARCHAR2(50),
    content       VARCHAR2(5000)
  );

  v_out       typ_detail;

begin

  v_sql := trim(v_sql);
  
  if v_sql like '%;' then
    v_sql := substr(v_sql, 1, length(v_sql)-1);
  end if;

  v_cursor := dbms_sql.open_cursor;
  dbms_sql.parse(v_cursor, v_sql, dbms_sql.NATIVE);
  dbms_sql.describe_columns(v_cursor, v_col_count, v_desc_tab);

  for i in 1..v_col_count
  loop
    case v_desc_tab(i).col_type
      when c_tp_varchar2 then
        dbms_sql.define_column(v_cursor, i, v_val_text, 2000);
      when c_tp_number then
        dbms_sql.define_column(v_cursor, i, v_val_number);
      when c_tp_date then
        dbms_sql.define_column(v_cursor, i, v_val_datetime);
      else
        dbms_sql.define_column(v_cursor, i, v_val_text, 2000);
    end case;
  end loop;

  v_ret := dbms_sql.execute(v_cursor);

  loop
    v_ret := dbms_sql.fetch_rows(v_cursor);
    exit when v_ret = 0;

    for i in 1..v_col_count
    loop

      v_out.info := v_desc_tab(i).col_name;

      case v_desc_tab(i).col_type
        when c_tp_varchar2 then
          dbms_sql.column_value(v_cursor, i, v_val_text);
          v_out.content := '''' || replace(v_val_text, '''', '''''') || '''';
        when c_tp_number then
          dbms_sql.column_value(v_cursor, i, v_val_number);
          v_out.content := case when v_val_number is null then 'NULL' else to_char(v_val_number) end;
        when c_tp_date then
          dbms_sql.column_value(v_cursor, i, v_val_datetime);
          v_out.content := case when v_val_datetime is null then 'NULL' else 
            'TO_DATE(''' || to_char(v_val_datetime, 'DD/MM/YYYY HH24:MI:SS') || ''', ''DD/MM/YYYY HH24:MI:SS'')' end;
        else
          -- other types (assume data can be converted by to_char)
          dbms_sql.column_value(v_cursor, i, v_val_text);
          v_out.content := '''' || replace(to_char(v_val_text), '''', '''''') || '''';
      end case;

      begin
        dbms_output.put_line(rpad(v_out.info, 30, ' ') || '= ' || v_out.content);
      exception
        when others then
          -- Oracle 9 can't handle more than 255 chars
          dbms_output.put_line(rpad(v_out.info, 30, ' ') || '= ' || substr(v_out.content, 1, 220) ||'...');
      end;

    end loop;
    
    dbms_output.put_line(' ');

  end loop;

  dbms_sql.close_cursor(v_cursor);

end;
/
undef 1
