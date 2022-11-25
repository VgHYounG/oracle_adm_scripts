/*
 Cria uma tuning task do oracle ADVISOR e a executa
 Ps. Licenciamento necessario.
*/


ACCEPT VAR_SQLID PROMPT 'INFORME O SQLID: '

SET SERVEROUTPUT ON SIZE UNLIMITED;

DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_id      => '&VAR_SQLID',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 300,
                          task_name   => 'tuning_task_&VAR_SQLID',
                          description => 'Tuning task1 for sql_id &VAR_SQLID');
    DBMS_SQLTUNE.execute_tuning_task(task_name => l_sql_tune_task_id);
    DBMS_OUTPUT.put_line('------------------------------------');
    DBMS_OUTPUT.put_line('-  Execute:                        -');
    DBMS_OUTPUT.put_line('------------------------------------');
    DBMS_OUTPUT.put_line('SET SERVEROUTPUT ON SIZE UNLIMITED;');
    DBMS_OUTPUT.put_line('DECLARE');
    DBMS_OUTPUT.put_line('  tuning_report CLOB;');
    DBMS_OUTPUT.put_line('BEGIN');
    DBMS_OUTPUT.put_line('  tuning_report := DBMS_SQLTUNE.REPORT_TUNING_TASK ( task_name => ''tuning_task_&VAR_SQLID'' , type => ''TEXT'' , level => ''TYPICAL'' , section => ''ALL'' );');
    DBMS_OUTPUT.put_line('  DBMS_OUTPUT.PUT_LINE(tuning_report);');
    DBMS_OUTPUT.put_line('END;');
    DBMS_OUTPUT.put_line('/');
END;
/

undef VAR_SQLID