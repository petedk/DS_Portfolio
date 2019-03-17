-- load batting data
batters = LOAD 'hdfs:/user/maria_dev/pigtest/Batting.csv' using PigStorage(',');
-- filter out batters 
realbatters = FILTER batters BY $1>0;
-- real batters
hit_data = FOREACH realbatters GENERATE $0 AS id, $8 AS b2, $9 AS b3, $8 + $9 as t_b;
-- group by player
by_player = GROUP hit_data BY id;
-- Sum Data by player
temp = FOREACH by_player GENERATE FLATTEN(hit_data.id) AS id, SUM(hit_data.b2) as total_b2, SUM(hit_data.b3) as total_b3, SUM(hit_data.t_b) as total_t_b;
hit_list = DISTINCT temp;

-- load batter details
master = LOAD 'hdfs:/user/maria_dev/pigtest/Master.csv' using PigStorage(',');
filter_state = FILTER master BY $5 != '';
filter_city = FILTER master BY (SUBSTRING($6,0, 1) == 'A' OR SUBSTRING($6,0, 1) == 'E' OR SUBSTRING($6,0, 1) == 'I' OR SUBSTRING($6,0, 1) == 'O' OR SUBSTRING($6,0, 1) == 'U');
-- file for batter
batter_details = FOREACH filter_city GENERATE $0 AS id, $6 AS b_city, $5 as b_state, CONCAT($6,'/',$5) as city_state;

-- Join
joined_data = JOIN hit_list  BY id, batter_details BY id;
city_state_data = FOREACH joined_data GENERATE $7 as city_state, $5 as b_city, $6 as b_state, $3 as total_hits;
-- group
by_city_state = GROUP city_state_data by city_state;
-- Sum
temp = FOREACH by_city_state GENERATE group as city_state, FLATTEN(city_state_data.b_city) AS city, FLATTEN(city_state_data.b_state) AS state, 
	SUM(city_state_data.total_hits) AS hits;
temp2 = DISTINCT temp;
city_state_hits = FILTER temp2 by city_state != '';
-- Order
order_by_hits =  ORDER city_state_hits BY hits DESC;
-- limit
top_5 = LIMIT order_by_hits 5;
-- results
winners = FOREACH top_5 GENERATE city_state; 

-- DESCRIBE winners;
DUMP winners;




