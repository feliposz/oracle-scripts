set serveroutput on size unlimited format wrapped
declare
-- Author: Felipo Soranz
-- Date:   14/04/2015
--
-- A small script for creating a quick "export" of a single table or a simple one line query.
-- Quick and easy to use in simple tables with small number of columns and regular data.
-- It won't work on all cases, adapt when necessary or use SQL Developer's export.
--
-- Limitations:
--   Only works with CHAR, VARCHAR(2), NUMBER, DATE. May work with some CLOB/BLOB. Will not work with nested tables/records.
--   If the query parameter contains quotes (') you need to escape them yourself. Ex: select ''abc'' from dual
--   Queries must be passed with "" when calling the script. Ex: "select ''abc'' as my_text, 123 as my_number, sysdate as my_date from dual"
--
--
-- Some ideas for future improvements:
--    http://stackoverflow.com/questions/8357226/oracle-dbms-package-command-to-export-table-content-as-insert-statement/8600685#8600685
--    https://github.com/ReneNyffenegger/oracle_scriptlets/blob/master/sqlpath/insert_statement_creator.sql
--    https://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:759825200346294209#766040800346583688
--
-- TODO: concatenate CHR(13) || CHR(10) or any other non printable ASCII
-- TODO: if output line is larger than 240 characters (actually 255, but for simplicity...), concatenate strings (when exporting from oracle 8/9)
-- TODO: concatenate column values larger than 2000 chars on separate lines

  v_table_or_query   varchar2(3000) := '&1';

  v_date_fmt         constant varchar2(30) := 'DD/MM/YYYY HH24:MI:SS';
  c_tp_varchar2      constant number := 1;
  c_tp_number        constant number := 2;
  c_tp_date          constant number := 12;

  v_table_name       varchar2(100);
  v_sql              varchar2(3000);
  v_cursor           number;
  v_col_count        integer;
  v_num_value        number;
  v_char_value       varchar2(32000);
  v_date_value       date;
  v_desc_table       dbms_sql.desc_tab;
  v_ret              number;
  v_col_name         varchar2(30);
  v_col_value        varchar2(32000);

  function escape_quotes (p_text varchar2) return varchar2
  is
  begin
    return replace(p_text, '''', '''''');
  end;


begin

  if upper(v_table_or_query) like '%SELECT%FROM%' then
    v_sql := v_table_or_query;
    v_table_name := 'tmp_export_query';
  else
    v_sql := 'select * from ' || v_table_or_query;
    v_table_name := lower(v_table_or_query);
  end if;

  dbms_output.put_line('-- =======' || lpad('=', length(v_sql), '='));
  dbms_output.put_line('-- Query: ' ||  v_sql);
  dbms_output.put_line('-- =======' || lpad('=', length(v_sql), '='));
  dbms_output.put_line(' ');

  v_cursor := dbms_sql.open_cursor;
  dbms_sql.parse(v_cursor, v_sql, dbms_sql.NATIVE);
  dbms_sql.describe_columns(v_cursor, v_col_count, v_desc_table);

  for i in 1..v_col_count
  loop
    case v_desc_table(i).col_type
      when c_tp_varchar2 then
        dbms_sql.define_column(v_cursor, i, v_char_value, 32000);
      when c_tp_number then
        dbms_sql.define_column(v_cursor, i, v_num_value);
      when c_tp_date then
        dbms_sql.define_column(v_cursor, i, v_date_value);
      else
        dbms_sql.define_column(v_cursor, i, v_char_value, 32000);
    end case;
  end loop;

  v_ret := dbms_sql.execute(v_cursor);

  loop
    v_ret := dbms_sql.fetch_rows(v_cursor);
    exit when v_ret = 0;

    for i in 1..v_col_count
    loop

      v_col_name := lower(v_desc_table(i).col_name);

      if i = 1 then
        dbms_output.put_line('INSERT INTO ' || v_table_name);
        dbms_output.put_line('( ');
      end if;

      if i < v_col_count then
        dbms_output.put_line('  ' || v_col_name || ',');
      else
        dbms_output.put_line('  ' || v_col_name);
        dbms_output.put_line(')');
        dbms_output.put_line('VALUES');
        dbms_output.put_line('(');
      end if;

    end loop;

    for i in 1..v_col_count
    loop

      case v_desc_table(i).col_type
        when c_tp_varchar2 then
          dbms_sql.column_value(v_cursor, i, v_char_value);
          if v_char_value is null then
            v_col_value := 'NULL';
          else
            v_col_value := '''' || escape_quotes(v_char_value) || '''';
          end if;
        when c_tp_number then
          dbms_sql.column_value(v_cursor, i, v_num_value);
          if v_num_value is null then
            v_col_value := 'NULL';
          else
            v_col_value := replace(to_char(v_num_value), ',', '.');
            --v_col_value := 'TO_NUMBER(''' || to_char(v_num_value) || ''')';
          end if;
        when c_tp_date then
          dbms_sql.column_value(v_cursor, i, v_date_value);
          if v_date_value is null then
            v_col_value := 'NULL';
          else
            v_col_value := 'TO_DATE(''' || to_char(v_date_value, v_date_fmt) || ''', ''' || v_date_fmt || ''')';
          end if;
        else
          -- assume other types can be converted by to_char
          dbms_sql.column_value(v_cursor, i, v_char_value);
          v_col_value := '''' || escape_quotes(v_char_value) || '''';
      end case;

      if i < v_col_count then
        dbms_output.put_line('  ' || v_col_value || ',');
      else
        dbms_output.put_line('  ' || v_col_value);
        dbms_output.put_line(');');
      end if;

    end loop;

    dbms_output.put_line(' ');

  end loop;

  dbms_sql.close_cursor(v_cursor);

end;
/
show errors
undef 1