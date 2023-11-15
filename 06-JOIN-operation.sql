/*
This tutorial introduces JOIN which allows you to use data from two or more tables.
https://sqlzoo.net/wiki/The_JOIN_operation

understanding different types of joins:
https://www.youtube.com/watch?v=zGSv0VaOtR0&ab_channel=JomaClass
*/

--#1
/*
  Show the matchid and player name for all goals scored by Germany.
*/

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'


--#2
/*
  Show id, stadium, team1, team2 for just game 1012
*/

SELECT team1, team2 FROM game
WHERE id = 1012


--#3
/*
  Show the player, teamid, stadium and mdate for every German goal
*/

SELECT player, teamid, stadium, mdate
FROM game game JOIN goal goal ON (game.id = goal.matchid)
WHERE teamid = 'GER'


--#4
/*
  Show the team1, team2 and player for every goal scored by a player called Mario.
*/

SELECT team1, team2, player
FROM game JOIN goal ON (id = matchid)
WHERE player LIKE 'Mario%'


--#5
/*
  Show player, teamid, coach, gtime for all goals scored in the first 10 minute
*/

SELECT player, teamid, coach, gtime
FROM goal JOIN eteam ON teamid = id
WHERE gtime <= 10


--#6
/*
  List the dates of the matches and the name of the team
  in which 'Fernando Santos' was the team1 coach.
*/

SELECT mdate, teamname
FROM eteam JOIN game ON eteam.id = game.team1
WHERE coach = 'Fernando Santos'


--#7
/*
  List the player for every goal scored in a game
  where the stadium was 'National Stadium, Warsaw'
*/

SELECT player
FROM goal JOIN game ON matchid = id
WHERE stadium = 'National Stadium, Warsaw'


--#8
/*
  Show the name of all players who scored a goal against Germany.
*/

SELECT DISTINCT player
FROM game JOIN goal ON matchid = id
WHERE
  'GER' IN (team1, team2) AND
  teamid <> 'GER'


--#9
/*
  Show teamname and the total number of goals scored.
*/

SELECT teamname, COUNT(*) AS goals
FROM eteam JOIN goal ON teamid = id
GROUP BY teamname


--#10
/*
  Show the stadium and the number of goals scored in each stadium.
*/

SELECT stadium, COUNT(*) AS goals
FROM game JOIN goal ON matchid = id
GROUP BY stadium


--#11
/*
  For every match involving 'POL', show the matchid, date and the number of goals scored.
*/

SELECT matchid, mdate, COUNT(*) AS goals
FROM game JOIN goal ON matchid = id
WHERE 'POl' IN (team1, team2)
GROUP BY matchid


--#12
/*
  For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
*/

SELECT matchid, mdate, COUNT(*) AS 'goals by germany'
FROM game JOIN goal ON (matchid = id AND teamid = 'GER')
GROUP BY matchid


--#13
/*
  List every match with the goals scored by each team as shown:
  mdate         | team1 | score1 | team2 | score2
  --------------|-------|--------|-------|-------
  1 July 2012   | ESP   | 4      | ITA   | 0
  10 June 2012  | ESP   | 1      | ITA   | 1
  10 June 2012  | IRL   | 1      | CRO   | 3
  
  Sort your result by mdate, matchid, team1 and team2
  CASE WHEN: https://sqlzoo.net/wiki/CASE
*/

SELECT
  mdate,
  team1,
  SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
  team2,
  SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game LEFT JOIN goal ON matchid = id
GROUP BY id
ORDER BY mdate, matchid, team1, team2


--#14
/*
  question: https://leetcode.com/problems/game-play-analysis-iv/
*/

SELECT ROUND(1. * COUNT(*) / (SELECT COUNT(DISTINCT player_id) FROM activity), 2) AS fraction
FROM activity
WHERE (player_id, event_date) IN (
  SELECT
    player_id, (MIN(event_date) + INTERVAL '1 day') AS next_day
  FROM activity
  GROUP BY player_id
)


--15
/*
  question: https://leetcode.com/problems/trips-and-users/
*/

SELECT
  request_at AS "Day",
  ROUND(1. * SUM(CASE WHEN status <> 'completed' THEN 1 ELSE 0 END) /
        COUNT(*),
  2) AS "Cancellation Rate"
FROM trips
WHERE
  'No' = ALL (SELECT banned FROM users WHERE users_id IN (client_id, driver_id)) AND
  request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY "Day"

-- another solution
SELECT
  request_at AS "Day",
  ROUND(1. * SUM(CASE WHEN status <> 'completed' THEN 1 ELSE 0 END) /
      COUNT(*),
  2) AS "Cancellation Rate"
FROM trips
JOIN users client ON client.users_id = trips.client_id
JOIN users driver ON driver.users_id = trips.driver_id
WHERE
  request_at BETWEEN '2013-10-01' AND '2013-10-03' AND
  client.banned = 'No' AND driver.banned = 'No'
GROUP BY "Day"