-- 解答
select stu.student_id, stu.student_name, t2.sub_name, t2.attend_exams
from students stu left join
(select t.student_id stu_id, sub.subject_name sub_name, t.count attend_exams from subjects sub left join
(select count(*) count, student_id, subject_name from examinations group by student_id, subject_name) t
on sub.subject_name = t.subject_name) t2
on stu.student_id = t2.stu_id;

-- 答案
-- 1
select t1.student_id, t1.student_name, t1.subject_name, ifnull(t2.attended_exams, 0) attended_exams from
(select * from students cross join subjects sub) t1
left join
(select count(*) attended_exams, student_id, subject_name from examinations group by student_id, subject_name) t2
on t1.student_id = t2.student_id and t1.subject_name = t2.subject_name
order by t1.student_id asc, t1.subject_name asc;
-- 2
SELECT 
    s.student_id, s.student_name, sub.subject_name, IFNULL(grouped.attended_exams, 0) AS attended_exams
FROM 
    Students s
CROSS JOIN 
    Subjects sub
LEFT JOIN (
    SELECT student_id, subject_name, COUNT(*) AS attended_exams
    FROM Examinations
    GROUP BY student_id, subject_name
) grouped 
ON s.student_id = grouped.student_id AND sub.subject_name = grouped.subject_name
ORDER BY s.student_id, sub.subject_name;