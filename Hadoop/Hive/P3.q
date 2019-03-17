DROP TABLE IF EXISTS master;
CREATE EXTERNAL TABLE IF NOT EXISTS master
(id STRING, byear INT, bmonth INT, bday INT, bcountry STRING, bstate STRING, bcity STRING, dyear INT, dmonth INT, dday INT, dcountry STRING, dstate STRING, dcity STRING, fname STRING, lname STRING,
name STRING, weight INT, height INT, bats STRING, throws STRING, debut STRING, finalgame STRING, retro STRING, bbref STRING) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/master' tblproperties ("skip.header.line.count"="1");

-- get result = 2
SELECT ranked.weight FROM
  -- rank result
  (SELECT *, rank() OVER (ORDER BY w.ct DESC) as rnk FROM
	-- weight infor
	(SELECT m.weight, count(m.weight) as ct from master AS m
	WHERE m.weight > 1
	GROUP BY m.weight) as w
  ) as ranked
  where ranked.rnk = 2
   ;