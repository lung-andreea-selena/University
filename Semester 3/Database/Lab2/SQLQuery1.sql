USE [Student Organizations]
GO

DELETE FROM WorksOn
DELETE FROM Task
DELETE FROM MadeBy
DELETE FROM Project
DELETE FROM PartOf
DELETE FROM Department
DELETE FROM Volunteering
DELETE FROM Student
DELETE FROM Organization
DELETE FROM Alliance
GO

INSERT INTO Alliance(AId,NameA,Years) 
	VALUES (1,'ANOSR',18),(2,'ESU',21),(3,'AUVT',15),(4,'ASDF',30)

INSERT INTO Organization(OId,NameO,AId) 
	VALUES(1,'OSUBB',1),(2,'ASC',1),(3,'OSP',2),(4,'ASP',2),(5,'OSUT',3)

--INSERT INTO Organization(OId,Name,AId) 
	--VALUES('Invalid',2)

INSERT INTO Student(SId,NameS,Telephone,PointsContribution,Age) 
	VALUES(1,'Lung Andreea',0726328798,100, 20), (2,'Oltyan Octavian',0721752492,50,19), (3,'Lazar Bianca',NULL,20,18),(4,'Matisan Rares',NULL,170,22),
	(5,'Vlad Dobrea',0749893020,40,19),(6,'Antonio Stan',NULL,80,23)

INSERT INTO Volunteering(OId,SId,Since) 
	VALUES (1,1,2022),(1,2,2023),(1,3,2023),(1,4,2021),(2,5,2020),(2,6,2022)

INSERT INTO Department(DId,NameD,OId) 
	VALUES(1,'Human Resources',1),(2,'Youth',1),(3,'Fundraising',1),(4,'Projects writer',1),(5,'Img & Pr',1),
	(6,'Human Resources',2),(7,'Youth',2),(8,'Fundraising',2),(9,'Projects writer',2),(10,'Img & Pr',2)

INSERT INTO PartOf(DId,SId,Since) 
	VALUES (1,1,2023) , (2,1,2023),(3,1,2024), (1,2,2022),(2,2,2022), (3,3,2023),(1,4,2021),(3,4,2022),(6,5,2022),(6,6,2019),(7,6,2020)

INSERT INTO Project(PId,NameP,DateP)
	VALUES (1,'CaravanaUBB','2024-02-19'),(2,'Trix','2023-12-04')

INSERT INTO MadeBy(DId,PID) --Caravana is made by youth and img&pr and trix by human resources,fundraising and img&pr
	VALUES(2,1),(5,1),(1,2),(3,2),(5,2)

INSERT INTO Task(TId,DescriptionT,Deadline,StatusT,PId)
	VALUES(1,'Write the script','2023-11-30','in progress',1),(2,'Make the presentation','2023-12-30','not started',1),(3,'Give all to feedback','2024-01-04','in progress',1),
	(4,'Make post on instagram','2023-11-10','in progress',2),(5,'Reseve a place','2023-11-02','finished',2)

INSERT INTO WorksOn(TId,SId)
	VALUES(1,1),(2,1),(3,3),(4,2),(3,4)

--UPDATE
SELECT *
FROM Organization
UPDATE Organization 
SET NameO = 'ASB'
WHERE NameO = 'ASC' AND AId = 1

SELECT *
FROM Student
UPDATE Student
SET PointsContribution = PointsContribution +10
WHERE Telephone IS NOT NULL

SELECT *
FROM Task
UPDATE Task --update the status for the tasks that are between 01 nov and 01 dec to finished 
SET StatusT = 'finished'
WHERE StatusT LIKE '%in progress%' AND Deadline BETWEEN '2023-11-01' AND '2023-12-01'

--DELETE

INSERT INTO Student(SId,NameS,Telephone,PointsContribution,Age) 
	VALUES(7,'Maric Razvan',0729032109,0,30),(8,'Obis Luca',NULL,10,31)

DELETE
FROM Student
WHERE PointsContribution <=10 AND (Age = 30 OR Age =31)

INSERT INTO Department(DId,NameD, OId) VALUES (11,'Amusement',1), (12,'Nothingnt',1)
INSERT INTO MadeBy(Did,PId) VALUES (11,1), (12,2)

DELETE
FROM MadeBy
WHERE DId = 11 OR Did= 12

DELETE
FROM Department
WHERE NameD LIKE 'nt%'


--a. 2 queries with the union operation; use UNION [ALL] and OR

--students names that are volunteering since 2022 or later in osubb or osut
SELECT S.NameS,V.Since,V.OId
FROM Student S,Volunteering V
WHERE S.SId= V.SId AND V.Since >=2022 AND V.OId = 1
UNION
SELECT S2.NameS,V2.Since,V2.OId
FROM Student S2,Volunteering V2
WHERE S2.SId=V2.SId AND V2.Since >=2022 AND V2.OId=2

