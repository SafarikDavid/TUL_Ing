SET STATISTICS IO ON;
SET STATISTICS TIME ON;

USE AdventureWorks2017
go
GRANT SHOWPLAN TO [student]
go

-- 1. Skenov�n� versus hled�n� (scan vs. seek)
-- p�i skenov�n� proch�z�me v�echny ��dky tabulky, p�i hled�n� pouze vybran�
-- Scan
SELECT P.BusinessEntityID, P.FirstName, P.LastName, E.EmailAddress FROM Person.Person P LEFT JOIN Person.EmailAddress E ON P.BusinessEntityID = E.BusinessEntityID
WHERE P.LastName = 'Smith'

-- SCAN vs. SEEK
SELECT BusinessEntityID, FirstName, MiddleName, LastName 
FROM Person.Person
WHERE LEFT(Person.LastName, 3) = 'For'

SELECT BusinessEntityID, FirstName, MiddleName, LastName 
FROM Person.Person
WHERE LastName LIKE 'For%'

-- 2. Implicitn� p�evod datov�ho typu
-- v Execution plan je vyk�i�n��ek, kter� mi ��k�, �e mus� doch�zet k typov� konverzi
SELECT E.BusinessEntityID, E.LoginID, E.JobTitle 
FROM HumanResources.Employee E
WHERE E.NationalIDNumber = 658797903

-- minimalizuji po�et logick�ho i fyzick�ho �ten�
SELECT E.BusinessEntityID, E.LoginID, E.JobTitle 
FROM HumanResources.Employee E
WHERE E.NationalIDNumber = '658797903'

-- 3. * vs. vybran� atributy
SELECT * FROM AdventureWorks2017.HumanResources.Employee

-- minimalizuji odhadovanou velikost ��dku (Execution plan -> Estimated Row Size)
SELECT NationalIDNumber, JobTitle, BirthDate, Gender, HireDate FROM AdventureWorks2017.HumanResources.Employee

-- 4. Pou�it� EXISTS
SET STATISTICS IO ON
SELECT COUNT(*) FROM Sales.SalesOrderDetail
WHERE SalesOrderDetailID = 44824

-- minimalizuji po�et logick�ch �ten� (Messages -> logical reads) a dostanu stejnou informaci
IF EXISTS (
	SELECT CarrierTrackingNumber FROM Sales.SalesOrderDetail
	WHERE SalesOrderDetailID = 44824
)
PRINT 'Yes'
ELSE
PRINT 'No'

-- 5. nadbyte�n� pou�it� GROUP BY nebo DISTINCT
-- zde se nejedn� o optimalizaci, ale sp�e o to, �e pokud DISTINCT nebo GROUP BY pou��t nepot�ebuji, m�l bych se jim vyhnout (nap��klad DISTINCT u PK)
-- rozd�l mezi GROUP BY a DISTINCT p�i stejn�m v�sledku nen�, ale obecn� bych doporu�il pou��t GROUP BY jen v p��padech, kdy pracujeme s agrega�n� funkc�
SELECT DISTINCT CarrierTrackingNumber FROM Sales.SalesOrderDetail

SELECT CarrierTrackingNumber FROM Sales.SalesOrderDetail GROUP BY CarrierTrackingNumber

-- 6. Spr�vn� pou�it� wildcards (_, %)
SELECT TOP 10
FirstName, Lastname, Suffix FROM Person.Person
WHERE FirstName LIKE '%Ken%'

SELECT TOP 10
FirstName, Lastname, Suffix FROM Person.Person
WHERE FirstName LIKE 'Ken%'

-- Wildcards (zdroj: W3Schools.com)
/*
%	Represents zero or more characters								bl% finds bl, black, blue, and blob
_	Represents a single character									h_t finds hot, hat, and hit
[]	Represents any single character within the brackets				h[oa]t finds hot and hat, but not hit
^	Represents any character not in the brackets					h[^oa]t finds hit, but not hot and hat
-	Represents any single character within the specified range		c[a-b]t finds cat and cbt
*/

-- 7. Vlo�en� podm�nky do HAVING versus WHERE klauzule
-- dotazy jsou sice vyhodnoceny naprosto stejn�, ale doporu�uji do HAVING d�vat podm�nky t�kaj�c� se agregace
-- v HAVING lze nav�c pou��t pouze atributy, kter� jsou za SELECTem, WHERE se zpracov�v� d��ve a na z�klad� vyfiltrovan�ch dat se teprve prov�d� agregace v podle atribut� v GROUP BY
SELECT SalesOrderID, SUM(UnitPrice * OrderQty) AS OrderTotal
FROM Sales.salesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(UnitPrice * OrderQty)>1000 AND SalesOrderID>50000 AND SalesOrderID<51000
Go

