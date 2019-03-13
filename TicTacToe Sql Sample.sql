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
	DECLARE @tempMark char(1)
	SELECT @tempMark = Mark FROM Board WHERE X = @X AND Y = @Y

	IF @tempMark IS NOT NULL
	BEGIN
		DECLARE @Message varchar(100)
		SET @Message = 'Already set, value: ' + @tempMark
		RAISERROR (@Message, 16, 1)
	END
	ELSE
	BEGIN
		INSERT INTO Board (X ,Y ,Mark)
		VALUES (@X, @Y, @Mark)
	END
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

--- *** ---
TRUNCATE TABLE Board
EXEC upStep 1, 1, 'O'
EXEC upStep 1, 2, 'O'
EXEC upStep 1, 3, 'O'


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = object_id(N'upCheckWinning') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
	DROP PROCEDURE upCheckWinning
GO

CREATE PROCEDURE upCheckWinning
 @winningMark char(1) OUTPUT
AS
BEGIN
	SELECT @winningMark = b1.Mark FROM Board b1
	INNER JOIN Board b2 ON b2.Mark = b1.Mark AND b2.X = b1.X AND b2.Y = b1.Y + 1
	INNER JOIN Board b3 ON b3.Mark = b2.Mark AND b3.X = b2.X AND b3.Y = b2.Y + 1
END

-- Testing winning and notr winning cases
TRUNCATE TABLE Board
EXEC upStep 1, 1, 'O'
EXEC upStep 1, 2, 'O'
EXEC upStep 1, 3, 'O'

DECLARE @testMark char(1)
EXEC upCheckWinning @testMark OUTPUT

IF @testMark <> 'O'
	PRINT '!!! O should be the winner!'


TRUNCATE TABLE Board
EXEC upStep 1, 1, 'O'
EXEC upStep 1, 2, 'O'
EXEC upStep 1, 3, 'X'

SET @testMark = NULL

EXEC upCheckWinning @testMark OUTPUT

IF @testMark IS NOT NULL
	PRINT '!!! There shoud be no winner!'

TRUNCATE TABLE Board
EXEC upStep 1, 1, 'O'
EXEC upStep 2, 1, 'O'
EXEC upStep 3, 1, 'O'

SET @testMark = NULL

EXEC upCheckWinning @testMark OUTPUT

IF @testMark <> 'O'
	PRINT '!!! O should be the winner!'

TRUNCATE TABLE Board
EXEC upStep 1, 1, 'O'
EXEC upStep 2, 2, 'O'
EXEC upStep 3, 3, 'O'

SET @testMark = NULL

EXEC upCheckWinning @testMark OUTPUT

IF @testMark <> 'O'
	PRINT '!!! O should be the winner!'