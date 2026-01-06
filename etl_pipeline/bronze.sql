CREATE STREAMING TABLE bronze_census_population_sql
COMMENT "Bronze layer: raw census population data ingested from CSV volume"
AS
SELECT
    region,
    year,
    age_group,
    gender,
    ethnic_group,
    population,
    literacy_rate,
    employed,
    employment_rate
FROM cloud_files(
    "/Volumes/workspace/default/census_volume",
    "csv",
    map(
        "header", "true",
        "inferSchema", "true"
    )
);
