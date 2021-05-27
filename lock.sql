/*
Traz sessoes e objetos em lock
*/
@set
prompt "########## sessões em lock ##########"

 SELECT 
     INST_LOCK||'   : '||SID_LOCK as  "Inst: Sessão bloqueadora",INST_WAIT||'   : '||SID_WAIT  as "Inst: Sessão bloqueada"
,      LOCK_CTIME_HOUR
,      WAIT_CTIME_HOUR
,      T2.CLIENT_INFO CI_LOCK
,      T3.CLIENT_INFO CI_WAIT
,      WAITER_LOCK_TYPE
,      WAITER_MODE_REQ
from
(
SELECT LH.INST_ID INST_LOCK, LH.SID SID_LOCK, ROUND(LH.CTIME/60/60,2) LOCK_CTIME_HOUR,
       LW.INST_ID INST_WAIT, LW.SID SID_WAIT, ROUND(LW.CTIME/60/60,2) WAIT_CTIME_HOUR,
       DECODE (lh.TYPE,
               'MR', 'Media_recovery',
               'RT', 'Redo_thread',
               'UN', 'User_name',
               'TX', 'Transaction',
               'TM', 'Dml',
               'UL', 'PLSQL User_lock',
               'DX', 'Distrted_Transaxion',
               'CF', 'Control_file',
               'IS', 'Instance_state',
               'FS', 'File_set',
               'IR', 'Instance_recovery',
               'ST', 'Diskspace Transaction',
               'IV', 'Libcache_invalidation',
               'LS', 'LogStaartORswitch',
               'RW', 'Row_wait',
               'SQ', 'Sequence_no',
               'TE', 'Extend_table',
               'TT', 'Temp_table',
               'Nothing-'
              ) waiter_lock_type,
       DECODE (lw.request,
               0, 'None',
               1, 'NoLock',
               2, 'Row-Share',
               3, 'Row-Exclusive',
               4, 'Share-Table',
               5, 'Share-Row-Exclusive',
               6, 'Exclusive',
               'Nothing-'
              ) waiter_mode_req
FROM   gv$lock lw, gv$lock lh
WHERE  lh.id1 = lw.id1
AND    lh.id2 = lw.id2
AND    lh.request = 0
AND    lw.lmode = 0
AND    (lh.id1, lh.id2) IN (
                           SELECT id1, id2
                           FROM   gv$lock
                           WHERE  request = 0
                           INTERSECT
                           SELECT id1, id2
                           FROM   gv$lock
                           WHERE  lmode = 0)
)  t1
,  gv$session t2
,  gv$session t3
where  (t1.inst_lock = t2.inst_id and t1.sid_lock = t2.sid)
and    (t1.inst_wait = t3.inst_id and t1.sid_wait = t3.sid)
order by LOCK_CTIME_HOUR desc,SID_LOCK
/


prompt "########## locktree ##########"
/* LOCKTREE.sql
 * Baseado no script locktree.sql de Guy Harrison, em http://165.225.144.123/OPSGSamples/Ch15/lock_tree.sql
 */

WITH 
sessions AS
   (SELECT distinct 
           inst_id, sid, serial#, username, blocking_session, row_wait_obj#, sql_id
      FROM gv$session),
