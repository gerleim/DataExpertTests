SELECT p.BusinessEntityID
FROM Person.Person p
WHERE p.BusinessEntityID NOT IN (
	SELECT PersonID
	FROM Sales.Customer
	WHERE PersonID IS NOT NULL)
ORDER BY p.BusinessEntityID DESC



SELECT PersonID
FROM Sales.Customer
WHERE PersonID IS NOT NULL
ORDER BY PersonID ASC

SELECT DISTINCT PersonID
FROM Sales.Customer
WHERE PersonID IS NOT NULL
ORDER BY PersonID ASC

/*
dfjkghladirukudsrigf odsuzfodugudgfzgdfkghdgjkhgdkjh yuxjzfg kudzgkucgufztgiduz tiuz tg


 dfiufoiufhoiuhf
 
 
 dj fgjdfgjd*/


INSERT INTO Sales.Customer
(PersonID, StoreID, TerritoryID, rowguid, ModifiedDate)
SELECT TOP 1 PersonID, 934 AS StoreId, TerritoryID, NEWID() rowguid, GETDATE() ModifiedDate
FROM Sales.Customer
WHERE PersonID IS NOT NULL AND StoreID IS NOT NULL
	AND StoreId <> 934
-- 934


SELECT LastName, MiddleName, FirstName
FROM Person.Person

SELECT LastName, MiddleName, FirstName
FROM Person.Person
ORDER BY LastName, MiddleName, FirstName


/*SELECT *
INTO Person.Person2
FROM Person.Person*/
