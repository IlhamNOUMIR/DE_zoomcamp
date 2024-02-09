#### SETUP:
#### Create an external table using the Green Taxi Trip Records Data for 2022.
#### Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table).

DROP TABLE IF EXISTS `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;
CREATE EXTERNAL TABLE `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://green-data-20222/green_tripdata_2022-*.parquet']
);

DROP TABLE IF EXISTS `sylvan-ocean-411119.ny_taxi.green_cap_2022`;
CREATE OR REPLACE TABLE `sylvan-ocean-411119.ny_taxi.green_cap_2022` AS
SELECT * FROM `sylvan-ocean-411119.ny_taxi.external_green_cap_2022`;
