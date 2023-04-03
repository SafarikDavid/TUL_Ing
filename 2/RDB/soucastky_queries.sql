--Mìjme relace o souèástkách dodávanıch dodavateli:

--Dodavatel (cisdod, jmeno, adresa, mesto)
--Dodává (cisdod, cissou)
--Souèástka (cissou, cena, barva)

SELECT * FROM Dodavatel
SELECT * FROM Dodava
SELECT * FROM Soucastka

--Pomocí SQL vyberte:

--Seznam dodavatelù (jmeno, mesto), z nich kadı nìco dodává.
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
SELECT cisdod
FROM Dodavatel 
WHERE cisdod IN (SELECT cisdod FROM Dodava WHERE cissou != 15);

--Èísla dodavatelù, kteøí nedodávají souèástku èíslo 15.

--Èísla dodavatelù, kteøí dodávají nìco i mimo souèástky èíslo 15.

--Èísla dodavatelù, kteøí dodávají pouze souèástku èíslo 15.

--Èísla dodavatelù, kteøí dodávají nìco, ale nedodávají souèástku èíslo 15.

--Èísla dodavatelù, kteøí dodávají alespoò souèástky 12, 13, 15.

--Èísla dodavatelù, kteøí dodávají všechny dodávané souèástky.

--Seznam mìst, ze kterıch je dodávána alespoò jedna èervená souèástka.

--Prùmìrnou cenu souèástky.

--Èísla souèástek s minimální cenou (cissou, min_cena). Mùe jich bıt více.

--Minimální cenu souèástky pro kadého dodavatele (cisdod, min_cena). Mùe jich bıt více.

--Souèet cen dodávanıch souèástek dodavatele z Jablonce nad Nisou, kterı dodává alespoò 2 souèástky.
