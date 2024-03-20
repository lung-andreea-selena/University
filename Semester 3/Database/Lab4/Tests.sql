USE [Student Organizations]

--procedure insert the tests into table Test
GO
CREATE OR ALTER PROCEDURE CreateTest @testName VARCHAR(50) 
AS
BEGIN
	IF EXISTS(SELECT* FROM Tests T WHERE Name = @testName)
	BEGIN
		RAISERROR('THIS TEST ALREADY EXISTS',10,1)
		RETURN
	END
	ELSE
		INSERT INTO Tests(Name) VALUES (@testName)
END


--procedure to add in Tables the tables that we will test (Student,Alliance,Organization,Volunteering)
GO
CREATE OR ALTER PROCEDURE AddTableToTable @tableName VARCHAR(50)
AS
BEGIN
	--check if the table exists
	IF NOT EXISTS(SELECT * FROM sys.tables WHERE name=@tableName)
	BEGIN
		RAISERROR( 'TABLE DOES NOT EXIST',16,2)
		RETURN 
	END
	--check if the table name is in the table Tables
	IF EXISTS(SELECT * FROM Tables T WHERE T.Name=@tableName)
	BEGIN
		RAISERROR( 'TABLE DOES NOT EXIST',10,3)
		RETURN
	END
	INSERT INTO Tables(Name) VALUES (@tableName)
END


--procedure that creates the TestTable (the connection between Tables and Test => the relation between many to many)
--inserting the tableName,testName,noOfRows,position
GO
CREATE OR ALTER PROCEDURE CreateTestTables @tableName VARCHAR(50),@testName VARCHAR(50),@noOfRows INT,@position INT
AS
BEGIN
	IF @noOfRows<=0
	BEGIN
		RAISERROR('NUMBER OF ROWS NEED TO BE MORE THAN 0',16,4)
		RETURN
	END
	IF @position<=0
	BEGIN
		RAISERROR('POSITION NEEDS TO BE AT LEAST 1',16,5)
		RETURN
	END
	DECLARE @testID INT, @tableID INT
	SET @testID=(SELECT T.TestID FROM Tests T WHERE T.Name=@testName)
	SET @tableID=(SELECT T.TableID FROM Tables T WHERE T.Name=@tableName)

	INSERT INTO TestTables(TestID,TableID,NoOfRows,Position) 
	VALUES (@testID,@tableID,@noOfRows,@position)
END


--procedure to add the views to View table
GO
CREATE OR ALTER PROCEDURE AddViewToView @viewName VARCHAR(50)
AS
BEGIN
	--check if the view exists
	IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_NAME=@viewName)
	BEGIN
		RAISERROR( 'VIEW DOES NOT EXIST',16,6)
		RETURN
	END
	--check if the view is already in the View
	IF EXISTS(SELECT * FROM Views WHERE Name=@viewName)
	BEGIN
		RAISERROR( 'VIEW ALREADY ADDED IN THE VIEW',16,7)
		RETURN
	END
	INSERT INTO Views(Name) VALUES (@viewName)
END

--procedure that creates the TestView (connection between Test and View)
--inserting viewName,testName
GO 
CREATE OR ALTER PROCEDURE CreateTestView @viewName VARCHAR(50),@testName VARCHAR(50) 
AS
BEGIN
	DECLARE @testID INT,@viewID INT
	SET @testID=(SELECT TestID FROM Tests T WHERE T.Name=@testName)
	SET @viewID=(SELECT ViewID FROM Views V WHERE V.Name=@viewName)
	INSERT INTO TestViews(TestID,ViewID) VALUES (@testID,@viewID)
END

