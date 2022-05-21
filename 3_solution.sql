-- 1. List each country name where the population is larger than that of 'Russia'. 
SELECT name
FROM world
    WHERE population > (
        SELECT population
        FROM world
            WHERE name = 'Russia'
    )

-- 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
    WHERE continent = 'Europe'
        AND gdp/population > (
            SELECT gdp/population
            FROM world
                WHERE name = 'United Kingdom'
        )

-- 3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world
    WHERE continent IN (
        SELECT continent
        FROM world
            WHERE name IN ('Argentina', 'Australia')
    )
ORDER BY
    name

-- 4. Which country has a population that is more than United Kingom but less than Germany? Show the name and the population.
SELECT name, population
FROM world
    WHERE population > (
        SELECT population
        FROM world
            WHERE name = 'United Kingdom'
    ) AND population < (
        SELECT population
        FROM world
            WHERE name = 'Germany'
    )

-- 5. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT 
    name
    ,CONCAT(round(population/(SELECT population FROM world WHERE name = 'Germany')*100), '%') as percentage
FROM world
    WHERE continent = 'Europe'

-- 6. Which countries have a GDP greater than every country in Europe? [Give the name only.] 
SELECT name
FROM world
    WHERE gdp > (
        SELECT MAX(gdp)
        FROM world 
            WHERE continent = 'Europe'
    )

/* Other suggestion using ALL
SELECT name, gdp
FROM world
WHERE gdp > ALL(SELECT gdp
             FROM world 
             WHERE continent = 'Europe' AND gdp > 0)
*/

-- 7. Find the largest country (by area) in each continent, show the continent, the name and the area.
SELECT continent, name, area
FROM world w1
    WHERE area >= ALL(
        SELECT area
        FROM world w2
            WHERE w1.continent = w2.continent
            AND area > 0
    )

-- 8. List each continent and the name of the country that comes first alphabetically.
SELECT continent, name
FROM world w1
    WHERE name <= ALL(
        SELECT name
        FROM world w2
            WHERE w1.continent = w2.continent
    )

-- 9. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population. 
SELECT w.name, w.continent, w.population
FROM world w
JOIN (
    SELECT continent, max(population) AS population
    FROM world
    GROUP BY continent
    HAVING max(population) <= 25000000
) tmp
    ON w.continent = tmp.continent

-- 10. Some countries have populations more than three times that of all of their neighbours (in the same continent). Give the countries and continents.
SELECT w1.name, w1.continent
FROM world w1
WHERE population > ALL(
    SELECT 3*population
    FROM world w2
    WHERE w1.continent = w2.continent
        AND w1.name <> w2.name
)
