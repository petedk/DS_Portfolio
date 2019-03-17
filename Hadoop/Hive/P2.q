DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master
(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, fname STRING, lname STRING,
name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, finalgame STRING, retro STRING, bbref STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/master' tblproperties ("skip.header.line.count"="1");

-- result
SELECT ranked.combined FROM
   -- RANK results  
  (SELECT *, rank() OVER (ORDER BY c.ct DESC) as rnk FROM
	-- get counts
   (SELECT players.combined, COUNT(players.combined) AS ct FROM
	-- get player details 
	 (SELECT m.id, m.bmonth, m.bday, CONCAT(m.bmonth,'/',m.bday) as combined from master as m
	  WHERE m.bday != 0
	  ) as players
	GROUP BY players.combined
	) AS c
  ) AS ranked
WHERE ranked.rnk <= 3
; 