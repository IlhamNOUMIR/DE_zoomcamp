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
SELECT DATE(lpep_pickup_datetime ) AS pickup_day, SUM(trip_distance) AS total_trip_distance
FROM  yellow_taxi_data
GROUP BY  pickup_day
ORDER BY total_trip_distance DESC
LIMIT 1;

Response : 2019-09-26

# Question 5. Three biggest pick up Boroughs
SELECT zo."Borough", SUM(ta."total_amount") AS "total_amount_sum"
FROM yellow_taxi_data AS ta
JOIN zones AS zo ON zo."LocationID" = ta."PULocationID"
WHERE DATE(ta."lpep_pickup_datetime") = '2019-09-18' AND zo."Borough" != 'Unknown'
GROUP BY zo."Borough"
HAVING SUM(ta."total_amount") > 50000
ORDER BY "total_amount_sum" DESC
LIMIT 3;

Response : "Brooklyn" "Manhattan" "Queens"

# Question 6. Largest tip

SELECT dropoff_zone."Zone" AS dropoff_zone_name, MAX(ta."tip_amount") AS max_tip_amount
FROM yellow_taxi_data AS ta
JOIN zones AS pickup_zone ON pickup_zone."LocationID" = ta."PULocationID"
JOIN zones AS dropoff_zone ON dropoff_zone."LocationID" = ta."DOLocationID"
WHERE pickup_zone."Zone" = 'Astoria' AND DATE(ta."lpep_pickup_datetime") >= '2019-09-01'  AND DATE(ta."lpep_pickup_datetime") <= '2019-09-30'
GROUP BY dropoff_zone."Zone"
ORDER BY max_tip_amount DESC
LIMIT 1;

Response : JFK Airport 


