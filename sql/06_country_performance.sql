-- ============================================================
-- RQ3: Country-Level Improvements in Economic Development
--      and Population Health
-- Study period: 2000-2024
-- ============================================================


-- ------------------------------------------------------------
-- 1. Top 15 countries by improvement in life expectancy
-- ------------------------------------------------------------

SELECT
    countries.country_name,
    countries.region,
    countries.income_group,

    ROUND(
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS life_expectancy_2000,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS life_expectancy_2024,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS improvement_years

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code

WHERE development_data.indicator_code = 'SP.DYN.LE00.IN'

GROUP BY
    countries.country_name,
    countries.region,
    countries.income_group

ORDER BY improvement_years DESC
LIMIT 15;


-- ------------------------------------------------------------
-- 2. Top 15 countries by reduction in under-five mortality
-- ------------------------------------------------------------

SELECT
    countries.country_name,
    countries.region,
    countries.income_group,

    ROUND(
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS mortality_2000,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS mortality_2024,

    ROUND(
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END)
        -
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END),
        2
    ) AS mortality_reduction

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code

WHERE development_data.indicator_code = 'SH.DYN.MORT'

GROUP BY
    countries.country_name,
    countries.region,
    countries.income_group

HAVING
    MAX(CASE WHEN development_data.year = 2000
             THEN development_data.value END) IS NOT NULL
    AND
    MAX(CASE WHEN development_data.year = 2024
             THEN development_data.value END) IS NOT NULL

ORDER BY mortality_reduction DESC
LIMIT 15;

-- ------------------------------------------------------------
-- 3. Top 15 countries by percentage increase in GDP per capita
--    between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.country_name,
    countries.region,
    countries.income_group,

    ROUND(
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS gdp_per_capita_2000,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS gdp_per_capita_2024,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS absolute_change,

    ROUND(
        100 * (
            MAX(CASE WHEN development_data.year = 2024
                     THEN development_data.value END)
            -
            MAX(CASE WHEN development_data.year = 2000
                     THEN development_data.value END)
        )
        /
        NULLIF(
            MAX(CASE WHEN development_data.year = 2000
                     THEN development_data.value END),
            0
        ),
        2
    ) AS percentage_change

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code

WHERE development_data.indicator_code = 'NY.GDP.PCAP.CD'

GROUP BY
    countries.country_name,
    countries.region,
    countries.income_group

HAVING
    MAX(CASE WHEN development_data.year = 2000
             THEN development_data.value END) IS NOT NULL
    AND
    MAX(CASE WHEN development_data.year = 2024
             THEN development_data.value END) IS NOT NULL

ORDER BY percentage_change DESC
LIMIT 15;


-- ------------------------------------------------------------
-- 4. Top 15 countries by improvement in electricity access
--    between 2000 and 2024
-- ------------------------------------------------------------

SELECT
    countries.country_name,
    countries.region,
    countries.income_group,

    ROUND(
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END), 2
    ) AS electricity_access_2000,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END), 2
    ) AS electricity_access_2024,

    ROUND(
        MAX(CASE WHEN development_data.year = 2024
                 THEN development_data.value END)
        -
        MAX(CASE WHEN development_data.year = 2000
                 THEN development_data.value END),
        2
    ) AS percentage_point_increase

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code

WHERE development_data.indicator_code = 'EG.ELC.ACCS.ZS'

GROUP BY
    countries.country_name,
    countries.region,
    countries.income_group

HAVING
    MAX(CASE WHEN development_data.year = 2000
             THEN development_data.value END) IS NOT NULL
    AND
    MAX(CASE WHEN development_data.year = 2024
             THEN development_data.value END) IS NOT NULL

ORDER BY percentage_point_increase DESC
LIMIT 15;