locks AS
(
    SELECT distinct lh.inst_id inst_lock, lh.SID sid_lock, lh.ctime lock_ctime,
           lw.inst_id inst_wait, lw.SID sid_wait, lw.ctime wait_ctime,
           DECODE (lh.TYPE,
                   'MR', 'Media_recovery',
                   'RT', 'Redo_thread',
                   'UN', 'User_name',
                   'TX', 'Transaction',
                   'TM', 'Dml',
                   'UL', 'PLSQL User_lock',
                   'DX', 'Distrted_Transaxion',
                   'CF', 'Control_file',
                   'IS', 'Instance_state',
                   'FS', 'File_set',
                   'IR', 'Instance_recovery',
                   'ST', 'Diskspace Transaction',
                   'IV', 'Libcache_invalidation',
                   'LS', 'LogStaartORswitch',
                   'RW', 'Row_wait',
                   'SQ', 'Sequence_no',
                   'TE', 'Extend_table',
                   'TT', 'Temp_table',
                   'Nothing-'
                  ) waiter_lock_type,
           DECODE (lw.request,
                   0, 'None',
                   1, 'NoLock',
                   2, 'Row-Share',
                   3, 'Row-Exclusive',
                   4, 'Share-Table',
                   5, 'Share-Row-Exclusive',
                   6, 'Exclusive',
                   'Nothing-'
                  ) waiter_mode_req
    FROM   gv$lock lw, gv$lock lh
    WHERE  lh.id1 = lw.id1
    AND    lh.id2 = lw.id2
    AND    lh.request = 0
    AND    lw.lmode = 0
    AND    (lh.id1, lh.id2) IN (
                               SELECT id1, id2
                               FROM   gv$lock
                               WHERE  request = 0
                               INTERSECT
                               SELECT id1, id2
                               FROM   gv$lock
                               WHERE  lmode = 0)
    )
SELECT distinct LPAD(' ', 3*(LEVEL-1))||sid sid,
       serial#,
       inst_id,
       username,
       object_name, 
       sql_id,
       inst_lock,
       sid_lock,
       lock_ctime,
       inst_wait,
       sid_wait,
       wait_ctime,
       waiter_lock_type,
       waiter_mode_req
FROM
(
    SELECT distinct sid,
           serial#,
           inst_id,
           username,
           object_name, 
           sql_id,
           blocking_session,
           decode(blocking_session, null, null, l.inst_lock) inst_lock,
           decode(blocking_session, null, null, l.sid_lock) sid_lock,
           decode(blocking_session, null, null, l.lock_ctime) lock_ctime,
           decode(blocking_session, null, null, l.inst_wait) inst_wait,
           decode(blocking_session, null, null, l.sid_wait) sid_wait,
           decode(blocking_session, null, null, l.wait_ctime) wait_ctime,
           decode(blocking_session, null, null, l.waiter_lock_type) waiter_lock_type,
           decode(blocking_session, null, null, l.waiter_mode_req) waiter_mode_req
      FROM sessions s
      JOIN locks l on (l.inst_lock = s.inst_id and l.sid_lock = s.sid) or (l.inst_wait = s.inst_id and l.sid_wait = s.sid)
      LEFT OUTER JOIN dba_objects 
           ON (object_id = row_wait_obj#)
     WHERE sid IN (SELECT blocking_session FROM sessions)
        OR blocking_session IS NOT NULL
)
CONNECT BY PRIOR sid = blocking_session
START WITH blocking_session IS NULL
ORDER SIBLINGS BY lock_ctime, wait_ctime
/ 



prompt "##########  Objetos em lock ##########"

SELECT
        count(Object_Name),
        B.Object_Name
FROM 
        GV$Locked_Object A, 
        dba_Objects B,
        gv$session C
WHERE 
        a.INST_ID = c.INST_ID AND
        A.Object_ID = B.Object_ID AND
        SESSION_ID = SID AND
        C.USERNAME = A.Oracle_Username  
group by B.Object_Name having count(Object_Name) > 0
order by 1 asc
/

SELECT
        B.Object_Name,
        c.username,
        SESSION_ID,
        c.inst_id
FROM 
        GV$Locked_Object A, 
        dba_Objects B,
        gv$session C
WHERE 
        a.INST_ID = c.INST_ID AND
        A.Object_ID = B.Object_ID AND
        SESSION_ID = SID 
order by 1 asc
/

/*
 COL Obj FORMAT A30
select inst_id "Inst. bloqueada",  sid "SID bloqueada", username, B.OWNER||'.'||B.Object_Name "Obj",
blocking_session "SID bloqueadora", BLOCKING_INSTANCE "Inst. bloqueadora" ,BLOCKING_SESSION_STATUS AS "Lock Status",a.STATUS, program,
a.*
from gv$session A,
dba_Objects B where blocking_session is not null AND
A.ROW_WAIT_OBJ# = B.Object_ID  
/
*/

clear col

