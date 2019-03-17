DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting
(id STRING, year INT, team STRING, league STRING, games INT, ab INT, runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT, ibb INT,
hbp INT, sh INT, sf INT, gidp INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/batting' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master
(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, fname STRING, lname STRING,
name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, finalgame STRING, retro STRING, bbref STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/master' tblproperties ("skip.header.line.count"="1");


SELECT ranked.month_state FROM
  (SELECT *, rank() OVER (ORDER BY joined.score) AS rnk FROM	
	  (SELECT month.bmonth, month.bstate, CONCAT(month.bmonth, '/', month.bstate) AS month_state, COUNT(player.id) AS p_count, SUM(player.hits) AS hits,
	   SUM(player.ab)AS ab,  SUM(player.hits) / SUM(player.ab) AS score FROM
		  (SELECT b.id, SUM(b.hits) AS hits, SUM(b.ab) AS ab FROM batting AS b
		  GROUP BY b.id
		  ) as player,

		  (SELECT m.id, m.bmonth, m.bstate FROM master AS m
		  ) AS month
	  WHERE player.id = month.id
	  GROUP BY month.bmonth, month.bstate, CONCAT(month.bmonth, '/', month.bstate)
	  ) AS joined
	  WHERE joined.bmonth IS NOT NULL
	  AND joined.bstate !=''
	  AND joined.p_count >=5
	  AND joined.AB > 100
  ) AS ranked
WHERE ranked.rnk = 1
;
