
drop table test purge;

create table TEST
as
select *
from DBA_SOURCE
where owner in ('XDB') -- 'ORDSYS','MDSYS')
/

