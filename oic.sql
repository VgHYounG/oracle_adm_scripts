/*
Lista status dos componentes e 
Conta objetos invalidos por owner
*/

set lines 500 pages 1000
col comp_name for a40
select comp_name, version, status from dba_registry order by 1;

set pages 9999
col PDB_NAME for a20
col owner for a20
col OBJECT_TYPE for a20
col status for a20

select p.name "PDB_NAME", o.OWNER, o.OBJECT_TYPE, o.STATUS, count(*) 
from cdb_objects o, v$pdbs p
where status <> 'VALID'
and o.CON_ID = p.CON_ID
group by p.name, o.OWNER, o.OBJECT_TYPE, o.STATUS 
order by 1,2,3,4;

prompt @?/rdbms/admin/utlrp