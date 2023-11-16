col qtd for 9999
col sql_id for a15
select * from (
select count(1) qtd, sql_id
from gv$session
where sql_id is not null
and status='ACTIVE'
group by sql_id
order by 1
) order by qtd;