# Question 1. Knowing docker tags : 
docker run --help -- > --rm -->  Automatically remove the container when it exits
Response : --rm

# Question 2. Understanding docker first run
winpty docker run -it --entrypoint /bin/bash python:3.9
3 
Package    Version
---------- -------
pip        23.0.1
setuptools 58.1.0
wheel      0.42.0

Response : 0.42.0

# Question 3. Count records
SELECT count(*)
FROM yellow_taxi_data
WHERE DATE(lpep_pickup_datetime ) = '2019-09-18';

Response: 15767

# Question 4. Largest trip for each day
SELECT 
    DATE(lpep_pickup_datetime ) AS pickup_day,
    SUM(trip_distance) AS total_trip_distance
FROM 
    yellow_taxi_data

GROUP BY 
    pickup_day
ORDER BY 
    total_trip_distance DESC
LIMIT 1;

Response : 2019-09-26
