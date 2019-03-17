DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding
(id STRING, year INT, team STRING, league STRING, pos STRING, G INT, GS INT, innOuts  INT, PO INT, A INT, E INT, DP INT, PB INT, WP INT, SB INT, CS INT, ZR INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding' tblproperties ("skip.header.line.count"="1");

-- result
SELECT ranked.id from
  -- rank results
  (SELECT *, rank() OVER (ORDER BY e.errors DESC) AS rnk FROM
	 -- get errors 
	(SELECT f.id, SUM(f.E) AS errors from fielding AS f
	GROUP BY f.id) AS e
  ) as ranked
WHERE ranked.rnk = 1
; 