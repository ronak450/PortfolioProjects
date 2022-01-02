select * from [Portfolio Project]..['Covid deaths$']
where continent is not null
order by 3,4


select location,date,total_cases,total_deaths,population 
from [Portfolio Project]..['Covid deaths$'] 
where continent is not null
order by 1,2



--Looking at Total Cases vs Total Deaths
--Shows likelihood of death when infested with covid in your country

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage 
from [Portfolio Project]..['Covid deaths$'] 
where location like '%INDIA%' order by 1,2



-- Looking at Total Cases vs Population
-- Shows the percentage of population got infected

select location,date,total_cases,population,(total_cases/population)*100 as DeathPercentage 
from [Portfolio Project]..['Covid deaths$'] 
where location like '%INDIA%' order by 1,2



-- Looking at countries with Highest Infection Rate with respect to Population

select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population))*100 as PopulationInfected
from [Portfolio Project]..['Covid deaths$']  
Group by location,population
order by PopulationInfected desc



-- Showing Countires with highest death count per Population

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..['Covid deaths$']
where continent is not null
Group by location
order by TotalDeathCount desc



-- Showing Continents with highest death count per Population

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project]..['Covid deaths$']
where continent is not null
Group by continent
order by TotalDeathCount desc



--GLOBAL NUMBERS

Select date, SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project]..['Covid deaths$']
where continent is not null
group by date
order by 1,2

Select SUM( new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [Portfolio Project]..['Covid deaths$']
where continent is not null
order by 1,2




Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
OVER(Partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..['Covid deaths$'] dea
join [Portfolio Project]..Covidvaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--and dea.location like '%india%'
order by 2,3




--USE CTE

with PopvsVac ( continent,location,date,population,new_vaccination,rollingpeoplevaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
OVER(Partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..['Covid deaths$'] dea
join [Portfolio Project]..Covidvaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(rollingpeoplevaccinated/population)*100
from PopvsVac




-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) 
OVER(Partition by dea.location order by dea.location,dea.date ) as RollingPeopleVaccinated
from [Portfolio Project]..['Covid deaths$'] dea
join [Portfolio Project]..Covidvaccinations$ vac
    on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated