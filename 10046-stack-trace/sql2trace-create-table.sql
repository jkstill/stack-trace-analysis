
-- sql2trace.sql

set line 200 trimspool on
set pagesize 60

declare

	v_sql clob := 'drop table stack_test purge';

	table_does_not_exist exception;
	pragma exception_init(table_does_not_exist,-942);

begin

	execute immediate v_sql;

exception
when table_does_not_exist then
	null;
when others then
	raise;
end;
/


create table stack_test
as 
select *
from dba_objects
/




