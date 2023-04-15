--Mìjme relace o souèástkách dodávaných dodavateli:

--Dodavatel (cisdod, jmeno, adresa, mesto)
--Dodává (cisdod, cissou)
--Souèástka (cissou, cena, barva)

SELECT * FROM Dodavatel
SELECT * FROM Dodava
SELECT * FROM Soucastka

--Pomocí SQL vyberte:

--Seznam dodavatelù (jmeno, mesto), z nichž každý nìco dodává.
SELECT jmeno, mesto 
FROM Dodavatel 
WHERE EXISTS (SELECT cisdod FROM Dodava WHERE Dodava.cisdod = Dodavatel.cisdod);

--Seznam dodavatelù (jmeno, mesto), kteøí nic nedodávají.
SELECT jmeno, mesto 
FROM Dodavatel 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava);


--Èísla dodavatelù, kteøí dodávají souèástku èíslo 15.
SELECT cisdod
FROM Dodava 
WHERE cissou = 15;

--Èísla dodavatelù, kteøí dodávají nìco, co není souèástka èíslo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--Èísla dodavatelù, kteøí nedodávají souèástku èíslo 15.
SELECT DISTINCT cisdod
FROM Dodavatel 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou = 15);

--Èísla dodavatelù, kteøí dodávají nìco i mimo souèástky èíslo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 15) AND cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--Èísla dodavatelù, kteøí dodávají pouze souèástku èíslo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 15) AND cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--Èísla dodavatelù, kteøí dodávají nìco, ale nedodávají souèástku èíslo 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod NOT IN (SELECT cisdod FROM Dodava WHERE cissou = 15);

--Èísla dodavatelù, kteøí dodávají alespoò souèástky 12, 13, 15.
SELECT * FROM Dodava;
SELECT DISTINCT cisdod
FROM Dodava 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou = 12 OR cissou = 13 OR cissou = 15);

--Èísla dodavatelù, kteøí dodávají všechny dodávané souèástky.
--INSERT INTO Dodava(cisdod, cissou)
--VALUES (1, 16);
--VALUES (2, 16);
--VALUES (1, 2), (1, 12), (1, 3), (1, 13), (1, 4), (1, 14), (1, 15);
SELECT * FROM Soucastka;
SELECT cisdod
FROM Dodava
GROUP BY cisdod
HAVING COUNT(cisdod) = (SELECT COUNT(DISTINCT cissou) FROM Dodava);

--Seznam mìst, ze kterých je dodávána alespoò jedna èervená souèástka.
SELECT * FROM Dodavatel;
SELECT * FROM Dodava;
SELECT * FROM Soucastka;
SELECT DISTINCT Dodavatel.mesto
FROM Dodavatel
JOIN Dodava ON Dodava.cisdod = Dodavatel.cisdod
JOIN Soucastka ON Dodava.cissou = Soucastka.cissou
WHERE barva = 'cervena';

--Prùmìrnou cenu souèástky.
SELECT * FROM Soucastka;
SELECT AVG(cena) as PrumCena
FROM Soucastka;

--Èísla souèástek s minimální cenou (cissou, min_cena). Mùže jich být více.
SELECT * FROM Soucastka;
SELECT cissou, cena as min_cena
FROM Soucastka
WHERE cena = (SELECT MIN(cena) FROM Soucastka);

--Minimální cenu souèástky pro každého dodavatele (cisdod, min_cena). Mùže jich být více.
SELECT Dodavatel.cisdod as cisdod, MIN(Soucastka.cena) as min_cena
FROM Soucastka
JOIN Dodava ON Soucastka.cissou = Dodava.cissou
RIGHT JOIN Dodavatel ON Dodavatel.cisdod = Dodava.cisdod
GROUP BY Dodavatel.cisdod;

--Souèet cen dodávaných souèástek dodavatele z Jablonce nad Nisou, který dodává alespoò 2 souèástky.
SELECT * FROM Dodavatel;
SELECT * FROM Dodava;
SELECT * FROM Soucastka;
SELECT Dodavatel.cisdod as cisdod, SUM(Soucastka.cena) as suma
FROM Dodavatel
JOIN Dodava ON Dodavatel.cisdod = Dodava.cisdod
JOIN Soucastka ON Dodava.cissou = Soucastka.cissou
WHERE Dodavatel.mesto = 'Jablonec nad Nisou' AND (SELECT COUNT(Dodava.cisdod) FROM Dodava WHERE Dodava.cisdod = Dodavatel.cisdod) >= 2
GROUP BY Dodavatel.cisdod;