--Tasks that are from Caravana or are in progress
SELECT DISTINCT T.DescriptionT
FROM Task T, Project P
WHERE (T.PId = P.PId AND P.NameP = 'CaravanaUBB') OR T.StatusT='in progress'


--b. 2 queries with the intersection operation; use INTERSECT and IN;

-- Find students who are part of both Human Resources and Youth departments in OSUBB
SELECT S.NameS
FROM Student S, PartOf P, Department D, Organization O
WHERE S.SId = P.SId AND P.DId = D.DId AND D.OId = O.OId AND O.OId = 1 AND D.NameD = 'Human Resources'
INTERSECT
SELECT S2.NameS
FROM Student S2, PartOf P2, Department D2, Organization O2
WHERE S2.SId = P2.SId AND P2.DId = D2.DId AND D2.OId = O2.OId AND O2.OId = 1 AND D2.NameD = 'Youth'

--using IN instead of INTERSECT
SELECT S.NameS
FROM Student S, PartOf P, Department D, Organization O
WHERE S.SId = P.SId AND P.DId = D.DId AND D.OId = O.OId AND O.OId = 1 AND D.NameD = 'Human Resources' 
AND S.SId IN (
        SELECT S2.SId
        FROM Student S2, PartOf P2, Department D2, Organization O2
        WHERE S2.SId = P2.SId AND P2.DId = D2.DId AND D2.OId = O2.OId AND O2.OId = 1 AND D2.NameD = 'Youth')


--c. 2 queries with the difference operation; use EXCEPT and NOT IN;

--Find students who are part of Human Resources but not Youth departments in ASC
SELECT S.NameS
FROM Student S, PartOf P, Department D, Organization O
WHERE S.SId = P.SId AND P.DId = D.DId AND D.OId = O.OId AND O.OId = 2 AND D.NameD = 'Human Resources'
EXCEPT
SELECT S2.NameS
FROM Student S2, PartOf P2, Department D2, Organization O2
WHERE S2.SId = P2.SId AND P2.DId = D2.DId AND D2.OId = O2.OId AND O2.OId = 2 AND D2.NameD = 'Youth'

-- same but with NOT IN
SELECT S.NameS
FROM Student S, PartOf P, Department D, Organization O
WHERE S.SId = P.SId AND P.DId = D.DId AND D.OId = O.OId AND O.OId = 2 AND D.NameD = 'Human Resources' 
AND S.SId NOT IN (
        SELECT S2.SId
        FROM Student S2, PartOf P2, Department D2, Organization O2
        WHERE S2.SId = P2.SId AND P2.DId = D2.DId AND D2.OId = O2.OId AND O2.OId = 2 AND D2.NameD = 'Youth')


--d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); 
--one query will join at least 3 tables, while another one will join at least two many-to-many relationships;

--INNER JOIN
SELECT*
FROM Student S INNER JOIN PartOf P ON S.SId=P.SId
INNER JOIN Department D ON P.DId = D.DId
INNER JOIN Organization O ON O.OId=D.OId

--LEFT JOIN
SELECT *
FROM Organization O LEFT JOIN Department D ON O.OId=D.OId

--RIGHT JOIN
SELECT *
FROM Organization O RIGHT JOIN Alliance A ON A.AId=O.AId

--FULL JOIN
-- Tasks that are made by students in an organization
SELECT O.NameO,S.NameS,T.DescriptionT
FROM Organization O FULL JOIN Volunteering V ON O.OId = V.OId
FULL JOIN Student S ON V.SId=S.SId
FULL JOIN WorksOn W ON S.SId=W.SId
FULL JOIN Task T ON W.TId = T.TId


--e. 2 queries with the IN operator and a subquery in the WHERE clause; in at least one case, the subquery must include a subquery in its own WHERE clause;

--find the departments that are involved into making a project and have tasks finished
SELECT D.NameD
FROM Department D
WHERE D.DId IN(
	SELECT M.DId
	FROM MadeBy M
	WHERE M.PID IN(
		SELECT P.PId
		FROM Project P
		WHERE P.PId IN(
			SELECT T.PId
			FROM Task T
			WHERE T.StatusT = 'finished'
			)
		)
	)

--students that are volunteering into an organization that is member of ANOSR and have pointContribution>50
SELECT S.NameS
FROM Student S
WHERE S.PointsContribution >50 AND S.SId IN(
	SELECT V.SId
	FROM Volunteering V
	WHERE V.OId IN(
		SELECT O.OId
		FROM Organization O
		WHERE O.AId IN(
			SELECT A.AId
			FROM Alliance A
			WHERE A.NameA = 'ANOSR')
		)
	)



--f. 2 queries with the EXISTS operator and a subquery in the WHERE clause
--departments that are involved in making CaravanaUbb
SELECT D.NameD
FROM Department D
WHERE EXISTS(
	SELECT *
	FROM MadeBy M
	WHERE D.DId=M.DId AND EXISTS (
		SELECT *
		FROM Project P
		WHERE P.NameP='CaravanaUBB' AND P.PId = M.PID
		)
	)

