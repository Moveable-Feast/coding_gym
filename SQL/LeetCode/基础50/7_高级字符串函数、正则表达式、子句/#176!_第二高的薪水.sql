-- 解答
select t.SecondHighestSalary from
  (select t1.sal SecondHighestSalary, rownum rn from
    (select * from emp order by sal desc) t1
  where rownum <= 2) t
where rn >= 2;
-- 答案
select max(salary) SecondHighestSalary from Employee
where salary < (select max(salary) from Employee);