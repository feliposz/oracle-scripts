set verify on
select count(1) as lines from &1;
set verify off
undef &1
