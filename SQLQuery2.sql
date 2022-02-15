
SELECT *
FROM cyclist..[2019_q1]


SELECT (tripduration/3600) as ride_time_hours, start_time, end_time, from_station_name, to_station_name, usertype
FROM cyclist..[2019_q1]
order by tripduration desc


-- station where  most rides started from (can be used to store more bikes)
SELECT from_station_name, COUNT(from_station_name) as occurance
FROM cyclist..[2019_q1]
Group by from_station_name
order by occurance desc


-- Which gender used the bike more
SELECT gender, usertype, count(usertype) as number_of_users
FROM cyclist..[2019_q1]
WHERE gender is not null 
Group by gender, usertype
ORDER bY number_of_users DESC


--average ridetime per day of the week
SELECT day_of_week, avg(tripduration/60) as avg_ride_time_mins, usertype
FROM cyclist..[2019_q1]
GROUP BY day_of_week, usertype
ORDER BY avg_ride_time_mins desc


--busiest day of the week
SELECT day_of_week, COUNT(trip_id) as number_of_trips--, usertype
FROM cyclist..[2019_q1]
GROUP BY day_of_week--, usertype
ORDER BY number_of_trips desc


-- average ride time for subscriber v/s customer
SELECT avg(tripduration) as avg_tripduration, usertype
FROM cyclist..[2019_q1]
Group by usertype
order by avg_tripduration desc


-- total ride time for subscriber v/s customer
SELECT ROUND(SUM(tripduration/3600), 2) as total_trip_duration_hrs, usertype
FROM cyclist..[2019_q1]
GROUP BY usertype
ORDER BY total_trip_duration_hrs desc


-- subscriber v/s customer on weekends avg ridetime on weekends
SELECT avg(tripduration/60) as avg_ride_time_mins, usertype
FROM cyclist..[2019_q1]
WHERE day_of_week = 1  or day_of_week = 7 
GROUP BY usertype
ORDER BY avg_ride_time_mins desc
-- from this result it is possible that the customers mostly use bikes on weekends as a means of leisure


-- subscriber v/s customer number of rides on weekends
SELECT count(usertype) as instances, usertype, gender
FROM cyclist..[2019_q1]
WHERE day_of_week = 1  or day_of_week = 7 
GROUP BY usertype, gender
ORDER BY instances desc

-- NOTE:
--WE COULD DO THE SAME CALCULATIONS FOR THE REST OF THE QUARTERS INDIVIDUALLY, BUT I HAVE ALREADY PERFORMED THEM ON EXCEL.
--AND CREATED PIVOT TABLES TO UNDERSTAND THEM BETTER. OUR MAIN OBJECTIVE IS TO FIND THE DIFFERENCE IN USAGE BETWEEN SUBSCRIBER AND CUSTOMER.
--SO NOW, I CAN MOVE DIRECTLY TO FINDING INSIGHTS ON THE COMPLETE YEARS DATA.


-- Let's merge the entire years data 

WITH ride_data AS
(
SELECT *
FROM cyclist..[2019_q1]
UNION
SELECT *
FROM cyclist..[2019_q2]
UNION
SELECT *
FROM cyclist..[2019_q3]
UNION
SELECT *
FROM cyclist..[2019_q4])

--SELECT *
--FROM ride_data

-- station where  most rides started from (can be used to store more bikes)
SELECT from_station_name, COUNT(from_station_name) as occurance
FROM ride_data
Group by from_station_name
order by occurance desc


-- average ride time for subscriber v/s customer
WITH ride_data AS
(
SELECT *
FROM cyclist..[2019_q1]
UNION
SELECT *
FROM cyclist..[2019_q2]
UNION
SELECT *
FROM cyclist..[2019_q3]
UNION
SELECT *
FROM cyclist..[2019_q4]
)
SELECT avg(tripduration/60) as avg_tripduration_mins, usertype
FROM ride_data
Group by usertype
order by avg_tripduration_mins desc


-- subscriber v/s customer avg ridetime on weekends
WITH ride_data AS
(
SELECT *
FROM cyclist..[2019_q1]
UNION
SELECT *
FROM cyclist..[2019_q2]
UNION
SELECT *
FROM cyclist..[2019_q3]
UNION
SELECT *
FROM cyclist..[2019_q4])

SELECT avg(tripduration/60) as avg_ride_time_mins, usertype
FROM ride_data
WHERE day_of_week = 1  or day_of_week = 7 
GROUP BY usertype
ORDER BY avg_ride_time_mins desc


-- subscriber v/s customer number of rides on weekends
WITH ride_data AS
(
SELECT *
FROM cyclist..[2019_q1]
UNION
SELECT *
FROM cyclist..[2019_q2]
UNION
SELECT *
FROM cyclist..[2019_q3]
UNION
SELECT *
FROM cyclist..[2019_q4])

SELECT count(usertype) as instances, usertype
FROM ride_data
WHERE day_of_week = 1  or day_of_week = 7 
GROUP BY usertype
ORDER BY instances desc


--busiest day of the week
WITH ride_data AS
(
SELECT *
FROM cyclist..[2019_q1]
UNION
SELECT *
FROM cyclist..[2019_q2]
UNION
SELECT *
FROM cyclist..[2019_q3]
UNION
SELECT *
FROM cyclist..[2019_q4])

SELECT day_of_week, COUNT(trip_id) as number_of_trips, usertype
FROM ride_data
GROUP BY day_of_week, usertype
ORDER BY number_of_trips desc
-- With this data, we can assume that the subscribers use the bike service mostly on weekdays, perhaps to commute to work.
-- While on the other hand the customers use the service on weekends maybe to try the bikes or for leisure (+/workout)


--While we can perform more queries and find more interesting data, I am going to stop here as we have answered the business question 
--which was the difference in usage of the service between the two usertypes.