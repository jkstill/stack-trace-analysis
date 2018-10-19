select s.sid 
from v$session s
	where userenv('SESSIONID') = s.audsid
/
