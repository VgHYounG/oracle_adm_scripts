/*
Lista Scheduled Jobs
*/
COL "OWNER"           FORMAT A15
COL "JOB_NAME"        FORMAT A50
COL "START_DATE"      FORMAT A38
COL "END_DATE"        FORMAT A17
COL "REPEAT_INTERVAL" FORMAT A30
COL "STATE"           FORMAT A10
COL "ENABLED"         FORMAT A17
COL "JOB_ACTION"      FORMAT A50

SELECT OWNER, JOB_NAME, START_DATE, END_DATE, REPEAT_INTERVAL, STATE, ENABLED, JOB_ACTION FROM DBA_SCHEDULER_JOBS WHERE OWNER Like('%&1%');

CLEAR COL
UNDEF 1


@reversa
TEIKO_LOCK
PRC_KILL_SESSAO_INATIVA


PROCEDURE
PRC_KILL_SESSAO_FAROL
TEIKO_LOCK


select distinct s1.status, s1.sid, s1.serial#, s1.inst_id, s1.event, s1.sql_id
    from gv$session s1, gv$session s2, gv$process p1, gv$process p2, gv$instance i1, gv$instance i2
    where s2.seconds_in_wait > 15     and (s2.blocking_instance = s1.inst_id and s2.blocking_session = s1.sid)  and
         (s1.inst_id = p1.inst_id(+) and s1.paddr=p1.addr(+))                                                   and
         (s2.inst_id = p2.inst_id(+) and s2.paddr=p2.addr(+))                                                   and
         (s1.inst_id = i1.inst_id)   and (s2.inst_id = i2.inst_id)                                              and
         (s1.status = 'ACTIVE'     or s2.status = 'ACTIVE')                                                 and
          s1.seconds_in_wait >= 90;

select s1.status, s1.sid, s1.serial#, s1.inst_id, s1.event, s1.username
    from gv$session s1
    where s1.status = 'ACTIVE' and s1.last_call_et > 3600;
