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

--note: the sql statement below produces a table that is missing two rows (compared to SQLZOO's answser) because of the INNER JOIN in the SQL statement. An INNER JOIN only returns rows where there is a match in both tables. In this case, if a game has no corresponding goals in the 'goal' table (i.e., a game ended with a score of 0-0), it will not be included in the result set.

SELECT game.mdate, game.team1, 
       SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END) as score1, 
       game.team2, 
       SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END) as score2
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY game.mdate, game.team1, game.team2
ORDER BY game.mdate, game.id, game.team1, game.team2;

--To include games that ended with a score of 0-0, you should use a LEFT JOIN instead. This type of join returns all the rows from the 'game' table, and the matched rows from the 'goal' table. If there is no match, the result is NULL on the 'goal' side.

SELECT game.mdate, game.team1, 
       COALESCE(SUM(CASE WHEN goal.teamid = game.team1 THEN 1 ELSE 0 END), 0) as score1, 
       game.team2, 
       COALESCE(SUM(CASE WHEN goal.teamid = game.team2 THEN 1 ELSE 0 END), 0) as score2
FROM game
LEFT JOIN goal ON game.id = goal.matchid
GROUP BY game.mdate, game.team1, game.team2
ORDER BY game.mdate, game.id, game.team1, game.team2;

--note: The COALESCE function is used to handle NULL values that may result from the LEFT JOIN. It returns the first non-NULL value in the list. In this case, if the SUM function returns NULL (which means there were no goals for a team in a particular game), COALESCE will return 0.

--TUTORIAL 7 MORE JOINS

--1. List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962;

--2. Give year of 'Citizen Kane'.
SELECT yr
 FROM movie
 WHERE title='Citizen Kane';

--3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.

SELECT id, title, yr
 FROM movie
 WHERE title like '%star% %trek%'
order by yr;

--4. What id number does the actor 'Glenn Close' have?

select id from actor where name = 'Glenn Close';

--5. What is the id of the film 'Casablanca'
select id from movie where title = 'Casablanca';

--6. Obtain the cast list for 'Casablanca'.  what is a cast list?  The cast list is the names of the actors who were in the movie.  Use movieid=11768, (or whatever value you got from the previous question).  Submit SQLrestore default.

SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Casablanca';

--note: how to methodically solve this problem:

--step one: Identify the tables you need to join. In this case, you need data from the movie, actor, and casting tables.
------(a)  The movie table contains information about movies, including their titles. You need this table to find the movie 'Casablanca'.
------(b)  The actor table contains information about actors, including their names. You need this table to get the names of the actors.
------(c)  However, neither of these tables directly links movies to actors. This is where the casting table comes in. It serves as a bridge between the movie and actor tables, linking them via the movieid and actorid fields.

--step two: Identify the common keys between the tables. The `movie` table and the `casting` table can be joined on `movie.id` and `casting.movieid`. The `actor` table and the `casting` table can be joined on `actor.id` and `casting.actorid`.  Keep in mind that the casting table is an example of a "junction table" or "bridge table". It connects two other tables in a many-to-many relationship.

--step three: Identify the fields you need in your final result. You need the `name` field from the `actor` table.

--step four: Construct the SQL statement. Start with the `SELECT` clause, then add the `FROM` clause with the necessary `JOIN` operations, and finally add the `WHERE` clause to filter for 'Casablanca'.

SELECT actor.name
FROM actor
JOIN casting ON actor.id = casting.actorid
JOIN movie ON casting.movieid = movie.id
WHERE movie.title = 'Casablanca';

--note on optimization: The performance of a SQL query can depend on a variety of factors, including the database management system (DBMS), the size of the tables, the distribution of data, the indexes available, and the specific implementation of the JOIN operation.

-- In general, starting the JOIN operation with the table that reduces the result set the most can improve performance. This is because fewer rows need to be processed in subsequent operations.

-- In your case, if there are many more rows in the actor table than in the movie table, and only a few of them are in 'Casablanca', starting with the movie table might be more efficient. This is because the WHERE clause can filter out the rows not related to 'Casablanca' early in the process.

-- On the other hand, if there are many more rows in the movie table than in the actor table, and most actors are in 'Casablanca', starting with the actor table might be more efficient.

-- However, modern DBMSs have query optimizers that can rearrange the operations in a query to achieve the most efficient execution plan, regardless of the order in which you write the JOIN operations. So, in practice, the order of tables in your query might not significantly affect performance.

-- To truly determine which query is more performant, you would need to run both queries on your specific DBMS and measure the execution time and resource usage.

--7. Obtain the cast list for the film 'Alien'

SELECT actor.name
FROM actor
JOIN casting ON actor.id = casting.actorid
JOIN movie ON casting.movieid = movie.id
WHERE movie.title = 'Alien';

-- or 

SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.title = 'Alien';

--8. List the films in which 'Harrison Ford' has appeared

SELECT movie.title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford';

--9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

SELECT movie.title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE actor.name = 'Harrison Ford' and ord <> 1;

--10. List the films together with the leading star for all 1962 films.

SELECT movie.title, actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.yr = 1962 and casting.ord = 1;

--11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

SELECT yr, COUNT(movie.title) 
FROM movie 
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

--12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.

SELECT movie.title, actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE casting.ord = 1 AND movie.id IN (
    SELECT movie.id
    FROM movie
    JOIN casting ON movie.id = casting.movieid
    JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Julie Andrews'
);

--note: the subquery SELECT movie.id FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON casting.actorid = actor.id WHERE actor.name = 'Julie Andrews' gets the IDs of all movies in which 'Julie Andrews' appeared. The IN operator in the main query then checks if a movie's ID is in this list of IDs. If it is, the main query retrieves the title of the movie and the name of the leading actor (where casting.ord = 1).

--13. Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.

SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING COUNT(casting.movieid) >= 15
ORDER BY actor.name ASC;

--14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

SELECT movie.title, COUNT(casting.actorid) as num_actors
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY num_actors DESC, movie.title ASC;

--15. List all the people who have worked with 'Art Garfunkel'.

--note: In this query, the subquery "SELECT movie.id FROM movie JOIN casting ON movie.id = casting.movieid JOIN actor ON casting.actorid = actor.id WHERE actor.name = 'Art Garfunkel'" gets the IDs of all movies in which 'Art Garfunkel' appeared. The 'IN' operator in the main query then checks if a movie's ID is in this list of IDs. If it is, the main query retrieves the names of all actors in that movie. The final condition "actor.name != 'Art Garfunkel'"" ensures that 'Art Garfunkel' is not included in the list of people who have worked with him.

SELECT actor.name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor ON casting.actorid = actor.id
WHERE movie.id IN (
    SELECT movie.id
    FROM movie
    JOIN casting ON movie.id = casting.movieid
    JOIN actor ON casting.actorid = actor.id
    WHERE actor.name = 'Art Garfunkel'
) AND actor.name != 'Art Garfunkel';