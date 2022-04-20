set define '&'
set verify off
set serveroutput on format truncated

declare

  v_table_name varchar2(30)   := upper('&1');
  v_owner      varchar2(30)   := sys_context('userenv', 'current_schema');
  v_flags      varchar2(10)   := ' ' || upper('&2');
  v_lastchar   varchar2(2)    := '';
  v_content    varchar2(100)  := '';
  v_result     varchar2(2000) := '';
  v_lbreak     varchar2(2)    := '';
  v_ident      varchar2(2)    := '  ';
  v_extraspc   varchar2(1)    := '';
  
  cursor cur_columns is
  select c.*, count(*) over () total 
    from all_tab_columns c 
   where c.table_name = v_table_name
     and owner = v_owner
     and ( instr(v_flags, 'N') = 0 or c.nullable = 'N' )
   order by column_id;
  
begin

  if v_table_name is null then
    dbms_output.put_line(' ');
    dbms_output.put_line('Usage: @make_insert [SCHEMA.]TABLE FLAGS');
    dbms_output.put_line(' ');
    dbms_output.put_line('Valid FLAGS:');
    dbms_output.put_line('  N - Ignore nullable columns.');
    dbms_output.put_line('  S - Set nullable columns to NULL.');
    dbms_output.put_line('  L - Format statement in a single line.');
    dbms_output.put_line(' ');
    return;
  end if;
  
  if instr(v_table_name, '.') > 0 then
    v_owner := substr(v_table_name, 1, instr(v_table_name, '.') - 1);
    v_table_name := substr(v_table_name, instr(v_table_name, '.') + 1);
  end if;
  
  if instr(v_flags, 'L') = 0 then
    v_lbreak   := chr(13) || chr(10);
    v_ident    := '  ';
    v_extraspc := '';
  else
    v_lbreak   := '';
    v_ident    := '';
    v_extraspc := ' ';
  end if;

  v_result := v_result || 'INSERT INTO ' || lower(v_table_name) || v_lbreak;
  v_result := v_result || v_extraspc || '(' || v_lbreak;
  
  for col in cur_columns
  loop
    if (cur_columns%rowcount = col.total) then
      v_lastchar := '';
    else
      v_lastchar := ',' || v_extraspc;
    end if;
    v_result := v_result || v_ident || lower(col.column_name) || v_lastchar || v_lbreak;
  end loop;
  
  v_result := v_result || ')' || v_lbreak;
  v_result := v_result || v_extraspc || 'VALUES' || v_extraspc || v_lbreak;
  v_result := v_result || '(' || v_lbreak;

  for col in cur_columns
  loop
    if (cur_columns%rowcount = col.total) then
      v_lastchar := '';
    else
      v_lastchar := ',' || v_extraspc;
    end if;
    
    if instr(v_flags, 'S') > 0 and col.nullable = 'Y' then
      v_content := 'NULL';
    else
      case col.data_type
        when 'NUMBER' then v_content := '0';
        when 'DATE'   then v_content := 'TO_DATE(''01/01/2000 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')';
        else v_content := ''' ''';
      end case;
    end if;
    
    v_result := v_result || v_ident || v_content || v_lastchar || v_lbreak;
  end loop;
  
  v_result := v_result || ')';

  dbms_output.put_line(v_result);

end;
/
show errors

undef 1
undef 2
