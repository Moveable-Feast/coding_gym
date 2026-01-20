-- 解答
select round(count(t.a2_player) / (select count(distinct player_id) from activity), 2) fraction from
  (select a1.player_id a1_player, min(a1.event_date) first_date, a2.player_id a2_player from
  activity a1 left join activity a2
  on a1.player_id = a2.player_id and a1.event_date + interval 1 day = a2.event_date
  group by a1.player_id) t
where t.a2_player is not null;

-- 答案
select IFNULL(round(count(distinct(Result.player_id)) / count(distinct(Activity.player_id)), 2), 0) as fraction
from (
  select Activity.player_id as player_id
  from (
    select player_id, DATE_ADD(MIN(event_date), INTERVAL 1 DAY) as second_date
    from Activity
    group by player_id
  ) as Expected, Activity
  where Activity.event_date = Expected.second_date and Activity.player_id = Expected.player_id
) as Result, Activity;