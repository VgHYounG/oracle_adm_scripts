-- > 90

SELECT 
   substr(name,1,30),
   value
FROM 
   v$sysstat 
WHERE 
   NAME = 'redo log space requests'
   OR
   NAME = 'redo buffer allocation retries'
   OR
   NAME = 'redo log space wait time';

select (100*(
    (SELECT value FROM v$sysstat WHERE name='redo entries')-
    (SELECT value FROM v$sysstat WHERE name='redo log space requests'))/
    (SELECT value FROM v$sysstat WHERE name='redo entries')) as logwaitratio
from dual;