USE [Student Organizations]
GO
--a) modify a type of column
CREATE OR ALTER PROCEDURE uspSetTypeAgeStudentToSmallInt --1 to 2
AS
	ALTER TABLE Student
	ALTER COLUMN Age SMALLINT NOT NULL
GO
CREATE OR ALTER PROCEDURE uspSetTypeAgeStudentToInt--2 to 1
AS
	ALTER TABLE Student
	ALTER COLUMN Age INT
GO

--b) add/remove a column
CREATE OR ALTER PROCEDURE uspAddColumnCityOrganization--2 to 3
AS
	ALTER TABLE Organization
	ADD City VARCHAR(50)
GO
CREATE OR ALTER PROCEDURE uspRemoveColumnCityOrganization--3 to 2
AS
	ALTER TABLE Organization
	DROP COLUMN City
GO

--c) add / remove a DEFAULT constraint
CREATE OR ALTER PROCEDURE uspAddDefaultConstraintStudentPoints--3 to 4
AS
	ALTER TABLE Student
	ADD CONSTRAINT default_points DEFAULT(0) FOR PointsContribution
GO
CREATE OR ALTER PROCEDURE uspRemoveDefaultConstraintStudentPoints--4 to 3
AS
	ALTER TABLE Student
	DROP CONSTRAINT default_points
GO

--d) add / remove a primary key
--To modify a primary key,
--you usually have to drop the existing primary key constraint

CREATE OR ALTER PROCEDURE uspAddPrimaryKeyAllianceNameA--4 to 5
AS
	ALTER TABLE Specialization
	ADD CONSTRAINT SPECIALIZATION_PRIMARY_KEY PRIMARY KEY(SpId)
GO
CREATE OR ALTER PROCEDURE uspRemovePrimaryKeyAllianceNameA--5 to 4
AS
	ALTER TABLE Specialization
	DROP CONSTRAINT SPECIALIZATION_PRIMARY_KEY
GO

--e) add/ remove a candidate key
--A candidate key is a column or a set of columns in a table that can uniquely identify a record. 
--It means that the columns within a candidate key satisfy the uniqueness constraint. 
--From the candidate keys, one is selected as the primary key. 
--Therefore, a candidate key that is not chosen as the primary key becomes an alternate key.

CREATE OR ALTER PROCEDURE uspAddCandidateKeyProject--5 to 6
AS
	ALTER TABLE Project
	ADD CONSTRAINT PROJECT_CANDIDATE_KEY UNIQUE(NameP)
GO
CREATE OR ALTER PROCEDURE uspRemoveCandidateKeyProject--6 to 5
AS
	ALTER TABLE Project
	DROP CONSTRAINT PROJECT_CANDIDATE_KEY

GO

--f) add/remove a foreign key
CREATE OR ALTER PROCEDURE uspAddForeignKeyProject--6 to 7
AS
	ALTER TABLE Specialization
	ADD CONSTRAINT SPECIALIZATION_FOREIGN_KEY FOREIGN KEY(SId) REFERENCES Student(SId)
GO
CREATE OR ALTER PROCEDURE uspRemoveForeignKeyProject--7 to 6
AS
	ALTER TABLE Specialization
	DROP CONSTRAINT SPECIALIZATION_FOREIGN_KEY
GO

--g) create/drop a table
CREATE OR ALTER PROCEDURE uspCreateTable--7 to 8
AS
	CREATE TABLE Specialization(
		SpId INT NOT NULL,
		NameSp VARCHAR(50) NOT NULL,
		Since INT,
		SId INT)
GO
CREATE OR ALTER PROCEDURE uspDropTable--8 to 7
AS
	DROP TABLE Specialization


--a table that contains the current version of the database schema

CREATE TABLE versionTable(
	versionNo INT)

INSERT INTO versionTable
VALUES (1) --INITIAL VERSION

--DROP TABLE versionTable

--a table that contains the initial version,the version after the excution and the procedure
CREATE TABLE procedureTable(
	init_version INT,
	final_version INT,
	procedureName VARCHAR(100),
	PRIMARY KEY(init_version,final_version))

INSERT INTO procedureTable
VALUES (1,2,'uspSetTypeAgeStudentToSmallInt'),
(2,1,'uspSetTypeAgeStudentToInt'),
(2,3,'uspAddColumnCityOrganization'),
(3,2,'uspRemoveColumnCityOrganization'),
(3,4,'uspAddDefaultConstraintStudentPoints'),
(4,3,'uspRemoveDefaultConstraintStudentPoints'),
(4,5,'uspAddPrimaryKeyAllianceNameA'),
(5,4,'uspRemovePrimaryKeyAllianceNameA'),
(5,6,'uspAddCandidateKeyProject'),
(6,5,'uspRemoveCandidateKeyProject'),
(6,7,'uspAddForeignKeyProject'),
(7,6,'uspRemoveForeignKeyProject'),
(7,8,'uspCreateTable'),
(8,7,'uspDropTable')
Select* from procedureTable
--procedure to bring tha db to the specified version
GO
CREATE OR ALTER PROCEDURE uspGoToVersion(@newV INT)
AS
	DECLARE @currentV INT
	DECLARE @procedureN VARCHAR(100)
	SELECT @currentV = versionNo FROM versionTable

	IF (@newV > 8 OR @newV <1)
	BEGIN
		RAISERROR('Invalid version',10,1)
	END
	ELSE
		BEGIN
			IF @currentV >@newV
			BEGIN
				WHILE @currentV>@newV
					BEGIN
						SELECT @procedureN = procedureName
						FROM procedureTable 
						WHERE init_version = @currentV AND final_version=@currentV-1
						PRINT('EXECUTING ' + @procedureN);
						EXEC(@procedureN)
						SET @currentV = @currentV-1
					END
			END

			IF @currentV < @newV
			BEGIN
				WHILE @currentV<@newV
					BEGIN
						SELECT @procedureN = procedureName
						FROM procedureTable 
						WHERE init_version = @currentV AND final_version=@currentV+1
						PRINT('EXECUTING ' + @procedureN);
						EXEC(@procedureN)
						SET @currentV = @currentV+1
					END
			END
			UPDATE versionTable SET versionNo = @newV
		END
EXEC uspGoToVersion 1


SELECT*
FROM versionTable
SELECT *
FROM Organization