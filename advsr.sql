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
                          time_limit  => 1200,
                          task_name   => 'tuning_task_&VAR_SQLID',
                          description => 'Tuning task1 for sql_id &VAR_SQLID');
    DBMS_SQLTUNE.execute_tuning_task(task_name => l_sql_tune_task_id);
    DBMS_OUTPUT.put_line('------------------------------------');
    DBMS_OUTPUT.put_line('-  Execute:                        -');
    DBMS_OUTPUT.put_line('------------------------------------');
    DBMS_OUTPUT.put_line('set long 1000000;')
    DBMS_OUTPUT.put_line('set longchunksize 100000')
    DBMS_OUTPUT.put_line('set pagesize 10000 ')
    DBMS_OUTPUT.put_line('set linesize 1000 ')
    DBMS_OUTPUT.put_line('select dbms_sqltune.report_tuning_task(''tuning_task_2_dt91hbcx2trha'') as Recommandations from dual;')
END;
/

undef VAR_SQLID