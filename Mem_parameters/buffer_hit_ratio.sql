PROMPT **********************************************************
PROMPT  HIT RATIO SECTION
PROMPT **********************************************************
PROMPT
PROMPT         =========================
PROMPT         BUFFER HIT RATIO
PROMPT         =========================
PROMPT (should be > 70, else increase db_block_buffers in init.ora)
 

SELECT TRUNC((1-(sum(decode(name,'physical reads',value,0))/
                (sum(decode(name,'db block gets',value,0))+
                (sum(decode(name,'consistent gets',value,0)))))
             )* 100) "Buffer Hit Ratio"
FROM v$SYSSTAT;
