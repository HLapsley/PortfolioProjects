select *
from Portfolioproject1.dbo.CovidDeaths
order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from Portfolioproject1.dbo.CovidDeaths
order by 1,2


--Looking at Total Cases vs Toal Deaths
--Shows the likelihood of dying if you contract covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from Portfolioproject1.dbo.CovidDeaths
where location like '%canada%'
order by 1,2


-- Looking at the Total Cases vs Population
-- Shows what percentage of population got Covid

select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage 
from Portfolioproject1.dbo.CovidDeaths
where location like '%canada%'
order by 1,2


-- Looking at countries with highest infection Rate compared to Population

select location,population,MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as
	PercentPoluationInfected
from Portfolioproject1.dbo.CovidDeaths
group by location,population
order by PercentPoluationInfected desc


-- Showing Countries with Highest Death Count per Population

select location,Max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolioproject1.dbo.CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc


-- LET'S BREAK THINGS DOWN BY CONTINENT 


select continent,Max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolioproject1.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- Showing continents with the Highest Death Count per Population

select continent,Max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolioproject1.dbo.CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, 
 SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage 
from Portfolioproject1.dbo.CovidDeaths
where continent is not null
group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
from Portfolioproject1.dbo.CovidDeaths dea
join Portfolioproject1.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 


-- USE CTE

WITH PopvsVac (Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
from Portfolioproject1.dbo.CovidDeaths dea
join Portfolioproject1.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3 
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


-- Creating view to store data for later visualizations

Create view PercentPopulationVaccinated as 
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location,dea.date) 
	as RollingPeopleVaccinated
	--(RollingPeopleVaccinated/population)*100
from Portfolioproject1.dbo.CovidDeaths dea
join Portfolioproject1.dbo.CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3 