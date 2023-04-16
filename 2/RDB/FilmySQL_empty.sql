USE RDB2023_DavidSafarik

SELECT * FROM Film;
SELECT * FROM Reviewer;
SELECT * FROM Hodnoceni;

-- 1. Najd�te n�zvy film�, kter� re��roval Steven Spielberg.
SELECT nazev
FROM Film
WHERE reziser = 'Steven Spielberg';

-- 2. Najd�te v�echny roky film�, kter� maj� hodnocen� 4 nebo 5 a se�a�te je vzestupn�.
SELECT YEAR(datum) as rok
FROM Hodnoceni
WHERE hodnoceni >= 4 AND datum IS NOT NULL
ORDER BY datum ASC;

SELECT DISTINCT YEAR(datum) as rok
FROM Hodnoceni
WHERE hodnoceni >= 4 AND datum IS NOT NULL
GROUP BY datum
ORDER BY YEAR(datum) ASC;

-- 3. Najd�te n�zvy v�ech film�, kter� nemaj� hodnocen�.
SELECT nazev
FROM Film
WHERE id_film NOT IN (SELECT id_film FROM Hodnoceni);

-- 4. N�kte�� hodnotitel� neposkytli datum sv�ho hodnocen�. Najd�te jm�na takov�ch hodnotitel�.
SELECT jmeno
FROM Reviewer
WHERE id_reviewer IN (SELECT id_reviewer FROM Hodnoceni WHERE datum IS NULL);

-- 5. Napi�te dotaz, kter� vr�t� data o hodnocen� v �iteln�j��m form�tu: jm�no hodnotitele, n�zev filmu, hodnocen� a datum hodnocen�. Set�i�te data podle jm�na hodnotitele, n�zvu filmu a nakonec podle hodnocen�.
SELECT Reviewer.jmeno as jmeno, Film.nazev as nazev, Hodnoceni.hodnoceni as hodnoceni, Hodnoceni.datum as datum
FROM Film
JOIN Hodnoceni ON Film.id_film = Hodnoceni.id_film
JOIN Reviewer ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
ORDER BY jmeno, nazev, hodnoceni;

-- 6. Pro v�echny p��pady, kdy ur�it� reviewer hodnotil stejn� film dvakr�t a dal mu podruh� vy��� hodnocen�, vra�te jm�no reviewera a n�zev filmu.


-- 7. Pro ka�d� film, kter� m� n�jak� hodnocen�, najd�te nejvy��� dosa�en� hodnocen�. Vypi�te n�zev filmu a hodnocen�, set�i�te podle n�zvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) as max_hodnoceni
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY nazev;

-- 8. Pro ka�d� film nalezn�te n�zev filmu a rozsah hodnocen�, co� je rozd�l mezi nejvy���m a nejni���m hodnocen�m. Set�i�te nejd��ve podle rozsahu od nejvy���ho po nejni���, potom podle n�zvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) - MIN(Hodnoceni.hodnoceni) as rozsah
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY rozsah, nazev;

-- 9. Najd�te rozd�l mezi pr�m�rn�m hodnocen�m film� uveden�ch p�ed rokem 1980 a pr�m�rn� hodnocen� film� uveden�ch od roku 1980. Ujist�te se, �e jste spo��tali pr�m�rn� hodnocen� nejd��ve pro ka�d� film a pak pr�m�r t�chto pr�m�r� p�ed rokem 1980 a po roce 1980.
SELECT AVG(Hodnoceni.hodnoceni)
FROM Hodnoceni
JOIN Film ON Hodnoceni.id_film = Film.id_film
WHERE Film.rok < 1980; -- dodelat

-- 10. Najd�te jm�na v�ech reviewer�, kte�� p�isp�li t�emi a v�ce hodnocen�mi. Pokuste se napsat dotaz bez pou�it� HAVING nebo bez Count.
SELECT Reviewer.jmeno as jmeno, COUNT(id_film) as pocet
FROM Reviewer
JOIN Hodnoceni ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
GROUP BY jmeno
HAVING COUNT(id_film) >= 3;