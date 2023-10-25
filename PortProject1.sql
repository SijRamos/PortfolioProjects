SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

--Total Cases vs Total Deaths
SELECT location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / total_cases)*100 AS DeathPercentage --total_deaths is NVARCHAR 
FROM CovidDeaths
WHERE location = 'Philippines'
ORDER BY 1,2


--Total Cases VS Population
SELECT location, date, total_cases, population, (CONVERT(float, total_cases) / population)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location = 'Philippines'
ORDER BY 1,2

--Countries with highest infection rate
SELECT location, population, MAX(total_cases) as HighestInfection, MAX((CONVERT(float, total_cases) / population)*100) AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--Countries with Highest Death Count per population
SELECT location, MAX(CONVERT(int,total_deaths)) AS TotalDeath
FROM CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY TotalDeath DESC

--Group by COntinent
SELECT location, MAX(CONVERT(int,total_deaths)) AS TotalDeath
FROM CovidDeaths
WHERE continent is NULL
GROUP BY location
ORDER BY TotalDeath DESC


--Global Numbers
SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS FLOAT)), SUM(CAST(new_deaths AS INT))/NULLIF(SUM(new_cases),0)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations


--Total population vs vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS TotalVaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3


--Creating View
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS TotalVaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
//ORDER BY 1,2,3