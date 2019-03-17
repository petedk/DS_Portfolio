-- load batting data
batters = LOAD 'hdfs:/user/maria_dev/pigtest/Batting.csv' using PigStorage(',');
-- filter out batters 
realbatters = FILTER batters BY $1>0;
-- file for real batters 
hit_data = FOREACH realbatters GENERATE $0 AS id, $7 AS hits, $5 AS AB;
-- group by player
by_player = GROUP hit_data BY id;
-- Sum Data by player
temp = FOREACH by_player GENERATE FLATTEN(hit_data.id) AS id, SUM(hit_data.hits) as total_hits, SUM(hit_data.AB) as total_AB;
hit_list = DISTINCT temp;

-- load batter details
master = LOAD 'hdfs:/user/maria_dev/pigtest/Master.csv' using PigStorage(',');
filter_state = FILTER master BY $5 != '';
filter_month = FILTER master BY $2 != '';
-- file for batter
batter_details = FOREACH filter_month GENERATE $0 AS id, $2 AS b_month, $5 as b_state, CONCAT($2,'/',$5) as month_state;
-- Join
joined_data = JOIN hit_list  BY id, batter_details BY id;
month_state_data = FOREACH joined_data GENERATE $6 as month_state, $4 as b_month, $5 as b_state, $1 as hits, $2 as AB, $0 as players;
-- group
by_month_state = GROUP month_state_data by month_state;
-- Sum
temp = FOREACH by_month_state GENERATE group as month_state, FLATTEN(month_state_data.b_month) AS month, FLATTEN(month_state_data.b_state) AS state, 
	SUM(month_state_data.hits) AS hits, SUM(month_state_data.AB) AS AB, COUNT(month_state_data.players) AS players, SUM(month_state_data.hits) / SUM(month_state_data.AB) AS score ;
city_state_hits = DISTINCT temp;
-- filter
filter_player = FILTER city_state_hits BY players > 9;
filter_AB = FILTER filter_player BY AB > 1499;
order_by_score = ORDER filter_AB BY score; 
-- limit
top_1 = LIMIT order_by_score 1;
-- results
winners = FOREACH top_1 GENERATE month_state; 

-- DESCRIBE winners;
DUMP winners;
