USE RDB2023_DavidSafarik

SELECT * FROM Film;
SELECT * FROM Reviewer;
SELECT * FROM Hodnoceni;

-- 1. Najdìte názvy filmù, které reíroval Steven Spielberg.
SELECT nazev
FROM Film
WHERE reziser = 'Steven Spielberg';

-- 2. Najdìte všechny roky filmù, které mají hodnocení 4 nebo 5 a seøaïte je vzestupnì.
SELECT rok
FROM Hodnoceni H, Film F
WHERE H.hodnoceni >= 4 AND F.id_film = H.id_film
ORDER BY rok ASC;

-- 3. Najdìte názvy všech filmù, které nemají hodnocení.
SELECT nazev
FROM Film
WHERE id_film NOT IN (SELECT id_film FROM Hodnoceni);

-- 4. Nìkteøí hodnotitelé neposkytli datum svého hodnocení. Najdìte jména takovıch hodnotitelù.
SELECT jmeno
FROM Reviewer
WHERE id_reviewer IN (SELECT id_reviewer FROM Hodnoceni WHERE datum IS NULL);

-- 5. Napište dotaz, kterı vrátí data o hodnocení v èitelnìjším formátu: jméno hodnotitele, název filmu, hodnocení a datum hodnocení. Setøiïte data podle jména hodnotitele, názvu filmu a nakonec podle hodnocení.
SELECT Reviewer.jmeno as jmeno, Film.nazev as nazev, Hodnoceni.hodnoceni as hodnoceni, Hodnoceni.datum as datum
FROM Film
JOIN Hodnoceni ON Film.id_film = Hodnoceni.id_film
JOIN Reviewer ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
ORDER BY jmeno, nazev, hodnoceni;

-- 6. Pro všechny pøípady, kdy urèitı reviewer hodnotil stejnı film dvakrát a dal mu podruhé vyšší hodnocení, vrate jméno reviewera a název filmu.
SELECT jmeno, nazev as nazev_filmu
FROM Film F, Reviewer R, (
	SELECT A.id_reviewer, A.id_film
	FROM Hodnoceni A, Hodnoceni B
	WHERE A.id_reviewer = B.id_reviewer AND A.id_film = B.id_film AND A.hodnoceni < B.hodnoceni AND A.datum < B.datum
) X
WHERE F.id_film = X.id_film AND R.id_reviewer = X.id_reviewer;

-- 7. Pro kadı film, kterı má nìjaké hodnocení, najdìte nejvyšší dosaené hodnocení. Vypište název filmu a hodnocení, setøiïte podle názvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) as max_hodnoceni
FROM Hodnoceni
JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY nazev;

-- 8. Pro kadı film naleznìte název filmu a rozsah hodnocení, co je rozdíl mezi nejvyšším a nejniším hodnocením. Setøiïte nejdøíve podle rozsahu od nejvyššího po nejniší, potom podle názvu filmu.
SELECT Film.nazev as nazev, MAX(Hodnoceni.hodnoceni) - MIN(Hodnoceni.hodnoceni) as rozsah
FROM Hodnoceni
RIGHT JOIN Film ON Film.id_film = Hodnoceni.id_film
GROUP BY nazev
ORDER BY rozsah, nazev;

-- 9. Najdìte rozdíl mezi prùmìrnım hodnocením filmù uvedenıch pøed rokem 1980 a prùmìrné hodnocení filmù uvedenıch od roku 1980.
-- Ujistìte se, e jste spoèítali prùmìrné hodnocení nejdøíve pro kadı film a pak prùmìr tìchto prùmìrù pøed rokem 1980 a po roce 1980.
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

-- 10. Najdìte jména všech reviewerù, kteøí pøispìli tøemi a více hodnoceními. Pokuste se napsat dotaz bez pouití HAVING nebo bez Count.
SELECT Reviewer.jmeno as jmeno, COUNT(id_film) as pocet
FROM Reviewer
JOIN Hodnoceni ON Reviewer.id_reviewer = Hodnoceni.id_reviewer
GROUP BY jmeno
HAVING COUNT(id_film) >= 3;