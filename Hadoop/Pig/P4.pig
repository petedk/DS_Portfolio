-- load fielding details
fielding = LOAD 'hdfs:/user/maria_dev/pigtest/Fielding.csv' using PigStorage(',');
-- Filter
filtered_team = FILTER fielding BY $2 != '';
filtered_yr = FILTER filtered_team BY $1 >= 1950;
filtered_error = FILTER filtered_yr BY $10 > 0;
-- fielding info
fielding_details = FOREACH filtered_error GENERATE $2 AS team, CONCAT($2,'_',$1) as team_year, $10 AS errors;
-- group by team
by_team = GROUP fielding_details by team_year;
-- count error
temp = FOREACH by_team GENERATE group as team_year, FLATTEN(fielding_details.team) as team, SUM(fielding_details.errors) as error_sum;
count_errors = DISTINCT temp;
-- find max errors
all_errors = GROUP count_errors ALL;
max_errors = FOREACH all_errors GENERATE MAX(count_errors.error_sum) as m_errors;
-- match team with max errors
max_team_errors = FILTER count_errors by error_sum == max_errors.m_errors;
result = FOREACH max_team_errors GENERATE team;
-- DESCRIBE result;
DUMP result;



