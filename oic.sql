/*
Lista status dos componentes e 
Conta objetos invalidos por owner
*/

set lines 500 pages 1000
col comp_name for a40
select comp_name, version, status from dba_registry order by 1;

set pages 9999
col owner for a30
select count(*) Qtd, owner from dba_objects where status <> 'VALID' group by owner
UNION ALL
select NULL Qtd, '------------------------------' owner from dual
UNION ALL
select count(*) Qtd, 'TOTAL' owner from dba_objects where status <> 'VALID';

prompt @?/rdbms/admin/utlrp