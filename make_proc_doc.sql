declare
  v_first boolean;
  v_name varchar2(30) := upper('&1');
  v_user varchar2(100);
  v_object user_objects%rowtype;
begin

  select * into v_object from user_objects where object_name = v_name and object_type NOT IN ('PACKAGE BODY', 'TYPE BODY');

  dbms_output.put_line('--------------------------------------------------------------------------------');
  dbms_output.put_line('--');
  dbms_output.put_line( '--  ' ||  initcap(v_object.object_type) || ': ' || lower(v_object.object_name) );
  dbms_output.put_line( '--' );
  dbms_output.put_line( '--  Description:');
  dbms_output.put_line( '--    '  || initcap(trim(replace(v_object.object_name, '_', ' '))));

  if v_object.object_type in ('PROCEDURE', 'FUNCTION') then

    v_first := true;
    for l_arg in ( select argument_name, max(length(argument_name)) over () as max_length, defaulted
                    from user_arguments
                   where object_name = v_object.object_name
                     and in_out in ('IN', 'IN/OUT')
                     and data_level = 0
                     and argument_name is not null
                   order by position )
    loop
      if v_first then
        dbms_output.put_line( '--' );
        dbms_output.put_line( '--  Input:' );
        v_first := false;
      end if;
      dbms_output.put_line( '--    '
                         || rpad(lower(l_arg.argument_name), l_arg.max_length, ' ')
                         || ' - '
                         || (case when l_arg.defaulted = 'Y' then '(Opcional) ' else '' end)
                         || initcap(trim(replace(replace(l_arg.argument_name, 'P_', ''), '_', ' '))));
    end loop;

    v_first := true;
    for l_arg in ( select argument_name, max(length(argument_name)) over () as max_length
                    from user_arguments
                   where object_name = v_object.object_name
                     and in_out in ('OUT', 'IN/OUT')
                      and data_level = 0
                     and argument_name is not null
                   order by position )
    loop
      if v_first then
        dbms_output.put_line( '--' );
        dbms_output.put_line( '--  Output:' );
        v_first := false;
      end if;
      dbms_output.put_line( '--    ' || rpad(lower(l_arg.argument_name), l_arg.max_length, ' ') || ' - ' || initcap(trim(replace(replace(l_arg.argument_name, 'P_', ''), '_', ' '))));
    end loop;

    v_first := true;
    for l_arg in ( select argument_name, data_type
                     from user_arguments
                    where object_name = v_object.object_name
                      and in_out = 'OUT'
                      and data_level = 0
                      and argument_name is null )
    loop
      if v_first then
        dbms_output.put_line( '--' );
        dbms_output.put_line( '--  Returns:' );
        v_first := false;
      end if;
      dbms_output.put_line( '--    ' || initcap(l_arg.data_type) );
    end loop;

    dbms_output.put_line('--');
    dbms_output.put_line('--  Exception handling:');
    dbms_output.put_line('--    ....');

  end if;

  v_user := initcap(replace(SYS_CONTEXT('USERENV', 'OS_USER'), '_', ' '));
  if instr(v_user, ' ') > 0 then
    v_user := substr(v_user, 1, instr(v_user, ' ') - 1);
  end if;

  dbms_output.put_line('--');
  dbms_output.put_line('--  Changes:');
  dbms_output.put_line('--    ' || to_char(sysdate, 'DD-MM-RR') || ' (' || v_user || ') - Implementation.' );
  dbms_output.put_line('--');
  dbms_output.put_line('--------------------------------------------------------------------------------');

end;
/
show errors
undef 1
