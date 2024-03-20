USE [Student Organizations]
GO

SELECT O.name, C.* FROM sys.objects O 
INNER JOIN sys.columns C ON O.object_id=C.object_id 
WHERE type='U'