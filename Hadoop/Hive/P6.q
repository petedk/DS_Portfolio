DROP TABLE IF EXISTS batting;
CREATE EXTERNAL TABLE IF NOT EXISTS batting
(id STRING, year INT, team STRING, league STRING, games INT, ab INT, runs INT, hits INT, doubles INT, triples INT, homeruns INT, rbi INT, sb INT, cs INT, walks INT, strikeouts INT, ibb INT,
hbp INT, sh INT, sf INT, gidp INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/batting' tblproperties ("skip.header.line.count"="1");

DROP TABLE IF EXISTS fielding;
CREATE EXTERNAL TABLE IF NOT EXISTS fielding
(id STRING, year INT, team STRING, league STRING, pos STRING, G INT, GS INT, innOuts  INT, PO INT, A INT, E INT, DP INT, PB INT, WP INT, SB INT, CS INT, ZR INT) 
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' LOCATION '/user/maria_dev/hivetest/fielding' tblproperties ("skip.header.line.count"="1");


-- result
SELECT ranked.id from
  -- rank results
  (SELECT *, rank() OVER (ORDER BY joined.score DESC) AS rnk FROM
	
    (SELECT bat.id, bat.h, bat.atbat, field.errors, field.games, ((bat.h/bat.atbat) - (field.errors/field.games)) AS score from      
          (SELECT b.id, SUM(b.hits) AS h, SUM(b.ab) AS atbat  FROM batting AS b
          WHERE b.year >= 2005
          AND b.year <= 2009
          GROUP BY b.id
          ) AS bat,
      
          (SELECT f.id,  SUM(f.E) AS errors, SUM(f.G) AS games FROM fielding as f
          WHERE f.year >= 2005
          AND f.year <= 2009
          AND coalesce(f.GS, f.innOuts, f.PO, f.A, f.E, f.DP, f.PB, f.WP, f.SB, f.CS, f.ZR) IS NOT NULL
          GROUP BY f.id
          ) AS field
	 
    WHERE bat.id = field.id
	AND bat.atbat >= 40
	AND field.games >= 20	      
    ) AS joined
 ) AS ranked
WHERE ranked.rnk <= 3 
;




