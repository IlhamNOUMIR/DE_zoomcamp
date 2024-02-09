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

### Question 1: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
### What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

##### code : 
SELECT COUNT(DISTINCT PULocationID) FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;

SELECT COUNT(DISTINCT PULocationID) FROM `sylvan-ocean-411119.ny_taxi.green_cap_2022`;
##### Answer :  0 MB for the External Table and 6.41MB for the Materialized Table
