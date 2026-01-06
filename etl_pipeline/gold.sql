CREATE MATERIALIZED VIEW gold_population_by_region_sql
COMMENT "Gold layer: total population aggregated by region and year"
AS
SELECT
    region,
    year,
    SUM(population) AS total_population
FROM LIVE.silver_census_population
GROUP BY region, year;

CREATE MATERIALIZED VIEW gold_gender_distribution_sql
COMMENT "Gold layer: population distribution by gender"
AS
SELECT
    region,
    year,
    gender,
    SUM(population) AS population
FROM LIVE.silver_census_population
GROUP BY region, year, gender;

CREATE MATERIALIZED VIEW gold_age_distribution_sql
COMMENT "Gold layer: population distribution by age group"
AS
SELECT
    region,
    year,
    age_group,
    SUM(population) AS population
FROM LIVE.silver_census_population
GROUP BY region, year, age_group;

CREATE MATERIALIZED VIEW gold_literacy_rate_sql
COMMENT "Gold layer: weighted average literacy rate by region and year"
AS
SELECT
    region,
    year,
    ROUND(
        SUM(literacy_rate * population) / SUM(population),
        2
    ) AS literacy_rate
FROM LIVE.silver_census_population
GROUP BY region, year;

CREATE MATERIALIZED VIEW gold_employment_rate_sql
COMMENT "Gold layer: weighted average employment rate by region and year"
AS
SELECT
    region,
    year,
    ROUND(
        SUM(employment_rate * population) / SUM(population),
        2
    ) AS employment_rate
FROM LIVE.silver_census_population
GROUP BY region, year;
CREATE MATERIALIZED VIEW gold_employed_population_sql
COMMENT "Gold layer: total employed population by region and year"
AS
SELECT
    region,
    year,
    SUM(employed) AS employed_population
FROM LIVE.silver_census_population
GROUP BY region, year;
