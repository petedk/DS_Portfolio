-- load batter details
master = LOAD 'hdfs:/user/maria_dev/pigtest/Master.csv' using PigStorage(',');
-- filter data
filtered = FILTER master BY $17 > 0;
-- temp file for batter info
batter_details = FOREACH filtered GENERATE $0 AS id, CONCAT($13,' ', $14) AS name ,$17 AS height;
-- group by height
by_height = GROUP batter_details by height;
-- count players
count_player = FOREACH by_height GENERATE batter_details.name AS name , COUNT(batter_details.height) as height_count;
-- limit to group of 1
odd_players = FILTER count_player BY height_count == 1;

results = FOREACH odd_players GENERATE FLATTEN(name.name);
-- DESCRIBE results;
DUMP results;



