SET DEFINE OFF
$cmd /c "echo System: & date /t & time /t"
$C:\Program Files\Git\usr\bin\date.exe +"Date: %d/%m/%Y Time: %T Weekday: %A (%w) Month: %B Week: %U/%V/%W Timezone: %z (%Z)"
BEGIN
  dbms_output.put_line('============================================================');
  dbms_output.put_line('SYSDATE           = ' || TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI:SS'));
  dbms_output.put_line('CURRENT_DATE      = ' || TO_CHAR(CURRENT_DATE, 'DD/MM/YYYY HH24:MI:SS'));
  dbms_output.put_line('SYSTIMESTAMP      = ' || TO_CHAR(SYSTIMESTAMP, 'DD/MM/YYYY HH24:MI:SSxFF TZH:TZM'));
  dbms_output.put_line('CURRENT_TIMESTAMP = ' || TO_CHAR(CURRENT_TIMESTAMP, 'DD/MM/YYYY HH24:MI:SSxFF TZH:TZM'));
  dbms_output.put_line('------------------------------------------------------------');
  dbms_output.put_line('DAY    = ' || TO_CHAR(SYSDATE, 'DAY'));
  dbms_output.put_line('DY     = ' || TO_CHAR(SYSDATE, 'DAY'));
  dbms_output.put_line('D      = ' || TO_CHAR(SYSDATE, 'D'));
  dbms_output.put_line('DDD    = ' || TO_CHAR(SYSDATE, 'DDD'));
  begin
    dbms_output.put_line('DL     = ' || TO_CHAR(SYSDATE, 'DL'));
    dbms_output.put_line('DS     = ' || TO_CHAR(SYSDATE, 'DS'));
    dbms_output.put_line('TS     = ' || TO_CHAR(SYSDATE, 'TS'));
  exception
    when others then
      null;
  end;
  dbms_output.put_line('MON    = ' || TO_CHAR(SYSDATE, 'MON'));
  dbms_output.put_line('MONTH  = ' || TO_CHAR(SYSDATE, 'MONTH'));
  dbms_output.put_line('RM     = ' || TO_CHAR(SYSDATE, 'RM') || ' (mês)');
  dbms_output.put_line('WW     = ' || TO_CHAR(SYSDATE, 'WW'));
  dbms_output.put_line('IW     = ' || TO_CHAR(SYSDATE, 'IW'));
  dbms_output.put_line('W      = ' || TO_CHAR(SYSDATE, 'W'));
  dbms_output.put_line('YEAR   = ' || TO_CHAR(SYSDATE, 'YEAR'));
  dbms_output.put_line('CC     = ' || TO_CHAR(SYSDATE, 'CC') || ' (século)');
  dbms_output.put_line('HH     = ' || TO_CHAR(SYSDATE, 'HH'));
  dbms_output.put_line('HH24   = ' || TO_CHAR(SYSDATE, 'HH24'));
  dbms_output.put_line('MI     = ' || TO_CHAR(SYSDATE, 'MI'));
  dbms_output.put_line('SS     = ' || TO_CHAR(SYSDATE, 'SS'));
  dbms_output.put_line('============================================================');
END;
/
SET DEFINE &
