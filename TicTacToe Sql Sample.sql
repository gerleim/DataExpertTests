--- Update CELL: WHEN NULL
-- CREATE DATABASE TicTacToe

USE TicTacToe
IF OBJECT_ID('Board', 'U') IS NOT NULL 
  DROP TABLE Board; 

CREATE TABLE Board (
 X int,
 Y int,
 Mark char(1)
)

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'upStep') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE upStep
GO

CREATE PROCEDURE upStep
 @X int,
 @Y int,
 @Mark char(1)
AS
BEGIN
	SET NOCOUNT ON 
	INSERT INTO Board (X ,Y ,Mark)
		 VALUES (@X, @Y, @Mark)
END
GO

-- TEST
EXEC upStep 2, 3, 'O'
DECLARE @countSpecific int
DECLARE @countAll int
DECLARE @testMark char(1)

SELECT @countAll = COUNT(*) FROM Board
SELECT @countSpecific = COUNT(*) FROM Board WHERE X = 2 AND Y = 3
SELECT @testMark = Mark FROM Board WHERE X = 2 AND Y = 3

IF @countAll <> 1
	PRINT '!!! There should be only one row!'

IF @countSpecific <> 1
	PRINT '!!! There should be only one hit!'

IF @testMark <> 'O'
	PRINT '!!! Mark should be O!'

-- Exec with invalid state
EXEC upStep 2, 3, 'O'

SELECT @countAll = COUNT(*) FROM Board
SELECT @countSpecific = COUNT(*) FROM Board WHERE X = 2 AND Y = 3
SELECT @testMark = Mark FROM Board WHERE X = 2 AND Y = 3

IF @countAll <> 1
	PRINT '!!! There should be only one row!'

IF @countSpecific <> 1
	PRINT '!!! There should be only one hit!'

IF @testMark <> 'O'
	PRINT '!!! Mark should be O!'