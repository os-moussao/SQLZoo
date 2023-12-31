/*
Working with Self JOIN
https://sqlzoo.net/wiki/Self_join
database: https://sqlzoo.net/wiki/Edinburgh_Buses
*/

--#1
/*
  How many stops are in the database. 
*/

SELECT COUNT(*) FROM stops


--#2
/*
  Find the id value for the stop 'Craiglockhart' 
*/

SELECT id FROM stops WHERE name = 'Craiglockhart' 


--#3
/*
  Give the id and the name for the stops on the '4' 'LRT' service. 
*/

SELECT stop.*
FROM stops stop
JOIN route ON route.stop = stop.id
WHERE num = '4' AND company = 'LRT'


--#4
/*
  The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
  Run the query and notice the two services that link these stops have a count of 2.
  Add a HAVING clause to restrict the output to these two routes.
*/

SELECT company, num, COUNT(*) AS visits
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING visits = 2


--#5
/*
The shown query gives all the places you can get to from Craiglockhart (53), without changing routes:
  SELECT a.company, a.num, a.stop, b.stop
  FROM route a JOIN route b ON
    (a.company=b.company AND a.num=b.num)
  WHERE a.stop=53
Change the query so that it shows the services from Craiglockhart to London Road.
*/

SELECT a.company, a.num, a.stop, b.stop
FROM route a
JOIN route b ON
  (a.company=b.company AND a.num=b.num)
JOIN stops stop ON
  (stop.id = b.stop AND stop.name = 'London Road')
WHERE a.stop=53


--#6
/*
  The query shown is similar to the previous one,
  however by joining two copies of the stops table
  we can refer to stops by name rather than by number:
    SELECT a.company, a.num, stopa.name, stopb.name
    FROM route a JOIN route b ON
      (a.company=b.company AND a.num=b.num)
      JOIN stops stopa ON (a.stop=stopa.id)
      JOIN stops stopb ON (b.stop=stopb.id)
    WHERE stopa.name='Craiglockhart'
  Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
*/

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road'


--#7
/*
  Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith') 
*/

SELECT DISTINCT r1.company, r1.num
FROM route r1
JOIN route r2 ON (r1.num, r1.company) = (r2.num, r2.company)
JOIN stops a ON r1.stop = a.id AND a.id = 115
JOIN stops b ON r2.stop = b.id AND b.id = 137


--#8
/*
  Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross' 
*/

SELECT DISTINCT r1.company, r1.num
FROM route r1
JOIN route r2 ON (r1.num, r1.company) = (r2.num, r2.company)
JOIN stops a ON r1.stop = a.id AND a.name = 'Craiglockhart'
JOIN stops b ON r2.stop = b.id AND b.name = 'Tollcross'


--#9
/*
  Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
  including 'Craiglockhart' itself, offered by the LRT company.
  Include the company and bus no. of the relevant services. 
*/

SELECT r1.company, r1.num, a.name, b.name
FROM route r1
JOIN route r2 ON (r1.num, r1.company) = (r2.num, r2.company)
JOIN stops a ON r1.stop = a.id AND a.name = 'Craiglockhart'
JOIN stops b ON r2.stop = b.id


--#10
/*
  Find the routes involving two buses that can go from Craiglockhart to Lochend.
  Show the bus no. and company for the first bus, the name of the stop for the transfer,
  and the bus no. and company for the second bus.
*/

SELECT r1.num, r1.company, c.name, r3.num, r3.company
FROM route r1
JOIN route r2 ON (r1.num, r1.company) = (r2.num, r2.company)
JOIN stops a ON r1.stop = a.id AND a.name = 'Craiglockhart'
JOIN stops b ON r2.stop = b.id
JOIN route r3
JOIN route r4 ON (r3.num, r3.company) = (r4.num, r4.company)
JOIN stops c ON r3.stop = c.id AND c.id = b.id
JOIN stops d ON r4.stop = d.id AND d.name = 'Lochend'

