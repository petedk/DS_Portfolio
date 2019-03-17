-- load batting data
batters = LOAD 'hdfs:/user/maria_dev/pigtest/Batting.csv' using PigStorage(',');
-- filter out batters 
realbatterlow = FILTER batters BY $1>2004;
realbatterhigh = FILTER realbatterlow BY $1<2010;
-- real batters 
hits_data = FOREACH realbatterhigh GENERATE $0 AS player, $2 AS team, $7 AS hit, $5 AS AB;
-- group by player
by_player = GROUP hits_data BY player;
-- Sum HIT and AB Data by player
temp = FOREACH by_player GENERATE group AS player, SUM(hits_data.hit) AS t_hits, SUM(hits_data.AB) AS t_AB;
hit_list = FOREACH temp GENERATE player, t_hits, t_AB;
-- load fielding details
fielding = LOAD 'hdfs:/user/maria_dev/pigtest/Fielding.csv' using PigStorage(',');
-- remove rows
filtered_team = FILTER fielding BY $2 != '';
filtered_low = FILTER filtered_team BY $1>2004;
filtered_high = FILTER filtered_low BY $1<2010;
filtered_null = FILTER filtered_high BY NOT ($6 == '' AND $7 == '' AND $8 == '' AND $9 == '' AND $10 == '' AND $11 == '' AND $12 == '' AND $13 == '' AND
	$14 == '' AND $15 == '' AND $16 == '');
error_data = FOREACH filtered_null GENERATE $0 AS player, $5 AS games, $10 AS errors;
-- group by player
by_player = GROUP error_data BY player;
-- sum games and errors
temp = FOREACH by_player GENERATE group as player, SUM(error_data.errors) as t_errors, SUM(error_data.games) as t_games;
error_list = FOREACH temp GENERATE player, t_errors, t_games;
-- join hit and error list
joined = JOIN hit_list BY player, error_list BY player;
-- filter by AB and games
filtered_AB = FILTER joined BY t_AB > 39;
filtered_games = FILTER filtered_AB by t_games > 19;
hit_error_data = FOREACH filtered_games GENERATE $0 AS player, $1 AS t_hits, $2 AS t_AB, $4 AS t_errors, $5 AS t_games, $1/$2 - $4/$5 AS score;
-- Order
order_scores = ORDER hit_error_data BY score DESC;
top_3 = LIMIT order_scores 3;
winners = FOREACH top_3 GENERATE player; 

-- DESCRIBE winners;
DUMP winners;

