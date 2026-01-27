-- 解答
select t_num.id, t_num.num from
  (select id, count(*) num from
    ((select requester_id id from requestaccepted) union (select accepter_id id from requestaccepted)) t
  left join requestaccepted ra
  on t.id = ra.requester_id or t.id = ra.accepter_id group by id) t_num
where t_num.num =
  (select max(t_num_2.num) from
    (select id, count(*) num from
      ((select requester_id id from requestaccepted) union (select accepter_id id from requestaccepted)) t
    left join requestaccepted ra
    on t.id = ra.requester_id or t.id = ra.accepter_id group by id) t_num_2);
-- 答案
select ids as id, cnt as num from
(
  select ids, count(*) as cnt from
    (
      select requester_id as ids from RequestAccepted
      union all
      select accepter_id from RequestAccepted
    ) as tbl1
  group by ids
) as tbl2
order by cnt desc
limit 1;