SET SERVEROUTPUT ON FEEDBACK OFF TIMING OFF
DEFINE _editor = "C:\Local\Programas\Notepad++\notepad++.exe -multiInst -nosession -notabbar"
SET EDITFILE C:\Temp\_sqlplus_buffer_.sql
@@default.sql
@@ptbr.sql
@@prompt

set time on

begin
  DBMS_OUTPUT.PUT_LINE('==================================================');
  DBMS_OUTPUT.PUT_LINE('CURRENT_USER....: ' || SYS_CONTEXT('USERENV', 'CURRENT_USER'));
  DBMS_OUTPUT.PUT_LINE('CURRENT_SCHEMA..: ' || SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'));
  DBMS_OUTPUT.PUT_LINE('DB_NAME.........: ' || SYS_CONTEXT('USERENV', 'DB_NAME'));
  DBMS_OUTPUT.PUT_LINE('==================================================');
  DBMS_OUTPUT.PUT_LINE(' ');
end;
/  
