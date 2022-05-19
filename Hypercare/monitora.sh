#!/bin/sh
#cat mon_hist_052022.csv | column -t -s $'\t'
#watch -n 120 "cat mon_hist_052022.csv | column -t -s $'\t'""
export datetime=$(date +"%d-%m-%Y %T")
export date=$(date +"%m%Y")
export pbyinstance=() #processo por instancia
export sbyinstance=() #sessao ativa por instancia

export instances=( "prdmv" "smlmv" "prdmv" ) #instancias a monitorar
export mon_dir=/home/oracle/Flowti/scripts/Hypercare #Diretorio os scripts
export mon_file_log=$mon_dir/mon_hist_$date.csv # Arquivo de log do monitoramento
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=$ORACLE_BASE/product/12.1.0/db_1

export PATH=$ORACLE_HOME/bin:$HOME/bin:$PATH:/bin:/usr/bin:/usr/sbin:/sbin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jre:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

function get_active_sessions (){
if [ ! $(pidof "ora_pmon_$1" ) ]
then
    echo "inst. $1 fora do ar"
else
export ORACLE_SID=$1
sativas=$($ORACLE_HOME/bin/sqlplus -S / as sysdba << EOF
set head off
select count(1)-1 from gv\$session where status = 'ACTIVE' and type = 'USER' and username is not null;
exit
EOF
)
echo $sativas
fi
}


if ! [ -e $mon_file_log ]
then
  echo -n -e HORA COLETA'\t'LOAD 1'\t'LOAD 5'\t'LOAD 15'\t'Proc Oracle'\t'Proc Ativo'\t'Proc Inativos >> $mon_file_log
  for inst in ${instances[@]}; do
    echo -n -e '\t'Proc ${inst}'\t'Sess ${inst} >> $mon_file_log
  done
  #quebra de linha
  echo >> $mon_file_log 
fi

# Faz a coleta dos loads 1, 5, 15 e 
# dos processos ativos e inativos.
export load1=$(cut -d' ' -f1 < /proc/loadavg)
export load5=$(cut -d' ' -f2 < /proc/loadavg)
export load15=$(cut -d' ' -f3 < /proc/loadavg)
export atveinatv=$(cut -d' ' -f4 < /proc/loadavg)
export pativo=${atveinatv%/*}
export pinatv=${atveinatv#*/}

# Faz leitura dos processos rodando num arquivo auxiliar
ps axHr > $mon_dir/prunning.log

# Faz a contagem de processo por instancia.
for i in ${!instances[@]}; do
  pbyinstance[$i]=$(grep -c "oracle${instances[i]}" $mon_dir/prunning.log)
done

# Conta os processos de background do oracle 
poracle=$(grep -c "ora_" $mon_dir/prunning.log)

# Apaga o arquivo auxiliar
rm $mon_dir/prunning.log

for i in ${!instances[@]}; do
  sbyinstance[$i]=$(get_active_sessions "${instances[i]}")
done;

#for i in ${!instances[@]}; do
#  echo "Sessoes da instancia: " ${instances[i]} ":" ${sbyinstance[i]}
#  echo "Processos da instancia: " ${instances[i]} ":" ${pbyinstance[i]}
#done;
#echo "load1: " $load1
#echo "load5: " $load5
#echo "load15: " $load15
#echo "Processos Oracle: " $poracle
#echo "Processos ativos: (leva em consideração o ps, considerar -1)" $pativo
#echo "Processos inativos: " $pinatv

echo -n -e $datetime'\t'$load1'\t'$load5'\t'$load15'\t'$poracle'\t'$pativo'\t'$pinatv>> $mon_file_log
for i in ${!instances[@]}; do
  echo -n -e '\t'${pbyinstance[i]}'\t'${sbyinstance[i]} >> $mon_file_log
done
#quebra de linha
echo >> $mon_file_log 