--the big procedure that runs the tests
GO
CREATE OR ALTER PROCEDURE RunTest @testName VARCHAR(50) 
AS
BEGIN
	--extract the id from the test that we specified in @testName
	DECLARE @testID INT
	SET @testID=(SELECT T.TestID FROM Tests T WHERE T.Name=@testName)

	--variables for help
	DECLARE @tableID INT, @tableName VARCHAR(50),@noOfRows INT,
	@viewID INT, @viewName VARCHAR(50),
	@testRunID INT, @command VARCHAR(100),
	@currentTestStart DATETIME2, @currentTestEnd DATETIME2,
	@allTestsStart DATETIME2, @allTestsEnd DATETIME2

	--insert into testruns as description the name of the test that we are doing now
	INSERT INTO TestRuns(Description)VALUES(@testName)
	SET @testRunID=CONVERT(INT,(SELECT last_value FROM sys.identity_columns WHERE name='TestRunId'))

	--create a cursor scroll that is ordered by the position
	--we use cursor scroll in order to be able to go forward and back
	--we want to get through only the tables that are part of this test
	DECLARE TableCursor CURSOR SCROLL FOR
	SELECT T2.TableID,T2.Name,TT.NoOfRows 
	FROM TestTables TT
	INNER JOIN Tables T2 ON T2.TableID = TT.TableID
	WHERE TT.TestID = @testID
	ORDER BY TT.Position

	--create a cursor FOR VIEWS
	--we want to get through only the views that are part of this test
	DECLARE ViewCursor CURSOR FOR
	SELECT V.ViewID,V.Name
	FROM Views V
	INNER JOIN TestViews TV ON TV.ViewID=V.ViewID
	WHERE TV.TestID=@testID
	SET @allTestsStart=SYSDATETIME();
	
	--start to use the tableCursor
	OPEN TableCursor

	FETCH FIRST FROM TableCursor INTO @tableID, @tableName,@noOfRows

	WHILE @@FETCH_STATUS=0 -- while it did not reach the end
	BEGIN
		SET @currentTestStart=SYSDATETIME();

		--populate the tables
		SET @command = 'PopulateTable '+char(39)+@tableName+char(39)+','+CONVERT(VARCHAR(10),@noOfRows) --char(39) = '
		EXEC (@command)

		--the table test has ended
		SET @currentTestEnd=SYSDATETIME();

		--insert in TestRunTables the values obtained
		INSERT INTO TestRunTables VALUES(@testRunID,@tableID,@currentTestStart,@currentTestEnd)

		--we go further with the tables
		FETCH NEXT FROM TableCursor INTO @tableID,@tableName,@noOfRows
	END

	CLOSE TableCursor

	--same thing but on views
	OPEN ViewCursor
	FETCH FROM ViewCursor INTO @viewId,@viewName
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @currentTestStart=SYSDATETIME();
		DECLARE @commandV VARCHAR(250)
		SET @commandV='SELECT* FROM '+@viewName
		EXEC (@commandV)
		SET @currentTestEnd=SYSDATETIME();
		INSERT INTO TestRunViews VALUES(@testRunID,@viewID,@currentTestStart,@currentTestEnd)
		FETCH NEXT FROM ViewCursor INTO @viewID,@viewName
	END
	CLOSE ViewCursor
	DEALLOCATE ViewCursor

	--same but for deletin from the table
	OPEN TableCursor
	FETCH LAST FROM TableCursor INTO @tableID,@tableName,@noOfRows
	WHILE @@FETCH_STATUS=0
	BEGIN
		EXEC DeleteTable @tableName 
		FETCH PRIOR FROM TableCursor INTO @tableID,@tableName,@noOfRows
	END
	CLOSE TableCursor
	DEALLOCATE TableCursor

	SET @allTestsEnd = SYSDATETIME();
	
	UPDATE TestRuns
	SET StartAt=@allTestsStart, EndAt=@allTestsEnd
	WHERE TestRunID=@testRunID
END

SELECT * FROM Views
SELECT * FROM Tables
SELECT * FROM TestViews
SELECT * FROM Tests
SELECT * FROM TestTables 
SELECT * FROM TestRunTables
SELECT * FROM TestRuns
SELECT * FROM TestRunViews

DELETE FROM TestRuns
DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestViews
DELETE FROM TestTables 
DELETE FROM Views
DELETE FROM Tables
DELETE FROM Tests


--Test 1
EXEC CreateTest 'Test1'
EXEC AddTableToTable 'Student'
EXEC CreateTestTables 'Student','Test1',200,1
EXEC AddViewToView 'StudentAge'
EXEC CreateTestView 'StudentAge','Test1'
EXEC RunTest 'Test1'

--Test2
EXEC CreateTest 'Test2'
EXEC AddTableToTable 'Alliance'
EXEC AddTableToTable 'Organization'
EXEC CreateTestTables 'Alliance','Test2',300,1
EXEC CreateTestTables 'Organization','Test2',250,2
EXEC AddViewToView 'AllianceAndOrg'
EXEC CreateTestView 'AllianceAndOrg','Test2'
EXEC RunTest 'Test2'

--Test3
EXEC CreateTest 'Test3'
EXEC AddTableToTable 'Student'
EXEC AddTableToTable 'Alliance'
EXEC AddTableToTable 'Organization'
EXEC AddTableToTable 'Volunteering'
EXEC CreateTestTables 'Student','Test3',400,1
EXEC CreateTestTables 'Alliance','Test3',300,2
EXEC CreateTestTables 'Organization','Test3',250,3
EXEC CreateTestTables 'Volunteering','Test3',400,4
EXEC AddViewToView 'AvgAgeOrg'
EXEC CreateTestView 'AvgAgeOrg','Test3'
EXEC RunTest 'Test3'
