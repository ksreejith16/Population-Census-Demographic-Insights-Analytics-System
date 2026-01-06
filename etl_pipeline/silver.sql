CREATE MATERIALIZED VIEW silver_census_population_sql
COMMENT "Silver layer: cleaned and typed census population data"
AS
SELECT DISTINCT
    TRIM(region)                        AS region,
    CAST(year AS INT)                   AS year,
    TRIM(age_group)                     AS age_group,
    TRIM(gender)                        AS gender,
    TRIM(ethnic_group)                  AS ethnic_group,
    CAST(population AS INT)             AS population,
    CAST(literacy_rate AS DOUBLE)       AS literacy_rate,
    CAST(employed AS INT)               AS employed,
    CAST(employment_rate AS DOUBLE)     AS employment_rate
FROM LIVE.bronze_census_population
WHERE
    region IS NOT NULL
    AND year IS NOT NULL
    AND population IS NOT NULL;