SELECT SalesOrderID, SUM(UnitPrice * OrderQty) AS OrderTotal
FROM Sales.salesOrderDetail
WHERE SalesOrderID>50000 AND SalesOrderID<51000
GROUP BY SalesOrderID
HAVING SUM(UnitPrice * OrderQty)>1000
Go

-- 8. Pou�it� IN versus EXISTS
SELECT * FROM [Production].[Product] p 
-- d�l�me pr�nik
WHERE productid IN (
	SELECT productid FROM [AdventureWorks2017].[Production].[TransactionHistory]
)
Go

SELECT * FROM [Production].[Product] p
-- kontrolujeme pouze existenci z�znamu
WHERE EXISTS (
	SELECT productid FROM [AdventureWorks2017].[Production].[TransactionHistory]
)

-- 9. OR jako sou��st spojovac� podm�nky versus UNION
-- 99 %
SELECT DISTINCT -- DISTINCT zde mus�me pou��t, abychom dostali stejn� v�sledek (jinak dostaneme cca 120000 ��dk�)
	PRODUCT.ProductID,
	PRODUCT.Name
FROM Production.Product PRODUCT
INNER JOIN Sales.SalesOrderDetail DETAIL
ON PRODUCT.ProductID = DETAIL.ProductID
OR PRODUCT.rowguid = DETAIL.rowguid;

-- 1 %
SELECT -- bez DISTINCT
	PRODUCT.ProductID,
	PRODUCT.Name
FROM Production.Product PRODUCT
INNER JOIN Sales.SalesOrderDetail DETAIL
ON PRODUCT.ProductID = DETAIL.ProductID
UNION
SELECT
	PRODUCT.ProductID,
	PRODUCT.Name
FROM Production.Product PRODUCT
INNER JOIN Sales.SalesOrderDetail DETAIL
ON PRODUCT.rowguid = DETAIL.rowguid

-- 10. JOIN HINTS - INNER JOIN vs. INNER MERGE JOIN vs. HASH JOIN vs. LOOP JOIN
 -- druhy JOIN operace, kdy mus�me p�esn� v�d�t, co d�l�me, proto�e optimaliz�tor v�t�inou zvol� spr�vn� za n�s (bere informace ze statistik)
-- INNER JOIN (p�irozen� spojen�)
SELECT 
  e.BusinessEntityID,
  p.Title,
  p.FirstName,
  p.LastName
FROM HumanResources.Employee e
INNER JOIN Person.Person p
ON p.BusinessEntityID = e.BusinessEntityID
WHERE FirstName LIKE 'E%'

-- INNER MERGE JOIN (set��d�n� sl�v�n�)
-- m�me-li na vstupu nejl�pe dv� set��d�n� sady dat, kter� v��i sob� porovn�v�me a v p��pad� shody provedeme slou�en�
SELECT 
  e.BusinessEntityID,
  p.Title,
  p.FirstName,
  p.LastName
FROM HumanResources.Employee e
INNER MERGE JOIN Person.Person p
ON p.BusinessEntityID = e.BusinessEntityID
WHERE FirstName LIKE 'E%'

SET STATISTICS PROFILE ON
SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'
SET STATISTICS PROFILE OFF

SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT MERGE JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'

-- HASH JOIN
-- Nejd��ve ur��me po�ty ��dk� obou tabulek na vstupu (na z�klad� statistik, tzn. v p��pad� jejich neaktu�lnosti nemus� odpov�dat realit�). Na z�klad� tabulky, kter� obsahuje m�n� ��dk� (build input) se vytvo�� hash tabulka (data z jednoho �i v�ce sloupc� a z dat se vytvo�� hash). Ka�d�mu ��dku v hash tabulce odpov�d� jeden ��dek v origin�ln� tabulce (ve v�sledku porovn�v�me jen jednu hodnotu v jednom sloupci z hash tabulky m�sto hodnot v n�kolika sloupc�ch v origin�ln� tabulce). Hash tabulka m��e b�t ulo�ena p��mo v pam�ti v p��pad� relativn� mal� hash tabulky. Je-li nedostatek voln� pam�ti, je ulo�ena do TempDB. Z druh� v�t�� tabulky na vstupu (probe input) se postupn� �te ��dek po ��dku, z p��slu�n�ch sloupc� se po��t� hash a porovn�v� se s hodnotami v hash tabulce. V p��pad� shody se ��dky d�le zpracov�vaj�.
SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT HASH JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'

-- NESTED LOOP JOIN (hn�zd�n� cykly)
-- Proch�z� se zdrojov� tabulka (outer input) ��dek po ��dku a dohled�v� se odpov�daj�c� ��dky ve druh� p�ipojovan� tabulce (inner input). Pro ka�d� ��dek outer input tabulky se prohled� cel� tabulka inner input, jestli neexistuj� ��dky odpov�daj�c� ��dku z outer input.
SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT LOOP JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'