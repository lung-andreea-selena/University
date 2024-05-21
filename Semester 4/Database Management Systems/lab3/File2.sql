use Stud_Org

GO

CREATE TABLE LoggingTable(
	ID INT PRIMARY KEY IDENTITY(2000,1),
	operationType VARCHAR(50),
	executionTime DATETIME,
	logMessage VARCHAR(50)
)
SELECT * FROM LoggingTable
SELECT * FROM Student

--Dirty Reads
--WRONG
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
BEGIN TRANSACTION
SELECT * FROM Student;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('SELECT Student', CURRENT_TIMESTAMP, 'Select after update')
WAITFOR DELAY '00:00:10'
SELECT * FROM Student;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('SELECT Student', CURRENT_TIMESTAMP, 'SELECT after rollback')
COMMIT TRANSACTION

--GOOD
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN TRANSACTION
SELECT * FROM Student;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('SELECT Student', CURRENT_TIMESTAMP, 'Select after update')
WAITFOR DELAY '00:00:10'
SELECT * FROM Student;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('SELECT Student', CURRENT_TIMESTAMP, 'SELECT after rollback')
COMMIT TRANSACTION

-- Non Repetable Reads
BEGIN TRANSACTION
WAITFOR DELAY '00:00:05';
UPDATE Student SET PointsContribution=1000 WHERE SId=200;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('UPDATE Student', CURRENT_TIMESTAMP, 'Delay for update')
COMMIT TRANSACTION
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('UPDATE Student', CURRENT_TIMESTAMP, 'Rollback')

-- Phantom Reads --
Select * from Student
BEGIN TRANSACTION
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('PHANTOM READ INSERT', CURRENT_TIMESTAMP, 'Delay for insert started')
WAITFOR DELAY '00:00:05'
INSERT INTO Student(NameS,Telephone,PointsContribution,Age) VALUES ('AAAAA', 0000000, 200, 20);
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('PHANTOM READ INSERT', CURRENT_TIMESTAMP, 'Insert')
COMMIT TRANSACTION
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('PHANTOM READ INSERT', CURRENT_TIMESTAMP, 'Insert Rollback')

--DeadLock--
--WRONG
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRAN;
UPDATE Student SET Telephone=88888 WHERE SId=200;
WAITFOR DELAY '00:00:05';
UPDATE Task SET StatusT='LOADING' WHERE TId = 501;
COMMIT TRAN;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('DEADLOCK', CURRENT_TIMESTAMP, 'Second transaction')



select * from Student
select * from Task


--Works
SET DEADLOCK_PRIORITY HIGH;
BEGIN TRAN;
UPDATE Student SET Telephone=111111 WHERE SId=200;
WAITFOR DELAY '00:00:05';
UPDATE Task SET StatusT='GOOD' WHERE TId = 501;
COMMIT TRAN;
INSERT INTO LoggingTable(operationType, executionTime, logMessage) VALUES('DEADLOCK', CURRENT_TIMESTAMP, 'Second transaction')
