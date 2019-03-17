-- load batting data
batters = LOAD 'hdfs:/user/maria_dev/pigtest/Batting.csv' using PigStorage(',');
-- filter out batters
realbatters = FILTER batters BY $1>0;
RBI_data = FOREACH realbatters GENERATE $0 AS id, $11 AS RBI;
-- group by player
by_player = GROUP RBI_data BY id;
-- Sum RBI Data by player
temp = FOREACH by_player GENERATE RBI_data.id AS id, SUM(RBI_data.RBI) as total_RBI;
RBI_list = FOREACH temp GENERATE FLATTEN(id.id) AS id, total_RBI;
-- Find max RBIs
all_RBI = GROUP RBI_list ALL;
max_RBI = FOREACH all_RBI  GENERATE MAX(RBI_list.total_RBI) AS m_RBI;
-- Find player with max RBIs
max_RBI_player_list = FILTER RBI_list by total_RBI == max_RBI.m_RBI;
-- Remove dups
max_RBI_player = DISTINCT max_RBI_player_list;
-- load batter details
master = LOAD 'hdfs:/user/maria_dev/pigtest/Master.csv' using PigStorage(',');
-- batter details 
batter_details = FOREACH master GENERATE $0 AS id, $6 AS b_city;
-- Join to player.id to player details
joined_data = JOIN max_RBI_player  BY id, batter_details BY id;
max_RBI_city = FOREACH joined_data GENERATE b_city;
-- DESCRIBE max_RBI_city;
DUMP max_RBI_city;




