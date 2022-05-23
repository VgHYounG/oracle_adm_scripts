-- < 1.6

SELECT name, value
FROM v$sysstat
WHERE name = 'parse count (total)' OR name = 'parse count (hard)';


SELECT (b.value/a.value)*100||'' HardParseRatio
FROM v$sysstat a, v$sysstat b
WHERE a.name = 'parse count (total)'
AND b.name = 'parse count (hard)';
