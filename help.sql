SELECT
    COLUMN_VALUE
FROM
TABLE(SYS.DBMS_DEBUG_VC2COLL(
'chkasm2.sql           |',
'datafile.sql          |',
'dropall.sql           |',
'infopid.sql           |',
'job_log.sql           |',
'lock.sql              |',
'mview.sql             |',
'oi.sql                |',
'rman_log.sql          |',
'set.sql               |',
'ss.sql                |',
'ss_io.sql             |',
'ss_pid.sql            |',
'temptb.sql            |',
'undotb.sql            |',
'wait.sql              |',
'chktb.sql             |',
'db_link.sql           |',
'grant_.sql            |',
'infosid.sql           |',
'kill_dpjob.sql        |',
'maxshrink.sql         |',
'obj.sql               |',
'reversa.sql           |',
'scheduled_jobs.sql    |',
'sql_id.sql            |',
'ss_cpu.sql            |',
'ss_mem.sql            |',
'ss_undo.sql           |',
'trace_file.sql        |',
'user_.sql             |'
)) nome 
WHERE COLUMN_VALUE LIKE '%&1%'
ORDER BY 1;