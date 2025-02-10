/*
Exibe o uso da tablespace TEMP por sessão
*/

col username for a40
col tablespace for a35

SELECT 
    S.SID,
    S.SERIAL#,
    S.USERNAME,
    S.STATUS,
    T.TABLESPACE,
    T.SEGTYPE,
    T.SEGFILE#,
    T.SEGBLK#,
    T.BLOCKS * (SELECT VALUE FROM V$PARAMETER WHERE NAME = 'db_block_size') / 1024 / 1024 AS TEMP_USED_MB
FROM 
    V$SESSION S
JOIN 
    V$TEMPSEG_USAGE T ON S.SADDR = T.SESSION_ADDR
ORDER BY 
    TEMP_USED_MB DESC;