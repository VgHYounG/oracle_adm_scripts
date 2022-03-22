set pagesize 100 linesize 400 pause off verify off head off feedback 6
select 'Sessoes Ativas: ' || count(1) as Q
from gv$session s, gv$process p
where s.username is not null
and s.paddr = p.addr
and s.status = 'ACTIVE'
and s.inst_id = p.inst_id
and nvl(p.pname,'XYZABC') not like 'O%'
UNION ALL
select 'Sessoes Totais: ' || count(1) as Q from gv$session;
exit
