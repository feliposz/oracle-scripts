SET SERVEROUTPUT ON
DECLARE
  TYPE keys_t IS TABLE OF VARCHAR2(50);
  keys keys_t := keys_t(
    'CURRENT_SCHEMA',
    'CURRENT_USER',
    'CURRENT_USERID',
    'DB_NAME',
    'IP_ADDRESS',
    'LANGUAGE',
    'NLS_DATE_FORMAT',
    'OS_USER',
    'SESSION_USER',
    'SESSION_USERID',
    'SESSIONID',
    'TERMINAL'
   );
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
  FOR i IN keys.FIRST..keys.LAST LOOP
    BEGIN
      DBMS_OUTPUT.PUT_LINE(RPAD(keys(i), 30, '.') || ': ' || SYS_CONTEXT('USERENV', keys(i)));
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(RPAD(keys(i), 30, '.') || ': ' || '(n/a)');
    END;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
END;
/
