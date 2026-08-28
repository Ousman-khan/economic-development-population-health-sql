-- ============================================================
-- RQ2: Regional and Income-Group Differences in Development
--      and Population Health
-- Study period: 2000-2024
-- ============================================================


-- ------------------------------------------------------------
-- 1. Number of countries by income group
-- ------------------------------------------------------------

SELECT
    income_group,
    COUNT(*) AS number_of_countries
FROM countries
GROUP BY income_group
ORDER BY number_of_countries DESC;


-- ------------------------------------------------------------
-- 2. Economic, health, and infrastructure indicators
--    by income group in 2024
-- ------------------------------------------------------------

SELECT
    countries.income_group,

    ROUND(AVG(CASE
        WHEN development_data.indicator_code = 'SP.DYN.LE00.IN'
        THEN development_data.value
    END), 2) AS life_expectancy,

    ROUND(AVG(CASE
        WHEN development_data.indicator_code = 'SH.DYN.MORT'
        THEN development_data.value
    END), 2) AS under5_mortality,

    ROUND(AVG(CASE
        WHEN development_data.indicator_code = 'NY.GDP.PCAP.CD'
        THEN development_data.value
    END), 2) AS gdp_per_capita,

    ROUND(AVG(CASE
        WHEN development_data.indicator_code = 'EG.ELC.ACCS.ZS'
        THEN development_data.value
    END), 2) AS electricity_access

FROM development_data
INNER JOIN countries
    ON development_data.country_code = countries.country_code

WHERE development_data.year = 2024

GROUP BY countries.income_group
ORDER BY gdp_per_capita DESC;


-- ------------------------------------------------------------
-- 3. High-income versus low-income development gaps in 2024
-- ------------------------------------------------------------

WITH income_group_summary AS (
    SELECT
        countries.income_group,

        AVG(CASE
            WHEN development_data.indicator_code = 'SP.DYN.LE00.IN'
            THEN development_data.value
        END) AS life_expectancy,

        AVG(CASE
            WHEN development_data.indicator_code = 'SH.DYN.MORT'
            THEN development_data.value
        END) AS under5_mortality,

        AVG(CASE
            WHEN development_data.indicator_code = 'NY.GDP.PCAP.CD'
            THEN development_data.value
        END) AS gdp_per_capita,

        AVG(CASE
            WHEN development_data.indicator_code = 'EG.ELC.ACCS.ZS'
            THEN development_data.value
        END) AS electricity_access

    FROM development_data
    INNER JOIN countries
        ON development_data.country_code = countries.country_code

    WHERE development_data.year = 2024

    GROUP BY countries.income_group
)

SELECT
    ROUND(
        MAX(CASE WHEN income_group = 'High income'
                 THEN life_expectancy END)
        -
        MAX(CASE WHEN income_group = 'Low income'
                 THEN life_expectancy END),
        2
    ) AS life_expectancy_gap_years,

    ROUND(
        MAX(CASE WHEN income_group = 'Low income'
                 THEN under5_mortality END)
        -
        MAX(CASE WHEN income_group = 'High income'
                 THEN under5_mortality END),
        2
    ) AS under5_mortality_gap,

    ROUND(
        MAX(CASE WHEN income_group = 'High income'
                 THEN gdp_per_capita END)
        -
        MAX(CASE WHEN income_group = 'Low income'
                 THEN gdp_per_capita END),
        2
    ) AS gdp_per_capita_gap,

    ROUND(
        MAX(CASE WHEN income_group = 'High income'
                 THEN electricity_access END)
        -
        MAX(CASE WHEN income_group = 'Low income'
                 THEN electricity_access END),
        2
    ) AS electricity_access_gap

FROM income_group_summary;