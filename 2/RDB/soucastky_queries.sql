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
SELECT cisdod
FROM Dodavatel 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--��sla dodavatel�, kte�� nedod�vaj� sou��stku ��slo 15.

--��sla dodavatel�, kte�� dod�vaj� n�co i mimo sou��stky ��slo 15.

--��sla dodavatel�, kte�� dod�vaj� pouze sou��stku ��slo 15.

--��sla dodavatel�, kte�� dod�vaj� n�co, ale nedod�vaj� sou��stku ��slo 15.

--��sla dodavatel�, kte�� dod�vaj� alespo� sou��stky 12, 13, 15.

--��sla dodavatel�, kte�� dod�vaj� v�echny dod�van� sou��stky.

--Seznam m�st, ze kter�ch je dod�v�na alespo� jedna �erven� sou��stka.

--Pr�m�rnou cenu sou��stky.

--��sla sou��stek s minim�ln� cenou (cissou, min_cena). M��e jich b�t v�ce.

--Minim�ln� cenu sou��stky pro ka�d�ho dodavatele (cisdod, min_cena). M��e jich b�t v�ce.

--Sou�et cen dod�van�ch sou��stek dodavatele z Jablonce nad Nisou, kter� dod�v� alespo� 2 sou��stky.
