--M�jme relace o sou��stk�ch dod�van�ch dodavateli:

--Dodavatel (cisdod, jmeno, adresa, mesto)
--Dod�v� (cisdod, cissou)
--Sou��stka (cissou, cena, barva)

SELECT * FROM Dodavatel
SELECT * FROM Dodava
SELECT * FROM Soucastka

--Pomoc� SQL vyberte:

--Seznam dodavatel� (jmeno, mesto), z nich� ka�d� n�co dod�v�.
SELECT jmeno, mesto 
FROM Dodavatel 
WHERE EXISTS (SELECT cisdod FROM Dodava WHERE Dodava.cisdod = Dodavatel.cisdod);

--Seznam dodavatel� (jmeno, mesto), kte�� nic nedod�vaj�.
SELECT jmeno, mesto 
FROM Dodavatel 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava);


--��sla dodavatel�, kte�� dod�vaj� sou��stku ��slo 15.
SELECT cisdod
FROM Dodava 
WHERE cissou = 15;

--��sla dodavatel�, kte�� dod�vaj� n�co, co nen� sou��stka ��slo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--��sla dodavatel�, kte�� nedod�vaj� sou��stku ��slo 15.
SELECT DISTINCT cisdod
FROM Dodavatel 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou = 15);

--��sla dodavatel�, kte�� dod�vaj� n�co i mimo sou��stky ��slo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 15) AND cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--��sla dodavatel�, kte�� dod�vaj� pouze sou��stku ��slo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 15) AND cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--��sla dodavatel�, kte�� dod�vaj� n�co, ale nedod�vaj� sou��stku ��slo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou = 15);

--��sla dodavatel�, kte�� dod�vaj� alespo� sou��stky 12, 13, 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 12 OR cissou = 13 OR cissou = 15);

--��sla dodavatel�, kte�� dod�vaj� v�echny dod�van� sou��stky.
--INSERT INTO Dodava(cisdod, cissou)
--VALUES (1, 16);
--VALUES (2, 16);
--VALUES (1, 2), (1, 12), (1, 3), (1, 13), (1, 4), (1, 14), (1, 15);
SELECT * FROM Soucastka;
SELECT cisdod
FROM Dodava
GROUP BY cisdod
HAVING COUNT(cisdod) = (SELECT COUNT(DISTINCT cissou) FROM Dodava);

--Seznam m�st, ze kter�ch je dod�v�na alespo� jedna �erven� sou��stka.
SELECT * FROM Dodavatel;
SELECT * FROM Dodava;
SELECT * FROM Soucastka;
SELECT DISTINCT Dodavatel.mesto
FROM Dodavatel
JOIN Dodava ON Dodava.cisdod = Dodavatel.cisdod
JOIN Soucastka ON Dodava.cissou = Soucastka.cissou
WHERE barva = 'cervena';

--Pr�m�rnou cenu sou��stky.
SELECT * FROM Soucastka;
SELECT AVG(cena) as PrumCena
FROM Soucastka;

--��sla sou��stek s minim�ln� cenou (cissou, min_cena). M��e jich b�t v�ce.
SELECT * FROM Soucastka;
SELECT cissou, cena as min_cena
FROM Soucastka
WHERE cena = (SELECT MIN(cena) FROM Soucastka);

--Minim�ln� cenu sou��stky pro ka�d�ho dodavatele (cisdod, min_cena). M��e jich b�t v�ce.
SELECT Dodavatel.cisdod as cisdod, MIN(Soucastka.cena) as min_cena
FROM Soucastka
JOIN Dodava ON Soucastka.cissou = Dodava.cissou
RIGHT JOIN Dodavatel ON Dodavatel.cisdod = Dodava.cisdod
GROUP BY Dodavatel.cisdod;

--Sou�et cen dod�van�ch sou��stek dodavatele z Jablonce nad Nisou, kter� dod�v� alespo� 2 sou��stky.
SELECT * FROM Dodavatel;
SELECT * FROM Dodava;
SELECT * FROM Soucastka;
SELECT Dodavatel.cisdod as cisdod, SUM(Soucastka.cena) as suma
FROM Dodavatel
JOIN Dodava ON Dodavatel.cisdod = Dodava.cisdod
JOIN Soucastka ON Dodava.cissou = Soucastka.cissou
WHERE Dodavatel.mesto = 'Jablonec nad Nisou' AND (SELECT COUNT(Dodava.cisdod) FROM Dodava WHERE Dodava.cisdod = Dodavatel.cisdod) >= 2
GROUP BY Dodavatel.cisdod;
