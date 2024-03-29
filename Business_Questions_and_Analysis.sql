use epl_players;


################
## Question 1 ##
################
# 1)	How many players were from England (gb-eng)?
SELECT COUNT(P.PLAYER_ID) AS NumberOfEnglishPlayers, COUNT(P.PLAYER_ID) / (SELECT COUNT(*) FROM PLAYER) AS ProportionOfEnglishPlayers
FROM PLAYER P
JOIN NATIONALITY N ON P.NATIONALITY_ID = N.NATIONALITY_ID
WHERE N.NATIONALITY_NAME = 'GB-ENG';


################
## Question 2 ##
################
# 2)	What is the distribution of player nationalities within the league?
SELECT N.NATIONALITY_NAME, COUNT(P.PLAYER_ID) AS NUMBEROFPLAYERS
FROM PLAYER P
JOIN NATIONALITY N ON P.NATIONALITY_ID = N.NATIONALITY_ID
GROUP BY N.NATIONALITY_NAME
ORDER BY NUMBEROFPLAYERS DESC;

################
## Question 3 ##
################
# 3)	Is there a correlation between heights and the primary position played by players?
SELECT POS.POSITION_NAME, AVG(PLAYER.HEIGHT) AS AVERAGEHEIGHT, STDDEV_POP(PLAYER.HEIGHT) AS STDDEVHEIGHT
FROM PLAYER
JOIN PLAYER_POSITION POS ON PLAYER.POSITION_ID = POS.POSITION_ID
GROUP BY POS.POSITION_NAME
ORDER BY AVERAGEHEIGHT DESC;


################
## Question 4 ##
################
# 4)	Were there any players who went out on loan/transferred to another team during the season?
SELECT P.PLAYER_NAME , T.TEAM_NAME AS TEAMNAME
FROM PLAYER P
JOIN TEAM T ON P.TEAM_ID = T.TEAM_ID
WHERE P.PLAYER_ID IN (SELECT PLAYER_ID FROM PLAYER
		GROUP BY PLAYER_ID
		HAVING COUNT(PLAYER_ID) > 1)
ORDER BY P.PLAYER_NAME;

################
## Question 5 ##
################
# 5)	Who leads the league in successful dribbles and what is their primary position?
SELECT P.PLAYER_NAME, POS.POSITION_NAME, MAX(OFP.DRIBBLES_WON) AS MAXDRIBBLES
FROM PLAYER P
JOIN OUTFIELD_PLAYER OFP ON P.PLAYER_ID = OFP.PLAYER_ID
JOIN PLAYER_POSITION POS ON P.POSITION_ID = POS.POSITION_ID
GROUP BY P.PLAYER_NAME, POS.POSITION_NAME
ORDER BY MAXDRIBBLES DESC
LIMIT 1;

################
## Question 6 ##
################
# 6)	Who were the top 5 most creative players in the league?
SELECT PLAYER_NAME, SUM(CREATIVEACTIONS) AS TOTALCREATIVEACTIONS
FROM ( SELECT P.PLAYER_NAME, OP.ASSISTS AS CREATIVEACTIONS
    FROM PLAYER P
    JOIN OUTFIELD_PLAYER OP ON P.PLAYER_ID = OP.PLAYER_ID
    UNION ALL
    SELECT P.PLAYER_NAME, OP.KEY_PASSES AS CREATIVEACTIONS
    FROM PLAYER P
    JOIN OUTFIELD_PLAYER OP ON P.PLAYER_ID = OP.PLAYER_ID) AS COMBINED
GROUP BY PLAYER_NAME
ORDER BY TOTALCREATIVEACTIONS DESC
LIMIT 5;


################
## Question 7 ##
################
# 7)	What are the average ages of different positions?
SELECT POS.POSITION_NAME, AVG(P.AGE) AS AVERAGEAGE
FROM PLAYER P
JOIN PLAYER_POSITION POS ON P.POSITION_ID = POS.POSITION_ID
GROUP BY POS.POSITION_NAME;

################
## Question 8 ##
################
# 8)	Which goalkeepers are better at saving long range shots compared to short range shots and vice versa?
SELECT P.PLAYER_NAME AS GOALKEEPERNAME, GK.INSIDE_BOX_SAVES, GK.OUTSIDE_BOX_SAVES,
    CASE
        WHEN GK.INSIDE_BOX_SAVES > GK.OUTSIDE_BOX_SAVES THEN 'Better at Inside Box Saves'
        WHEN GK.OUTSIDE_BOX_SAVES > GK.INSIDE_BOX_SAVES THEN 'Better at Outside Box Saves'
        ELSE 'Equally Skilled'
    END AS STRENGTH
FROM PLAYER P
JOIN GOALKEEPER GK ON P.PLAYER_ID = GK.PLAYER_ID;


################
## Question 9 ##
################
# 9)	Using some of the results obtained above, which players would be part of the Team of the Season?
SELECT SQ.TEAM_NAME, SQ.PLAYERNAME, SQ.POSITION_NAME, SQ.RATING, SQ.GOALS, SQ.ASSISTS
FROM (SELECT TEAM.TEAM_NAME, PLAYER.PLAYER_NAME AS PLAYERNAME, POS.POSITION_NAME, 
		COALESCE(OUTFIELD_PLAYER.RATING, GOALKEEPER.RATING) AS RATING,
		OUTFIELD_PLAYER.GOALS,
		OUTFIELD_PLAYER.ASSISTS,
		ROW_NUMBER() OVER (PARTITION BY POS.POSITION_NAME ORDER BY 
			CASE 
				WHEN POS.POSITION_NAME = 'FORWARD' THEN OUTFIELD_PLAYER.GOALS>=18 AND OUTFIELD_PLAYER.ASSISTS>=5   
				WHEN POS.POSITION_NAME = 'MIDFIELDER' THEN OUTFIELD_PLAYER.ASSISTS AND KEY_PASSES >= 2.5
				ELSE COALESCE(OUTFIELD_PLAYER.RATING, GOALKEEPER.RATING) 
			END DESC) AS RN
		FROM PLAYER
		JOIN TEAM ON PLAYER.TEAM_ID = TEAM.TEAM_ID
        JOIN PLAYER_POSITION POS ON PLAYER.POSITION_ID = POS.POSITION_ID
        LEFT JOIN OUTFIELD_PLAYER ON PLAYER.PLAYER_ID = OUTFIELD_PLAYER.PLAYER_ID
        LEFT JOIN GOALKEEPER ON PLAYER.PLAYER_ID = GOALKEEPER.PLAYER_ID) AS SQ
	WHERE 
    (SQ.POSITION_NAME = 'GOALKEEPER' AND SQ.RN = 1) OR
    (SQ.POSITION_NAME = 'DEFENDER' AND SQ.RN <= 4) OR
    (SQ.POSITION_NAME = 'MIDFIELDER' AND SQ.RN <= 3) OR
    (SQ.POSITION_NAME = 'FORWARD' AND SQ.RN <= 3)
ORDER BY SQ.POSITION_NAME, 
  CASE 
    WHEN SQ.POSITION_NAME = 'FORWARD' THEN SQ.GOALS 
    WHEN SQ.POSITION_NAME = 'MIDFIELDER' THEN SQ.ASSISTS 
    ELSE SQ.RATING 
  END DESC;