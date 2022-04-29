#!/bin/bash

export LOG_FILE=/root/rsync_check.log
export DIR_ORIGEM=/backup/arquivos/rman/prd/
export DIR_DESTINO=10.17.56.11:/mnt/orabackup/prd
export TAG_RSYNC="-P --size-only -z -d"

date >> $LOG_FILE
echo "Checando por processos em execucao" >> $LOG_FILE
COUNT=`ps ax | grep rsync | grep -v grep | grep -v rsync_check.sh | wc -l`
echo "Existem $COUNT processos Rsync em execução"; >> $LOG_FILE
if [ $COUNT -eq 0 ]
then
        echo "Sem Rsync em execucao, reiniciando processo" >> $LOG_FILE
        ##killall rsync  # Previne enfileiramento de processos, não usar em ambiente com rotina de rsync;
        rsync ${DIR_ORIGEM} ${DIR_DESTINO} ${TAG_RSYNC} >> $LOG_FILE
fi