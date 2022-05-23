#!/bin/sh

# Uso [COMO ROOT] LimpaLogs.sh <Caminho Log>
# */5 * * * * sh /u01/app/oracle/Flowti/scripts/LimpaLogs.sh /u01/app/oracle/Flowti/logs

export LOG_FILE=$1/limpaLogs_`date '+%d%m%Y_%H%M'`.log

## Apagar arquivos de Logs SGDB
# Listar arquivos
find /u01/app/oracle/diag/rdbms/*/*/cdump/core_*      -mtime 3 -type d -exec rm -frv {} \; >> $LOG_FILE
find /u01/app/oracle/diag/rdbms/*/*/incident/incdir_* -mtime 3 -type d -exec rm -frv {} \; >> $LOG_FILE
find /u01/app/oracle/diag/rdbms/*/*/trace/cdmp_*      -mtime 3 -type d -exec rm -frv {} \; >> $LOG_FILE

find /u01/app/oracle/diag/rdbms/*/*/trace/*.trm      -mtime 3 -type f -exec rm -frv {} \; >> $LOG_FILE
find /u01/app/oracle/diag/rdbms/*/*/trace/*.trc      -mtime 3 -type f -exec rm -frv {} \; >> $LOG_FILE

# Limpar arquivos ASM
find /u01/app/grid/diag/asm/+asm/+ASM1/trace/ -mtime 5 -type f -name *ufg* -exec rm -frv {} \; >> $LOG_FILE
find /u01/app/grid/diag/asm/+asm/+ASM1/trace/ -mtime 5 -type f -name *nfg* -exec rm -frv {} \; >> $LOG_FILE

# Limpar Logs
find $1 -type f -mtime 5 -name "limpaLogs_*.log" -exec rm -frv {} \; >> $LOG_FILE