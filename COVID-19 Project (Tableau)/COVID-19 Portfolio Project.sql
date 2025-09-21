SELECT *
FROM Portfolio_Project..CovidDeaths

SELECT *
FROM Portfolio_Project..CovidDeaths
ORDER BY 3, 4;


ALTER TABLE Portfolio_Project..CovidDeaths
ALTER COLUMN total_cases FLOAT;

ALTER TABLE Portfolio_Project..CovidDeaths
ALTER COLUMN new_cases FLOAT;

ALTER TABLE Portfolio_Project..CovidDeaths
ALTER COLUMN total_deaths FLOAT;

ALTER TABLE Portfolio_Project..CovidDeaths
ALTER COLUMN new_deaths FLOAT;

ALTER TABLE Portfolio_Project..CovidDeaths
ALTER COLUMN population FLOAT;


-- Backing up my database incase in need to revert back to my raw data
SELECT *
INTO _CovidDeaths
FROM Portfolio_Project..CovidDeaths;

SELECT *
INTO _CovidVacinations
FROM Portfolio_Project..CovidVaccinations;


SELECT *
FROM Portfolio_Project..CovidVaccinations
WHERE continent IS NOT NULL
ORDER BY 3, 4;

--SELECT *
--FROM Portfolio_Project..CovidVacinations
--ORDER BY 3, 4;

-- Select Data that we are going to be using


--Looking at Total Cases vs Total Deaths
--Show the liklihood of dying from COVID-19 if infected in the US.

SELECT Location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS death_ratio
FROM Portfolio_Project..CovidDeaths
WHERE location like '%states'
	AND continent IS NOT NULL
ORDER BY 1, 2;

---------------------------Looking at the Total Cases vs Population------------------------------
SELECT Location, date, total_cases, total_deaths, Population, (total_cases / Population) * 100 AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
WHERE location like '%states'
	AND continent IS NOT NULL
ORDER BY 1, 2;

------------------- Looking at Countries with Highest Infection Rate compared to population------------------------------

SELECT continent AS Continent, Location, Population, date as Date, MAX(total_cases) AS highestInfectionCount,  MAX((total_cases / Population)) * 100 
	AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
GROUP BY continent, location, Population, Date
ORDER BY PercentPopulationInfected DESC;

------------------------Breaking fields by continent-------------------------------------

SELECT continent AS Continent, MAX(total_deaths) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

--------------------Showing Countries with Highest Death Count per Population-------------------------
 
SELECT continent AS Continent, Location, Population, MAX(total_deaths) AS TotalDeathCount
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
WHERE continent IS NOT NULL
GROUP BY continent, location, Population
ORDER BY TotalDeathCount DESC;


-----------------Breaking down Global Numbers---------------------------------

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_perentage
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;



--------------------Looking at the total Population vs Vaccinations------------------------

SELECT 
	death.continent AS Continent,
	death.location, 
	death.date, 
	death.population, 
	vacin.new_vaccinations,
	SUM(vacin.new_vaccinations) OVER (
	PARTITION BY death.location 
	ORDER BY death.date,
	death.date) 
	
	AS RollingPeopleVaccinated

FROM Portfolio_Project..CovidDeaths as death
JOIN Portfolio_Project..CovidVaccinations AS vacin
	ON death.location = vacin.location
	AND death.date = vacin.date
WHERE death.continent IS NOT NULL
ORDER BY 2, 3



-------------------------CTE for PercentVaccinated------------------------------

WITH Population_vs_Vaccination (
Continent, 
location, 
date, 
population, 
new_vaccinations, 
RollingPeopleVaccinated) AS 
(
SELECT 
	death.continent AS Continent, 
	death.location, death.date, 
	death.population, 
	vacin.new_vaccinations,
	SUM(vacin.new_vaccinations) 
	OVER (PARTITION BY death.location ORDER BY death.date,death.date) 

	AS RollingPeopleVaccinated

FROM Portfolio_Project..CovidDeaths as death
JOIN Portfolio_Project..CovidVaccinations AS vacin
	ON death.location = vacin.location
	AND death.date = vacin.date
WHERE death.continent IS NOT NULL
--ORDER BY 2, 3
)

SELECT* ,  (RollingPeopleVaccinated/population)*100 AS PercentVaccinated
FROM Population_vs_Vaccination;


-----------------------------Temp Table ---------------------------------------

DROP TABLE IF EXISTS #PercentPopulationVaccinated

CREATE TABLE #PercentPopulationVaccinated (
Continent varchar(50),
Location varchar(50),
Date datetime,
Population float,
New_vaccinations int,
RollingPeopleVaccinated BIGINT
)

INSERT INTO #PercentPopulationVaccinated

SELECT 
	death.continent AS Continent, 
	death.location, 
	death.date, 
	death.population, 
	vacin.new_vaccinations,
	SUM(vacin.new_vaccinations) 
	OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
	
	AS RollingPeopleVaccinated

FROM Portfolio_Project..CovidDeaths as death
JOIN Portfolio_Project..CovidVaccinations AS vacin
	ON death.location = vacin.location
	AND death.date = vacin.date
WHERE death.continent IS NOT NULL

SELECT* , (RollingPeopleVaccinated/population)*100 AS PercentVaccinated
FROM #PercentPopulationVaccinated;


--------------------- Creating View to store data for data visualization---------------

DROP VIEW IF EXISTS PercentPopulationVaccinatedView;
GO

CREATE VIEW PercentPopulationVaccinatedView AS
SELECT 
    death.continent AS Continent,
    death.location,
    death.date,
    death.population,
    vacin.new_vaccinations,
    SUM(vacin.new_vaccinations) OVER (
        PARTITION BY death.location 
        ORDER BY death.date) 
		AS RollingPeopleVaccinated

FROM Portfolio_Project..CovidDeaths AS death
JOIN Portfolio_Project..CovidVaccinations AS vacin
    ON death.location = vacin.location
    AND death.date = vacin.date
WHERE death.continent IS NOT NULL
;

SELECT *
FROM PercentPopulationVaccinatedView


--------- Tabeau Tables -----------------

-- 1. 

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 AS death_perentage
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;

-- 2.

SELECT Location, SUM(new_deaths) as TotalDeathCount
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- 3.

SELECT continent AS Continent, Location, Population,  MAX(total_cases) AS highestInfectionCount,  MAX((total_cases / Population)) * 100 
	AS PercentPopulationInfected
FROM Portfolio_Project..CovidDeaths
--WHERE location like '%states'
GROUP BY continent, location, Population
ORDER BY PercentPopulationInfected DESC;