-- 解答
select t.department, t.employee, t.salary
from
    (select
        d.name department,
        e.name employee,
        e.salary,
        dense_rank() over (partition by d.id order by salary desc) as rank_over_dept
    from department d, employee e where e.departmentid = d.id) t
where t.rank_over_dept <= 3;
-- 答案
SELECT
    d.Name AS 'Department', e1.Name AS 'Employee', e1.Salary
FROM
    Employee e1
        JOIN
    Department d ON e1.DepartmentId = d.Id
WHERE
    3 > (SELECT
            COUNT(DISTINCT e2.Salary)
        FROM
            Employee e2
        WHERE
            e2.Salary > e1.Salary
                AND e1.DepartmentId = e2.DepartmentId
        )
;