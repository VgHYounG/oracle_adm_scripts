-- > 90

select Sum(Pins) "Hits",
      Sum(Reloads) "Misses",
      ((Sum(Reloads) / Sum(Pins)) * 100) "Reload %",
      Sum(pins) / (Sum(Pins) + sum(Reloads)) * 100 "Hit Ratio"
from V$LibraryCache;

