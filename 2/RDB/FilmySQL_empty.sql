USE RDB2023_DavidSafarik

SELECT * FROM Film;
SELECT * FROM Reviewer;
SELECT * FROM Hodnoceni;

-- 1. Najd�te n�zvy film�, kter� re��roval Steven Spielberg.
SELECT nazev
FROM Film
WHERE reziser = 'Steven Spielberg';

-- 2. Najd�te v�echny roky film�, kter� maj� hodnocen� 4 nebo 5 a se�a�te je vzestupn�.
SELECT rok
FROM Hodnoceni H, Film F
WHERE H.hodnoceni >= 4 AND F.id_film = H.id_film
ORDER BY rok ASC;

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
SELECT jmeno, nazev as nazev_filmu
FROM Film F, Reviewer R, (
	SELECT A.id_reviewer, A.id_film
	FROM Hodnoceni A, Hodnoceni B
	WHERE A.id_reviewer = B.id_reviewer AND A.id_film = B.id_film AND A.hodnoceni < B.hodnoceni AND A.datum < B.datum
) X
WHERE F.id_film = X.id_film AND R.id_reviewer = X.id_reviewer;

-- 7. Pro ka�d� film, kter� m� n�jak� hodnocen�, najd�te nejvy��� dosa�en� hodnocen�. Vypi�te n�zev filmu a hodnocen�, set�i�te podle n�zvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) as max_hodnoceni
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY nazev;

-- 8. Pro ka�d� film nalezn�te n�zev filmu a rozsah hodnocen�, co� je rozd�l mezi nejvy���m a nejni���m hodnocen�m. Set�i�te nejd��ve podle rozsahu od nejvy���ho po nejni���, potom podle n�zvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) - MIN(Hodnoceni.hodnoceni) as rozsah
FROM Hodnoceni
RIGHT JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY rozsah, nazev;

-- 9. Najd�te rozd�l mezi pr�m�rn�m hodnocen�m film� uveden�ch p�ed rokem 1980 a pr�m�rn� hodnocen� film� uveden�ch od roku 1980.
-- Ujist�te se, �e jste spo��tali pr�m�rn� hodnocen� nejd��ve pro ka�d� film a pak pr�m�r t�chto pr�m�r� p�ed rokem 1980 a po roce 1980.
SELECT AVG(pred) - AVG(po) as rozdil
FROM (
	SELECT AVG(H.hodnoceni) as pred
	FROM Hodnoceni H, Film F
	WHERE H.id_film = F.id_film AND F.rok < 1980
	GROUP BY H.id_film
) as PRED, (
	SELECT AVG(H.hodnoceni) as po
	FROM Hodnoceni H, Film F
	WHERE H.id_film = F.id_film AND F.rok >= 1980
	GROUP BY H.id_film
) as PO;

-- 10. Najd�te jm�na v�ech reviewer�, kte�� p�isp�li t�emi a v�ce hodnocen�mi. Pokuste se napsat dotaz bez pou�it� HAVING nebo bez Count.
SELECT Reviewer.jmeno as jmeno, COUNT(id_film) as pocet
FROM Reviewer
JOIN Hodnoceni ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
GROUP BY jmeno
HAVING COUNT(id_film) >= 3;