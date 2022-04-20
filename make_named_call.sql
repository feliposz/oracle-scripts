declare

  v_param   VARCHAR2(100) := UPPER('&&1');
  
  v_owner   VARCHAR2(30);
  v_package VARCHAR2(30);
  v_object  VARCHAR2(30);

  cursor cur_argument (p_in_out varchar2) is
  select argument_name
       , variable_name
       , max(length(argument_name)) over () as argument_length
       , max(length(variable_name)) over () as variable_length
       , ( case 
             when pls_type = 'VARCHAR2' and data_length is not null then 'VARCHAR2(' || data_length || ')' 
             when pls_type = 'VARCHAR2' then 'VARCHAR2(4000)'
             when data_type = 'PL/SQL RECORD' then '???%ROWTYPE'
             when data_type = 'OBJECT' then type_name
             else pls_type
           end ) As pls_type
       , position
       , sequence
       , defaulted
       , default_value
       , default_length
       , object_call
       , count(*) over () as argument_count
    from (select lower(argument_name) as argument_name
               , lower('v_' || case when in_out = 'IN' or position = 0 then '' else replace(in_out, '/', '') || '_' end
                            || case
                                when position = 0 then 'ret'
                                when substr(argument_name, 1, 2) = 'P_' then substr(argument_name, 3)
                                else argument_name
                               end ) as variable_name
               , pls_type
               , data_type
               , data_length
               , type_name
               , position
               , sequence
               , defaulted
               , default_value
               , default_length
               , lower(nvl2(package_name, package_name || '.', '') || object_name) as object_call
            from all_arguments
           where owner = v_owner
             and nvl(package_name, '!!') = nvl(v_package, '!!')
             and object_name = v_object
             and in_out = nvl(p_in_out, in_out)
             and data_level = 0 -- No fields from record parameters!
           order by position);
  
begin


  if instr(v_param, '.') > 1 then
    v_package := substr(v_param, 1, instr(v_param, '.') - 1);
    v_object  := substr(v_param, instr(v_param, '.', -1) + 1);
  else
    v_package := null;
    v_object  := v_param;
  end if;

  begin
    select owner, package_name, object_name
      into v_owner, v_package, v_object
      from (select distinct owner, package_name, object_name
              from all_arguments
             where object_name = v_object
               and nvl(package_name, '!!') = nvl(v_package, '!!')
             order by decode(owner, sys_context('USERENV', 'CURRENT_SCHEMA'), 1, user, 2, 'SYS', 3, 99))
     where rownum = 1;
  exception
    when no_data_found then
      dbms_output.put_line('Not found: ' || v_param);
      return;
  end;

  dbms_output.put_line('DECLARE');
  dbms_output.put_line(' ');

  for l_argument in cur_argument(null) loop
    dbms_output.put_line('  ' || rpad(l_argument.variable_name, l_argument.variable_length, ' ') || ' ' || l_argument.pls_type || ';');
  end loop;

  dbms_output.put_line(' ');
  dbms_output.put_line('BEGIN');
  dbms_output.put_line(' ');

  for l_argument in cur_argument(null) loop
    dbms_output.put_line('  ' || rpad(l_argument.variable_name, l_argument.variable_length, ' ') || ' := NULL;');
  end loop;

  dbms_output.put_line(' ');

  for l_argument in cur_argument(null) loop
    if cur_argument%rowcount = 1 then
      if l_argument.position = 0 then
        dbms_output.put_line('  ' || l_argument.variable_name || ' := ' || l_argument.object_call);
      else
        dbms_output.put_line('  ' || l_argument.object_call);
      end if;
      dbms_output.put_line('  (');
    end if;
    if l_argument.position > 0 then
      dbms_output.put_line('    ' || rpad(l_argument.argument_name, l_argument.argument_length, ' ') || ' => ' || l_argument.variable_name || (case when l_argument.argument_count = cur_argument%rowcount then '' else ',' end));
    end if;
  end loop;

  dbms_output.put_line('  );');
  dbms_output.put_line(' ');

  for l_argument in cur_argument('OUT') loop
    dbms_output.put_line('  dbms_output.put_line(''' || rpad(l_argument.variable_name, l_argument.variable_length, ' ') || ' = '' || ' || l_argument.variable_name || ');');
  end loop;

  for l_argument in cur_argument('IN/OUT') loop
    dbms_output.put_line('  dbms_output.put_line(''' || rpad(l_argument.variable_name, l_argument.variable_length, ' ') || ' = '' || ' || l_argument.variable_name || ');');
  end loop;
  
  dbms_output.put_line(' ');
  dbms_output.put_line('END;');

end;
/
undef 1
