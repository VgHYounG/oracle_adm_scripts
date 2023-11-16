PROMPT >>>>>>>> ESTATISTICAS DE MEMORIA ORACLE ADVISORS
PROMPT 
PROMPT --Advisors 1 - Buffer Cache, 2 - Shared Pool, 3 - PGA, 4 - SGA, 5 - MEMORY (11g)
set lines 400;
set pages 400;
show parameter db_cache_size
 
PROMPT
COLUMN size_for_estimate FORMAT 999,999,999,999 heading 'Cache Size (MB)'
COLUMN buffers_for_estimate FORMAT 999,999,999 heading 'Buffers'
COLUMN estd_physical_read_factor FORMAT 999.90 heading 'Estd Phys|Read Factor'
COLUMN estd_physical_reads FORMAT 999,999,999 heading 'Estd Phys| Reads'
SELECT size_for_estimate, buffers_for_estimate, estd_physical_read_factor, estd_physical_reads
FROM V$DB_CACHE_ADVICE
WHERE name = 'DEFAULT'
AND block_size = (SELECT value FROM V$PARAMETER WHERE name = 'db_block_size')
AND advice_status = 'ON';
 
PROMPT 
show parameter shared_pool_size
PROMPT
select SHARED_POOL_SIZE_FOR_ESTIMATE, SHARED_POOL_SIZE_FACTOR, ESTD_LC_MEMORY_OBJECTS ESTD_LC_SIZE, ESTD_LC_MEMORY_OBJECT_HITS from V$SHARED_POOL_ADVICE;
 
PROMPT 
show parameter pga_aggregate_target
PROMPT
SELECT PGA_TARGET_FACTOR, round(PGA_TARGET_FOR_ESTIMATE/1024/1024) target_mb,
ESTD_PGA_CACHE_HIT_PERCENTAGE cache_hit_perc, ESTD_EXTRA_BYTES_RW, ESTD_OVERALLOC_COUNT
FROM V$PGA_TARGET_ADVICE;
 
PROMPT 
SELECT * FROM v$sga_target_advice ORDER BY sga_size;
 
PROMPT 
SELECT * FROM v$memory_target_advice ORDER BY memory_size;