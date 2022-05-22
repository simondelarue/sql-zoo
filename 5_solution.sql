-- 1. Show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player 
FROM goal
    WHERE teamid = 'GER'

-- 2. Show id, stadium, team1, team2 for just game 1012
SELECT id, stadium, team1, team2
FROM game
    WHERE id = 1012

-- 3. Show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
FROM goal
JOIN game
    ON goal.matchid = game.id
    WHERE teamid = 'GER'

-- 4. Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM goal
JOIN game
    ON goal.matchid = game.id
    WHERE player LIKE 'Mario%'

-- 5. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM eteam
JOIN goal
    ON eteam.id = goal.teamid
    WHERE gtime <= 10

-- 6. List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM eteam
JOIN game
    ON eteam.id = game.team1
    WHERE coach = 'Fernando Santos'

-- 7. List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal
JOIN game
    ON goal.matchid = game.id
    AND stadium = 'National Stadium, Warsaw'

-- 8. Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
FROM goal
JOIN game
    ON goal.matchid = game.id
    AND goal.teamid <> 'GER' AND (game.team1 = 'GER' OR game.team2 = 'GER')

-- 9. Show teamname and the total number of goals scored.
SELECT teamname, total_goals
FROM eteam
JOIN (
    SELECT teamid, COUNT(player) as total_goals
    FROM goal
    GROUP BY teamid
) goals 
    ON eteam.id = goals.teamid

-- 10. Show the stadium and the number of goals scored in each stadium. 
SELECT stadium, COUNT(player) as total_goals
FROM game
JOIN goal
    ON game.id = goal.matchid
GROUP BY stadium

-- 11. For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(player) as total_goals
FROM game
JOIN goal
    ON game.id = goal.matchid
    AND (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

-- 12. For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(player) as total_goals
FROM game
JOIN goal
    ON game.id = goal.matchid
    AND goal.teamid = 'GER'
GROUP BY matchid, mdate

-- 13. List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
SELECT 
    mdate
    ,team1
    ,SUM(CASE WHEN team1 = teamid THEN 1 ELSE 0 END) score1
    ,team2
    ,SUM(CASE WHEN team2 = teamid THEN 1 ELSE 0 END) score1
FROM game
JOIN goal
    ON game.id = goal.matchid
GROUP BY
    mdate
    ,team1
    ,team2
ORDER BY
    mdate
    ,team1
    ,team2