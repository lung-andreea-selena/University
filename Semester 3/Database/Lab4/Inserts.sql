USE [Student Organizations]
GO 

CREATE VIEW Randomizer
AS
SELECT RAND() AS Value

GO

--function to return a random integer between the range (lower,upper]
CREATE FUNCTION dbo.RandomInt(@lower INT, @upper INT) RETURNS INT
AS
BEGIN
    RETURN FLOOR((SELECT Value FROM Randomizer)*(@upper-@lower)+@lower);
END

--procedure to insert in Students (1 primary key)
GO
CREATE OR ALTER PROCEDURE InsertStudent @index INT
AS
BEGIN
	INSERT INTO Student
	VALUES(@index,'Deea'+CONVERT(VARCHAR(10),@index),0712345678,0,dbo.RandomInt(18,35))
END

--procedure to insert in Alliance (So that i can insert in Organization)
GO
CREATE OR ALTER PROCEDURE InsertAlliance @index INT 
AS
BEGIN
	INSERT INTO Alliance
	VALUES (@index, 'Alliance'+CONVERT(VARCHAR(10),@index),20)
END

--procedure to insert into Organization (1pk,1fk)
GO
CREATE OR ALTER PROCEDURE InsertOrganization @index INT
AS
BEGIN
	INSERT INTO Organization
	VALUES (@index, 'Organization'+CONVERT(VARCHAR(10),@index),(SELECT TOP 1 AId FROM Alliance ORDER BY NEWID()))
END

--procedure to insert into Volunteeering(2pk)
GO
CREATE OR ALTER PROCEDURE InsertVolunteering @index INT
AS
BEGIN
	DECLARE @SId INT, @OId INT
	WHILE 1=1
	BEGIN
		SET @SId=(SELECT TOP 1 SId FROM Student ORDER BY NEWID())
		SET @OId=(SELECT TOP 1 OId FROM Organization ORDER BY NEWID()) -- by using newid it helps us to get the last added id
		IF NOT EXISTS(SELECT 1 FROM Volunteering WHERE SId=@SId AND OId=@OId)
			BREAK
		ELSE
			PRINT('SOMETHING IS WRONG')
	END
	INSERT INTO Volunteering VALUES (@OId,@SId,dbo.RandomInt(1990,2023))
END

--procedure to insert into tables (the big procedure)
GO
CREATE OR ALTER PROCEDURE PopulateTable @tableName VARCHAR(50),@noOfRows INT 
AS
BEGIN
	DECLARE @currentRow INT, @command VARCHAR(100)
	SET @currentRow = 1
	WHILE @currentRow<=@noOfRows
		BEGIN
			SET @command = 'Insert'+@tableName+' '+CONVERT(VARCHAR(10),@currentRow)
			EXEC(@command)
			SET @currentRow=@currentRow+1
		END
END

--procedure for deleting from tables
GO
CREATE OR ALTER PROCEDURE DeleteTable @tableName VARCHAR(50)
AS
	EXEC('DELETE FROM '+@tableName)


--VIEWS
GO
--student that have age < 25
CREATE VIEW StudentAge
AS
SELECT S.NameS,S.Age
FROM Student S
WHERE S.Age <25

GO
-- right join to see the alliances and their organizations including the alliances that does not have an org assigned
CREATE VIEW AllianceAndOrg 
AS
SELECT DISTINCT O.NameO,A.NameA
FROM Organization O RIGHT JOIN Alliance A ON A.AId=O.AId

GO
--Find the organizations with an average student age greater than 24
CREATE VIEW AvgAgeOrg 
AS
SELECT O.OId, O.NameO, AVG(S.Age) AS AvgAge
FROM Student S
JOIN Volunteering V ON S.SId = V.SId
JOIN Organization O ON V.OId = O.OId
GROUP BY O.OId, O.NameO
HAVING AVG(S.Age) > 24

GO

--THINGS FOR TESTING IF EVERYTHING WORKS

--eg to test the 2nd view
DELETE FROM Organization
DELETE FROM Alliance
INSERT INTO Alliance(AId,NameA,Years) 
	VALUES (1,'ANOSR',18),(2,'ESU',21),(3,'AUVT',15),(4,'ASDF',30)

INSERT INTO Organization(OId,NameO,AId) 
	VALUES(1,'OSUBB',1),(2,'ASC',1),(3,'OSP',2),(4,'ASP',2),(5,'OSUT',3)
SELECT DISTINCT O.NameO,A.NameA
FROM Organization O RIGHT JOIN Alliance A ON A.AId=O.AId

--rest
EXEC PopulateTable 'Student',20
EXEC PopulateTable 'Alliance',20
EXEC PopulateTable 'Organization',10
EXEC PopulateTable 'Volunteering',5

SELECT* FROM Student
SELECT* FROM Alliance
SELECT* FROM Organization
SELECT* FROM Volunteering

EXEC DeleteTable 'Volunteering'
EXEC DeleteTable 'Student'
EXEC DeleteTable 'Organization'
EXEC DeleteTable 'Alliance'
