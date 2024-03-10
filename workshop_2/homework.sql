# Question 1 : 
  
# MV:
CREATE MATERIALIZED VIEW trip_time_stats AS
SELECT
    tz1.zone AS start_zone,
    tz2.zone AS end_zone,
    AVG(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS avg_trip_time,
    MIN(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS min_trip_time,
    MAX(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS max_trip_time
FROM
    trip_data td
JOIN
    taxi_zone tz1 ON td.pulocationid = tz1.location_id
JOIN
    taxi_zone tz2 ON td.dolocationid = tz2.location_id
WHERE
    td.tpep_dropoff_datetime > '2022-01-02'::timestamp - INTERVAL '1 day' -- Adjust this filter according to your data freshness requirements
AND
    tz1.zone != tz2.zone -- Exclude trips within the same zone
GROUP BY
    tz1.zone,
    tz2.zone;


# Query : 
SELECT start_zone, end_zone
FROM trip_time_stats
ORDER BY avg_trip_time DESC
LIMIT 1;


# Answer :  Yorkville East, Steinway

# Question 2 : 

# MV :
CREATE MATERIALIZED VIEW trip_time_stats_with_count AS
SELECT
    tz1.zone AS start_zone,
    tz2.zone AS end_zone,
    AVG(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS avg_trip_time,
    MIN(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS min_trip_time,
    MAX(EXTRACT(epoch FROM (td.tpep_dropoff_datetime - td.tpep_pickup_datetime))) AS max_trip_time,
    COUNT(*) AS trip_count
FROM
    trip_data td
JOIN
    taxi_zone tz1 ON td.pulocationid = tz1.location_id
JOIN
    taxi_zone tz2 ON td.dolocationid = tz2.location_id
WHERE
   td.tpep_dropoff_datetime > '2022-01-02'::timestamp - INTERVAL '1 day' -- Adjust this filter according to your data freshness requirements
AND
    tz1.zone != tz2.zone -- Exclude trips within the same zone
GROUP BY
    tz1.zone,
    tz2.zone;

# Query : 

  SELECT start_zone, end_zone, avg_trip_time, trip_count
  FROM trip_time_stats_with_count
  ORDER BY avg_trip_time DESC, trip_count DESC
  LIMIT 1;

# Answer :  1


# Question 3: 

SELECT tz.zone, COUNT(*) AS pickup_count
FROM trip_data td
JOIN taxi_zone tz ON td.pulocationid = tz.location_id
WHERE td.tpep_pickup_datetime BETWEEN (SELECT MAX(tpep_pickup_datetime) FROM trip_data) - INTERVAL '17 hours' AND (SELECT MAX(tpep_pickup_datetime) FROM trip_data)
GROUP BY tz.zone
ORDER BY pickup_count DESC
LIMIT 3;

# Answer : LaGuardia Airport, Lincoln Square East, JFK Airport

