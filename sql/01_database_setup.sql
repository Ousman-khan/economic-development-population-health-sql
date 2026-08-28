-- ============================================================
-- Project: Assessing Economic Development and Population Health
-- Database setup
-- ============================================================

-- Country metadata
CREATE TABLE countries (
    country_code VARCHAR(3) PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    region VARCHAR(100),
    income_group VARCHAR(100)
);

-- Development indicator metadata
CREATE TABLE indicators (
    indicator_code VARCHAR(30) PRIMARY KEY,
    indicator_name VARCHAR(150) NOT NULL
);

-- Annual country-level indicator observations
CREATE TABLE development_data (
    country_code VARCHAR(3) NOT NULL,
    indicator_code VARCHAR(30) NOT NULL,
    year INTEGER NOT NULL,
    value NUMERIC,

    PRIMARY KEY (country_code, indicator_code, year),

    FOREIGN KEY (country_code)
        REFERENCES countries(country_code),

    FOREIGN KEY (indicator_code)
        REFERENCES indicators(indicator_code),

    CHECK (year BETWEEN 2000 AND 2024)
);

-- Staging table for raw World Bank indicator data
CREATE TABLE wdi_staging (
    country_code VARCHAR(3),
    indicator_code VARCHAR(30),
    indicator_name VARCHAR(150),
    year INTEGER,
    value NUMERIC
);