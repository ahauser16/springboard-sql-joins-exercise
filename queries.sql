-- $ psql joins_exercise
​--Write the following SQL commands to produce the necessary output that joins the two tables so that every column and record appears, regardless of if there is not an owner_id.

--note:The LEFT JOIN keyword returns all records from the left table (owners), and the matched records from the right table (vehicles). The result is NULL on the right side, if there is no match.

SELECT *
FROM owners
LEFT JOIN vehicles
ON owners.id = vehicles.owner_id;

--Count the number of cars for each owner. Display the owners first_name , last_name and count of vehicles. The first_name should be ordered in ascending order.