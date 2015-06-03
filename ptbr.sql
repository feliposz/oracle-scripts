HOST CHCP 1252 > NUL

ALTER SESSION SET
  NLS_LANGUAGE            = 'BRAZILIAN PORTUGUESE'
  NLS_TERRITORY           = 'BRAZIL'
  NLS_CURRENCY            = 'R$'
  NLS_ISO_CURRENCY        = 'BRAZIL'
  NLS_NUMERIC_CHARACTERS  = ',.'
  NLS_DATE_LANGUAGE       = 'BRAZILIAN PORTUGUESE'
  NLS_DATE_FORMAT         = 'DD/MM/YYYY HH24:MI:SS'
  NLS_SORT                = 'WEST_EUROPEAN'
  NLS_TIME_FORMAT         = 'HH24:MI:SSXFF'
  NLS_TIMESTAMP_FORMAT    = 'DD/MM/RR HH24:MI:SSXFF'
  NLS_TIME_TZ_FORMAT      = 'HH24:MI:SSXFF TZR'
  NLS_TIMESTAMP_TZ_FORMAT = 'DD/MM/RR HH24:MI:SSXFF TZR'
  NLS_DUAL_CURRENCY       = 'Cr$'
;