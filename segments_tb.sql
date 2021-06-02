/*
Tras o tamanho das tabela de uma determinada tablespace
*/
select
    segment_name, segment_type, tablespace_name, sum(bytes)/1024/1024/1024 "GB"
from dba_segments
where tablespace_name='&1'
group by tablespace_name, segment_type, segment_name
order by 4