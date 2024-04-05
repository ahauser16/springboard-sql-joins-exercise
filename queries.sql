-- $ psql joins_exercise
--before starting the practice problems, keep in mind that `owner_id INTEGER REFERENCES owners (id)` creates a column named `owner_id` with a data type of `INTEGER`. The `REFERENCES owners (id)` part establishes a foreign key relationship with the owners table. It means that each value in the `owner_id` column MUST correspond to a value in the `id` column of the owners table. This links each vehicle to an owner.

​--query number one: Write the following SQL commands to produce the necessary output that joins the two tables so that every column and record appears, regardless of if there is not an owner_id.

--note:The LEFT JOIN keyword returns all records from the left table (owners), and the matched records from the right table (vehicles). The result is NULL on the right side, if there is no match.

SELECT *
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id;

--query number two: Count the number of cars for each owner. Display the owners first_name , last_name and count of vehicles. The first_name should be ordered in ascending order.

--NOTE: This command will join the 'owners' and 'vehicles' tables on the 'id' field of 'owners' and 'owner_id' field of 'vehicles'. It then groups the results by the 'first_name' and 'last_name' fields of 'owners' and counts the number of 'id' fields in 'vehicles' for each group. The result is a list of owners with the count of their vehicles.

SELECT owners.first_name, owners.last_name, COUNT(vehicles.id) as vehicle_count
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id
GROUP BY owners.first_name, owners.last_name;

--query number three: Count the number of cars for each owner and display the average price for each of the cars as integers. Display the owners first_name, last_name, average price and count of vehicles. The first_name should be ordered in descending order. Only display results with more than one vehicle and an average price greater than 10000.

--NOTE: This command will join the 'owners' and 'vehicles' tables on the 'id' field of 'owners' and 'owner_id' field of 'vehicles'. It then groups the results by the 'first_name' and 'last_name' fields of 'owners' and calculates the average price of the 'price' field in 'vehicles' for each group. It also counts the number of 'id' fields in 'vehicles' for each group. The HAVING clause filters the results to only include groups with more than one vehicle and an average price greater than 10000. The result is a list of owners with the average price and count of their vehicles, sorted by 'first_name' in descending order.

SELECT owners.first_name, owners.last_name, CAST(AVG(vehicles.price) AS INTEGER) as average_price, COUNT(vehicles.id) as vehicle_count
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id
GROUP BY owners.first_name, owners.last_name
HAVING COUNT(vehicles.id) > 1 AND AVG(vehicles.price) > 10000
ORDER BY owners.first_name DESC;

--PART TWO: SQL ZOO - TUTORIAL NUMBER 6

-- QUESTION 1 -> The first example shows the goal scored by a player with the last name 'Bender'. The * says to list all the columns in the table - a shorter way of saying matchid, teamid, player, gtime
-- Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'

SELECT matchid, player FROM goal WHERE teamid = 'GER';

-- QUESTION 2 -> From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.  Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
--Show id, stadium, team1, team2 for just game 1012

SELECT id,stadium,team1,team2 FROM game WHERE id = 1012;

-- QUESTION 3 -> You can combine the two steps into a single query with a JOIN.

SELECT goal.player, goal.teamid, game.stadium, game.mdate
FROM game
JOIN goal ON game.id = goal.matchid
WHERE goal.teamid = 'GER';

-- QUESTION 4 -> Use the same JOIN as in the previous question.  Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'.ABORT

SELECT game.team1, game.team2, goal.player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE goal.player LIKE 'Mario%';

-- QUESTION 5 -> The table eteam gives details of every national team including the coach. You can JOIN goal to eteam using the column teamid from goal and id from eteam. Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10

SELECT goal.player, goal.teamid, eteam.coach, goal.gtime
FROM goal 
JOIN eteam on goal.teamid = eteam.id
WHERE gtime<=10;

-- QUESTION 6 -> To JOIN game with eteam you could use either game JOIN eteam ON (team1=eteam.id) or game JOIN eteam ON (team2=eteam.id).  Notice that because id is a column name in both game and eteam you must specify eteam.id instead of just id.  List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.

SELECT game.mdate, eteam.teamname
FROM game
JOIN eteam ON game.team1 = eteam.id
WHERE eteam.coach = 'Fernando Santos';

-- QUESTION 7 -> List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT goal.player 
FROM goal
JOIN game on goal.matchid = game.id
WHERE stadium = 'National Stadium, Warsaw';

-- QUESTION 8 -> The example query shows all goals scored in the Germany-Greece quarterfinal. Instead show the name of all players who scored a goal against Germany.  Select goals scored only by non-German players in matches where GER was the id of either team1 or team2.  You can use teamid!='GER' to prevent listing German players.  You can use DISTINCT to stop players being listed twice.

SELECT DISTINCT goal.player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE (game.team1='GER' OR game.team2='GER') AND goal.teamid != 'GER';

-- QUESTION 9 -> Show teamname and the total number of goals scored.  You should COUNT(*) in the SELECT line and GROUP BY teamname.

SELECT eteam.teamname, COUNT(goal.player) as total_goals
FROM eteam
JOIN goal ON eteam.id = goal.teamid
GROUP BY eteam.teamname
ORDER BY eteam.teamname;

-- QUESTION 10 -> Show the stadium and the number of goals scored in each stadium.  You should COUNT(*) in the SELECT line and GROUP BY stadium.

SELECT game.stadium, COUNT(goal.matchid) as total_goals
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY game.stadium;

-- QUESTION 11 -> For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT goal.matchid, game.mdate, COUNT(goal.gtime) as total_goals
FROM game
JOIN goal ON game.id = goal.matchid
WHERE (game.team1 = 'POL' OR game.team2 = 'POL')
GROUP BY game.id, game.mdate;

-- QUESTION 12 -> For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'

SELECT goal.matchid, game.mdate, COUNT(goal.gtime) as total_goals
FROM game
JOIN goal ON game.id = goal.matchid
WHERE goal.teamid = 'GER'
GROUP BY game.id, game.mdate;

-- QUESTION 13 -> List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.

SELECT game.mdate, game.team1, 
       SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) as score1, 
       game.team2, 
       SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) as score2
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY game.mdate, game.team1, game.team2
ORDER BY game.mdate, game.id, game.team1, game.team2;

--TUTORIAL 7 MORE JOINS