USE Stud_Org

-- Validate Organization
GO
CREATE OR ALTER FUNCTION ValidateOrganization(@NameO VARCHAR(50))
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ERROR VARCHAR(100)
	SET @ERROR =''
	IF LEN(@NameO) < 3
	BEGIN
		SET @ERROR='ERROR FROM NameO, IT MUST HAVE AT LEAST 3 CHARACTERS'
	END
	RETURN @ERROR
END
GO

--Validate Student
GO
CREATE OR ALTER FUNCTION ValidateStudent(@NameS VARCHAR(50), @PointsContribution INT, @Age INT)
RETURNS VARCHAR(100)
AS
BEGIN
	DECLARE @ERROR VARCHAR(100)
	SET @ERROR=''
	IF LEN(@NameS) < 3
	BEGIN
		SET @ERROR='ERROR FROM NameS, IT MUST HAVE AT LEAST 3 CHARACTERS'
	END
	IF @PointsContribution < 0
	BEGIN
		SET @ERROR='ERROR FROM PointsContribution, IT MUST BE AT LEST 0'
	END
	IF @Age <18
	BEGIN
		SET @ERROR='ERROR FROM AGE, IT MUST BE AT LEAST 18'
	END
	RETURN @ERROR
END
GO

--Validate Volunteering (m:n rel)
GO
CREATE OR ALTER FUNCTION ValidateVolunteering(@OId int, @SId int)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @ERRORMESSAGE VARCHAR(200)
	SET @ERRORMESSAGE=''
	IF(NOT(EXISTS(SELECT * FROM Organization WHERE OId=@OId)))
		SET @ERRORMESSAGE = @ERRORMESSAGE + 'THERE IS NO ORGANIZATION WITH THIS ID'

	IF(NOT(EXISTS(SELECT* FROM Student WHERE SId=@SId)))
		SET @ERRORMESSAGE= @ERRORMESSAGE + 'THERE IS NO STUDENT WITH THIS ID'
	
	RETURN @ERRORMESSAGE
END
GO

CREATE TABLE LogTable
(
	Id INT PRIMARY KEY IDENTITY(1000,1),
	OperationType VARCHAR(20),
	TableName VARCHAR(20),
	ExecutionTime DATETIME,
)
--create a stored procedure that inserts data in tables that are in a m:n relationship; if one insert fails, all the operations performed by the procedure must be rolled back (grade 3)
GO
CREATE OR ALTER PROCEDURE InsertForGrade3
(
	@NameO VARCHAR(50),
	@NameS VARCHAR(50),
	@Telephone INT,
	@PointsContribution INT,
	@Age INT,
	@Since INT
)
AS
BEGIN
	BEGIN TRAN
	BEGIN TRY
		DECLARE @ERROR VARCHAR(200)
		SET @ERROR=''
		SET @ERROR=dbo.ValidateStudent(@NameS,@PointsContribution,@Age)
		IF @ERROR !=''
			RAISERROR(@ERROR,14,1)
		INSERT INTO Student(NameS,Telephone,PointsContribution,Age) VALUES (@NameS,@Telephone,@PointsContribution,@Age)
		INSERT INTO LogTable(OperationType,TableName,ExecutionTime) VALUES ('INSERT','STUDENT',GETDATE())
		DECLARE @SId int;
		SET @SId = (SELECT MAX(SID) FROM STUDENT);

		SET @ERROR = dbo.ValidateOrganization(@NameO)
		IF @ERROR != ''
			RAISERROR(@ERROR,1,1)
		INSERT INTO Organization(NameO) VALUES (@NameO)
		INSERT INTO LogTable(OperationType,TableName,ExecutionTime)VALUES ('INSERT','ORGANIZATION',GETDATE())
		DECLARE @OId INT;
		SET @OId = (SELECT MAX(OId) FROM Organization);

		SET @ERROR = dbo.ValidateVolunteering(@OId, @SId)
		IF @ERROR !=''
			RAISERROR(@ERROR,14,1)
		INSERT INTO Volunteering(OId,SId,Since) VALUES (@OId,@SId,@Since)
		INSERT INTO LogTable(OperationType,TableName,ExecutionTime) VALUES ('INSERT','VOLUNTEERING',GETDATE())

		COMMIT TRAN
		SELECT 'Transaction Commited'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction Rollbacked'
	END CATCH
