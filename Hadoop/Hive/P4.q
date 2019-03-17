DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding
(id STRING, year INT, team STRING, league STRING, pos STRING, G INT, GS INT, innOuts  INT, PO INT, A INT, E INT, DP INT, PB INT, WP INT, SB INT, CS INT, ZR INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding' tblproperties ("skip.header.line.count"="1");

-- result
SELECT ranked.team from
  -- rank results
  (SELECT *, rank() OVER (ORDER BY e.errors DESC) as rnk FROM
	 -- get errors 
	(SELECT f.team, f.year, SUM(f.E) AS errors from fielding as f
	WHERE f.year = 2001
	GROUP BY f.team, f.year) AS e
  ) as ranked
WHERE ranked.rnk = 1
; 