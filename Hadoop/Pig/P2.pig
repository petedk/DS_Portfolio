-- load batter details
master = LOAD 'hdfs:/user/maria_dev/pigtest/Master.csv' using PigStorage(',');
-- FILTERS rows
filteredyr = FILTER master BY $1 > 0;
filteredm = FILTER filteredyr BY $2 > 0;
-- batter info
batter_details = FOREACH filteredm GENERATE $0 AS id, $1 as b_year, $2 AS b_month, CONCAT($2,'/', $1) AS combined;
-- group 
by_month_year = GROUP batter_details by combined;
-- count players by month/year combo
temp = FOREACH by_month_year GENERATE batter_details.combined AS m_yr, COUNT(batter_details.combined) as player_count;
temp_dup= FOREACH temp GENERATE FLATTEN(m_yr) AS m_yr, player_count;
-- remove dups
month_year_count = DISTINCT temp_dup;
-- group by player_count
temp = GROUP month_year_count by player_count;
by_player_count = ORDER temp BY group DESC;
top_3 = LIMIT by_player_count 3;
winners = FOREACH top_3 GENERATE month_year_count.m_yr;
-- DESCRIBE winners;
DUMP winners;



