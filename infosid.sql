@set

SELECT
    'Matar a sessao : ALTER SYSTEM KILL SESSION '       || CHR(39) || ss.SID ||','|| ss.SERIAL# || CHR(39) ||' IMMEDIATE;' || chr(10) ||
    'Desconectar    : ALTER SYSTEM DISCONNECT SESSION ' || CHR(39) || ss.SID ||','|| ss.SERIAL# || CHR(39) ||' IMMEDIATE;' || chr(10) ||
    'Trace ON       : EXEC SYS.DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION ('|| ss.SID ||', '||ss.SERIAL# ||', TRUE)'             || chr(10) ||
    'Trace OFF      : EXEC SYS.DBMS_SYSTEM.SET_SQL_TRACE_IN_SESSION ('|| ss.SID ||', '||ss.SERIAL# ||', FALSE)'            || chr(10) ||
    'Explain        : select * from table(dbms_xplan.display_cursor('||chr(39)||SQL_HASH_VALUE||chr(39)||',null));'        || chr(10) ||
    'Session ID     : '||SID           || chr(10) ||
    'Process ID     : '||SPID          || '    ( ps -ef|grep '||chr(34)||' '||spid||' '||chr(34)||'|grep -v grep )' || chr(10) ||
    'Machine        : '||ss.machine    || chr(10) ||
    'Terminal       : '||ss.terminal   || chr(10) ||
    'User SO        : '||OSUSER        || chr(10) ||
    'User Oracle    : '||ss.USERNAME   || chr(10) ||
    'Status         : '||STATUS        || chr(10) ||
    'Schema         : '||SCHEMANAME    || chr(10) ||
    'Program        : '||ss.PROGRAM    || chr(10) ||
    'SQL ID:        : '||ss.SQL_ID     || '    @sql_id ' || ss.SQL_ID ||chr(10) ||
    'Start Session  : '||ss.logon_time || chr(10) ||
    'Tempo conexao  : '||lpad(floor(((sysdate-logon_time)*86400)/(3600)) ||':'|| lpad(floor((((sysdate-logon_time)*86400) - (floor(((sysdate-logon_time)*86400)/(3600))*3600))/60), 2, '0') ||':'||lpad(mod((((sysdate-logon_time)*86400) - (floor(((sysdate-logon_time)*86400)/(3600))*3600)),60), 2, '0'), 10, ' ')  || chr(10) ||
    'Last Call      : '||lpad(trim(to_char(floor(last_call_et/(3600)),9000)||':'||trim(to_char(floor((last_call_et - (floor(last_call_et/(3600))*3600))/60),900))||':'||trim(to_char(mod((last_call_et - (floor(last_call_et/(3600))*3600)),60),900))), 10, ' ') COMMAND
    FROM v$session ss, v$process ps
   WHERE ss.paddr = ps.addr AND ss.sid = '&&1'
ORDER BY ps.spid;

undef 1