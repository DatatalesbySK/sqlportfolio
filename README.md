# 🦠 COVID-19 Data Exploration Using SQL

This project performs in-depth data exploration and analysis on global COVID-19 data using **SQL Server Management Studio (SSMS)**. 
The goal is to derive key insights into cases, deaths, vaccination trends, and population impact across countries and continents.

---

## 📂 Project Overview

Using real-world COVID-19 datasets from [Our World in Data](https://ourworldindata.org/coronavirus), this project explores:
- Trends in cases and deaths over time
- Infection and death rates per country
- Vaccination progress across the globe
- Population-level insights using window functions, aggregates, and joins

---

## 🧠 Key Insights & Analysis

- 🌍 Identified countries with the **highest infection and death rates** relative to population.
- 💉 Tracked **rolling vaccination totals** per country using SQL `OVER()` clause.
- 📈 Calculated **percent of population infected/vaccinated** to understand pandemic spread.
- 🌐 Aggregated global numbers daily and over time to show the progression of the pandemic.

---

## 📊 Tools & Technologies Used

- **SQL Server Management Studio (SSMS)**
- **T-SQL** for querying and data manipulation
- **Window functions** (`OVER`, `PARTITION BY`)
- **CTEs**, **temp tables**, and **views**
- **Excel** for data input and initial inspection

---

## 📁 Data Sources

Two datasets were used (uploaded in this repo as `.xlsm` files):
- `CovidDeathssample.xlsm`
- `CovidVaccinationssample.xlsm`

Original source: [Our World in Data - COVID-19 Dataset](https://ourworldindata.org/covid-data)

---

## 📌 SQL Concepts Practiced

- `JOIN`, `GROUP BY`, `ORDER BY`, `WHERE`
- Aggregates: `SUM()`, `MAX()`, `CAST()`, `CONVERT()`
- **Window Functions**: `SUM() OVER(PARTITION BY...)`
- **CTEs** for clean query logic
- **Temp Tables** for reusability and optimization
- **Views** for dashboard/reporting readiness

---

## 📈 Sample Query Snippets

```sql
-- Total Death Percentage
SELECT location, date, total_cases, total_deaths,
       (total_deaths / total_cases) * 100 AS DeathPercentage
FROM portfoliosql..coviddeaths
WHERE location LIKE '%India%'
