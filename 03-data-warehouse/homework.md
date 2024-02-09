#### SETUP:
###### Create an external table using the Green Taxi Trip Records Data for 2022.
###### Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table).


DROP TABLE IF EXISTS `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;

CREATE EXTERNAL TABLE `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green-data-20222/green_tripdata_2022-*.parquet']
);

DROP TABLE IF EXISTS `sylvan-ocean-411119.ny_taxi.green_cap_2022`;

CREATE OR REPLACE TABLE `sylvan-ocean-411119.ny_taxi.green_cap_2022` AS
SELECT * FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;


### Question 1: What is count of records for the 2022 Green Taxi Data??
##### code : 
select count(*) from `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;
##### Answer : 840,402

### Question 2: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
### What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

##### code : 
SELECT COUNT(DISTINCT PULocationID) FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;

SELECT COUNT(DISTINCT PULocationID) FROM `sylvan-ocean-411119.ny_taxi.green_cap_2022`;
##### Answer :  0 MB for the External Table and 6.41MB for the Materialized Table



### Question 3: How many records have a fare_amount of 0? 
##### code : 
SELECT COUNT(*) FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022` WHERE fare_amount=0;
##### Answer : 1622


### Question 4 : What is the best strategy to make an optimized table in Big Query if your query will always order the results by PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)

##### code : 
CREATE OR REPLACE TABLE `sylvan-ocean-411119.ny_taxi.green_cap_2022_partionned_clustred`
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;

##### Answer :  Partition by lpep_pickup_datetime Cluster on PUlocationID

### Question 5 : Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)

##### code : 
SELECT DISTINCT(PULocationID)
FROM `sylvan-ocean-411119.ny_taxi.green_cap_2022`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

SELECT DISTINCT(PULocationID)
FROM `sylvan-ocean-411119.ny_taxi.green_cap_2022_partionned_clustred`
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

##### Answer :  12.82 MB for non-partitioned table and 1.12 MB for the partitioned table


### Question 6 : Where is the data stored in the External Table you created?

##### Answer : GCP Bucket


### Question 7 : It is best practice in Big Query to always cluster your data? 

##### Answer : False 
