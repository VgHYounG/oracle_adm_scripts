EXEC DBMS_STATS.GATHER_DICTIONARY_STATS;
EXEC DBMS_STATS.GATHER_FIXED_OBJECTS_STATS;

begin
DBMS_STATS.GATHER_DATABASE_STATS(ESTIMATE_PERCENT => &ESTIMATE_PERCENT
,block_sample => FALSE
,method_opt => 'for all columns size AUTO'
,degree => &DEGREE
,granularity => 'ALL'
,cascade => TRUE
,stattab => null
,statid => null
,options => 'GATHER'
,statown => null
,gather_sys => TRUE
,NO_INVALIDATE => FALSE
,gather_temp => TRUE
,gather_fixed => FALSE
,stattype => 'ALL');
end;
/
