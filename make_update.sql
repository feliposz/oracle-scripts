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
  v_lbreak     varchar2(2)    := '';
  v_ident      varchar2(10)   := '';
  v_extraspc   varchar2(1)    := '';
  
  cursor cur_columns is
  select c.*, count(*) over () total, max(length(c.column_name)) over() max_length
    from all_tab_columns c 
   where c.table_name = v_table_name
     and c.owner = v_owner
     and ( instr(v_flags, 'N') = 0 or c.nullable = 'N' )
     and c.column_name not in
         (
          select b.column_name
            from all_constraints a, all_cons_columns b
           where a.constraint_name = b.constraint_name
             and a.table_name = b.table_name
             and a.owner = b.owner
             and a.table_name = c.table_name
             and a.owner = c.owner             
             and a.constraint_type = 'P'
         );

  cursor cur_primary_key is
  select c.*, max(length(c.column_name)) over() max_length
    from all_constraints a, all_cons_columns b, all_tab_columns c
   where a.constraint_name = b.constraint_name
     and a.table_name = b.table_name
     and a.owner = b.owner
     and a.table_name = c.table_name
     and a.owner = c.owner             
     and b.column_name = c.column_name
     and a.constraint_type = 'P'  
     and c.table_name = v_table_name
     and c.owner = v_owner;
  
begin

  if v_table_name is null then
    dbms_output.put_line(' ');
    dbms_output.put_line('Usage: @make_update [SCHEMA.]TABLE FLAGS');
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
    v_ident    := '       ';
    v_extraspc := '';
  else
    v_lbreak   := '';
    v_ident    := '';
    v_extraspc := ' ';
  end if;

  v_result := v_result || 'UPDATE ' || lower(v_table_name) || v_lbreak;

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
        when 'DATE'   then v_content := 'TO_DATE(''' || TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY HH24:MI:SS') || ''', ''DD/MM/YYYY HH24:MI:SS'')';
        else v_content := ''' ''';
      end case;
    end if;
    
    if instr(v_flags, 'L') = 0 then
      v_column := rpad(lower(col.column_name), col.max_length);
    else
      v_column := lower(col.column_name);
    end if;
    
    if (cur_columns%rowcount = 1) then
      v_result := v_result || '   SET ' || v_column || ' = ' || v_content || v_lastchar || v_lbreak;
    else
      v_result := v_result || v_ident || v_column || ' = ' || v_content || v_lastchar || v_lbreak;
    end if;
  end loop;
  
  for col in cur_primary_key 
  loop
    if (cur_primary_key%rowcount = 1) then
      v_result := v_result || ' WHERE ';
    else
      v_result := v_result || '   AND ';
    end if;
    
    case col.data_type
      when 'NUMBER' then v_content := '0';
      when 'DATE'   then v_content := 'TO_DATE(''' || TO_CHAR(TRUNC(SYSDATE), 'DD/MM/YYYY HH24:MI:SS') || ''', ''DD/MM/YYYY HH24:MI:SS'')';
      else v_content := ''' ''';
    end case;
    
    if instr(v_flags, 'L') = 0 then
      v_column := rpad(lower(col.column_name), col.max_length);
    else
      v_column := lower(col.column_name);
    end if;

    v_result := v_result || v_column || ' = ' || v_content || v_lbreak;
  end loop;    

  dbms_output.put_line(v_result);

end;
/
show errors

undef 1
undef 2
