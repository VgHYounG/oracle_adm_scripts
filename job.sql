/*
Lista info. de jobs cadastrados 
Lista Jobs e Scheduled jobs em execucao
*/
@set
SET VERIFY OFF

COL "WHAT"     FORMAT A80
COL "LAST"     FORMAT A20
COL "LOG_USER" FORMAT A20

accept VAR_OWNER prompt 'INFORME O OWNER: '

prompt == JOBs ===============================================================================
SELECT 
    LOG_USER,
    JOB,
    'EXEC ' || UPPER(WHAT) WHAT,
    BROKEN,
    FAILURES,
    TO_CHAR(LAST_DATE, 'DD/MM/YYYY HH24:MI:SS') LAST,
    TO_CHAR(NEXT_DATE, 'DD/MM/YYYY HH24:MI:SS') NEXT
FROM
    DBA_JOBS
WHERE 
    LOG_USER LIKE UPPER('%&VAR_OWNER%')
ORDER BY WHAT;

prompt == JOBs em execucao. ==================================================================

--select j.LOG_USER, jr.SID, jr.JOB, jr.FAILURES, jr.LAST_DATE, jr.LAST_SEC, jr.THIS_DATE, jr.THIS_SEC, jr.INSTANCE 
--from dba_jobs_running jr inner join dba_jobs j on j.job = jr.job
--where j.LOG_USER LIKE upper('%&VAR_OWNER%')
--/

SELECT 
    LOWNER,V.SID, V.ID2 JOB, J.FAILURES,
    LAST_DATE, SUBSTR(TO_CHAR(LAST_DATE,'HH24:MI:SS'),1,8) LAST_SEC,
    THIS_DATE, SUBSTR(TO_CHAR(THIS_DATE,'HH24:MI:SS'),1,8) THIS_SEC,
    V.INST_ID INSTANCE
FROM 
    SYS.JOB$ J, GV$LOCK V
WHERE
    V.TYPE = 'JQ' AND J.JOB(+) = V.ID2; 

prompt == SCHEDULED JOBs em execucao. ========================================================
SELECT
    OWNER,
    JOB_NAME,
    SESSION_ID "SID",
    'exec DBMS_SCHEDULER.STOP_JOB('''|| OWNER || '.' || JOB_NAME || ''', force=>true);'
FROM
    dba_scheduler_running_jobs;

CLEAR COL
UNDEF VAR_OWNER