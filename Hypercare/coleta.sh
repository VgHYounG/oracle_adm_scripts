export LOG_FILE=coleta.log

cd /home/oracle/mon/
. /home/oracle/.bash_profile

now=$(date)
echo "----------- $now -----------" >> $LOG_FILE

free -h >> $LOG_FILE
uptime >> $LOG_FILE
echo \`\`\` >> $LOG_FILE
echo -n "LOAD1: " >> $LOG_FILE
cut -d ' ' -f1 /proc/loadavg >> $LOG_FILE
echo -n "MEM% :" >> $LOG_FILE
free | grep Mem | awk '{print $3/$2 * 100.0}' >> $LOG_FILE
echo -n "CPU% :" >> $LOG_FILE
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' >> $LOG_FILE
iowait_v=$(top -bn2| awk -F"," '/Cpu/{if(p==0){p=1}else{split($5,a,"%");print a[1]}}')
echo IOWAIT%: ${iowait_v::-3} >> $LOG_FILE
top -bn1| awk -F"," '/Cpu/{if(p==0){p=1}else{split($5,a,"%");print a[1]}}' >> $LOG_FILE
sqlplus -S / as sysdba @ss_count >> $LOG_FILE
echo \`\`\` >> $LOG_FILE 
echo "----------------------------------------------------" >> $LOG_FILE
sqlplus -S / as sysdba @ss_mon >> $LOG_FILE.detailed