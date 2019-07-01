

-----  NYU Emerg Med PreTest June30  -----

---- solution 1: assuming that only the SAME lesson (with the same user_id and test date) counts as "more than once"



; with T01 as (
	Select  row_number()over (partition by u.user_id, training_id, training_date order by u.user_id		asc, training_date desc) as Duplicate_training3  --- partition the users into groups based on how    many training lessons (same lesson only) they took on that day
	,  USER_TRAINING_ID, U.user_id, user_name, training_id,training_date
	from users1 as U
	inner join training_details1 as T
	on U.user_id = T.user_id )
, T02_3users_MoreThanOnce as (   --- n = 5 rows retrieved, 3 users 
		Select  T1.*
		from T01 as T1
		Where Duplicate_training3 >1	--- filter out those who took the SAME lesson more than once		in	the same day
	)  ----------below to get the remaining person not of interest (Jane Don)-------
, T_usersNotOfInterest as (  -- Jane Don , only once
	select distinct user_id, user_name from T01
	where user_id not in (select user_id from T02_3users_MoreThanOnce)
	)  
, T_3UsersFirstTraining as (
	select *
	from T01
	where user_id not in (select user_id from T_usersNotOfInterest)	
	and Duplicate_training3 =1
	)
, T_allneeded as (
	select Duplicate_training3, user_training_id, user_id, user_name, training_id, training_date 
	from T_3UsersFirstTraining
	where user_training_id not in (9,10,7) -- to delete these 3 rows (different training lessons) 
	union 
	select Duplicate_training3, user_training_id, user_id, user_name, training_id, training_date 
	from T02_3users_MoreThanOnce)
select * from T_allneeded 
order by user_id asc, training_date desc



