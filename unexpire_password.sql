alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

PROMPT
PROMPT "EXECUTE OS COMANDOS ABAIXO PARA DESBLOQUEAR E VALIDAR OS LOGINS: "
PROMPT

select 'ALTER USER ' || username || ' ACCOUNT UNLOCK;' cmd from dba_users where ACCOUNT_STATUS like '%LOCK%';

select 'ALTER USER ' || name || ' IDENTIFIED BY VALUES ' || trim(PASSWORD) || ';' cmd
    from user$ where name in (select username from dba_users where ACCOUNT_STATUS like '%EXPIRED%') and trim(PASSWORD) is not null;