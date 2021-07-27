Create database	Portafolio

use Portafolio

Select * from Covid_Death
order by 3,4

/*Select * from Covid_Vaccionation
order by 3,4 */

--Percentage of people that got covid:

Select d.location, d.total_cases, d.population , (d.total_cases/d.population)*100 as Infected_percentage from Covid_Death d
order by 4 DESC

/*Select avg(d.population) from Covid_Death d
where d.location = 'Andorra'
group by d.location*/

--Comparisson of countries witgh highest infection rate compared to population

Select d.location,d.population, max(d.total_cases) as Highest_Count,max(d.total_cases/d.population)*100 as MAX_RATE from Covid_Death d
group by d.location, d.population
order by 4 DESC;

-- Hightest death rate against population per country
						
Select  d.location, max (cast(d.total_deaths as INT)) MAX_Death_per_Country /*--Esto necesita ser un INT, para que se agrupe correctamente*/
from Covid_Death d
group by d.location
order by 2 DESC;


Select  d.location, (d.total_deaths/d.population)*100 as Covid_Death_rate from Covid_Death d
order by 2 DESC;

Select 


 
/*Select d.location,d.total_cases, v.population,(d.total_cases/v.population)*100 as Infected 
from Covid_Death d inner join Covid_Vaccionation v on d.location = v.location
order by 4 desc*/


--Death count by continent:

Select d.location, max(d.total_deaths) as Total_death_by_continent from Covid_Death d
where d.continent is null
group by d.location
order by 2 desc;



--Global numbers: Sacar el ratio de nuevos fallecidos con respecto a nuevas muertes

Select  d.location , /*,d.new_cases,d.new_deaths,*/ SUM(cast(d.new_deaths as INT))/sum(cast(d.new_cases as INT)) *100 as Death_Percentage 
from Covid_Death d
--where d.new_cases != 0
group by d.location  ,d.new_cases,d.new_deaths
order by 2 desc;

Select * from Covid_Death;




----Total population vs vaccinations ¿How many people in the world have been vaccinated?

Select * 
from Covid_Death dea
join Covid_Vaccionation vac
on dea.location = vac.location
and dea.date = vac.date       -- Join por doble condición

Select  dea.continent ,dea.location, dea.date ,dea.population, vac.new_vaccinations from Covid_Death dea
join Covid_Vaccionation vac
on dea.location = vac.location
and dea.date = vac.date       -- Join por doble condición
where dea.continent is not null
order by 2,3

--Sacando la suma agregaqda por nuevas vacunas:

Select  dea.continent ,dea.location, dea.date ,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as INT)) over (partition by dea.location order by dea.location,dea.date) as New_Vacc_Acumulated /*The order by it´s very importante*/
from Covid_Death dea
join Covid_Vaccionation vac
on dea.location = vac.location
and dea.date = vac.date      
where dea.continent is not null
order by 2,3

--Trabajando con esa nueva columna:

with deathpercentage  (continent, location, date, population, new_vaccinations, New_Vacc_Acumulated )

as (

Select  dea.continent ,dea.location, dea.date ,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as INT)) over (partition by dea.location order by dea.location,dea.date) as New_Vacc_Acumulated /*The order by it´s very importante*/
from Covid_Death dea
join Covid_Vaccionation vac
on dea.location = vac.location
and dea.date = vac.date       -- Se puede hacer un join por dos condiciones!
where dea.continent is not null
--order by 2,3)
)

Select *, death.New_Vacc_Acumulated/death.population *100 as Acumulated_percentage from deathpercentage death

--Creando vistas:

create View death_percentage_2 as 
Select dea.continent ,dea.location, dea.date ,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as INT)) over (partition by dea.location order by dea.location,dea.date) as New_Vacc_Acumulated /*The order by it´s very importante*/
from Covid_Death dea
join Covid_Vaccionation vac
on dea.location = vac.location
and dea.date = vac.date       -- Se puede hacer un join por dos condiciones!
where dea.continent is not null
--order by 2,3)

Select * from death_percentage_2

