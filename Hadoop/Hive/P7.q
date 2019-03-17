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

-- result
SELECT ranked.city_state from
  -- rank results
  (SELECT *, rank() OVER (ORDER BY joined.score DESC) as rnk FROM
     -- join city and player
     (SELECT city.city_state, SUM(player.dbl) as dbl, SUM(player.trip) as trip , SUM(player.score) as score FROM
        -- get city details
        (SELECT m.id, m.bcity, m.bstate, CONCAT(m.bcity,'/',m.bstate) as city_state FROM master AS m
          WHERE m.bcity != ''
          AND m.bstate !=''
          GROUP BY m.id, m.bcity, m.bstate, CONCAT(m.bcity,'/',m.bstate) 
        ) AS city, 
	    -- get player details
        (SELECT b.id, SUM(b.doubles) AS dbl, SUM(b.triples) AS trip, (SUM(b.doubles) + SUM(b.triples))AS score FROM batting AS b
          GROUP BY b.id 
        ) AS player 
	 WHERE city.id = player.id
	 GROUP BY city.city_state
    ) AS joined 
  ) AS ranked
WHERE rnk <= 5
;












