/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

Select *
From CovidDeaths
Where continent is not null 
order by 3,4;

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, dat, Population, total_cases,(total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
order by 1,2;

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc;

-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc;

-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per populatio

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc;

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths
where continent is not null 
order by 1,2;


--LOOKING AT TOTAL POPULATION VS VACCINATIONS

select dea.continent, dea.location, dea.dat, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (PARTITION by dea.location order by dea.location,
  dea.dat) as Rollingpeoplevaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac. location
    and dea.dat = vac. dat
    where dea.continent is not null
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Dat, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.dat, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (PARTITION by dea.location order by dea.location,
  dea.dat) as Rollingpeoplevaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac. location
    and dea.dat = vac. dat
    where dea.continent is not null
--order by 2,3;
)
select(rollingpeoplevaccinated/population)*100
from popvsvac;


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.dat, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (PARTITION by dea.location order by dea.location,
  dea.dat) as Rollingpeoplevaccinated
from coviddeaths dea
join covidvaccinations vac
    on dea.location = vac. location
    and dea.dat = vac. dat
    where dea.continent is not null
order by 2,3;


--PERCENTPOPULATIONVACCINATED DETAILS
select*from percentpopulationvaccinated;
