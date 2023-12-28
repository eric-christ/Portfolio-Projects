--SELECT *
--FROM PortfolioProject..CovidDeaths
--WHERE Continent is not NULL
--ORDER BY 1,2

--SELECT *
--FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

-----	Select Data that I am going to use

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--ORDER BY 1,2

-----	Looking At Total Cases vs Total Deaths
-----	Likelihood of Dying if you contract covid in Indonesia
--SELECT location, date, total_cases, total_deaths,
--   CONVERT(DECIMAL(18, 5), (CONVERT(DECIMAL(18, 5), total_deaths) / CONVERT(DECIMAL(18, 5), total_cases)))*100 as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE Location like '%indonesia%'
--ORDER BY 1,2


-----	Looking at Total Cases vs Population
-----	Shows Percentage of Population that got COVID in Indonesia
--SELECT location, date, total_cases, population,
--   CONVERT(DECIMAL(18, 5), (CONVERT(DECIMAL(18, 5), total_cases) / CONVERT(DECIMAL(18, 5), population)))*100 as TotalCasesPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE Location like '%indonesia%'
--ORDER BY 1,2

-----	Looking at Countries with highest Infection Rate compared to Population
--SELECT location, population,
--   MAX(total_cases) AS HighestInfectionCount,
--   MAX(total_cases/population)*100 AS PercentPopulationInfected
--FROM PortfolioProject..CovidDeaths
--GROUP BY location, population
--ORDER BY 4 DESC 

-----	Showing Countries with the highest death count per Population
--SELECT location,
--   MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY location
--ORDER BY TotalDeathCount desc

-----	Break things by continent
--SELECT continent,
--   MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY continent
--ORDER BY TotalDeathCount desc


-----	IMPORTANT QUERY FOR VISUALIZATION
--SELECT location,
--   MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is NULL
--	AND location NOT LIKE '%income%'
--GROUP BY location
--ORDER BY TotalDeathCount desc

-----	Showing continents with the highest death count
--SELECT continent,
--   MAX(cast(total_deaths as int)) AS TotalDeathCount
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY continent
--ORDER BY TotalDeathCount desc

-----	Global Numbers per Day
--SELECT date, SUM(new_cases) total_cases, SUM(new_deaths) total_deaths, 
--       CASE WHEN SUM(new_cases) <> 0 
--            THEN (SUM(new_deaths)/SUM(new_cases))*100
--            ELSE 0
--       END as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
--GROUP BY date
--ORDER BY 1,2



-----	Global Numbers
--SELECT SUM(new_cases) total_cases, SUM(new_deaths) total_deaths, 
--       CASE WHEN SUM(new_cases) <> 0 
--            THEN (SUM(new_deaths)/SUM(new_cases))*100
--            ELSE 0
--       END as DeathPercentage
--FROM PortfolioProject..CovidDeaths
--WHERE continent is not NULL
----GROUP BY date
--ORDER BY 1,2

-----	Looking at Total Population vs Vaccinations per Day !!!
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(decimal(18,0), vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is NOT NULL
--ORDER BY 2,3



-----	CTE

--With PopvsVac(Continent, Location, Date, population, new_vaccinations, RollingPeopleVaccinated)
--as
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(decimal(18,0), vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is NOT NULL
--)

--SELECT *, (RollingPeopleVaccinated/Population)*100
--FROM PopvsVac



-----	TEMP TABLE
-- DROP Table if exists #PercentPopulationVaccinated
--CREATE TABLE #PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar(255),
--Date datetime,
--Population numeric,
--New_vaccinations numeric,
--RollingPeopleVacinated numeric
--)

--INSERT INTO #PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(decimal(18,0), vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is NOT NULL


--SELECT *, (RollingPeopleVacinated/Population)*100
--FROM #PercentPopulationVaccinated





----- Creating View to Store Data for Later Visualizations

--CREATE VIEW PercentPopulationVaccinated as
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(CONVERT(decimal(18,0), vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
--FROM PortfolioProject..CovidDeaths dea
--JOIN PortfolioProject..CovidVaccinations vac
--	ON dea.location = vac.location
--	and dea.date = vac.date
--WHERE dea.continent is NOT NULL

SELECT *
from PercentPopulationVaccinated