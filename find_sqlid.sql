COL SQL_TEXT format a45

select inst_id, sql_id, substr(sql_text,1,200) sql_text
from gv$sql 
where upper(sql_text)
like upper('%&1%');

undef 1