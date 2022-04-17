col owner format a30
SELECT owner
     , TO_CHAR(SUM(DECODE(object_type, 'TABLE'       , 1, 0)), '9G999G990') AS "TB"
     , TO_CHAR(SUM(DECODE(object_type, 'PROCEDURE'   , 1, 0)), '9G999G990') AS "PR"
     , TO_CHAR(SUM(DECODE(object_type, 'FUNCTION'    , 1, 0)), '9G999G990') AS "FN"
     , TO_CHAR(SUM(DECODE(object_type, 'TRIGGER'     , 1, 0)), '9G999G990') AS "TRG"
     , TO_CHAR(SUM(DECODE(object_type, 'PACKAGE'     , 1, 0)), '9G999G990') AS "PKG"
     , TO_CHAR(SUM(DECODE(object_type, 'PACKAGE BODY', 1, 0)), '9G999G990') AS "PKG BODY"
     , TO_CHAR(SUM(DECODE(object_type, 'TYPE'        , 1, 0)), '9G999G990') AS "TYPE"
     , TO_CHAR(SUM(DECODE(object_type, 'TYPE BODY'   , 1, 0)), '9G999G990') AS "TYPE BODY"
     , TO_CHAR(SUM(DECODE(object_type, 'SYNONYM'     , 1, 0)), '9G999G990') AS "SYN"
     , TO_CHAR(SUM(DECODE(object_type, 'VIEW'        , 1, 0)), '9G999G990') AS "VIEW"
     , TO_CHAR(SUM(DECODE(object_type, 'SEQUENCE'    , 1, 0)), '9G999G990') AS "SEQ"
  FROM all_objects
 GROUP BY owner
 ORDER BY 2;
col owner clear