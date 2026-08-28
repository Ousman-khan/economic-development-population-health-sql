-- ============================================================
-- RQ1: Trends in Economic Development and Population Health
-- Study period: 2000-2024
-- ============================================================

SELECT
    indicators.indicator_name,
    MIN(development_data.year) FILTER (
        WHERE development_data.value IS NOT NULL
    ) AS first_available_year,
    MAX(development_data.year) FILTER (
        WHERE development_data.value IS NOT NULL
    ) AS last_available_year,
    COUNT(development_data.value) AS available_observations,
    COUNT(*) - COUNT(development_data.value) AS missing_observations
FROM development_data
INNER JOIN indicators
    ON development_data.indicator_code = indicators.indicator_code
GROUP BY indicators.indicator_name
ORDER BY indicators.indicator_name;

-- ------------------------------------------------------------
-- 2. Regional trends in life expectancy, 2000-2024
-- ------------------------------------------------------------

SELECT
    countries.region,
    development_data.year,
    ROUND(AVG(development_data.value), 2) AS average_life_expectancy
FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'SP.DYN.LE00.IN'
    AND development_data.value IS NOT NULL
GROUP BY
    countries.region,
    development_data.year
ORDER BY
    countries.region,
    development_data.year;

    -- ------------------------------------------------------------
-- 3. Change in regional life expectancy between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.region,

    ROUND(
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS life_expectancy_2000,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS life_expectancy_2024,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS improvement_years

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'SP.DYN.LE00.IN'
GROUP BY countries.region
ORDER BY improvement_years DESC;

-- ------------------------------------------------------------
-- 4. Regional trends in under-five mortality, 2000-2024
-- ------------------------------------------------------------

SELECT
    countries.region,
    development_data.year,
    ROUND(AVG(development_data.value), 2) AS average_under5_mortality
FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'SH.DYN.MORT'
    AND development_data.value IS NOT NULL
GROUP BY
    countries.region,
    development_data.year
ORDER BY
    countries.region,
    development_data.year;


-- ------------------------------------------------------------
-- 5. Change in regional under-five mortality between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.region,

    ROUND(
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS mortality_2000,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS mortality_2024,

    ROUND(
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END)
        -
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END),
        2
    ) AS mortality_reduction

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'SH.DYN.MORT'
GROUP BY countries.region
ORDER BY mortality_reduction DESC;

-- ------------------------------------------------------------
-- 6. Regional trends in GDP per capita, 2000-2024
-- ------------------------------------------------------------

SELECT
    countries.region,
    development_data.year,
    ROUND(AVG(development_data.value), 2) AS average_gdp_per_capita
FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'NY.GDP.PCAP.CD'
    AND development_data.value IS NOT NULL
GROUP BY
    countries.region,
    development_data.year
ORDER BY
    countries.region,
    development_data.year;


-- ------------------------------------------------------------
-- 7. Change in regional GDP per capita between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.region,

    ROUND(
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS gdp_per_capita_2000,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS gdp_per_capita_2024,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS absolute_change,

    ROUND(
        100 * (
            AVG(CASE WHEN development_data.year = 2024
                     THEN development_data.value END)
            -
            AVG(CASE WHEN development_data.year = 2000
                     THEN development_data.value END)
        )
        /
        NULLIF(
            AVG(CASE WHEN development_data.year = 2000
                     THEN development_data.value END),
            0
        ),
        2
    ) AS percentage_change

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'NY.GDP.PCAP.CD'
GROUP BY countries.region
ORDER BY percentage_change DESC;

-- ------------------------------------------------------------
-- 8. Regional trends in access to electricity, 2000-2024
-- ------------------------------------------------------------

SELECT
    countries.region,
    development_data.year,
    ROUND(AVG(development_data.value), 2) AS average_electricity_access
FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'EG.ELC.ACCS.ZS'
    AND development_data.value IS NOT NULL
GROUP BY
    countries.region,
    development_data.year
ORDER BY
    countries.region,
    development_data.year;


-- ------------------------------------------------------------
-- 9. Change in regional access to electricity between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.region,

    ROUND(
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS electricity_access_2000,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS electricity_access_2024,

    ROUND(
        AVG(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        AVG(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS percentage_point_change

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code
WHERE development_data.indicator_code = 'EG.ELC.ACCS.ZS'
GROUP BY countries.region
ORDER BY percentage_point_change DESC;