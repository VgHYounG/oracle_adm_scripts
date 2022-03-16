SELECT 'Sorts in Memory ' "Ratio" ,
    ROUND((SELECT SUM(value) FROM V$SYSSTAT WHERE name = 'sorts (memory)') / 
        (SELECT SUM(value) FROM V$SYSSTAT     WHERE name IN ('sorts (memory)', 'sorts (disk)')) * 100, 2) ||'%' "Percentage"
FROM DUAL;