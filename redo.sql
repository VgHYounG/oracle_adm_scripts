/*
Traz a geracao de redo por sessao
*/

set lines 300;
set pages 4000;
col name for a20;
col MACHINE for a40;
col USERNAME for a20;
SELECT s.INST_ID, s.sid,
  sn.SERIAL#,
  sn.username,
  sn.MACHINE,
  sn.PROGRAM,
  n.name,
  ROUND (VALUE / 1024 / 1024, 2) redo_mb,
  sn.status,
  sn.TYPE,
  decode( trunc(sysdate-sn.logon_time),            -- dias conectado
               0, to_char(sn.logon_time,'hh24:mi:ss'),  -- se menos de um dia
                  to_char(trunc(sysdate-sn.logon_time, 1), 'fm99.0') || ' dias'
             ) as log_time
FROM gv$sesstat s
JOIN gv$statname n ON n.statistic# = s.statistic#
JOIN gv$session sn ON sn.sid = s.sid
WHERE n.name LIKE 'redo size' AND s.VALUE <> 0 and s.INST_ID=sn.INST_ID and s.INST_ID=n.INST_ID and ROUND (VALUE / 1024 / 1024, 2) > 100 and TYPE<>'BACKGROUND'
ORDER BY redo_mb DESC;