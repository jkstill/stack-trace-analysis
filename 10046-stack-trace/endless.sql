
prompt OS PID

@spid

prompt
prompt

declare
	v_str varchar2(128);
begin

	while true
	loop
		v_str := dbms_random.string('l',128);
		dbms_lock.sleep(.1);
	end loop;

end;
/

