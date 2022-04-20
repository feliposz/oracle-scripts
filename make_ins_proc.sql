set define '&'
set verify off
set serveroutput on format truncated

declare

  v_table_name varchar2(30)   := upper('&1');
  v_owner      varchar2(30)   := sys_context('userenv', 'current_schema');
  v_lastchar   varchar2(2)    := '';
  v_column     varchar2(100)  := '';
  v_content    varchar2(100)  := '';
  v_result     varchar2(2000) := '';
  v_lbreak     varchar2(2)    := chr(13) || chr(10);
  v_ident      varchar2(10)   := '';
  v_extraspc   varchar2(1)    := '';
  
  cursor cur_columns is
  select c.*,
         count(*) over () total,
         max(length(c.column_name)) over() max_length
    from all_tab_columns c
   where c.table_name = v_table_name
     and c.owner = v_owner;

begin

  if v_table_name is null then
    dbms_output.put_line(' ');
    dbms_output.put_line('Usage: @make_ins_proc [SCHEMA.]TABELA');
    dbms_output.put_line(' ');
    return;
  end if;
  
  if instr(v_table_name, '.') > 0 then
    v_owner := substr(v_table_name, 1, instr(v_table_name, '.') - 1);
    v_table_name := substr(v_table_name, instr(v_table_name, '.') + 1);
  end if;

  v_result := v_result || 'CREATE OR REPLACE PROCEDURE pr_' || lower(v_table_name) || '_insert' || v_lbreak;
  v_result := v_result || '(';  
  dbms_output.put_line(v_result);

  for col in cur_columns
  loop
    v_result  := '';
    v_column  := rpad(lower(col.column_name), col.max_length);
    v_content := '  p_' || v_column || ' IN  ' || lower(v_table_name) || '.' || lower(col.column_name) || '%TYPE';
    if cur_columns%rowcount < col.total then
      v_content := v_content || ',';
    end if;
    v_result  := v_content;
    dbms_output.put_line(v_result);
  end loop;

  v_result := '';  
  v_result := v_result || ')' || v_lbreak;
  v_result := v_result || 'IS' || v_lbreak;
  v_result := v_result || '  v_' || lower(v_table_name) || ' ' || lower(v_table_name) || '%ROWTYPE;' || v_lbreak;
  v_result := v_result || 'BEGIN' || v_lbreak;

  dbms_output.put_line(v_result);
  
  for col in cur_columns
  loop
    v_result := '';
    v_column  := rpad(lower(col.column_name), col.max_length);
    v_content := 'p_' || lower(col.column_name);
    v_result := v_result || '  v_' || lower(v_table_name) || '.' || v_column || ' := ' || v_content || ';';
    dbms_output.put_line(v_result);
  end loop;

  v_result := '';
  v_result := v_result || v_lbreak ||'  INSERT INTO ' || lower(v_table_name) || ' VALUES v_' || lower(v_table_name) || ';'|| v_lbreak;
  v_result := v_result || v_lbreak;
  v_result := v_result || '  COMMIT;' || v_lbreak;
  v_result := v_result || v_lbreak;
  v_result := v_result || 'EXCEPTION' || v_lbreak;
  v_result := v_result || '  WHEN OTHERS THEN' || v_lbreak;
  v_result := v_result || '    ROLLBACK;' || v_lbreak;
  v_result := v_result || '    RAISE;' || v_lbreak;
  v_result := v_result || 'END;' || v_lbreak;
  v_result := v_result || '/' || v_lbreak || 'SHOW ERRORS' || v_lbreak;

    
  dbms_output.put_line(v_result);

end;
/
show errors

undef 1
undef 2
