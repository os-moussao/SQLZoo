/*
How to use SELECT statements within SELECT statements to perform more complex queries. 
https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
*/

/*
  1. List each country name where the population is larger than that of 'Russia'.
*/

SELECT name FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia')


/*
  2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
*/

SELECT name FROM world
WHERE
  continent = 'Europe' AND
  gdp/population > (
    SELECT gdp/population FROM world
    WHERE name = 'United Kingdom'
  )


/*
  3. List the name and continent of countries in the continents containing either Argentina or Australia.
      Order by name of the country.
*/

SELECT name, continent FROM world
WHERE
  continent IN (
    SELECT continent FROM world
    WHERE name IN ('Argentina', 'Australia')
  )
ORDER BY name


/*
  4. Which country has a population that is more than United Kingdom but less than Germany?
  Show the name and the population.
*/

SELECT name, population FROM world
WHERE
  population > (
    SELECT population from world WHERE name = 'United Kingdom'
  ) AND
  population < (
    SELECT population from world WHERE name = 'Germany'
  )


/*
  5. Germany (population 80 million) has the largest population of the countries in Europe.
  Austria (population 8.5 million) has 11% of the population of Germany. 
  
  Show the name and the population of each country in Europe.
  Show the population as a percentage of the population of Germany.
*/

SELECT
  name,
  CONCAT(
    ROUND((population * 100) / (
      SELECT population FROM world
      WHERE name = 'Germany'
    ), 0),
    '%'
  ) AS percentage
FROM world
WHERE continent = 'Europe'


/*
  6. Which countries have a GDP greater than every country in Europe?
*/

SELECT name FROM world
WHERE gdp > ALL(
  SELECT gdp FROM world
  WHERE continent = 'Europe'
)

SELECT name FROM world
WHERE gdp > (
  SELECT gdp FROM world
  WHERE continent = 'Europe'
  ORDER BY gdp DESC
  LIMIT 1
)


/*
  7. Find the largest country (by area) in each continent.
    Show the continent, the name and the area.
    use: sql correlated subqueries
*/

SELECT continent, name, area FROM world country1
WHERE country1.area >= ALL(
  SELECT area FROM world country2
  WHERE country2.continent = country1.continent
)


/*
  8. List each continent and the name of the country that comes first alphabetically.
*/

SELECT continent, name FROM world country1
WHERE country1.name <= ALL(
  SELECT name FROM world country2
  WHERE country2.continent = country1.continent
)


/*
  9. Find the continents where all countries have a population <= 25000000.
  Then find the names of the countries associated with these continents.
  Show name, continent and population. 
*/

SELECT name, continent, population FROM world country1
WHERE (
  SELECT COUNT(*) FROM world country2
  WHERE population <= 25000000 AND country2.continent = country1.continent
) = (
  SELECT COUNT(*) FROM world country2
  WHERE country2.continent = country1.continent
)

-- a better way
SELECT name, continent, population FROM world country1
WHERE 25000000 > ALL(
  SELECT population FROM world country2
  WHERE country1.continent = country2.continent
)


/*
  10. Some countries have populations more than three times that of all of their neighbours
  (in the same continent). Give the countries and continents.
*/

SELECT name, continent FROM world country1
WHERE country1.population >= ALL(
  SELECT 3 * population FROM world country2
  WHERE country1.continent = country2.continent AND
  country1.name <> country2.name
)
