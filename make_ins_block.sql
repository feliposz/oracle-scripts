set define '&'
set verify off
set serveroutput on format truncated

declare

  v_table_name varchar2(30)   := upper('&1');
  v_owner      varchar2(30)   := sys_context('userenv', 'current_schema');
  v_flags      varchar2(10)   := ' ' || upper('&2');
  v_lastchar   varchar2(2)    := '';
  v_column     varchar2(100)  := '';
  v_content    varchar2(100)  := '';
  v_result     varchar2(2000) := '';
  v_lbreak     varchar2(2)    := chr(13) || chr(10);
  v_ident      varchar2(10)   := '';
  v_extraspc   varchar2(1)    := '';

  cursor cur_columns is
  select c.*, count(*) over () total, max(length(c.column_name)) over() max_length
    from all_tab_columns c
   where c.table_name = v_table_name
     and c.owner = v_owner
     and ( instr(v_flags, 'N') = 0 or c.nullable = 'N' );


begin

  if v_table_name is null then
    dbms_output.put_line(' ');
    dbms_output.put_line('Uso: @make_ins_block [SCHEMA.]TABLE FLAGS');
    dbms_output.put_line(' ');
    dbms_output.put_line('Valid FLAGS:');
    dbms_output.put_line('  N - Ignore nullable columns.');
    dbms_output.put_line('  S - Set nullable columns to NULL.');
    dbms_output.put_line(' ');
    return;
  end if;

  if instr(v_table_name, '.') > 0 then
    v_owner := substr(v_table_name, 1, instr(v_table_name, '.') - 1);
    v_table_name := substr(v_table_name, instr(v_table_name, '.') + 1);
  end if;

  v_result := v_result || 'DECLARE' || v_lbreak || v_lbreak;
  v_result := v_result || '  v_' || lower(v_table_name) || ' ' || lower(v_table_name) || '%ROWTYPE;' || v_lbreak || v_lbreak;
  v_result := v_result || 'BEGIN' || v_lbreak || v_lbreak;

  for col in cur_columns
  loop

    if instr(v_flags, 'S') > 0 and col.nullable = 'Y' then
      v_content := 'NULL';
    else
      case col.data_type
        when 'NUMBER' then v_content := '0';
        when 'DATE'   then v_content := 'TO_DATE(''01/01/2000 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')';
        else v_content := ''' ''';
      end case;
    end if;

    v_column := rpad(lower(col.column_name), col.max_length);

    v_result := v_result || '  v_' || lower(v_table_name) || '.' || v_column || ' := ' || v_content || ';' || v_lbreak;

  end loop;

  v_result := v_result || v_lbreak ||'  INSERT INTO ' || lower(v_table_name) || ' VALUES v_' || lower(v_table_name) || ';'|| v_lbreak || v_lbreak;

  v_result := v_result || 'END;' || v_lbreak;

  dbms_output.put_line(v_result);

end;
/
show errors

undef 1
undef 2
