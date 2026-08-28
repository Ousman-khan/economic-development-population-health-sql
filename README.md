# Assessing Economic Development and Population Health Using SQL

## Overview

This project analyzes cross-country patterns in economic development and population health using World Bank World Development Indicators (WDI) from 2000–2024.

An end-to-end analytical workflow was developed using the World Bank API, Python, PostgreSQL, SQL, and Matplotlib. The analysis examines long-term trends, regional and income-group disparities, country-level improvements, and relationships between economic conditions, infrastructure, and population health.

## Objective

To assess cross-country patterns and trends in economic development and population health, focusing on changes over time, regional and income-group differences, and relationships among key development and health indicators.

## Research Questions

1. How have economic development and population health indicators changed over time?
2. How do development and health outcomes differ across regions and income groups?
3. Which countries experienced the greatest improvements?
4. What relationships exist between economic conditions, infrastructure, health investment, and population health?
5. Which lower-income countries achieve comparatively strong population-health outcomes?

## Data

**Source:** World Bank World Development Indicators  
**Study period:** 2000–2024  
**Coverage:** Individual countries/economies; World Bank aggregate groups were excluded.

### Indicators

- GDP per capita (current US$)
- GDP growth (annual %)
- Life expectancy at birth
- Under-five mortality rate
- Current health expenditure (% of GDP)
- Access to electricity (% of population)
- Population, total

## Workflow

```text
World Bank API
      ↓
Python
      ↓
CSV data
      ↓
PostgreSQL staging table
      ↓
Relational database
      ↓
SQL analysis
      ↓
Python / Matplotlib
      ↓
Results and visualizations