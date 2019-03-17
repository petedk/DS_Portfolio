-- load fielding details
fielding = LOAD 'hdfs:/user/maria_dev/pigtest/Fielding.csv' using PigStorage(',');
-- filter
filtered_player = FILTER fielding BY $0 != '';
filtered_team = FILTER fielding BY $2 != '';
filtered_yr = FILTER filtered_team BY $1 >= 1950;
filtered_error = FILTER filtered_yr BY $10 > 0;
-- fielding info
fielding_details = FOREACH filtered_error GENERATE $0 as player, $2 AS team, CONCAT($0,'_',$2) as player_team, $10 AS errors;
-- group
by_player_team = GROUP fielding_details by player_team;
-- count
temp = FOREACH by_player_team GENERATE group as player_team, FLATTEN(fielding_details.player) as player, FLATTEN(fielding_details.team) as team, 
	SUM(fielding_details.errors) as error_sum;
count_errors = DISTINCT temp;
-- get max errors
all_errors = GROUP count_errors ALL;
max_errors = FOREACH all_errors GENERATE MAX(count_errors.error_sum) as m_errors;
-- match max_errors to player_team list
max_player_team_errors = FILTER count_errors by error_sum == max_errors.m_errors;
result = FOREACH max_player_team_errors GENERATE player, team;

-- DESCRIBE result;
DUMP result;