--students that work on a task that is 'in progress' and have the age >= 20
SELECT DISTINCT S.NameS, S.Age
FROM Student S
WHERE S.Age >= 20 AND EXISTS(
	SELECT*
	FROM WorksOn W
	WHERE W.SId = S.SId AND EXISTS(
		SELECT*
		FROM Task T
		WHERE T.TId=W.TId AND T.StatusT = 'in progress')
		)


--g. 2 queries with a subquery in the FROM clause
--students that are older than 18 years old and have points contribution>20 which volunteer in osubb
SELECT s.NameS,s.Age
FROM(
	SELECT*
	FROM Student S
	WHERE S.Age >18 AND S.PointsContribution >20
	)s WHERE EXISTS(
		SELECT* 
		FROM Volunteering V
		WHERE V.SId= s.SId AND EXISTS (
			SELECT*
			FROM Organization O
			WHERE V.OId = O.OId AND O.NameO = 'OSUBB')
			)

--projects that start later than 2024-01-01 which have tasks that are not started
SELECT p.NameP
FROM(
	SELECT*
	FROM Project P
	WHERE P.DateP > '2024-01-01'
	)p WHERE EXISTS(
	SELECT*
	FROM Task T
	WHERE T.PId = p.PId AND T.StatusT='not started')


--h. 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
--2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

----Count the number of departments in which the students are part of (those who are in more than 2)
SELECT P.SId, COUNT(*) NoOfDep 
From PartOf P
GROUP BY P.SId
HAVING COUNT(*) > 2

--Find the organizations with an average student age greater than 18
SELECT O.OId, O.NameO, AVG(S.Age) AS AvgAge
FROM Student S
JOIN Volunteering V ON S.SId = V.SId
JOIN Organization O ON V.OId = O.OId
GROUP BY O.OId, O.NameO
HAVING AVG(S.Age) > 18

--the organizations that have a sum of pointscontribution bigger than 90 and have AId=1
SELECT O.NameO, SUM(S.PointsContribution) AS SumPointsContribution
FROM Organization O
JOIN Volunteering V ON O.OId = V.OId
JOIN Student S ON V.SId = S.SId
WHERE O.AId = 1
GROUP BY O.NameO
HAVING 90 < (
    SELECT SUM(S2.PointsContribution)
    FROM Organization O2
    JOIN Volunteering V2 ON O2.OId = V2.OId
    JOIN Student S2 ON V2.SId = S2.SId
    WHERE O2.AId = 1
)
--the max age for each organization that is a member of the first alliance
SELECT O.NameO, MAX(S.Age) AS MaxStudentAge
FROM Organization O
JOIN Volunteering V ON O.OId = V.OId
JOIN Student S ON V.SId = S.SId
WHERE O.AId = 1
GROUP BY O.NameO
HAVING MAX(S.Age) > (
    SELECT AVG(S2.Age)
    FROM Organization O2
    JOIN Volunteering V2 ON O2.OId = V2.OId
    JOIN Student S2 ON V2.SId = S2.SId
    WHERE O2.AId = 1
)


-- 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator); 
--rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.

--top 3 students with the biggest points of contribution that have at least 18 years old
--which has more points than the least
SELECT TOP 3 S.*
FROM Student S
WHERE S.Age > 18 AND S.PointsContribution > ANY(
	SELECT S2.PointsContribution
	FROM Student S2
	WHERE S2.Age >18)
ORDER BY S.PointsContribution DESC

--rewrite with MIN
SELECT TOP 3 S.*
FROM Student S
WHERE S.Age > 18 AND S.PointsContribution >(
	SELECT MIN(S2.PointsContribution)
	FROM Student S2
	WHERE S2.Age> 18)
ORDER BY S.PointsContribution DESC

--find the students that volunteer since 2021 or later
SELECT S.NameS, V.Since
FROM Student S
JOIN Volunteering V ON S.SId = V.SId
WHERE S.SId = ANY (  --ANY operator to check if the SId from the outer query matches any SId values in the result set of the subquery
    SELECT V2.SId
    FROM Volunteering V2
    WHERE V2.Since >= 2021)

--rewrite with IN
SELECT S.NameS, V.Since
FROM Student S
JOIN Volunteering V ON S.SId = V.SId
WHERE S.SId IN (  
    SELECT V2.SId
    FROM Volunteering V2
    WHERE V2.Since >= 2021)

--top 2 in asc order that have points contribution> someone called Octavian
SELECT TOP 2 S.*
FROM Student S
WHERE S.PointsContribution > ALL(
	SELECT S2.PointsContribution
	FROM Student S2
	WHERE S2.NameS='Oltyan Octavian')
ORDER BY S.PointsContribution ASC

--rewrite witn MAX
SELECT TOP 2 S.*
FROM Student S
WHERE S.PointsContribution >(
	SELECT MAX(S2.PointsContribution)
	FROM Student S2
	WHERE S2.NameS='Oltyan Octavian')
ORDER BY S.PointsContribution ASC











