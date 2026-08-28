-- ============================================================
-- Project: Assessing Economic Development and Population Health
-- Data loading and transformation
-- ============================================================

-- Populate indicator metadata from the staging table
INSERT INTO indicators (indicator_code, indicator_name)
SELECT DISTINCT
    indicator_code,
    indicator_name
FROM wdi_staging;

-- Populate annual development observations
INSERT INTO development_data (
    country_code,
    indicator_code,
    year,
    value
)
SELECT
    country_code,
    indicator_code,
    year,
    value
FROM wdi_staging;