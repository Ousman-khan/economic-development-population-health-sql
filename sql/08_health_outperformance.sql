-- ============================================================
-- RQ5: Strong Population Health Outcomes Among
--      Lower-Income Countries
-- Study year: 2024
-- ============================================================

-- Identifies World Bank low-income and lower-middle-income
-- countries with:
--   1. Above-average life expectancy, and
--   2. Below-average under-five mortality
-- relative to other countries in the same combined
-- lower-income comparison group.


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

lower_income_countries AS (
    SELECT *
    FROM country_profile
    WHERE income_group IN ('Low income', 'Lower middle income')
        AND life_expectancy IS NOT NULL
        AND under5_mortality IS NOT NULL
),

health_benchmarks AS (
    SELECT
        AVG(life_expectancy) AS average_life_expectancy,
        AVG(under5_mortality) AS average_under5_mortality
    FROM lower_income_countries
)

SELECT
    lower_income_countries.country_name,
    lower_income_countries.region,
    lower_income_countries.income_group,

    ROUND(
        lower_income_countries.gdp_per_capita, 2
    ) AS gdp_per_capita,

    ROUND(
        lower_income_countries.life_expectancy, 2
    ) AS life_expectancy,

    ROUND(
        lower_income_countries.under5_mortality, 2
    ) AS under5_mortality

FROM lower_income_countries

CROSS JOIN health_benchmarks

WHERE lower_income_countries.life_expectancy >
      health_benchmarks.average_life_expectancy

    AND lower_income_countries.under5_mortality <
        health_benchmarks.average_under5_mortality

ORDER BY lower_income_countries.life_expectancy DESC;