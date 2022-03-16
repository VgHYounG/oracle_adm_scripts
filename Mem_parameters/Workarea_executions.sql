column "col1"  format a35           heading "Estatistica"
column "col2"  format 999,999,999,990 heading "Valor"
 
select
    name "col1", value "col2"
from
    v$sysstat
where
    name LIKE '%workarea%';
