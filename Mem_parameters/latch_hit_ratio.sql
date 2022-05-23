-- > 90

SELECT 'Latch Hit Ratio ' "Ratio" , ROUND(
        (SELECT SUM(gets) - SUM(misses) FROM V$LATCH) / 
        (SELECT SUM(gets) FROM V$LATCH) * 100, 2)||'%' "Percentage" 
FROM DUAL;