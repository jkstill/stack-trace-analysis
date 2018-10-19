
select /*+ use_hash(t2) gather_plan_statistics */ 
	count(*) tcount
from TEST t1, TEST t2
where t1.owner = t2.owner
/