END
GO

---
EXECUTE dbo.InsertForGrade3
	@NameO = 'OSFM3',

	@NameS = 'Pop Mihaela',
	@Telephone = 0745738794,
	@PointsContribution = 30,
	@Age = 22,

	@Since = 2022;

SELECT * FROM Organization
SELECT * FROM Student
SELECT * FROM Volunteering
SELECT * FROM LogTable

--- Wrong
EXECUTE dbo.InsertForGrade3
	@NameO = 'WRONG3',

	@NameS = 'Pop Mihaela',
	@Telephone = 0745738794,
	@PointsContribution = 30,
	@Age = 16,

	@Since = 2022;

SELECT * FROM Organization
SELECT * FROM Student
SELECT * FROM Volunteering
SELECT * FROM LogTable


---create a stored procedure that inserts data in tables that are in a m:n relationship; if an insert fails, try to recover as much as possible from the entire operation: for example, if the user wants to add a book and its authors, succeeds creating the authors, but fails with the book, the authors should remain in the database (grade 5);
GO
CREATE OR ALTER PROCEDURE InsertForGrade5
(
	@NameO VARCHAR(50),

	@NameS VARCHAR(50),
	@Telephone INT,
	@PointsContribution INT,
	@Age INT,

	@Since INT
)
AS
BEGIN
	DECLARE @ERROR1 VARCHAR(200)
	DECLARE @ERROR2 VARCHAR(200)
	DECLARE @ERROR3 VARCHAR(200)
	DECLARE @OId INT
	DECLARE @SId INT

	BEGIN TRAN
	BEGIN TRY
		SET @ERROR1=dbo.ValidateStudent(@NameS,@PointsContribution,@Age)
		IF @ERROR1 != ''
			RAISERROR(@ERROR1,14,1)
		INSERT INTO Student(NameS,Telephone,PointsContribution,Age) VALUES (@NameS,@Telephone,@PointsContribution,@Age)
		INSERT INTO LogTable(OperationType,TableName,ExecutionTime) VALUES ('INSERT','STUDENT',GETDATE())
		SET @SId = (SELECT MAX(SID) FROM STUDENT)

		COMMIT TRAN
		SELECT 'Transaction commited in table Student'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked in table Student'
	END CATCH

	BEGIN TRAN
	BEGIN TRY
		SET @ERROR2 = dbo.ValidateOrganization(@NameO)
		IF @ERROR2 !=''
			RAISERROR(@ERROR2,14,1)
		INSERT INTO Organization(NameO) VALUES (@NameO)
		INSERT INTO LogTable(OperationType,TableName,ExecutionTime)VALUES ('INSERT','ORGANIZATION',GETDATE())
		SET @OId = (SELECT MAX(OId) FROM Organization)

		COMMIT TRAN
		SELECT 'Transaction commited in table Organization'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked in table Organization'
	END CATCH

	BEGIN TRAN
	BEGIN TRY
	SET @ERROR3 = dbo.ValidateVolunteering(@OId,@SId)
	IF @ERROR3 !=''
			RAISERROR(@ERROR3,14,1)
	INSERT INTO Volunteering(OId,SId,Since) VALUES (@OId,@SId,@Since)
	INSERT INTO LogTable(OperationType,TableName,ExecutionTime) VALUES ('INSERT','VOLUNTEERING',GETDATE())

	COMMIT TRAN
		SELECT 'Transaction commited in table Volunteering'
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
		SELECT 'Transaction rollbacked in table Volunteering'
	END CATCH
END
GO

---
EXECUTE dbo.InsertForGrade5
	@NameO = 'OSFM5',

	@NameS = 'Pop Andreea',
	@Telephone = 0745738794,
	@PointsContribution = 30,
	@Age = 23,

	@Since = 2022;

SELECT * FROM Organization
SELECT * FROM Student
SELECT * FROM Volunteering
SELECT * FROM LogTable

---WRONG
EXECUTE dbo.InsertForGrade5
	@NameO = 'WRONG5',

	@NameS = 'Pop Andreea',
	@Telephone = 0745738794,
	@PointsContribution = 30,
	@Age = 1,

	@Since = 2022;

SELECT * FROM Organization
SELECT * FROM Student
SELECT * FROM Volunteering
SELECT * FROM LogTable
