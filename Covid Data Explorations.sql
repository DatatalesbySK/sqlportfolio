select *
From portfoliosql..coviddeaths
Where continent is  not null
Order By 3,4

--select *
--From portfoliosql..covidVaccinations
--Order By 3,4

--Select Data that we are going to be using

Select Location,date,total_cases,new_cases,total_deaths,population
From portfoliosql..coviddeaths
Where continent is  not null
Order By 1,2


-- Looking at Total Cases Vs Total Deaths
-- shows likelihood of dying if you contact covid in your country

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From portfoliosql..coviddeaths
Where location like '%India%'
and continent is not null
Order By 1,2

-- Looking at Total Cases vs Population
-- shows what percenatge of population got Covid

Select Location,date,total_cases,population,(total_cases/population)*100 as PercentPopoltaionInfected
From portfoliosql..coviddeaths
--Where location like '%India%'
WHERE continent is  not null
Order By 1,2


--Looking at Countries with Highest Infection Rate Compared to Popultaion

Select Location,population,MAX(total_cases) as HighestInfectionCount ,Max((total_cases/population))*100 as PercentPopoltaionInfected
From portfoliosql..coviddeaths
Group By Location,population
Order By PercentPopoltaionInfected DESC

-- Showing Countries with Highest Death Count per population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfoliosql..coviddeaths
Where continent is  not null
Group By Location
Order By TotalDeathCount DESC

-- LET'S BREAK THINGS DOWN BY CONTINENT

-- Showing the continents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From portfoliosql..coviddeaths
Where continent is not null
Group By continent
Order By TotalDeathCount DESC


-- GLOBAL NUMBERS

Select date,Sum(new_cases) as TotalNewCases,Sum(cast(new_deaths as int)) as TotalNewDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From portfoliosql..coviddeaths
--Where location like '%India%'
Where continent is not null
Group By date
Order By 1,2

Select Sum(new_cases) as TotalNewCases,Sum(cast(new_deaths as int)) as TotalNewDeaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From portfoliosql..coviddeaths
--Where location like '%India%'
Where continent is not null
Order By 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations)) 
over(Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
From portfoliosql..Coviddeaths dea
Join portfoliosql..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
Order By 2,3


-- USE CTE

With PopVsVac
As
(
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int, ISNULL(vac.new_vaccinations,0)))
over(
     Partition by dea.location
     Order by dea.location,dea.date
    ) as RollingPeopleVaccinated

From portfoliosql..Coviddeaths dea
Join portfoliosql..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null
)
Select *,Round((RollingPeopleVaccinated/population)*100,2) From PopVsVac


-- TEMP TABLE 

Drop Table if exists #PercentPopulationVaccinateed
Create Table #PercentPopulationVaccinateed
(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric

)

Insert into #PercentPopulationVaccinateed

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations))
over(
     Partition by dea.location
     Order by dea.location,dea.date
    ) as RollingPeopleVaccinated

From portfoliosql..Coviddeaths dea
Join portfoliosql..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null

Select *,Round((RollingPeopleVaccinated/population)*100,2)
From #PercentPopulationVaccinateed



-- Creating View to store data for later visualisation

Create View PercentPopulationVaccinated as
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int, vac.new_vaccinations))
over(
     Partition by dea.location
     Order by dea.location,dea.date
    ) as RollingPeopleVaccinated

From portfoliosql..Coviddeaths dea
Join portfoliosql..CovidVaccinations vac
   On dea.location = vac.location
   and dea.date = vac.date
Where dea.continent is not null