-- ============================================================
-- Project: Assessing Economic Development and Population Health
-- Data quality and validation
-- ============================================================

-- Check dimensions and data availability
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT country_code) AS countries,
    COUNT(DISTINCT indicator_code) AS indicators,
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year,
    COUNT(value) AS available_values,
    COUNT(*) - COUNT(value) AS missing_values
FROM wdi_staging;


-- Check for duplicate country-indicator-year observations
SELECT
    country_code,
    indicator_code,
    year,
    COUNT(*) AS record_count
FROM wdi_staging
GROUP BY country_code, indicator_code, year
HAVING COUNT(*) > 1;


-- Check for country codes that do not exist in the countries table
SELECT DISTINCT
    wdi_staging.country_code
FROM wdi_staging
LEFT JOIN countries
    ON wdi_staging.country_code = countries.country_code
WHERE countries.country_code IS NULL;


-- Check data availability by indicator
SELECT
    indicators.indicator_name,
    COUNT(*) AS total_records,
    COUNT(development_data.value) AS available_values,
    COUNT(*) - COUNT(development_data.value) AS missing_values
FROM development_data
INNER JOIN indicators
    ON development_data.indicator_code = indicators.indicator_code
GROUP BY indicators.indicator_name
ORDER BY missing_values DESC;