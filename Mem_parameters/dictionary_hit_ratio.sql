-- Deve ser maior que 95 

select sum(gets) as "Gets", sum(getmisses) as "Misses", (1-(sum(getmisses)/sum(gets)))*100 as "CACHE HIT RATIO"
from gv$rowcache;