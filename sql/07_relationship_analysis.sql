-- ============================================================
-- RQ4: Relationships Between Economic Conditions,
--      Infrastructure, Health Investment, and
--      Population Health Outcomes
-- ============================================================


-- ------------------------------------------------------------
-- 1. Population health outcomes by GDP per capita quartile, 2024
-- ------------------------------------------------------------

WITH country_profile AS (
    SELECT
        countries.country_name,
        countries.region,
        countries.income_group,

        MAX(CASE
            WHEN development_data.indicator_code = 'NY.GDP.PCAP.CD'
            THEN development_data.value
        END) AS gdp_per_capita,

        MAX(CASE
            WHEN development_data.indicator_code = 'SP.DYN.LE00.IN'
            THEN development_data.value
        END) AS life_expectancy,

        MAX(CASE
            WHEN development_data.indicator_code = 'SH.DYN.MORT'
            THEN development_data.value
        END) AS under5_mortality

    FROM development_data
    INNER JOIN countries
        ON development_data.country_code = countries.country_code

    WHERE development_data.year = 2024

    GROUP BY
        countries.country_name,
        countries.region,
        countries.income_group
),

gdp_groups AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY gdp_per_capita) AS gdp_quartile
    FROM country_profile
    WHERE gdp_per_capita IS NOT NULL
)

SELECT
    gdp_quartile,
    COUNT(*) AS number_of_countries,
    ROUND(MIN(gdp_per_capita), 2) AS minimum_gdp_per_capita,
    ROUND(MAX(gdp_per_capita), 2) AS maximum_gdp_per_capita,
    ROUND(AVG(life_expectancy), 2) AS average_life_expectancy,
    ROUND(AVG(under5_mortality), 2) AS average_under5_mortality
FROM gdp_groups
GROUP BY gdp_quartile
ORDER BY gdp_quartile;


-- ------------------------------------------------------------
-- 2. Population health outcomes by electricity-access group, 2024
-- ------------------------------------------------------------

WITH country_profile AS (
    SELECT
        countries.country_name,
        countries.region,
        countries.income_group,

        MAX(CASE
            WHEN development_data.indicator_code = 'EG.ELC.ACCS.ZS'
            THEN development_data.value
        END) AS electricity_access,

        MAX(CASE
            WHEN development_data.indicator_code = 'SP.DYN.LE00.IN'
            THEN development_data.value
        END) AS life_expectancy,

        MAX(CASE
            WHEN development_data.indicator_code = 'SH.DYN.MORT'
            THEN development_data.value
        END) AS under5_mortality

    FROM development_data
    INNER JOIN countries
        ON development_data.country_code = countries.country_code

    WHERE development_data.year = 2024

    GROUP BY
        countries.country_name,
        countries.region,
        countries.income_group
),

electricity_groups AS (
    SELECT
        *,
        CASE
            WHEN electricity_access < 50
                THEN 'Low access (<50%)'
            WHEN electricity_access < 80
                THEN 'Moderate access (50-79.9%)'
            WHEN electricity_access < 100
                THEN 'High access (80-99.9%)'
            ELSE 'Universal access (100%)'
        END AS electricity_access_group

    FROM country_profile
    WHERE electricity_access IS NOT NULL
)

SELECT
    electricity_access_group,
    COUNT(*) AS number_of_countries,
    ROUND(AVG(electricity_access), 2) AS average_electricity_access,
    ROUND(AVG(life_expectancy), 2) AS average_life_expectancy,
    ROUND(AVG(under5_mortality), 2) AS average_under5_mortality
FROM electricity_groups
GROUP BY electricity_access_group
ORDER BY average_electricity_access;


-- ------------------------------------------------------------
-- 3. Population health outcomes by health-expenditure
--    quartile, 2023
--
-- 2023 is used because it is the most recent year with
-- adequate health-expenditure coverage (192 countries).
-- ------------------------------------------------------------

WITH country_profile AS (
    SELECT
        countries.country_name,
        countries.region,
        countries.income_group,

        MAX(CASE
            WHEN development_data.indicator_code = 'SH.XPD.CHEX.GD.ZS'
            THEN development_data.value
        END) AS health_expenditure,

        MAX(CASE
            WHEN development_data.indicator_code = 'SP.DYN.LE00.IN'
            THEN development_data.value
        END) AS life_expectancy,

        MAX(CASE
            WHEN development_data.indicator_code = 'SH.DYN.MORT'
            THEN development_data.value
        END) AS under5_mortality

    FROM development_data
    INNER JOIN countries
        ON development_data.country_code = countries.country_code

    WHERE development_data.year = 2023

    GROUP BY
        countries.country_name,
        countries.region,
        countries.income_group
),

health_spending_groups AS (
    SELECT
        *,
        NTILE(4) OVER (ORDER BY health_expenditure) AS expenditure_quartile
    FROM country_profile
    WHERE health_expenditure IS NOT NULL
)

SELECT
    expenditure_quartile,
    COUNT(*) AS number_of_countries,
    ROUND(MIN(health_expenditure), 2) AS minimum_health_expenditure,
    ROUND(MAX(health_expenditure), 2) AS maximum_health_expenditure,
    ROUND(AVG(life_expectancy), 2) AS average_life_expectancy,
    ROUND(AVG(under5_mortality), 2) AS average_under5_mortality
FROM health_spending_groups
GROUP BY expenditure_quartile
ORDER BY expenditure_quartile;