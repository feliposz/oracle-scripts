-- HELP: Recompila objetos inválidos conforme parâmetro passado
SET DEFINE "&"
set serveroutput on

declare
  v_total integer := 0;
  v_erro  integer := 0;
  v_ok    integer := 0;
begin
  dbms_output.enable(50000);

  for reg in (
    select
      decode( OBJECT_TYPE, 'PACKAGE BODY',
      'alter package "'||OBJECT_NAME || '" compile body',
      'alter ' || OBJECT_TYPE || ' "'||OBJECT_NAME || '" compile' ) comando
    from
      user_objects
    where
      STATUS = 'INVALID' and
      OBJECT_TYPE in ( 'PACKAGE BODY', 'PACKAGE', 'FUNCTION', 'PROCEDURE',
                        'TRIGGER', 'VIEW', 'TYPE' )
    and
      OBJECT_NAME LIKE UPPER('%&&1%')
    order by
      OBJECT_TYPE,
      OBJECT_NAME )
  loop
    v_total := v_total + 1;

    begin
      execute immediate reg.comando;
      v_ok := v_ok + 1;
    exception
      when others then
        v_erro := v_erro + 1;
    end;
  end loop;

  dbms_output.put_line('------------------------------');
  dbms_output.put_line('Invalid objects.......: '||lpad(v_total,6));
  dbms_output.put_line('Compile success.......: '||lpad(v_ok,6));
  dbms_output.put_line('Compile errors........: '||lpad(v_erro,6));
  dbms_output.put_line('------------------------------');

end;
/

select object_type, object_name from user_objects
where status = 'INVALID' and object_name like upper('%&&1%') 
order by 1,2;

UNDEF 1
