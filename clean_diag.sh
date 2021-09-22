export L_PATH=$ORACLE_BASE/diag/tnslsnr/$HOSTNAME/listener
export DATA=`date +%Y%m%d`
cp $L_PATH/trace/listener.log $L_PATH/trace/listenerold.log && echo -n > $L_PATH/trace/listener.log
tar -zcvf $L_PATH/trace/listener.$DATA.tar.gz $L_PATH/trace/listenerold.log
rm $L_PATH/trace/listenerold.log
tar -zcvf $L_PATH/alert/logs.$DATA.tar.gz $L_PATH/alert/log_* && rm -f $L_PATH/alert/log_*

ls $L_PATH/alert/
ls $L_PATH/trace/ |grep list 
du -sch $ORACLE_BASE/diag