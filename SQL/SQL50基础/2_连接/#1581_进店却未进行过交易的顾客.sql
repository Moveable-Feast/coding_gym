-- 解答
select
cv.customer_id customer_id, cv.count_visit_v - ifnull(tvc.count_visit_t, 0) count_no_trans
from
(select count(visit_id) count_visit_v, customer_id from visits group by customer_id) cv
left join
(select count(distinct tr.visit_id) count_visit_t, vi.customer_id customer_id from transactions tr, visits vi where vi.visit_id = tr.visit_id group by vi.customer_id) tvc
on cv.customer_id = tvc.customer_id
where cv.count_visit_v - ifnull(tvc.count_visit_t, 0) > 0;

-- 答案
-- 1
select customer_id, count(customer_id) count_no_trans from
visits v left join transactions t on v.visit_id = t.visit_id
where transaction_id is null
group by customer_id;
-- 2
select customer_id, count(customer_id) as count_no_trans from visits
where visit_id not in 
(select visit_id from transactions)
group by customer_id;