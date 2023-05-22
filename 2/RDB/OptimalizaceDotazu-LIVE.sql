SET STATISTICS IO ON;
SET STATISTICS TIME ON;

USE AdventureWorks2017
go
GRANT SHOWPLAN TO [student]
go

-- 1. Skenování versus hledání (scan vs. seek)
-- pøi skenování procházíme všechny øádky tabulky, pøi hledání pouze vybrané
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

-- 2. Implicitní pøevod datového typu
-- v Execution plan je vykøièníèek, který mi øíká, že musí docházet k typové konverzi
SELECT E.BusinessEntityID, E.LoginID, E.JobTitle 
FROM HumanResources.Employee E
WHERE E.NationalIDNumber = 658797903

-- minimalizuji poèet logického i fyzického ètení
SELECT E.BusinessEntityID, E.LoginID, E.JobTitle 
FROM HumanResources.Employee E
WHERE E.NationalIDNumber = '658797903'

-- 3. * vs. vybrané atributy
SELECT * FROM AdventureWorks2017.HumanResources.Employee

-- minimalizuji odhadovanou velikost øádku (Execution plan -> Estimated Row Size)
SELECT NationalIDNumber, JobTitle, BirthDate, Gender, HireDate FROM AdventureWorks2017.HumanResources.Employee

-- 4. Použití EXISTS
SET STATISTICS IO ON
SELECT COUNT(*) FROM Sales.SalesOrderDetail
WHERE SalesOrderDetailID = 44824

-- minimalizuji poèet logických ètení (Messages -> logical reads) a dostanu stejnou informaci
IF EXISTS (
	SELECT CarrierTrackingNumber FROM Sales.SalesOrderDetail
	WHERE SalesOrderDetailID = 44824
)
PRINT 'Yes'
ELSE
PRINT 'No'

-- 5. nadbyteèné použití GROUP BY nebo DISTINCT
-- zde se nejedná o optimalizaci, ale spíše o to, že pokud DISTINCT nebo GROUP BY použít nepotøebuji, mìl bych se jim vyhnout (napøíklad DISTINCT u PK)
-- rozdíl mezi GROUP BY a DISTINCT pøi stejném výsledku není, ale obecnì bych doporuèil použít GROUP BY jen v pøípadech, kdy pracujeme s agregaèní funkcí
SELECT DISTINCT CarrierTrackingNumber FROM Sales.SalesOrderDetail

SELECT CarrierTrackingNumber FROM Sales.SalesOrderDetail GROUP BY CarrierTrackingNumber

-- 6. Správné použití wildcards (_, %)
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

-- 7. Vložení podmínky do HAVING versus WHERE klauzule
-- dotazy jsou sice vyhodnoceny naprosto stejnì, ale doporuèuji do HAVING dávat podmínky týkající se agregace
-- v HAVING lze navíc použít pouze atributy, které jsou za SELECTem, WHERE se zpracovává døíve a na základì vyfiltrovaných dat se teprve provádí agregace v podle atributù v GROUP BY
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

-- 8. Použití IN versus EXISTS
SELECT * FROM [Production].[Product] p 
-- dìláme prùnik
WHERE productid IN (
	SELECT productid FROM [AdventureWorks2017].[Production].[TransactionHistory]
)
Go

SELECT * FROM [Production].[Product] p
-- kontrolujeme pouze existenci záznamu
WHERE EXISTS (
	SELECT productid FROM [AdventureWorks2017].[Production].[TransactionHistory]
)

-- 9. OR jako souèást spojovací podmínky versus UNION
-- 99 %
SELECT DISTINCT -- DISTINCT zde musíme použít, abychom dostali stejný výsledek (jinak dostaneme cca 120000 øádkù)
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
 -- druhy JOIN operace, kdy musíme pøesnì vìdìt, co dìláme, protože optimalizátor vìtšinou zvolí správnì za nás (bere informace ze statistik)
-- INNER JOIN (pøirozené spojení)
SELECT 
  e.BusinessEntityID,
  p.Title,
  p.FirstName,
  p.LastName
FROM HumanResources.Employee e
INNER JOIN Person.Person p
ON p.BusinessEntityID = e.BusinessEntityID
WHERE FirstName LIKE 'E%'

-- INNER MERGE JOIN (setøídìné slévání)
-- máme-li na vstupu nejlépe dvì setøídìné sady dat, které vùèi sobì porovnáváme a v pøípadì shody provedeme slouèení
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
-- Nejdøíve urèíme poèty øádkù obou tabulek na vstupu (na základì statistik, tzn. v pøípadì jejich neaktuálnosti nemusí odpovídat realitì). Na základì tabulky, která obsahuje ménì øádkù (build input) se vytvoøí hash tabulka (data z jednoho èi více sloupcù a z dat se vytvoøí hash). Každému øádku v hash tabulce odpovídá jeden øádek v originální tabulce (ve výsledku porovnáváme jen jednu hodnotu v jednom sloupci z hash tabulky místo hodnot v nìkolika sloupcích v originální tabulce). Hash tabulka mùže být uložena pøímo v pamìti v pøípadì relativnì malé hash tabulky. Je-li nedostatek volné pamìti, je uložena do TempDB. Z druhé vìtší tabulky na vstupu (probe input) se postupnì ète øádek po øádku, z pøíslušných sloupcù se poèítá hash a porovnává se s hodnotami v hash tabulce. V pøípadì shody se øádky dále zpracovávají.
SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT HASH JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'

-- NESTED LOOP JOIN (hnízdìné cykly)
-- Prochází se zdrojová tabulka (outer input) øádek po øádku a dohledává se odpovídající øádky ve druhé pøipojované tabulce (inner input). Pro každý øádek outer input tabulky se prohledá celá tabulka inner input, jestli neexistují øádky odpovídající øádku z outer input.
SELECT
  P.LastName
  ,P.FirstName
  ,E.EmailAddress
FROM
  Person.Person AS P
  LEFT LOOP JOIN Person.EmailAddress AS E ON E.BusinessEntityID = P.BusinessEntityID
WHERE
  P.LastName = 'Smith'