-- 解答
-- Oracle
select user_id, initcap(name) name from users order by user_id;

-- 答案
select
  user_id,
  concat(upper(substring(name, 1, 1)), lower(substring(name, 2))) name
from users order by user_id;